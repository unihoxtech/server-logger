FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl unzip supervisor gnupg2 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Grafana
RUN curl -sL https://dl.grafana.com/oss/release/grafana_10.0.0_amd64.deb -o grafana.deb && \
    apt install ./grafana.deb -y && rm grafana.deb

# Install Loki
RUN curl -LO https://github.com/grafana/loki/releases/latest/download/loki-linux-amd64.zip && \
    unzip loki-linux-amd64.zip && mv loki-linux-amd64 /usr/local/bin/loki && chmod +x /usr/local/bin/loki

# Install Promtail
RUN curl -LO https://github.com/grafana/loki/releases/latest/download/promtail-linux-amd64.zip && \
    unzip promtail-linux-amd64.zip && mv promtail-linux-amd64 /usr/local/bin/promtail && chmod +x /usr/local/bin/promtail

# Copy configs
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY loki/config.yaml /etc/loki/config.yaml
COPY promtail/config.yaml /etc/promtail/config.yaml

EXPOSE 3000 3100 9080

CMD ["/usr/bin/supervisord"]
