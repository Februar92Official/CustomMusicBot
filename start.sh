#!/usr/bin/env sh
set -e

echo "DEBUG: DISCORD_TOKEN Laenge ist: ${#DISCORD_TOKEN}"

if [ -z "$DISCORD_TOKEN" ] || [ -z "$OWNER_ID" ]; then
  echo "FEHLER: DISCORD_TOKEN oder OWNER_ID fehlt!"
  exit 1
fi

# Fallback-Werte sauber in reinen Variablen vorbereiten (vermeidet den ':' in der Config)
ALONE_VAL="${ALONE_TIME:-60}"
PREFIX_VAL="${PREFIX:-!}"
GAME_VAL="${GAME:-DEFAULT}"
JAVA_MEM="${JAVA_XMX:-300m}"

# config.txt komplett sauber ohne ':' im Dateiinhalt erzeugen
cat << EOF > /app/config.txt
discordtoken = "$DISCORD_TOKEN"
owner = $OWNER_ID
prefix = "$PREFIX_VAL"
game = "$GAME_VAL"
status = ONLINE
songinstatus = false
stayinchannel = false
alonetimeuntilstop = $ALONE_VAL
maxtime = 0
skipratio = 0.55
updatealerts = false
loglevel = info
eval = false
EOF

echo "config.txt wurde fehlerfrei generiert."

# Mini-Webserver für Render im Hintergrund starten
mkdir -p /app/health
echo "Music Bot laeuft" > /app/health/index.html
python3 -m http.server "${PORT:-10000}" --directory /app/health > /dev/null 2>&1 &

# JMusicBot mit der Config starten
exec java -Xmx${JAVA_MEM} -Dnogui=true -jar /app/JMusicBot.jar /app/config.txt
