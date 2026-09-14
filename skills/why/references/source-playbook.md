# Source playbooks

One investigator per source, each carrying a single playbook from `sources/`. Which sources exist is decided at run time, never assumed.

## Discover what is connected

1. Git is always available. `gh` is available when `gh auth status` succeeds. If it fails, PR bodies and review threads are unreachable. Record that as a gap in Sources Consulted, and the source control investigator works from commits alone.
2. Run `claude mcp list`. It prints every configured MCP server and whether it is connected or needs authentication. A server that is not connected does not get an investigator. Record it as a gap.
3. Confirm from the tool names in your context. MCP tools are named `mcp__<server>__<tool>`, for example `mcp__plugin_linear_linear__get_issue` or `mcp__claude_ai_Notion__notion-search`. If the schemas are deferred, `ToolSearch` loads them.
4. Map each connected server to a playbook by what its tools do, not by its name alone.

| Source | Playbook | Verified against |
|---|---|---|
| Source control history | `sources/code-archaeology.md` | git, `gh` |
| Issue tracker | `sources/linear.md` | the Linear MCP, tools under `mcp__plugin_linear_linear__` |
| Long-form documents | `sources/notion.md` | the Notion MCP, tools under `mcp__claude_ai_Notion__` |

A different tracker or docs MCP (Jira, Confluence, Google Docs) takes the playbook for its category. Tell the investigator to read the server's tool schemas first and adapt the tool names.

## When nothing is connected

Git alone is a complete run, not a failure. Spawn the single source control investigator. Sources Consulted then names the tracker and documents as not searched because no MCP was connected. The user learns where the record was not reachable, which is itself an answer.

## A source with no playbook

An MCP that fits none of the three (team chat, error tracking, a warehouse) still counts as evidence. Spawn its investigator with the base prompt alone, tell it to read the server's tool schemas before searching, and say in Sources Consulted that it ran without a playbook.

## Defensive code

If the target looks defensive (null checks, retries, timeouts, rate limits, feature flags, guards), an incident probably motivated it. Each playbook has a section for that hunt. Make sure every investigator runs it.
