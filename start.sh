#!/bin/sh
set -e

: "${DISCORD_TOKEN:?DISCORD_TOKEN fehlt (Umgebungsvariable)}"
: "${OWNER_ID:?OWNER_ID fehlt (Umgebungsvariable)}"

# config.txt aus Umgebungsvariablen erzeugen, damit der Token nie im Repo steht
cat > config.txt << CONFIG
token = "${DISCORD_TOKEN}"
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
CONFIG

# Mini-Webserver: Render braucht einen offenen Port, UptimeRobot pingt ihn an
mkdir -p /app/health
echo "Music Bot laeuft" > /app/health/index.html
python3 -m http.server "${PORT:-10000}" --directory /app/health > /dev/null 2>&1 &

# JVM-Speicher begrenzen (Render Free hat nur 512 MB RAM)
exec java -Xmx${JAVA_XMX:-300m} -Dnogui=true -jar /app/JMusicBot.jar
