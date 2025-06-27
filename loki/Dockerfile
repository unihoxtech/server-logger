FROM grafana/loki:2.9.3
COPY config.yaml /etc/loki/config.yaml
EXPOSE 3100

CMD ["-config.file=/etc/loki/config.yaml"]
