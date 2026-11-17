#!/usr/bin/env sh
set -e

echo "DEBUG: DISCORD_TOKEN Laenge ist: ${#DISCORD_TOKEN}"

# Prüfen, ob die Variablen da sind
if [ -z "$DISCORD_TOKEN" ]; then
  echo "FEHLER: DISCORD_TOKEN ist in Render leer oder nicht gesetzt!"
  exit 1
fi

if [ -z "$OWNER_ID" ]; then
  echo "FEHLER: OWNER_ID ist in Render leer oder nicht gesetzt!"
  exit 1
fi

# config.txt explizit schreiben
cat << EOF > config.txt
discordtoken = "$DISCORD_TOKEN"
owner = $OWNER_ID
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

echo "config.txt wurde geschrieben."

# Mini-Webserver für Render im Hintergrund starten
mkdir -p /app/health
echo "Music Bot laeuft" > /app/health/index.html
python3 -m http.server "${PORT:-10000}" --directory /app/health > /dev/null 2>&1 &

# JMusicBot starten
exec java -Xmx${JAVA_XMX:-300m} -Dnogui=true -jar /app/JMusicBot.jar
