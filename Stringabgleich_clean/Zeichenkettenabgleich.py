#Zeichenkettenabgleich 

import time
import subprocess
zeichen = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzäöüß1234567890 "
zeichenkette = input("Gib die Zeichenkette für den Abgleich ein: ")
result = ""

for position, z in enumerate(zeichenkette):
    for char in zeichen:
        print(f"try: {char}", end="\r", flush=True)
        time.sleep(0.05)
        if char == z:
            print(f"✔ found: {char}")
            result += char
            time.sleep(0.1)
            break

print(f"Ergebnis: {result}")
print("Starte Cleaning...")
subprocess.run(["./clean_bash.sh"])





    
