FROM mcr.microsoft.com/dotnet/runtime:10.0-noble
WORKDIR /app

# yt-dlp 改用 pip 安裝。bashonly 的 sabr build 已經沒有 release，sabr 由 build.sh 傳 git 分支進來
ARG YTDLP_SPEC="yt-dlp[default]"
# plugin 要跟 docker-compose 裡 bgutil-provider 的版本一致
ARG BGUTIL_VERSION=2.0.2

# set -xe 讓 apt/pip 任何一步失敗就直接中止 build
RUN set -xe; \
    apt-get update; \
    apt-get install -y --no-install-recommends python3 python3-venv git wget unzip pipx ffmpeg; \
    python3 -m venv /opt/yt-dlp; \
    /opt/yt-dlp/bin/pip install --no-cache-dir "$YTDLP_SPEC"; \
    ln -s /opt/yt-dlp/bin/yt-dlp /usr/local/bin/yt-dlp; \
    mkdir -p /etc/yt-dlp/plugins; \
    wget -O /etc/yt-dlp/plugins/bgutil-ytdlp-pot-provider.zip "https://github.com/Brainicism/bgutil-ytdlp-pot-provider/releases/download/$BGUTIL_VERSION/bgutil-ytdlp-pot-provider.zip"; \
    pipx ensurepath; \
    pipx install streamlink; \
    apt-get purge -y git wget unzip; \
    apt-get autoremove -y; \
    apt-get autoclean -y

ENV PATH="$PATH:/root/.local/bin"

COPY --from=denoland/deno:bin-2.9.2 /deno /usr/local/bin/deno

COPY docker-entrypoint.sh /app/docker-entrypoint.sh

RUN chmod +x /app/docker-entrypoint.sh; \
    chown 1654:1654 /app/docker-entrypoint.sh

ENTRYPOINT ["/app/docker-entrypoint.sh"]
