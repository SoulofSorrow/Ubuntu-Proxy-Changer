## Proxy Check Service

Dieses Projekt enthält ein Bash-Skript und eine Systemd-Service-Datei, um den Proxy-Server systemweit in Ubuntu zu setzen oder zu entfernen, basierend auf der Erreichbarkeit eines spezifischen Hosts im Netzwerk.

### Funktionsweise

Das Bash-Skript `proxy-check.sh` überprüft den Status des angegebenen Hosts im Netzwerk mithilfe des Ping-Befehls. Wenn der Host erreichbar ist, werden die Proxy-Einstellungen gesetzt. Andernfalls werden die Proxy-Einstellungen entfernt.

Die Konfigurationsvariablen, einschließlich des zu überprüfenden Hosts und der Proxy-Einstellungen, werden in einer separaten Konfigurationsdatei (`proxy.conf`) gespeichert.

Die Systemd-Service-Datei `proxy-check.service` ermöglicht es, den Proxy Check Service automatisch beim Systemstart zu starten und den Service kontinuierlich zu überwachen. Bei einem Absturz des Dienstes oder einem Fehler im Skript wird der Service automatisch neu gestartet.

### Verwendung

1. Klone das Repository:

   ```plaintext
   git clone https://github.com/SoulofSorrow/Ubuntu-Proxy-Changer.git
   ```

2. Navigiere in das Verzeichnis:

   ```plaintext
   cd Ubuntu-Proxy-Changer
   ```

3. Bearbeite die Konfigurationsdatei `proxy-check.conf` und setze die entsprechenden Werte für den zu überprüfenden Host und die Proxy-Einstellungen.

4. Kopiere das Bash-Skript und die Service-Datei in die richtigen Verzeichnisse:

   ```plaintext
   sudo cp proxy-check.sh /usr/local/bin/
   sudo cp proxy-check.service /etc/systemd/system/
   ```

5. Aktualisiere den Service und starte ihn:

   ```plaintext
   sudo systemctl daemon-reload
   sudo systemctl enable proxy-check.service
   sudo systemctl start proxy-check.service
   ```

Der Proxy Check Service wird nun automatisch beim Systemstart gestartet und überwacht den Status des spezifischen Hosts, um den Proxy entsprechend zu setzen oder zu entfernen. Der Service wird auch automatisch neu gestartet, falls er abstürzen sollte oder das Skript einen Fehler zurückgibt.

Du kannst den Status des Services mit dem Befehl `systemctl status proxy-check.service` überprüfen.
