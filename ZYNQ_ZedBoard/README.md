# AIfES sur ZedBoard (Zynq-7000)

Branche `aifes-zynq`. Deux objectifs, dans cet ordre :

1. Faire tourner **AIfES sur le cœur ARM** (Cortex-A9, bare-metal) de la ZedBoard.
2. Concevoir un **IP matériel en logique programmable** (type MAC) qui accélère le calcul d'AIfES, et
   mesurer le gain par rapport à la version logicielle.

Le MLP MNIST et son export AIfES viennent du reste du dépôt (`emnist.ipynb`, `aifes_f32/`,
`aifes_q7/`). Le déploiement STM32 est dans `STM32_Projet_Embedded_AI_MCU/` (voir le `README.md`
racine pour ses résultats).

## Environnement

| | |
|---|---|
| Carte | ZedBoard (contraintes `zedboard_master_XDC_RevC_D_v3.xdc` des labs) |
| Circuit | `xc7z020clg484-1` (relevé dans les projets Vivado des labs) |
| Outils | Vivado et Vitis **2025.2**, installés dans `C:\AMDDesignTools\2025.2` (Vitis Unified IDE) |
| Compilateur ARM | `arm-xilinx-eabi-gcc` 13.3.0, dans `gnu\aarch32\nt\gcc-arm-none-eabi\bin` |

Pour avoir `vivado` et `vitis` en ligne de commande dans une session PowerShell :

```powershell
. .\ZYNQ_ZedBoard\scripts\env.ps1
```

Contrôle effectué : les 62 sources C d'AIfES 2.2.0 (`core/`, `basic/`, `cnn/`) compilent avec ce
compilateur pour `-mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard`, sans erreur.

## Organisation prévue

```
ZYNQ_ZedBoard/
  scripts/     env.ps1 et, plus tard, les scripts Tcl de creation des projets
  hw/          Vivado : Tcl, RTL, contraintes, IP (sources uniquement)
  vitis_ws/    espace de travail Vitis : plateforme + application AIfES
```

`hw/` et `vitis_ws/` seront créés avec les premiers projets.

## Ce qui se versionne, ce qui ne se versionne pas

| Se versionne | Ne se versionne pas |
|---|---|
| Scripts Tcl de création du projet Vivado | Le dossier du projet Vivado (`.cache`, `.gen`, `.runs`, `.sim`...) |
| RTL (`.v`, `.sv`), contraintes `.xdc`, IP personnalisés | Journaux `.jou` et `.log` |
| Le matériel exporté `.xsa` (quelques centaines de Ko) | Bitstream `.bit`, binaires `.elf` et `.bin` (reproductibles) |
| Code C de l'application Vitis | Sorties de build des composants Vitis (`build/`, `export/`) |

Le workspace Vitis génère lui-même un `.gitignore` dans chaque composant : on le garde.

## Feuille de route

| Phase | Contenu | État |
|---|---|---|
| 0 | Environnement, branche git, arborescence | fait |
| 1 | AIfES sur le Cortex-A9 : plateforme matérielle (PS7 + UART + DDR), application Vitis, AIfES et `aiprint`, une image MNIST, comparaison avec le PC | à faire |
| 2 | Mesures de référence : temps d'inférence logiciel (F32, puis Q7), répartition du temps par couche | à faire |
| 3 | IP matériel : conception, simulation, intégration AXI, remplacement de la fonction de calcul dans AIfES, mesure du gain | à faire |
