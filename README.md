# Claude Code - OpenTelemetry

This repository provides a ready-to-use Docker stack to ingest OpenTelemetry metrics from Claude Code.

## Usage

1. Start the Docker stack which starts the following containers: OTEL Collector, Prometheus and Grafana.

```shell
docker compose up -d 
```

2. Set Claude Code environment variables so it sends the metrics to the OTEL Collector.

```shell
source ./env.sh
```

3. Start Claude Code, should see the metrics appearing in Grafana.

```shell
claude
```

## Grafana

The Grafana instance can be accessed at http://localhost:3000, default username/password is `admin`:`admin`.

Prometheus datasource is automatically configured.

TODO: add `.json` file for the example dashboard.

## Helpful Resources

- [Claude Code Monitoring Documentation](https://docs.claude.com/en/docs/claude-code/monitoring-usage)
- [Example AWS Monitoring](https://github.com/aws-solutions-library-samples/guidance-for-claude-code-with-amazon-bedrock/blob/main/assets/docs/MONITORING.md)
