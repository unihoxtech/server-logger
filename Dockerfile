FROM debian:bullseye

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
      curl \
      unzip \
      gnupg2 \
      supervisor \
      ca-certificates \
      libfontconfig1 \
      adduser \
      libglib2.0-0 \
      nginx \
    && rm -rf /var/lib/apt/lists/*

# Install Grafana
RUN curl -sL https://dl.grafana.com/oss/release/grafana_10.0.0_amd64.deb -o grafana.deb && \
    dpkg -i grafana.deb && \
    rm grafana.deb

# Install Loki
RUN curl -LO https://github.com/grafana/loki/releases/download/v2.9.4/loki-linux-amd64.zip && \
    unzip loki-linux-amd64.zip && \
    mv loki-linux-amd64 /usr/local/bin/loki && \
    chmod +x /usr/local/bin/loki && \
    rm loki-linux-amd64.zip

# Install Promtail
RUN curl -LO https://github.com/grafana/loki/releases/download/v2.9.4/promtail-linux-amd64.zip && \
    unzip promtail-linux-amd64.zip && \
    mv promtail-linux-amd64 /usr/local/bin/promtail && \
    chmod +x /usr/local/bin/promtail && \
    rm promtail-linux-amd64.zip

# Create directories
RUN mkdir -p /etc/loki /etc/promtail /etc/supervisor/conf.d /loki /var/log /etc/nginx/conf.d

# Copy configuration files
COPY loki/loki-config.yaml /etc/loki/loki-config.yaml
COPY promtail/promtail.yaml /etc/promtail/promtail.yaml
COPY supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx/nginx.conf /etc/nginx/conf.d/server-logger.conf

# Expose ports
EXPOSE 80 3000 3100 9080

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]