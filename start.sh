#!/usr/bin/env sh
set -e

echo "DEBUG: DISCORD_TOKEN Laenge ist: ${#DISCORD_TOKEN}"

if [ -z "$DISCORD_TOKEN" ] || [ -z "$OWNER_ID" ]; then
  echo "FEHLER: DISCORD_TOKEN oder OWNER_ID fehlt!"
  exit 1
fi

# Wir schreiben die config.txt absolut sauber im aktuellen Ordner (.)
printf 'discordtoken = "%s"\n' "$DISCORD_TOKEN" > config.txt
printf 'owner = %s\n' "$OWNER_ID" >> config.txt
printf 'prefix = "%s"\n' "${PREFIX:-!}" >> config.txt
printf 'game = "%s"\n' "${GAME:-DEFAULT}" >> config.txt
printf 'status = ONLINE\n' >> config.txt
printf 'songinstatus = false\n' >> config.txt
printf 'stayinchannel = false\n' >> config.txt
printf 'alonetimeuntilstop = %s\n' "${ALONE_TIME:-60}" >> config.txt
printf 'maxtime = 0\n' >> config.txt
printf 'skipratio = 0.55\n' >> config.txt
printf 'updatealerts = false\n' >> config.txt
printf 'loglevel = info\n' >> config.txt
printf 'eval = false\n' >> config.txt

echo "Inhalt der erzeugten config.txt (erste 2 Zeilen):"
head -n 2 config.txt

# Mini-Webserver für Render im Hintergrund starten
mkdir -p /app/health
echo "Music Bot laeuft" > /app/health/index.html
python3 -m http.server "${PORT:-10000}" --directory /app/health > /dev/null 2>&1 &

# JMusicBot starten (er sucht automatisch nach config.txt im aktuellen Ordner)
exec java -Xmx${JAVA_XMX:-300m} -Dnogui=true -jar /app/JMusicBot.jar
