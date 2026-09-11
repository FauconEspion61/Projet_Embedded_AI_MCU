"""
Rend un modele .h5 sauvegarde par tf_keras 2.21 lisible par ST Edge AI Core.

Probleme
--------
tf_keras 2.21 ecrit une cle "optional" dans la config des couches (InputLayer).
Le Keras embarque dans ST Edge AI Core 2.2.0 est plus ancien et rejette cette
cle inconnue :

    E010(InvalidModelError): Couldn't load Keras model ...
    Unrecognized keyword arguments: ['optional']

Ce script retire recursivement les cles inconnues de la config stockee dans
l'attribut HDF5 "model_config", sans toucher aux poids.

Usage
-----
    python tools/fix_h5_for_stedgeai.py models/mon-modele.h5
    python tools/fix_h5_for_stedgeai.py models/mon-modele.h5 -o models/clean.h5
"""

import argparse
import json
import shutil
import sys
from pathlib import Path

import h5py

# Cles emises par tf_keras 2.21 mais inconnues du Keras de ST Edge AI Core.
UNKNOWN_KEYS = ("optional",)


def strip_keys(node, removed):
    """
    Retire recursivement UNKNOWN_KEYS de tous les dictionnaires "config".

    Args:
        node: Un fragment de la config (dict, list ou scalaire).
        removed (list): Accumulateur des cles retirees, pour le rapport.

    Returns:
        Le fragment nettoye.
    """
    if isinstance(node, dict):
        name = node.get("name") or node.get("class_name")
        for key in UNKNOWN_KEYS:
            if key in node:
                del node[key]
                removed.append("{}.{}".format(name or "?", key))
        return {k: strip_keys(v, removed) for k, v in node.items()}
    if isinstance(node, list):
        return [strip_keys(v, removed) for v in node]
    return node


def clean_attr(handle, attr, removed):
    """
    Nettoie un attribut HDF5 contenant du JSON, s'il existe.

    Args:
        handle (h5py.File): Fichier ouvert en ecriture.
        attr (str): Nom de l'attribut.
        removed (list): Accumulateur des cles retirees.
    """
    if attr not in handle.attrs:
        return
    raw = handle.attrs[attr]
    if isinstance(raw, bytes):
        raw = raw.decode("utf-8")
    handle.attrs[attr] = json.dumps(strip_keys(json.loads(raw), removed))


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("model", type=Path, help="Le fichier .h5 a corriger.")
    parser.add_argument("-o", "--output", type=Path,
                        help="Fichier de sortie. Par defaut, corrige sur place "
                             "en gardant une sauvegarde .h5.bak")
    args = parser.parse_args()

    if not args.model.is_file():
        sys.exit("Fichier introuvable : {}".format(args.model))

    if args.output:
        target = args.output
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(args.model, target)
    else:
        target = args.model
        backup = args.model.with_suffix(args.model.suffix + ".bak")
        if not backup.exists():
            shutil.copy2(args.model, backup)
            print("Sauvegarde : {}".format(backup))

    removed = []
    with h5py.File(target, "r+") as handle:
        clean_attr(handle, "model_config", removed)
        clean_attr(handle, "training_config", removed)

    if removed:
        print("Cles retirees ({}) :".format(len(removed)))
        for item in removed:
            print("  - {}".format(item))
    else:
        print("Aucune cle problematique trouvee, fichier deja compatible.")

    print("Ecrit : {}".format(target))


if __name__ == "__main__":
    main()
