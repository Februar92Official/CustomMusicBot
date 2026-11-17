#!/usr/bin/env sh
set -e

echo "DEBUG: DISCORD_TOKEN Laenge ist: ${#DISCORD_TOKEN}"

if [ -z "$DISCORD_TOKEN" ] || [ -z "$OWNER_ID" ]; then
  echo "FEHLER: DISCORD_TOKEN oder OWNER_ID fehlt!"
  exit 1
fi

# config.txt im aktuellen Verzeichnis (/app) explizit erzeugen
cat << 'EOF' > /app/config.txt
discordtoken = "${DISCORD_TOKEN}"
owner = ${OWNER_ID}
prefix = "${PREFIX:-!}"
game = "${GAME:-DEFAULT}"
status = ONLINE
songinstatus = false
stayinchannel = false
alonetimeuntilstop = ${ALONE_TIME:-60}
maxtime = 0
skipratio = 0.55
updatealerts = false
loglevel = info
eval = false
EOF

# WICHTIG: Ersetze die Platzhalter im Nachhinein, damit Bash/Sh sie garantiert korrekt einsetzt
sed -i "s|\${DISCORD_TOKEN}|$DISCORD_TOKEN|g" /app/config.txt
sed -i "s|\${OWNER_ID}|$OWNER_ID|g" /app/config.txt

echo "Generierte config.txt (erste Zeile zur Kontrolle):"
head -n 1 /app/config.txt

# Mini-Webserver für Render im Hintergrund starten
mkdir -p /app/health
echo "Music Bot laeuft" > /app/health/index.html
python3 -m http.server "${PORT:-10000}" --directory /app/health > /dev/null 2>&1 &

# JMusicBot mit explizitem Config-Pfad starten
exec java -Xmx${JAVA_XMX:-300m} -Dnogui=true -jar /app/JMusicBot.jar /app/config.txt
