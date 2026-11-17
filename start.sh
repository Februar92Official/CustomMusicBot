#!/usr/bin/env sh
set -e

cd /app

echo "DEBUG: DISCORD_TOKEN Laenge ist: ${#DISCORD_TOKEN}"

if [ -z "$DISCORD_TOKEN" ] || [ -z "$OWNER_ID" ]; then
  echo "FEHLER: DISCORD_TOKEN oder OWNER_ID fehlt!"
  exit 1
fi

# Minimale config.txt erzeugen (damit andere Settings wie Owner geladen werden)
printf 'owner = %s\n' "$OWNER_ID" > config.txt
printf 'prefix = "!"\n' >> config.txt
printf 'status = ONLINE\n' >> config.txt
printf 'songinstatus = false\n' >> config.txt
printf 'stayinchannel = false\n' >> config.txt
printf 'alonetimeuntilstop = 60\n' >> config.txt
printf 'maxtime = 0\n' >> config.txt
printf 'skipratio = 0.55\n' >> config.txt
printf 'updatealerts = false\n' >> config.txt
printf 'loglevel = info\n' >> config.txt
printf 'eval = false\n' >> config.txt

echo "config.txt wurde erstellt."

# Mini-Webserver für Render im Hintergrund starten
mkdir -p /app/health
echo "Music Bot laeuft" > /app/health/index.html
python3 -m http.server "${PORT:-10000}" --directory /app/health > /dev/null 2>&1 &

# JMusicBot starten und den Token direkt als Argument zwingend übergeben
exec java -Xmx${JAVA_XMX:-300m} -Dnogui=true -jar JMusicBot.jar "$DISCORD_TOKEN"
