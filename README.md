# Claude Code - OpenTelemetry

This repository provides a simple stack to view and explore the metrics and logs emitted from Claude Code via
OpenTelemetry.

## Usage

### OpenTelemetry Stack

Start the Docker stack which runs the following containers;

- `OpenTelemetry`
- `Loki` - logs
- `Tempo` - traces (not required for Claude Code)
- `Prometheus` - metrics

```shell
docker compose up -d
```

Volumes are used so that data should persist between restarts.

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

It is preconfigured to have Prometheus (for metrics), Loki (for logs) and Tempo (for traces) as datasources.

## Claude Code Monitoring

Here are the standard attributes provided to all metrics and events:

| **Attribute**       | **Description**                                       | **Controlled By**                                     |
|---------------------|-------------------------------------------------------|-------------------------------------------------------|
| `session.id`        | Unique session identifier                             | `OTEL_METRICS_INCLUDE_SESSION_ID` (default: `true`)   |
| `app.version`       | Current Claude Code version                           | `OTEL_METRICS_INCLUDE_VERSION` (default: `false`)     |
| `organization.id`   | Organization UUID (when authenticated)                | Always included when available                        |
| `user.account_uuid` | Account UUID (when authenticated)                     | `OTEL_METRICS_INCLUDE_ACCOUNT_UUID` (default: `true`) |
| `terminal.type`     | Terminal type (e.g., iTerm.app, vscode, cursor, tmux) | Always included when detected                         |

_Source: https://code.claude.com/docs/en/monitoring-usage#standard-attributes_

### Metrics

Here are the metrics emitted by Claude Code, according to their documentation:

| **Metric Name**                       | **Description**                                 | **Unit** | **Controlled By**                                       | **Attributes**                                                                                                                               |
|---------------------------------------|-------------------------------------------------|----------|---------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `claude_code.session.count`           | Count of CLI sessions started                   | count    | Incremented at the start of each session                | All standard attributes                                                                                                                      |
| `claude_code.lines_of_code.count`     | Count of lines of code modified                 | count    | Incremented when code is added or removed               | All standard attributes<br>`type`: ("added", "removed")                                                                                      |
| `claude_code.pull_request.count`      | Number of pull requests created                 | count    | Incremented when creating pull requests via Claude Code | All standard attributes                                                                                                                      |
| `claude_code.commit.count`            | Number of git commits created                   | count    | Incremented when creating git commits via Claude Code   | All standard attributes                                                                                                                      |
| `claude_code.cost.usage`              | Cost of the Claude Code session                 | USD      | Incremented after each API request                      | All standard attributes<br>`model`: Model identifier (e.g., “claude-sonnet-4-5-20250929”)                                                    |
| `claude_code.token.usage`             | Number of tokens used                           | tokens   | Incremented after each API request                      | All standard attributes<br>`type`: ("input", "output", "cacheRead", "cacheCreation")<br>`model`: Model identifier                            |
| `claude_code.code_edit_tool.decision` | Count of code editing tool permission decisions | count    | Incremented when user accepts or rejects tool usage     | All standard attributes<br>`tool`: ("Edit", "Write", "NotebookEdit")<br>`decision`: ("accept", "reject")<br>`language`: Programming language |
| `claude_code.active_time.total`       | Total active time in seconds                    | s        | Incremented during active user interactions             | All standard attributes                                                                                                                      |

_Source: https://code.claude.com/docs/en/monitoring-usage#metrics_

### Events

Here are the events emitted by Claude Code, according to their documentation:

| **Event Name**              | **Description**                                                 | **Controlled By**                                     | **Attributes**                                                                                                                                                                |
|-----------------------------|-----------------------------------------------------------------|-------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `claude_code.user_prompt`   | Logged when a user submits a prompt.                            | Triggered when a user enters a prompt.                | All standard attributes<br>`event.timestamp`<br>`prompt_length`<br>`prompt` (redacted by default)                                                                             |
| `claude_code.tool_result`   | Logged when a tool completes execution.                         | Triggered upon tool completion.                       | All standard attributes<br>`event.timestamp`<br>`tool_name`<br>`success`<br>`duration_ms`<br>`error` (if failed)<br>`decision`<br>`source`<br>`tool_parameters`               |
| `claude_code.api_request`   | Logged for each API request made to Claude.                     | Triggered after every API request.                    | All standard attributes<br>`event.timestamp`<br>`model`<br>`cost_usd`<br>`duration_ms`<br>`input_tokens`<br>`output_tokens`<br>`cache_read_tokens`<br>`cache_creation_tokens` |
| `claude_code.api_error`     | Logged when an API request to Claude fails.                     | Triggered on API request failure.                     | All standard attributes<br>`event.timestamp`<br>`model`<br>`error`<br>`status_code`<br>`duration_ms`<br>`attempt`                                                             |
| `claude_code.tool_decision` | Logged when a tool permission decision is made (accept/reject). | Triggered when user accepts or rejects a tool action. | All standard attributes<br>`event.timestamp`<br>`tool_name`<br>`decision`<br>`source`                                                                                         |

_Source: https://code.claude.com/docs/en/monitoring-usage#events_

## Additional Resources

- [Claude Code Monitoring Documentation](https://docs.claude.com/en/docs/claude-code/monitoring-usage)
- [Example AWS Monitoring](https://github.com/aws-solutions-library-samples/guidance-for-claude-code-with-amazon-bedrock/blob/main/assets/docs/MONITORING.md)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/what-is-opentelemetry/)
- [Grafana Documentation](https://grafana.com/docs/)
