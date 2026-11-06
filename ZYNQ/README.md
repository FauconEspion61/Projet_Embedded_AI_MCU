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
  vitis/       espace de travail Vitis (plateforme + application)   [à venir]
```

Le projet Vivado est versionné **en entier**, pour que l'on puisse l'ouvrir et le relire tel quel.
Seuls sont exclus (`ZYNQ/.gitignore`) : le dossier temporaire `.Xil/`, les fichiers de verrou et les
journaux de session écrits à la racine de `vivado/`. Les journaux et rapports des dossiers `.runs/`
restent suivis.

## Ouvrir le projet

```powershell
. .\ZYNQ\env.ps1
vivado ZYNQ\vivado\Projet_Codesign.xpr
```

Ou double-clic sur `ZYNQ/vivado/Projet_Codesign.xpr`. État actuel du matériel : le Processing System
seul (`processing_system7_0`), sur `xc7z020clg484-1`. D'après le block design, le Cortex-A9 tourne à
**666,67 MHz** et `FCLK_CLK0` à **100 MHz**. Le matériel exporté est `vivado/AIfES_wrapper.xsa`.

Le `.xpr` mémorise la carte (`avnet.com:zedboard:part0:1.4`) et un chemin de dépôt de cartes relatif au
profil Windows de l'auteur. Sur une autre machine, Vivado affiche un avertissement ; le circuit et le
block design ne sont pas concernés, et la carte se resélectionne dans *Settings → General*.

## Cloner sous Windows : chemins longs

Les fichiers générés par Vivado ont des chemins profonds. Dans ce dépôt, le plus long chemin d'un
fichier suivi fait **141 caractères** à partir de la racine, ce qui est sous la limite de 260 de
Windows tant que le dépôt est cloné dans un dossier dont le chemin ne dépasse pas environ 115
caractères. Dans le doute :

```powershell
git clone -c core.longpaths=true <url>
```

Chaque IP ajouté au block design allonge ces chemins : à surveiller.

## Environnement

| | |
|---|---|
| Carte | ZedBoard (contraintes `zedboard_master_XDC_RevC_D_v3.xdc` des labs) |
| Circuit | `xc7z020clg484-1` |
| Outils | Vivado et Vitis **2025.2**, installés dans `C:\AMDDesignTools\2025.2` (Vitis Unified IDE) |
| Compilateur ARM | `arm-xilinx-eabi-gcc` 13.3.0, dans `gnu\aarch32\nt\gcc-arm-none-eabi\bin` |

Contrôle effectué : les 62 sources C d'AIfES 2.2.0 (`core/`, `basic/`, `cnn/`) compilent avec ce
compilateur pour `-mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard`, sans erreur.

## Taille du dépôt

Le projet Vivado pèse 27 Mo pour 207 fichiers (le plus gros fait 2,9 Mo). La synthèse et
l'implémentation y ajouteront des points de contrôle `.dcp` et le bitstream : à contrôler avant chaque
envoi, GitHub refusant les fichiers de plus de 100 Mo.

## Feuille de route

| Phase | Contenu | État |
|---|---|---|
| 0 | Environnement, branche git, arborescence, projet Vivado dans le dépôt | fait |
| 1 | AIfES sur le Cortex-A9 : plateforme matérielle (PS7 + UART + DDR, exportée), application Vitis, AIfES et `aiprint`, une image MNIST, comparaison avec le PC | matériel fait, application à faire |
| 2 | Mesures de référence : coût d'une écriture AXI-Lite, temps d'inférence logiciel (F32, puis Q7), répartition du temps par couche | à faire |
| 3 | IP matériel autour de `aimath_q7_default_linear32_bt` : conception, simulation, intégration AXI, mesure du gain | à faire |
