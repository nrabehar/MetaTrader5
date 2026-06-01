FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm as base

ENV TITLE=MetaTrader5
ENV	WINEARCH=win64
ENV	WINEPREFIX="/config/.wine"
ENV DISPLAY=:0

# Ensure the directory exists with correct permissions
RUN mkdir -p /config/.wine && \
	chown -R abc:abc /config/.wine && \
	chmod -R 755 /config/.wine

# Update packages lists and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y --no-install-recommends \
	dos2unix \
	python3-pip \
	wget \
	python3-pyxdg \
	netcat \
	&& pip install --upgrade pip

RUN wget -q https://dl.winehq.org/wine-builds/winehq.key > /dev/null 2>&1 && \
	apt-key add winehq.key && \
	add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ bookworm main' && \
	rm winehq.key

RUN dpkg --add-architecture i386 && \
	apt-get update

RUN apt-get install -y --no-install-recommends \
	winehq-stable && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

FROM base as final

COPY scripts /scripts
RUN dos2unix /scripts/*.sh && chmod +x /scripts/*.sh

COPY root /
RUN touch /var/log/mt5_setup.log && \
	chmod abc:abc /var/log/mt5_setup.log && \
	chmod 644 /var/log/mt5_setup.log

VOLUME /config