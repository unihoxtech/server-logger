FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
  wget curl gnupg ca-certificates unzip supervisor \
  && rm -rf /var/lib/apt/lists/*

# Install Grafana with dependency fix
RUN wget https://dl.grafana.com/oss/release/grafana_10.2.3_amd64.deb && \
    dpkg -i grafana_10.2.3_amd64.deb || true && \
    apt-get update && apt-get install -y -f && \
    rm grafana_10.2.3_amd64.deb

# Install Loki
RUN wget https://github.com/grafana/loki/releases/download/v2.9.3/loki-linux-amd64.zip && \
    unzip loki-linux-amd64.zip && \
    mv loki-linux-amd64 /usr/bin/loki && \
    chmod +x /usr/bin/loki && \
    rm loki-linux-amd64.zip

# Copy configuration
COPY loki/config.yaml /etc/loki/config.yaml
COPY supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports
EXPOSE 3000 3100

# Start both Grafana and Loki
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
