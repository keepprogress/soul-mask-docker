FROM cm2network/steamcmd:root

# USER root
# RUN apt update -y && apt install vim -y


USER steam

WORKDIR /home/steam/steamcmd

RUN echo "$(uname -m)" > platform
RUN mkdir -p /home/steam/temp

COPY GameXishu.json /home/steam/temp/GameXishu.json
COPY entrypoint.sh /home/steam/WS/entrypoint.sh


USER root

RUN chown steam:steam /home/steam/temp/GameXishu.json && \
    chown steam:steam /home/steam/WS/entrypoint.sh && \
    chmod +x /home/steam/WS/entrypoint.sh


USER steam

EXPOSE 8211/udp

VOLUME ["/home/steam/WS/Saved"]

ENTRYPOINT ["/home/steam/WS/entrypoint.sh"]


