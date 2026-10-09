# Projet Embedded AI MCU — branche `aifes-q7`

Déploiement d'un MLP MNIST sur une **STM32L4R9I-DISCO** (STM32L4R9AIIx, Cortex-M4F à 120 MHz,
2 Mo de Flash) avec la bibliothèque **AIfES** (Fraunhofer IMS), en **float32** convertit en **int8**.

> **Résultat : cette variante tient en Flash.** L'édition de liens réussit avec de la marge,
> plus plus de dépassement RAM. Le code compile sur STM32L4R9 sans problème. 
> Resultat du test sur 100 images avec le programme **Communication_STM32** :
Synchronising...
Synchronised
Evaluating model on STM32...
----- Iteration 1 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.01

----- Iteration 2 -----
   Expected output: [0. 0. 1. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.02

----- Iteration 3 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.03

----- Iteration 4 -----
   Expected output: [1. 0. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.04

----- Iteration 5 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.05

----- Iteration 6 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.06

----- Iteration 7 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.792156862745098, 0.0, 0.0, 0.0, 0.0, 0.19607843137254902]
----------------------- Accuracy: 0.07

----- Iteration 8 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.00784313725490196, 0.4392156862745098, 0.0, 0.058823529411764705, 0.0, 0.00784313725490196, 0.011764705882352941, 0.4392156862745098]
----------------------- Accuracy: 0.07

----- Iteration 9 -----
   Expected output: [0. 0. 0. 0. 0. 1. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.19607843137254902, 0.792156862745098, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.07

----- Iteration 10 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549]
----------------------- Accuracy: 0.08

----- Iteration 11 -----
   Expected output: [1. 0. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.09

----- Iteration 12 -----
   Expected output: [0. 0. 0. 0. 0. 0. 1. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.10

----- Iteration 13 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549]
----------------------- Accuracy: 0.11

----- Iteration 14 -----
   Expected output: [1. 0. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.12

----- Iteration 15 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.13

----- Iteration 16 -----
   Expected output: [0. 0. 0. 0. 0. 1. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.14

----- Iteration 17 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549]
----------------------- Accuracy: 0.15

----- Iteration 18 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.16

----- Iteration 19 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.17

----- Iteration 20 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.18

----- Iteration 21 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549]
----------------------- Accuracy: 0.19

----- Iteration 22 -----
   Expected output: [0. 0. 0. 0. 0. 0. 1. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.023529411764705882, 0.9647058823529412, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.20

----- Iteration 23 -----
   Expected output: [0. 0. 0. 0. 0. 0. 1. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.21

----- Iteration 24 -----
   Expected output: [0. 0. 0. 0. 0. 1. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.22

----- Iteration 25 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.9647058823529412, 0.0, 0.0, 0.0, 0.0, 0.023529411764705882]
----------------------- Accuracy: 0.23

----- Iteration 26 -----
   Expected output: [1. 0. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.24

----- Iteration 27 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.25

----- Iteration 28 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.26

----- Iteration 29 -----
   Expected output: [1. 0. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.27

----- Iteration 30 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.28

----- Iteration 31 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.29

----- Iteration 32 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.9764705882352941, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.011764705882352941]
----------------------- Accuracy: 0.30

----- Iteration 33 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.31

----- Iteration 34 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.023529411764705882, 0.0, 0.0, 0.0, 0.9647058823529412, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.32

----- Iteration 35 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.33

----- Iteration 36 -----
   Expected output: [0. 0. 1. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.34

----- Iteration 37 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.35

----- Iteration 38 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.36

----- Iteration 39 -----
   Expected output: [0. 0. 1. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.37

----- Iteration 40 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.38

----- Iteration 41 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.9568627450980393, 0.0, 0.0, 0.0, 0.0, 0.0, 0.011764705882352941, 0.0, 0.011764705882352941]
----------------------- Accuracy: 0.39

----- Iteration 42 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.40

----- Iteration 43 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.41

----- Iteration 44 -----
   Expected output: [0. 0. 1. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.42

----- Iteration 45 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.43

----- Iteration 46 -----
   Expected output: [0. 0. 0. 0. 0. 1. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.44

----- Iteration 47 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.45

----- Iteration 48 -----
   Expected output: [0. 0. 1. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.46

----- Iteration 49 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.47

----- Iteration 50 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.48

----- Iteration 51 -----
   Expected output: [0. 0. 0. 0. 0. 0. 1. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.49

----- Iteration 52 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.50

----- Iteration 53 -----
   Expected output: [0. 0. 0. 0. 0. 1. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.51

----- Iteration 54 -----
   Expected output: [0. 0. 0. 0. 0. 1. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.52

----- Iteration 55 -----
   Expected output: [0. 0. 0. 0. 0. 0. 1. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.53

----- Iteration 56 -----
   Expected output: [1. 0. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.54

----- Iteration 57 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.55

----- Iteration 58 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.56

----- Iteration 59 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549]
----------------------- Accuracy: 0.57

----- Iteration 60 -----
   Expected output: [0. 0. 0. 0. 0. 1. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.8941176470588236, 0.0, 0.0784313725490196, 0.0, 0.011764705882352941]
----------------------- Accuracy: 0.58

----- Iteration 61 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.59

----- Iteration 62 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 1. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0]
----------------------- Accuracy: 0.60

----- Iteration 63 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549]
----------------------- Accuracy: 0.61

----- Iteration 64 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.9411764705882353, 0.0, 0.0, 0.0, 0.0, 0.047058823529411764, 0.0]
----------------------- Accuracy: 0.62

----- Iteration 65 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.63

----- Iteration 66 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.8941176470588236, 0.011764705882352941, 0.0, 0.0, 0.0, 0.0784313725490196]
----------------------- Accuracy: 0.64

----- Iteration 67 -----
   Expected output: [0. 0. 0. 0. 0. 0. 1. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.65

----- Iteration 68 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.66

----- Iteration 69 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.67

----- Iteration 70 -----
   Expected output: [1. 0. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.68

----- Iteration 71 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.69

----- Iteration 72 -----
   Expected output: [1. 0. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.70

----- Iteration 73 -----
   Expected output: [0. 0. 1. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.71

----- Iteration 74 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549]
----------------------- Accuracy: 0.72

----- Iteration 75 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.73

----- Iteration 76 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.74

----- Iteration 77 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.75

----- Iteration 78 -----
   Expected output: [0. 0. 1. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.76

----- Iteration 79 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549]
----------------------- Accuracy: 0.77

----- Iteration 80 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.78

----- Iteration 81 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9411764705882353, 0.0, 0.047058823529411764]
----------------------- Accuracy: 0.79

----- Iteration 82 -----
   Expected output: [0. 0. 0. 0. 0. 0. 1. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.80

----- Iteration 83 -----
   Expected output: [0. 0. 1. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.81

----- Iteration 84 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.82

----- Iteration 85 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 1. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0]
----------------------- Accuracy: 0.83

----- Iteration 86 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.84

----- Iteration 87 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.85

----- Iteration 88 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.86

----- Iteration 89 -----
   Expected output: [0. 0. 0. 0. 0. 0. 1. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.87

----- Iteration 90 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.88

----- Iteration 91 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.89

----- Iteration 92 -----
   Expected output: [0. 0. 0. 0. 0. 0. 1. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.90

----- Iteration 93 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549]
----------------------- Accuracy: 0.91

----- Iteration 94 -----
   Expected output: [0. 0. 0. 1. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.9529411764705882, 0.0, 0.0, 0.0, 0.0, 0.0, 0.03529411764705882]
----------------------- Accuracy: 0.92

----- Iteration 95 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.93

----- Iteration 96 -----
   Expected output: [0. 0. 0. 0. 1. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.94

----- Iteration 97 -----
   Expected output: [0. 1. 0. 0. 0. 0. 0. 0. 0. 0.]
   Received output: [0.0, 0.48627450980392156, 0.0196078431372549, 0.0, 0.17647058823529413, 0.0196078431372549, 0.01568627450980392, 0.01568627450980392, 0.0392156862745098, 0.17647058823529413]
----------------------- Accuracy: 0.95

----- Iteration 98 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 1. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0]
----------------------- Accuracy: 0.96

----- Iteration 99 -----
   Expected output: [0. 0. 0. 0. 0. 0. 1. 0. 0. 0.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549, 0.0, 0.0, 0.0]
----------------------- Accuracy: 0.97

----- Iteration 100 -----
   Expected output: [0. 0. 0. 0. 0. 0. 0. 0. 0. 1.]
   Received output: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.996078431372549]
----------------------- Accuracy: 0.98

> On arrive donc a une précision de 98% sur le modèle testé **on device** et quantifié en **Q7**

## Ce qui fonctionne dans cette branche

- Export Q7 depuis le notebook (`emnist.ipynb`, cellule d'export AIfES) vers `aifes_q7/`.
- Les 62 sources AIfES compilent avec GNU Tools for STM32 14.3 : **0 warning** une fois
  `AIDEBUG_ENABLE_PRINTING` activé.
- Le code applicatif (synchronisation, réception, inférence, réponse) compile et se lie sans dépassement de mémoire Flash.
- Test du modèle sur le device **STM32L4R9** : tout fonctionne et le modèle atteint une précision de 98%.

## Conclusion 

Le modèle quantizé en Q7 passe sans problème sur le device **STM32L4R9** (empreinte mémoire divisée par 4). Les tests montrent un précision de 98% ce qui représente une perte négligeable au vu des gains de mémoire.






