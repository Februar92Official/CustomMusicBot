FROM eclipse-temurin:17-jre

# Python nur für den kleinen Health-Webserver (Render + UptimeRobot)
RUN apt-get update \
 && apt-get install -y --no-install-recommends python3-minimal \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Version hier ändern, wenn es ein Update gibt: https://github.com/jagrosh/MusicBot/releases/latest
ARG JMUSICBOT_VERSION=0.4.3
ADD https://github.com/jagrosh/MusicBot/releases/download/${JMUSICBOT_VERSION}/JMusicBot-${JMUSICBOT_VERSION}.jar /app/JMusicBot.jar

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
