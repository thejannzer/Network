#Netzwerkscan mit nmap (installieren über pip)
import nmap
import tkinter as tk
from tkinter import scrolledtext
import threading

#scan_running = False  (kann weg, weil mit Button config gearbeitet wird)

def scan_network():
    #global scan_running

    subnet = entry.get()
    if not subnet:
        output.insert(tk.END, "Bitte ein Subnetz eingeben")
        return
    
    output.insert(tk.END, f"Starte Scan für: {subnet}")

    #scan_running = True
    btn.config(state = "disabled")  #Button deaktivieren solange ein Scan läuft

    def scan():
        #global scan_running
        scanner = nmap.PortScanner()

        try:
            scanner.scan(hosts = subnet, arguments = 'sn')
        except Exception as e:
            output.insert(tk.END, f"Fehler: {e}")
            #scan_running = False
            btn.config(state = "normal")
            return

        hosts = scanner.all_hosts()
        output.insert(tk.END, f"\nGefundene Geräte:\n")

        for host in hosts:
            state = scanner[host].state()
            output.insert(tk.END, f"{host} - {state}\n")

        output.insert(tk.END, "\nScan abgeschlossen.\n")
        #scan_running = False
        btn.config(state = "normal")

    threading.Thread(target=scan).start()

# ---------- GUI ----------
root = tk.Tk()
root.title("nmap Netzwerkscanner")
root.geometry("1000x800")

label = tk.Label(root, text="Subnetz eingeben (z.B. 192.168.0.0/24):")
label.pack(pady=5)

entry = tk.Entry(root, width=30)
entry.pack()

btn = tk.Button(root, text="Scan starten", command=scan_network)
btn.pack(pady=10)

output = scrolledtext.ScrolledText(root, width=60, height=15)
output.pack(pady=10)

root.mainloop()
    
