# Projet Embedded AI MCU — branche `aifes-f32`

Déploiement d'un MLP MNIST sur une **STM32L4R9I-DISCO** (STM32L4R9AIIx, Cortex-M4F à 120 MHz,
2 Mo de Flash) avec la bibliothèque **AIfES** (Fraunhofer IMS), en **float32**.

> **Résultat : cette variante ne tient pas en Flash.** L'édition de liens échoue avec
> `region 'FLASH' overflowed by 584396 bytes`. La branche est conservée comme trace de l'essai.
> La suite du travail est dans la branche **`aifes-q7`** (poids quantifiés en 8 bits).

## Le problème

Le modèle (784 → 512 → 256 → 128 → 64 → 10) compte **575 050 paramètres**. En float32 ils occupent
575 050 × 4 = **2 300 200 octets**, stockés en Flash (`const float aifes_f32_flat_weights[]`,
section `.rodata`). La Flash de la carte fait 2 048 Kio = **2 097 152 octets**
(`STM32L4R9AIIX_FLASH.ld`) : les poids seuls la dépassent.

Message de l'éditeur de liens :

```
ld.exe: STM32_Projet_Embedded_AI_MCU.elf section `.rodata' will not fit in region `FLASH'
ld.exe: region `FLASH' overflowed by 584396 bytes
```

## Ce qui fonctionne dans cette branche

- Export F32 depuis le notebook (`emnist.ipynb`, cellule d'export AIfES) vers `aifes_f32/`.
- Les 62 sources AIfES compilent avec GNU Tools for STM32 14.3 : **0 warning** une fois
  `AIDEBUG_ENABLE_PRINTING` activé.
- Le code applicatif (synchronisation, réception, inférence, réponse) compile et se lie jusqu'au
  dépassement de Flash.
- Sur PC, AIfES F32 donne **exactement** les mêmes classes que Keras (98,14 %, 100 % d'accord).






