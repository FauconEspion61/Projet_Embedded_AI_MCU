import os
import serial
import numpy as np

PORT = "COM7"

# Fichier MNIST au format Keras (cles x_train, y_train, x_test, y_test). Keras le
# telecharge ici au premier appel de mnist.load_data(). Le lire directement evite
# d'importer TensorFlow (~13 s) juste pour recuperer les images de test.
MNIST_NPZ = os.path.expanduser("~/.keras/datasets/mnist.npz")


def load_test_set():
    """
    Reconstruit le jeu de test MNIST avec exactement le pretraitement utilise
    a l'entrainement (voir emnist.ipynb : normalize_dataset / flatten_dataset).

    Les anciens fichiers MNIST_xtest_NN_C2_16_10.npy / MNIST_ytest_NN_C2_16_10.npy
    (herites d'un autre TP) sont normalises en [0, 1], alors que le modele est
    entraine sur des pixels en [-0.5, 0.5] ((pixel/255) - 0.5). Envoyer les
    mauvaises donnees ne fait planter ni le protocole ni la carte : la carte
    repond toujours, mais avec des predictions degradees. Verifie en local :
    98.14% de precision avec la bonne normalisation, 82.2% avec l'ancienne
    (mesure sur le meme modele, en float32, sans STM32 ni compression).

    Returns:
        tuple: (X_test, Y_test) - images aplaties en (N, 784) float32 dans
        [-0.5, 0.5], labels en one-hot (N, 10).
    """
    if os.path.exists(MNIST_NPZ):
        with np.load(MNIST_NPZ) as data:
            x_raw, y_raw = data["x_test"], data["y_test"]
    else:
        # Premier lancement : Keras telecharge le fichier (import lent, une seule fois).
        import tensorflow as tf
        (_, _), (x_raw, y_raw) = tf.keras.datasets.mnist.load_data()
    x_test = ((x_raw / 255) - 0.5).astype(np.float32).reshape(x_raw.shape[0], -1)
    y_test = np.eye(10)[y_raw].astype(np.float32)
    return x_test, y_test


def synchronise_UART(serial_port):
    """
    Synchronizes the UART communication by sending a byte and waiting for a response.

    Args:
        serial_port (serial.Serial): The serial port object to use for communication.

    Returns:
        None
    """
    while (1):
        serial_port.write(b"\xAB")
        ret = serial_port.read(1)
        if (ret == b"\xCD"):
            serial_port.read(1)
            break


def send_inputs_to_STM32(inputs, serial_port):
    """
    Sends a numpy array of inputs to the STM32 microcontroller via a serial port.

    Args:
        inputs (numpy.ndarray): The inputs to send to the STM32.
        serial_port (serial.Serial): The serial port to use for communication.

    Returns:
        None
    """
    inputs = inputs.astype(np.float32)
    buffer = b""
    for x in inputs:
        buffer += x.tobytes()
    serial_port.write(buffer)


def read_output_from_STM32(serial_port):
    """
    Reads 10 bytes from the given serial port and returns a list of float values obtained by dividing each byte by 255.

    Args:
    serial_port: A serial port object.

    Returns:
    A list of float values obtained by dividing each byte by 255.
    """
    output = serial_port.read(10)

    float_values = [int(out)/255 for out in output]
    return float_values


def evaluate_model_on_STM32(iterations, serial_port):
    """
    Evaluates the accuracy of a machine learning model on an STM32 device.

    Args:
        iterations (int): The number of iterations to run the evaluation for.
        serial_port (Serial): The serial port object used to communicate with the STM32 device.

    Returns:
        float: The accuracy of the model, as a percentage.
    """
    accuracy = 0
    for i in range(iterations):
        print(f"----- Iteration {i+1} -----")
        send_inputs_to_STM32(X_test[i], serial_port)
        output = read_output_from_STM32(serial_port)
        if (np.argmax(output) == np.argmax(Y_test[i])):
            accuracy += 1 / iterations
        print(f"   Expected output: {Y_test[i]}")
        print(f"   Received output: {output}")
        print(f"----------------------- Accuracy: {accuracy:.2f}\n")
    return accuracy


if __name__ == '__main__':
    X_test, Y_test = load_test_set()

    with serial.Serial(PORT, 115200, timeout=1) as ser:
        print("Synchronising...")
        synchronise_UART(ser)
        print("Synchronised")

        print("Evaluating model on STM32...")
        error = evaluate_model_on_STM32(100, ser)
