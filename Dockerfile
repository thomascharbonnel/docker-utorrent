FROM ubuntu
LABEL maintainer "thomas@charbonnel.email"

# Set default user and group IDs
ENV PUID 1000
ENV PGID 1000

# Create user and group for utorrent.
RUN groupadd -r -g $PGID utorrent \
    && useradd -r -u $PUID -g $PGID -d /utorrent -m utorrent

# Add utorrent init script.
ADD utorrent.sh /utorrent.sh
RUN chown utorrent: /utorrent.sh \
    && chmod 755 /utorrent.sh

# Install utorrent and all required dependencies.
RUN apt-get -q update \
    && apt-get install -qy curl libssl1.0.0 \
    && curl -s http://download.ap.bittorrent.com/track/beta/endpoint/utserver/os/linux-x64-ubuntu-13-04 | tar xzf - --strip-components 1 -C /utorrent \
    && chown -R utorrent: /utorrent \
    && apt-get -y remove curl \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# Define container settings.
VOLUME ["/settings", "/media"]

EXPOSE 8080 6881

# Start utorrent.

WORKDIR /utorrent

CMD ["/utorrent.sh"]
