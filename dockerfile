FROM cm2network/steamcmd:root

# USER root
# RUN apt update -y && apt install vim -y


USER steam

WORKDIR /home/steam/steamcmd

RUN echo "$(uname -m)" > platform
RUN mkdir -p /home/steam/WS/Saved

COPY GameXishu.json /home/steam/WS/GameXishu.json
COPY entrypoint.sh /home/steam/WS/entrypoint.sh


USER root

RUN chown steam:steam /home/steam/WS/GameXishu.json && \
    chown steam:steam /home/steam/WS/entrypoint.sh && \
    chmod +x /home/steam/WS/entrypoint.sh


USER steam

EXPOSE 8211/udp

VOLUME ["/home/steam/WS/Saved"]

ENTRYPOINT ["/home/steam/WS/entrypoint.sh"]


