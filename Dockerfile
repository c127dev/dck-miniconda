FROM debian:bullseye-slim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV CONDA_INSTALL_PATH=/app/conda
ENV MINICONDA_INSTALLER_SCRIPT=/tmp/miniconda_installer.sh
ENV MINICONDA_VERSION="latest"
ENV TARGETARCH=${TARGETARCH}
ENV PATH=${CONDA_INSTALL_PATH}/bin:$PATH

ENV APP_USER=app

# WARNING: Use another password (Only Debug purposes)
ENV APP_PASS=RT2fEDayXh4zVQBtr7WwCHgd
ENV PUID=1000
ENV PGID=1000

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl bash sudo git\
    && curl -fsSL -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/latest/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/local/bin/gosu \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
WORKDIR /app

COPY source/* /usr/local/bin/
RUN chmod 755 -R /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "bash" ]