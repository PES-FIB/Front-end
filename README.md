# Front-End PES

Per a provar l'aplicació:

1. Descarregar flutter
2. Descarregar el repositori
3. Si es vol provar l’aplicació en un dispositiu mòbil, s’hauran d’activar les developer options i també s'hauria d’activar l'USB debugging mode
4. Connectar el mòbil a l'ordinador via cable USB
5. Un cop dins la carpeta del repositori (carpeta arrel del repositori) s’ha d’executar la següent seqüència de comandes per instal·lar l’aplicació en el dispositiu, depenent d'en quin mode es vulgui executar. 
      - flutter pub get (per obtenir les dependències de l’aplicació)
      Si es desitja córrer l’aplicació en mode Release:
      - flutter run --release 
      Si en canvi, volem córrer l’aplicació en mode Debug:
      - flutter run
6. Esperar que l’aplicació s’instal·li en el dispositiu.
I fet, ja està l’aplicació llesta per a poder ser executada!

Alternativament:
1. Navegar desde la carpeta arrel fins a: /apk en l’explorador d’arxius, aquesta és la carpeta on es troba l’apk de l’aplicació en mode Release.
2. Copiar l’arxiu culturicat.apk en el directori del mòbil que es desitgi i que sigui accessible.
3. Desde el mòbil, instal·lar l’arxiu que acabes de copiar (és possible que faci falta donar permisos de descàrregues externes)

