# AIfES sur ZedBoard (Zynq-7000)

Branche `aifes-zynq`. Deux objectifs, dans cet ordre :

1. Faire tourner **AIfES sur le cœur ARM** (Cortex-A9, bare-metal) de la ZedBoard.
2. Concevoir un **IP matériel en logique programmable** (type MAC) qui accélère le calcul d'AIfES, et
   mesurer le gain par rapport à la version logicielle.

Le MLP MNIST et son export AIfES viennent du reste du dépôt (`emnist.ipynb`, `aifes_f32/`,
`aifes_q7/`). Le déploiement STM32 est dans `STM32_Projet_Embedded_AI_MCU/` (voir le `README.md`
racine pour ses résultats).

## Arborescence

```
ZYNQ/
  README.md
  env.ps1      Vivado et Vitis 2025.2 dans le PATH de la session PowerShell
  vivado/      projet Vivado complet : Projet_Codesign.xpr, sources, block design,
               .gen, .cache, .runs, simulation, AIfES_wrapper.xsa
  vitis/       espace de travail Vitis
    AIfES_component/   application : src/ (main.c, board_io.*, aifes_port.c, réseau Q7),
                       UserConfig.cmake, copie des sources AIfES 2.2.0
    AIfES_platform/    plateforme générée à partir du .xsa  -> NON versionnée, voir ci-dessous
  communication_zynq.py   script PC : envoie des images MNIST par l'UART et mesure précision et temps
```

La plateforme `AIfES_platform` et les fichiers de session de Vitis ne sont pas dans git : ils sont
régénérés par l'IDE et contiennent des chemins absolus propres à la machine (`V:/...`, `C:/Users/...`).
Pour reconstruire l'espace de travail après un clone : créer dans Vitis une plateforme nommée
`AIfES_platform` à partir de `ZYNQ/vivado/AIfES_wrapper.xsa` (système `standalone`, processeur
`ps7_cortexa9_0`), la construire, puis construire `AIfES_component`.

## Prérequis : chemins courts

Le CMake de Vitis refuse les chemins trop longs (limite de 250 caractères pour un fichier objet) : la
création de la plateforme échoue dans ce dépôt tel quel, dont le chemin complet dépasse 100 caractères.
Il faut donner au dépôt une lettre de lecteur courte et ouvrir l'espace de travail par ce lecteur :

```powershell
subst V: "C:\chemin\vers\Projet_Embedded_AI_MCU"      # puis ouvrir V:\ZYNQ\vitis dans Vitis
```

`subst` ne survit pas à un redémarrage. Cloner le dépôt directement dans un dossier au chemin court
est l'autre solution.

## Environnement

| | |
|---|---|
| Carte | ZedBoard (contraintes `zedboard_master_XDC_RevC_D_v3.xdc` des labs) |
| Circuit | `xc7z020clg484-1` |
| Outils | Vivado et Vitis **2025.2**, installés dans `C:\AMDDesignTools\2025.2` (Vitis Unified IDE) |
| Compilateur ARM | `arm-xilinx-eabi-gcc` 13.3.0, dans `gnu\aarch32\nt\gcc-arm-none-eabi\bin` |

Contrôle effectué : les 62 sources C d'AIfES 2.2.0 (`core/`, `basic/`, `cnn/`) compilent avec ce
compilateur pour `-mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard`, sans erreur.

## Feuille de route

| Phase | Contenu | État |
|---|---|---|
| 0 | Environnement, branche git, arborescence, projet Vivado dans le dépôt | fait |
| 1 | AIfES sur le Cortex-A9 : plateforme matérielle (PS7 + UART + DDR, exportée), application Vitis, AIfES et `aiprint`, images MNIST envoyées par l'UART | **fait** (Q7 : 98 % sur 100 images, voir ci-dessous) |
| 2 | Mesures de référence : coût d'une écriture AXI-Lite, temps d'inférence logiciel (F32, puis Q7), répartition du temps par couche | à faire |
| 3 | IP matériel autour de `aimath_q7_default_linear32_bt` : conception, simulation, intégration AXI, mesure du gain | à faire |


## Premier résultat d'inférence sur le Zynq

Réseau Q7 (784-512-256-128-64-10, 575 050 paramètres, 574 080 MAC par inférence), compilé en `-O2`,
exécuté sur le Cortex-A9. Les 100 premières images du jeu de test MNIST sont envoyées par l'UART
(115200 bauds) :

```
python ZYNQ/communication_zynq.py --n 100

Synchronisation sur COM11 ...
Synchronise. Envoi de 100 images ...
    100/100  precision courante  98.0 %
Precision      : 98.00 %  (100 images)
Inference carte: moyenne 1226 us, min 1225 us, max 1235 us
Debit global   : 3.6 images/s  (27.9 s au total, dominees par le transfert UART)
```

Le temps d'inférence est mesuré sur la carte (horloge globale du Cortex-A9), transfert UART exclu :
c'est la référence logicielle pour la phase 2. Le débit global, lui, est limité par l'UART
(3136 octets par image à 115200 bauds).

## Utilisation

1. Dans Vitis, construire `AIfES_component` puis le lancer sur la carte (Run). Le terminal série affiche
   `Pret : en attente du PC sur l'UART`.
2. **Fermer le terminal série de Vitis** : un seul programme à la fois peut ouvrir le port.
3. Lancer le script avec le venv du projet (le port de l'USB-UART est détecté automatiquement) :

```powershell
.\.venv\Scripts\python.exe ZYNQ\communication_zynq.py --n 100
```

Protocole (commun avec le STM32, plus le temps d'inférence) : le PC envoie `0xAB`, la carte répond
`0xCD 0x00` ; puis pour chaque image, le PC envoie 784 `float32` little-endian normalisés par
`(pixel/255) - 0,5`, et la carte répond 10 octets (probabilité de chaque classe × 255) suivis de
4 octets (temps d'inférence en µs, little-endian). Après 0,5 s sans octet, la carte se remet en
attente de synchronisation.
