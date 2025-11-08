# Claude Code - OpenTelemetry

This repository provides a simple stack to view and explore the metrics and logs emitted from Claude Code via
OpenTelemetry.

## Usage

### OpenTelemetry Stack

```shell
docker compose up -d
```

### Claude Code Configuration

The following Claude Code environment variables are the minimum required to send the metrics and logs to our
OpenTelemetry collector, check out [Claude Code Monitoring](https://code.claude.com/docs/en/monitoring-usage) for more.

```shell
# enable telemetry
export CLAUDE_CODE_ENABLE_TELEMETRY=1
# use otlp exporter and point to locally hosted endpoint
export OTEL_METRICS_EXPORTER=otlp
export OTEL_LOGS_EXPORTER=otlp
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
# enable logging of prompts and including details in metrics
export OTEL_LOG_USER_PROMPTS=1
export OTEL_METRICS_INCLUDE_SESSION_ID=true
export OTEL_METRICS_INCLUDE_VERSION=true
export OTEL_METRICS_INCLUDE_ACCOUNT_UUID=true
```

These can also be set in the `.claude/settings.json`:

```json
{
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "grpc",
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://localhost:4317",
    "OTEL_LOG_USER_PROMPTS": "1",
    "OTEL_METRICS_INCLUDE_SESSION_ID": "true",
    "OTEL_METRICS_INCLUDE_VERSION": "true",
    "OTEL_METRICS_INCLUDE_ACCOUNT_UUID": "true"
  }
}
```

## Grafana Dashboard

The Grafana container can be accessed at http://localhost:3000, default username/password is `admin`:`admin`.

It is preconfigured to have Prometheus (for metrics) and Loki (for logs) as datasources.

## Additional Resources

- [Claude Code Monitoring Documentation](https://docs.claude.com/en/docs/claude-code/monitoring-usage)
- [Example AWS Monitoring](https://github.com/aws-solutions-library-samples/guidance-for-claude-code-with-amazon-bedrock/blob/main/assets/docs/MONITORING.md)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/what-is-opentelemetry/)
- [Grafana Documentation](https://grafana.com/docs/)
- 