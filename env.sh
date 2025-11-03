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
