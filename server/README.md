# Setup Server
1. Installieren Sie [Docker](https://docs.docker.com/engine/install/) und das [Compose](https://docs.docker.com/compose/install/linux/) Plugin auf Ihrem Server
2. Kopieren Sie die Dateien **.env**, **Caddyfile**, **config.json**, **docker-compose.yml**, **init.sql** in einen Ordner auf Ihrem Server
3. Geben sie `export CR_PAT=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` und anschließend `echo $CR_PAT | docker login ghcr.io -u ravtscheev --password-stdin` in Ihre Terminal ein. Docker loggt sich dabei im privaten Docker-Registry des Projekt-Repositories an.
4. Als nächstes kann mit `docker pull ghcr.io/kingkoxy/spicesquad:spicesquad-backend` das Image des Backends gepullt werden.
5. Ändern Sie in der **.env** und **Caddyfile** die Variable `{serverdomain}` auf Ihre Server Domain. Falls Sie keine Domain für den Server haben funktioniert Caddys automatisiertes https certificate nicht. Deshalb muss bei Wahl einer IP-Adresse in der **.env** die URL mit `http://{serverip}:3000` gewählt werden!
6. Starten die das Backend mit `docker compose up -d` bzw. `docker-compose up -d`.
7. Alle Anfrage sollten jetzt über `https://{serverdomain}/spicesquad` bzw. `http://{serverip}:3000` gestellt werden können.


Das herunterfahren des SpiceSquad Backend funktioniert über den Befehl `docker compose down` bzw. `docker-compose down`


## Fehlerbehandlung
### Docker Nutzer nicht in Docker Gruppe
Es kann unter Umständen zu Problem bei der Installation von Docker kommen, wodurch der Eingeloggt Nutzer nicht zur Gruppe Docker hinzugefügt wird. Um den Fehler zu beheben geben Sie folgende Befehle ein und ersetzen dabei {username} mit dem derzeitigen Nutzer.
* `sudo groupadd docker`
* `sudo usermod -aG docker {username}`
* `newgrp docker`
* `reboot`

Der Server sollte neu starten und das Problem sollte behoben sein.

### Freie Ports
Es ist wichtig, dass keine anderen Anwendungen auf den Ports **80**, **443**, **5432** und **3000** laufen, da es sonst zu Konflikten kommen kann.

### Anderweitige Fehler
Sollte es zu anderweitigen Fehlern kommen die nicht gelöst werden können, wenden Sie sich gerne an das PSE-Team von SpiceSquad.

## Anmerkungen
Es ist anzumerken, dass durch Watchtower immer das aktuelle Image vom Docker-Registry geholt wird. Ist diese Funktionalität nicht erwünscht sollte in der **docker-compose.yml** der Abschnitt von watchtower entfernt werden.