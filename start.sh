#!/usr/bin/env sh
set -e

# Prüfen, ob die Variablen da sind
if [ -z "$DISCORD_TOKEN" ]; then
  echo "FEHLER: DISCORD_TOKEN ist nicht gesetzt!"
  exit 1
fi

if [ -z "$OWNER_ID" ]; then
  echo "FEHLER: OWNER_ID ist nicht gesetzt!"
  exit 1
fi

# config.txt explizit schreiben
echo "discordtoken = \"$DISCORD_TOKEN\"" > config.txt
echo "owner = $OWNER_ID" >> config.txt
echo "prefix = \"${PREFIX:-!}\"" >> config.txt
echo "game = \"${GAME:-DEFAULT}\"" >> config.txt
echo "status = ONLINE" >> config.txt
echo "songinstatus = false" >> config.txt
echo "stayinchannel = false" >> config.txt
echo "alonetimeuntilstop = ${ALONE_TIME:-60}" >> config.txt
echo "maxtime = 0" >> config.txt
echo "skipratio = 0.55" >> config.txt
echo "updatealerts = false" >> config.txt
echo "loglevel = info" >> config.txt
echo "eval = false" >> config.txt

echo "Generierte config.txt Inhalt (ohne Token):"
grep -v "discordtoken" config.txt

# Mini-Webserver für Render starten
mkdir -p /app/health
echo "Music Bot laeuft" > /app/health/index.html
python3 -m http.server "${PORT:-10000}" --directory /app/health > /dev/null 2>&1 &

# JMusicBot starten
exec java -Xmx${JAVA_XMX:-300m} -Dnogui=true -jar /app/JMusicBot.jar
