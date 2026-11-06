"""Evalue sur la ZedBoard (Cortex-A9, AIfES Q7) des images MNIST envoyees par l'UART.

Protocole (voir main.c cote carte) :
    PC -> carte : 0xAB                       demande de synchronisation
    carte -> PC : 0xCD 0x00                  acquittement
    puis, pour chaque image :
    PC -> carte : 784 float32 little-endian  (3136 octets), pretraites comme a l'entrainement
    carte -> PC : 10 octets (probabilite de chaque classe x 255) + 4 octets (temps d'inference, us)

Exemple :
    python ZYNQ/communication_zynq.py --port COM5 --n 100

Le port est celui de l'USB-UART de la ZedBoard (pas celui du JTAG). Un seul programme a la fois
peut ouvrir ce port : fermer PuTTY ou le terminal serie de Vitis avant de lancer le script.
"""
import argparse
import os
import sys
import time

import numpy as np

SYNC_BYTE = b"\xAB"
ACK = b"\xCD\x00"
N_PIXELS = 784
N_CLASSES = 10
REPLY_BYTES = N_CLASSES + 4
MNIST_NPZ = os.path.expanduser("~/.keras/datasets/mnist.npz")


def load_test_set():
    """Jeu de test MNIST avec le pretraitement de l'entrainement : (pixel/255) - 0.5, aplati.

    Returns:
        tuple: (x, y) - x de forme (10000, 784) en float32 dans [-0.5, 0.5], y de forme (10000,).
    """
    if os.path.exists(MNIST_NPZ):
        with np.load(MNIST_NPZ) as data:
            x_raw, y = data["x_test"], data["y_test"]
    else:
        import tensorflow as tf  # premier lancement : Keras telecharge le fichier
        (_, _), (x_raw, y) = tf.keras.datasets.mnist.load_data()
    x = ((x_raw / 255) - 0.5).astype(np.float32).reshape(len(x_raw), N_PIXELS)
    return x, y


def read_exact(ser, n, timeout_s):
    """Lit exactement n octets, ou moins si le delai est depasse."""
    buf = b""
    end = time.monotonic() + timeout_s
    while len(buf) < n and time.monotonic() < end:
        buf += ser.read(n - len(buf))
    return buf


def synchronise(ser, timeout_s=30.0):
    """Envoie 0xAB et attend 0xCD 0x00. Tout autre octet (texte de demarrage de la carte) est ignore.

    Le tampon d'entree n'est vide qu'une fois, au debut : le vider a chaque tentative pourrait
    jeter un acquittement deja arrive. Une nouvelle demande n'est envoyee qu'apres 1 s sans reponse.
    """
    ser.reset_input_buffer()
    end = time.monotonic() + timeout_s
    while time.monotonic() < end:
        ser.write(SYNC_BYTE)
        window = b""
        attempt_end = time.monotonic() + 1.0
        while time.monotonic() < attempt_end:
            b = ser.read(1)
            if not b:
                continue
            window = (window + b)[-2:]
            if window == ACK:
                return True
    return False


def infer(ser, image):
    """Envoie une image (784 float32) et lit la reponse.

    Returns:
        tuple: (probabilites en octets, tableau de 10 uint8 ; temps d'inference de la carte en us).
    """
    ser.write(np.ascontiguousarray(image, dtype="<f4").tobytes())
    reply = read_exact(ser, REPLY_BYTES, timeout_s=3.0)
    if len(reply) != REPLY_BYTES:
        raise RuntimeError(
            "Reponse incomplete de la carte ({} octets sur {}). La carte n'est pas synchronisee "
            "ou ne repond plus : reinitialiser la carte (bouton PS-RST) et relancer.".format(len(reply), REPLY_BYTES))
    probs = np.frombuffer(reply[:N_CLASSES], dtype=np.uint8)
    microseconds = int.from_bytes(reply[N_CLASSES:], "little")
    return probs, microseconds


def evaluate(ser, x, y, n, progress=True):
    """Envoie les n premieres images et mesure precision et temps.

    Returns:
        dict: preds, probs, board_us, wall_s, accuracy.
    """
    preds, probs_all, board_us = [], [], []
    t_start = time.perf_counter()
    for i in range(n):
        probs, us = infer(ser, x[i])
        preds.append(int(np.argmax(probs)))     # premier maximum en cas d'egalite, comme np.argmax
        probs_all.append(probs)
        board_us.append(us)
        if progress and ((i + 1) % 10 == 0 or i + 1 == n):
            ok = sum(1 for k in range(i + 1) if preds[k] == int(y[k]))
            print("  {:>5}/{}  precision courante {:5.1f} %".format(i + 1, n, 100.0 * ok / (i + 1)), end="\r")
    wall = time.perf_counter() - t_start
    if progress:
        print()
    correct = sum(1 for k in range(n) if preds[k] == int(y[k]))
    return {"preds": preds, "probs": probs_all, "board_us": board_us, "wall_s": wall, "accuracy": correct / n}


ZEDBOARD_UART_VID = 0x04B4      # Cypress : fabricant du convertisseur USB-UART de la ZedBoard


def find_zedboard_port(ports):
    """Port de l'USB-UART de la ZedBoard s'il y en a exactement un (identifiant USB Cypress)."""
    candidates = [p.device for p in ports if p.vid == ZEDBOARD_UART_VID]
    return candidates[0] if len(candidates) == 1 else None


def print_ports(ports):
    for p in ports:
        print("  {:8s} {}".format(p.device, p.description))
    if not ports:
        print("  (aucun)")


def main():
    parser = argparse.ArgumentParser(description="Evaluation d'AIfES Q7 sur la ZedBoard via l'UART.")
    parser.add_argument("--port", help="port serie de l'USB-UART de la ZedBoard, par exemple COM11 "
                                       "(detecte automatiquement s'il est omis)")
    parser.add_argument("--n", type=int, default=100, help="nombre d'images a envoyer (defaut : 100)")
    parser.add_argument("--baud", type=int, default=115200, help="vitesse en bauds (defaut : 115200)")
    args = parser.parse_args()

    import serial
    import serial.tools.list_ports

    ports = list(serial.tools.list_ports.comports())
    port = args.port or find_zedboard_port(ports)
    if not port:
        print("Port de la ZedBoard introuvable : precise-le avec --port. Ports serie disponibles :")
        print_ports(ports)
        return 2
    if not args.port:
        print("Port detecte automatiquement : {}".format(port))

    x, y = load_test_set()
    n = min(args.n, len(x))

    try:
        ser = serial.Serial(port, args.baud, timeout=0.2)
    except serial.SerialException as exc:
        print("Impossible d'ouvrir {} : {}".format(port, exc))
        print("Ports serie disponibles :")
        print_ports(ports)
        print("Si le port est absent : carte sous tension, cable USB sur le port UART, pilote installe. "
              "S'il est present : un autre programme (terminal serie de Vitis, PuTTY) l'utilise peut-etre.")
        return 1

    with ser:
        print("Synchronisation sur {} ...".format(port))
        if not synchronise(ser):
            print("Pas d'acquittement de la carte. Verifier : programme lance (Run), bon port UART, "
                  "aucun autre programme sur ce port, 115200 bauds.")
            return 1
        print("Synchronise. Envoi de {} images ...".format(n))
        res = evaluate(ser, x, y, n)

    us = np.array(res["board_us"], dtype=np.float64)
    print("Precision      : {:.2f} %  ({} images)".format(100.0 * res["accuracy"], n))
    print("Inference carte: moyenne {:.0f} us, min {:.0f} us, max {:.0f} us".format(us.mean(), us.min(), us.max()))
    print("Debit global   : {:.1f} images/s  ({:.1f} s au total, dominees par le transfert UART)".format(
        n / res["wall_s"], res["wall_s"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
