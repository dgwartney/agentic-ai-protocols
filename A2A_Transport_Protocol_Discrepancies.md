# A2A Transport Protocol Support — Full Audit Report

**Audited document:** `A2A_Transport_Protocol_Support.pdf`

**Document claim:** Agent2Agent (A2A) Protocol v0.3.0 · As of March 2026

**Audit date:** 2026-03-09

---

## Summary of Discrepancies

Five issues were identified during verification:

| # | Issue | Severity | Detail |
|---|-------|----------|--------|
| 1 | A2A spec "recommends" JSON-RPC | Nuance | The spec treats all three transports as equal in status; JSON-RPC is the *default fallback*, not a recommendation. The document's "Key insight" overstates this. |
| 2 | LangSmith `tasks/get` support | Inaccurate | Document claims LangSmith supports `tasks/get`; official API docs only list `message/send` and `message/stream`. |
| 3 | Draft v1.0 omission | Nuance | Document says v0.3.0 is current but does not mention that Draft v1.0 is already in progress with SDKs targeting it. |
| 4 | FastA2A spec version | Nuance | FastA2A (PydanticAI) implements A2A v0.2.5, not v0.3.0. May not support all v0.3.0 transport features. |
| 5 | LlamaIndex April 2025 gRPC claim | Inaccurate | gRPC was not formally in the A2A spec until v0.2.2/v0.3.0 (mid-2025); claiming gRPC "via SDK" based on an April 2025 announcement is anachronistic. |

---

## Per-Framework Audit

### 1. Google ADK (Python)

| Transport | Document Claim | Verdict |
|-----------|---------------|---------|
| JSON-RPC 2.0 | Supported | **Confirmed** |
| HTTP+JSON/REST | Supported | **Confirmed** |
| gRPC | Supported | **Confirmed** |

**Document note:** "All three transports supported natively via the official a2a-sdk v0.3.0 on both client and server."

**Audit finding:** The `a2a-sdk` Python package exists on PyPI and supports all three transports. The Google ADK Python integration uses this SDK for A2A connectivity.

**Sources:**
- https://pypi.org/project/a2a-sdk/
- https://google.github.io/adk-docs/

---

### 2. Google ADK (Go)

| Transport | Document Claim | Verdict |
|-----------|---------------|---------|
| JSON-RPC 2.0 | Supported | **Confirmed** |
| HTTP+JSON/REST | Supported | **Confirmed** |
| gRPC | Supported | **Confirmed** |

**Document note:** "Go ADK ClientFactory supports TransportProtocolJSONRPC, TransportProtocolHTTP, and TransportProtocolGRPC."

**Audit finding:** The Go ADK source code defines `TransportProtocol` constants for all three transports in its client factory. These are first-class, configurable options.

**Sources:**
- https://github.com/google/adk-golang

---

### 3. A2A Java SDK (Quarkus / LangChain4j)

| Transport | Document Claim | Verdict |
|-----------|---------------|---------|
| JSON-RPC 2.0 | Supported | **Confirmed** |
| HTTP+JSON/REST | Supported | **Confirmed** |
| gRPC | Supported | **Confirmed** |

**Document note:** "Separate installable Maven modules for each transport. Each can be set as preferred or additional in the Agent Card."

**Audit finding:** The A2A Java SDK provides separate Maven modules (artifacts) for each transport binding. Transports can be declared in the Agent Card as preferred or additional.

**Sources:**
- https://github.com/a2a-java-sdk/a2a-java-sdk

---

### 4. CrewAI

| Transport | Document Claim | Verdict |
|-----------|---------------|---------|
| JSON-RPC 2.0 | Default | **Confirmed** |
| HTTP+JSON/REST | Supported | **Confirmed** |
| gRPC | Supported | **Confirmed** |

**Document note:** "A2AClientConfig explicitly exposes transport options: JSONRPC (default), GRPC, or HTTP+JSON with ordered preference lists."

**Audit finding:** CrewAI's `A2AClientConfig` class exposes a transport configuration option with JSON-RPC as the default and ordered preference lists for alternative transports.

**Sources:**
- https://docs.crewai.com/
- https://github.com/crewAIInc/crewAI

---

### 5. AG2 / AutoGen

| Transport | Document Claim | Verdict |
|-----------|---------------|---------|
| JSON-RPC 2.0 | Supported | **Confirmed** |
| HTTP+JSON/REST | Via SDK | **Confirmed** |
| gRPC | Via SDK | **Confirmed** |

**Document note:** "Uses the official a2a-sdk under the hood. AG2 docs characterize it primarily as JSON-RPC 2.0 over HTTP(S)."

**Audit finding:** AG2/AutoGen uses the `a2a-sdk` package, which provides all three transports. The AG2 documentation emphasizes JSON-RPC as the primary transport.

**Sources:**
- https://ag2.ai/docs/
- https://github.com/ag2ai/ag2

---

### 6. AWS Strands Agents

| Transport | Document Claim | Verdict |
|-----------|---------------|---------|
| JSON-RPC 2.0 | Supported | **Confirmed** |
| HTTP+JSON/REST | Via SDK | **Confirmed** |
| gRPC | Via SDK | **Confirmed** |

**Document note:** "Strands 1.0 adds A2A via A2AServer/A2AClientToolProvider. Bedrock AgentCore explicitly prefers JSON-RPC in its protocol contract."

**Audit finding:** AWS Strands Agents 1.0 includes `A2AServer` and `A2AClientToolProvider` classes for A2A integration. Bedrock AgentCore's protocol contract specifies JSON-RPC as the preferred transport.

**Sources:**
- https://github.com/strands-agents/sdk-python
- https://aws.amazon.com/bedrock/agentcore/

---

### 7. Semantic Kernel (Microsoft)

| Transport | Document Claim | Verdict |
|-----------|---------------|---------|
| JSON-RPC 2.0 | Default | **Confirmed** |
| HTTP+JSON/REST | Via SDK | **Confirmed** |
| gRPC | Via SDK | **Confirmed** |

**Document note:** "Integrates A2A on top of HTTP, JSON-RPC 2.0, SSE. Multi-transport theoretically available via a2a-sdk but not surfaced in SK docs."

**Audit finding:** Semantic Kernel integrates A2A through samples and the `a2a-sdk`, not through native SK abstractions. Multi-transport is available via the underlying SDK but is not documented as a Semantic Kernel feature.

**Sources:**
- https://github.com/microsoft/semantic-kernel
- https://learn.microsoft.com/en-us/semantic-kernel/

---

### 8. LangGraph / LangSmith

| Transport | Document Claim | Verdict |
|-----------|---------------|---------|
| JSON-RPC 2.0 | Supported | **Confirmed** |
| HTTP+JSON/REST | Not documented | **Confirmed** |
| gRPC | Not documented | **Confirmed** |

**Document note:** "LangSmith agent server supports message/send, message/stream, and tasks/get over JSON-RPC only. No gRPC or REST transport documented."

**Audit finding:** The claim about `tasks/get` is **inaccurate**. Official LangSmith API documentation only lists `message/send` and `message/stream` as supported A2A methods. The `tasks/get` endpoint is not documented in the LangSmith agent server API.

| Sub-claim | Verdict |
|-----------|---------|
| `message/send` support | **Confirmed** |
| `message/stream` support | **Confirmed** |
| `tasks/get` support | **Inaccurate** — not listed in official API docs |
| JSON-RPC only | **Confirmed** |

**Sources:**
- https://docs.smith.langchain.com/
- https://github.com/langchain-ai/langsmith-sdk

---

### 9. PydanticAI (FastA2A)

| Transport | Document Claim | Verdict |
|-----------|---------------|---------|
| JSON-RPC 2.0 | Supported | **Confirmed** |
| HTTP+JSON/REST | Not documented | **Confirmed** |
| gRPC | Not documented | **Confirmed** |

**Document note:** "FastA2A implements A2A over JSON-RPC via Starlette/ASGI. No gRPC or REST transport bindings documented."

**Audit finding:** FastA2A implements A2A via JSON-RPC over Starlette/ASGI, confirmed. However, FastA2A targets **A2A spec v0.2.5**, not v0.3.0. This means it may lack some v0.3.0-specific transport features. The document header claims v0.3.0 coverage, which is misleading for this framework.

| Sub-claim | Verdict |
|-----------|---------|
| JSON-RPC via Starlette/ASGI | **Confirmed** |
| Spec version v0.3.0 | **Nuance** — FastA2A implements v0.2.5 |

**Sources:**
- https://ai.pydantic.dev/a2a/
- https://github.com/pydantic/pydantic-ai

---

### 10. LlamaIndex

| Transport | Document Claim | Verdict |
|-----------|---------------|---------|
| JSON-RPC 2.0 | Supported | **Confirmed** |
| HTTP+JSON/REST | Via SDK | **Nuance** |
| gRPC | Via SDK | **Inaccurate** |

**Document note:** "A2A-compatible agents announced April 2025 using the a2a-sdk. All three transports technically available but not a first-class API."

**Audit finding:** LlamaIndex announced A2A-compatible agents in April 2025. At that time, the A2A spec was pre-v0.2.2 and **gRPC was not yet formally part of the spec** (gRPC support was added in v0.2.2/v0.3.0, mid-2025). Claiming gRPC availability "via SDK" for an April 2025 announcement is anachronistic — the SDK version available at that time would not have included gRPC transport bindings.

| Sub-claim | Verdict |
|-----------|---------|
| JSON-RPC support | **Confirmed** |
| HTTP+JSON/REST via SDK | **Nuance** — depends on SDK version at time of integration |
| gRPC via SDK | **Inaccurate** — gRPC not in spec at announcement date |

**Sources:**
- https://www.llamaindex.ai/blog
- https://github.com/run-llama/llama_index

---

## Audit of Legend

The document defines three support levels:

| Symbol | Definition | Verdict |
|--------|-----------|---------|
| Supported | Explicitly documented / natively configurable in the framework | **Accurate** — used consistently |
| Via SDK | The framework depends on Google's `a2a-sdk` library internally, which supports this transport. However, the framework does not expose it as a configurable option in its own API — users would need to configure the underlying SDK directly or modify lower-level settings to use it. | **Accurate** — used consistently |
| Not documented | JSON-RPC only in practice; gRPC/REST not referenced in official docs | **Accurate** — used consistently |

The legend definitions are clear and applied consistently across the table.

---

## Audit of "Key Insight" Claim

**Document states:** "Most frameworks default to JSON-RPC 2.0 as their primary transport. Only the official Google SDKs (Python, Go, Java) and CrewAI explicitly expose all three transports as first-class, configurable options. The A2A spec recommends JSON-RPC for new implementations due to broad language support and firewall compatibility."

| Sub-claim | Verdict |
|-----------|---------|
| Most frameworks default to JSON-RPC 2.0 | **Confirmed** |
| Only Google SDKs + CrewAI expose all three as first-class | **Confirmed** |
| A2A spec "recommends" JSON-RPC | **Nuance** — The A2A spec treats all three transports as equal in status. JSON-RPC is the *default fallback* transport (used when no preference is specified), not a "recommendation." The spec does not express a preference for one transport over another for new implementations. |

---

## Overall Assessment

- **7 of 10 frameworks:** All claims confirmed accurate
- **2 frameworks** (LangSmith, LlamaIndex): Contain inaccurate sub-claims
- **1 framework** (PydanticAI/FastA2A): Spec version nuance (v0.2.5 vs v0.3.0)
- **Key insight:** Mostly accurate but overstates spec's position on JSON-RPC
- **Missing context:** Document does not mention A2A Draft v1.0, which is already in progress with SDKs beginning to target it

The document is broadly reliable as a quick-reference table but should be corrected on the specific discrepancies noted above before use as a definitive reference.
