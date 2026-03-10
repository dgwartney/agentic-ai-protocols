---
title: "A2A Transport Protocol Support"
subtitle: "Framework Compatibility Matrix and Analysis"
author: "David Gwartney (david.gwartney@gmail.com)"
date: "March 2026"
rights: "© 2026 David Gwartney. Licensed under CC BY 4.0"
toc: true
toc-depth: 2
numbersections: false
geometry: "margin=1in"
fontsize: 11pt
colorlinks: true
linkcolor: blue
urlcolor: blue
header-includes: |
  \usepackage{fancyhdr}
  \pagestyle{fancy}
  \fancyhf{}
  \fancyfoot[L]{\leftmark}
  \fancyfoot[R]{\thepage}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0.4pt}
  \usepackage{needspace}
  \usepackage{etoolbox}
  \preto{\section}{\needspace{5\baselineskip}}
  \preto{\subsection}{\needspace{4\baselineskip}}
  \preto{\subsubsection}{\needspace{3\baselineskip}}
  \usepackage{longtable}
  \usepackage{booktabs}
include-before: |
  \newpage
---
\newpage
# Introduction

The Agent-to-Agent (A2A) protocol, originally introduced by Google in April 2025, defines a
standard for autonomous AI agents to discover each other's capabilities and exchange tasks,
messages, and artifacts across framework boundaries. A critical — and often overlooked — dimension
of A2A adoption is **transport protocol support**: the wire-level mechanism by which agents
communicate.

The A2A specification defines three transport protocols: JSON-RPC 2.0 over HTTP, HTTP+JSON/REST,
and gRPC. While all three are treated as equal by the spec, framework implementations vary
widely in which transports they expose, how they are configured, and what spec version they
target.

**Audience.** This document is written for Sales Engineers and Product Managers evaluating
agentic framework options. It provides a single reference for comparing transport support
across 14 frameworks, understanding spec version alignment, and identifying gaps or caveats
in each framework's A2A implementation.

**Scope.** The analysis covers 14 frameworks across three transports, tracking A2A spec
versions from v0.1.0 through Draft v1.0. Five inaccuracies identified in an earlier audit
have been corrected inline throughout this document.

\newpage
# A2A Specification Version History

The A2A specification has evolved rapidly since its initial release. Transport protocol support
has expanded with each major version.

| Version | Date | Transport Changes |
|---------|------|-------------------|
| v0.1.0 | April 2025 | Initial release. JSON-RPC 2.0 over HTTP(S) as the sole transport. |
| v0.1.1 | May 2025 | Bug fixes and clarifications. No transport changes. |
| v0.2.0 | June 2025 | Streaming support formalized via SSE over JSON-RPC. No new transports. |
| v0.2.1 | July 2025 | Minor refinements to streaming semantics. JSON-RPC remains only transport. |
| v0.2.2 | August 2025 | **gRPC and HTTP+JSON/REST added** as alternative transports. |
| v0.2.5 | September 2025 | Transport negotiation improvements. Three transports available. |
| v0.3.0 | November 2025 | gRPC formalized with proto definitions. `preferredTransport` field added to AgentCard. IBM ACP merged into A2A, expanding the ecosystem. |
| Draft v1.0 | In progress | Unified `Part` type, `supportedInterfaces[]` replacing capability flags, modern OAuth 2.1 authentication. All three transports remain equal. |

**Key clarification:** The A2A spec treats all three transports as equal in status. JSON-RPC
2.0 is the **default fallback** transport — used when no preference is specified in the
AgentCard — but the spec does not recommend it over the alternatives for new implementations.

\newpage
# Transport Protocol Overview

## JSON-RPC 2.0 over HTTP(S)

The original and default A2A transport. Uses JSON-RPC 2.0 request/response envelopes over
standard HTTP(S). Streaming is achieved via Server-Sent Events (SSE). Widely supported by all
frameworks and compatible with firewalls, proxies, and load balancers without special
configuration.

## HTTP+JSON/REST

A RESTful alternative using standard HTTP methods (GET, POST, PUT) with JSON payloads. Aligns
with conventional web API patterns, making it familiar to developers and easy to integrate with
existing API gateways and monitoring tools. Added to the spec in v0.2.2.

## gRPC

A high-performance binary transport using Protocol Buffers over HTTP/2. Provides built-in
streaming (unary, server-streaming, client-streaming, bidirectional), strong typing via proto
definitions, and efficient serialization. Best suited for internal service-to-service
communication where performance is critical. Formally added in v0.2.2 and fully specified
with proto definitions in v0.3.0.

**When to choose each:**

- **JSON-RPC 2.0** — Default choice. Broad language support, firewall-friendly, sufficient
  for most use cases.
- **HTTP+JSON/REST** — When integration with existing REST-based infrastructure is a priority.
- **gRPC** — When low latency, bidirectional streaming, or strong typing is required in
  internal networks.

# Support Level Definitions

This document uses three support levels to characterize transport availability:

| Level | Definition |
|-------|-----------|
| **Supported** | Explicitly documented and natively configurable in the framework's own API or configuration. |
| **Via SDK** | Available through the underlying `a2a-sdk` library, but not surfaced as a framework-level feature. Users would need to configure the SDK directly. |
| **Not documented** | JSON-RPC only in practice. gRPC and/or REST are not referenced in official documentation. |

\newpage
# Summary Matrix

| Framework | Spec | JSON-RPC | HTTP+JSON | gRPC |
|-----------|------|----------|-----------|------|
| Google ADK (Python) | v0.3.0 | ✓ | ✓ | ✓ |
| Google ADK (Go) | v0.3.0 | ✓ | ✓ | ✓ |
| A2A Java SDK (Quarkus) | v0.3.0 | ✓ | ✓ | ✓ |
| CrewAI | v0.3.0 | ✓ | ✓ | ✓ |
| AG2 / AutoGen | v0.3.0 | ✓ | SDK | SDK |
| AWS Strands Agents | v0.3.0 | ✓ | SDK | SDK |
| Semantic Kernel | v0.3.0 | ✓ | SDK | SDK |
| LangGraph / LangSmith | v0.3.0 | ✓ | — | — |
| PydanticAI (FastA2A) | v0.2.5 | ✓ | — | — |
| LlamaIndex | v0.2.1 | ✓ | — | — |
| Spring AI | v0.3.0 | ✓ | ✓ | — |
| BeeAI / IBM | v0.3.0 | ✓ | SDK | SDK |
| Mastra | v0.3.0 | ✓ | — | — |
| Amazon Bedrock AgentCore | v0.3.0 | ✓ | SDK | SDK |

**Legend:**

✓ = Supported natively 

SDK = Available via underlying `a2a-sdk`

— = Not documented

\newpage
# Per-Framework Details

## Google ADK (Python)

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Supported |
| gRPC | Supported |

**Spec version:** v0.3.0

**Integration:** Native, via the official `a2a-sdk` Python package. All three transports are
supported natively on both client and server sides. The ADK uses the SDK as its A2A connectivity
layer, and transport selection is a first-class configuration option.

**Key classes:** `A2AClient`, `A2AServer` from `a2a-sdk`. Transport is configured at client
instantiation.

**Status:** Production-ready. As the reference implementation maintained by Google, it tracks
the latest spec version closely.

## Google ADK (Go)

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Supported |
| gRPC | Supported |

**Spec version:** v0.3.0

**Integration:** Native. The Go ADK `ClientFactory` supports `TransportProtocolJSONRPC`,
`TransportProtocolHTTP`, and `TransportProtocolGRPC` as first-class, configurable constants.

**Key classes:** `ClientFactory`, `TransportProtocol` constants in the `adk` package.

**Status:** Production-ready. Idiomatic Go implementation with strong typing for transport
selection.

## A2A Java SDK (Quarkus / LangChain4j)

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Supported |
| gRPC | Supported |

**Spec version:** v0.3.0

**Integration:** Native. Separate installable Maven modules provide bindings for each
transport. Each transport can be declared as preferred or additional in the Agent Card.

**Key config:** Maven artifacts per transport (e.g., `a2a-transport-jsonrpc`,
`a2a-transport-grpc`). Transport preference is set in the AgentCard configuration.

**Status:** Production-ready. The modular Maven approach allows deployments to include only
the transports they need.

## CrewAI

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported (default) |
| HTTP+JSON/REST | Supported |
| gRPC | Supported |

**Spec version:** v0.3.0

**Integration:** Native. `A2AClientConfig` explicitly exposes transport options with JSON-RPC
as the default and ordered preference lists for alternative transports.

**Key classes:** `A2AClientConfig` with `transport` parameter accepting `JSONRPC`, `GRPC`,
or `HTTP_JSON`, plus `transport_preferences` for ordered fallback lists.

**Status:** Production-ready. One of only four frameworks that expose all three transports as
first-class configurable options.

## AG2 / AutoGen

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Via SDK |
| gRPC | Via SDK |

**Spec version:** v0.3.0

**Integration:** Via SDK. AG2 uses the official `a2a-sdk` under the hood. Documentation
characterizes A2A primarily as JSON-RPC 2.0 over HTTP(S). HTTP+JSON/REST and gRPC are
available through the underlying SDK but are not surfaced in AG2's own configuration API.

**Key classes:** A2A integration classes delegate to `a2a-sdk` transport layer.

**Status:** Stable. JSON-RPC is the documented and tested path; other transports require
direct SDK configuration.

## AWS Strands Agents

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Via SDK |
| gRPC | Via SDK |

**Spec version:** v0.3.0

**Integration:** Via SDK. Strands 1.0 adds A2A via `A2AServer` and `A2AClientToolProvider`
classes. The framework's A2A integration uses the `a2a-sdk` for transport, with JSON-RPC as
the documented default.

**Key classes:** `A2AServer`, `A2AClientToolProvider` in the Strands SDK.

**Status:** GA as of Strands 1.0. Bedrock AgentCore explicitly prefers JSON-RPC in its
protocol contract.

## Semantic Kernel (Microsoft)

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported (default) |
| HTTP+JSON/REST | Via SDK |
| gRPC | Via SDK |

**Spec version:** v0.3.0

**Integration:** Via SDK. Semantic Kernel integrates A2A through samples and the `a2a-sdk`,
not through native SK abstractions. Multi-transport is available via the underlying SDK but
is not documented as a Semantic Kernel feature.

**Key classes:** A2A samples in the SK repository demonstrate JSON-RPC usage. No SK-native
transport configuration abstraction exists.

**Status:** Stable but community-driven. A2A is not yet a first-class SK feature; expect
deeper integration in future releases.

## LangGraph / LangSmith

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Not documented |
| gRPC | Not documented |

**Spec version:** v0.3.0

**Integration:** Native for JSON-RPC. The LangSmith agent server implements A2A over JSON-RPC
only. No gRPC or REST transport bindings are documented.

**Supported A2A methods:** `message/send` and `message/stream` only.

**Audit correction:** The original analysis claimed LangSmith supports `tasks/get`. This is
**inaccurate** — official LangSmith API documentation lists only `message/send` and
`message/stream` as supported A2A methods.

**Status:** Production-ready for JSON-RPC. Single-transport implementation focused on
LangChain ecosystem integration.

## PydanticAI (FastA2A)

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Not documented |
| gRPC | Not documented |

**Spec version:** v0.2.5

**Audit correction:** FastA2A targets **A2A spec v0.2.5**, not v0.3.0. It may lack some
v0.3.0-specific transport features such as `preferredTransport` in the AgentCard.

**Integration:** Native for JSON-RPC. FastA2A implements A2A via JSON-RPC over
Starlette/ASGI. The implementation is tightly coupled to the ASGI middleware pattern.

**Key classes:** `FastA2A` ASGI application class.

**Status:** Active development. Spec version is one minor version behind; expect updates as
the PydanticAI team tracks the evolving spec.

## LlamaIndex

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Not documented |
| gRPC | Not documented |

**Spec version:** v0.2.1 (at time of initial A2A announcement)

**Audit correction:** LlamaIndex announced A2A-compatible agents in April 2025, when the
A2A spec was pre-v0.2.2. gRPC was **not formally part of the spec** at that time (added in
v0.2.2, August 2025). An earlier analysis claiming gRPC "via SDK" for LlamaIndex was
anachronistic — the SDK version available at the April 2025 announcement would not have
included gRPC transport bindings. HTTP+JSON/REST support similarly depends on the SDK
version integrated.

**Integration:** Via SDK. A2A support uses the `a2a-sdk` for transport, but only JSON-RPC
is documented in LlamaIndex's own materials.

**Status:** Early integration. Transport support should be re-evaluated once LlamaIndex
updates to a post-v0.2.2 SDK version.

## Spring AI

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Supported |
| gRPC | Not documented |

**Spec version:** v0.3.0

**Integration:** Native. Spring AI provides A2A client and server support built on Spring's
HTTP infrastructure. JSON-RPC is the default transport, and HTTP+JSON/REST is available as
a natural fit given Spring's REST-centric architecture. gRPC support is not documented in
Spring AI's A2A integration.

**Key classes:** `A2aClient`, `A2aServer` in the `spring-ai-a2a` module. Transport
configuration follows Spring Boot conventions.

**Status:** Active development. Spring AI's A2A support was added in recent releases and
benefits from Spring's mature HTTP stack. gRPC may follow given Spring's existing gRPC
support in other modules.

## BeeAI Framework / IBM

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Via SDK |
| gRPC | Via SDK |

**Spec version:** v0.3.0

**Integration:** Via SDK. BeeAI originated from IBM's Agent Communication Protocol (ACP),
which merged into A2A in December 2025. The framework uses the `a2a-sdk` for transport
connectivity. JSON-RPC is the primary documented transport, with other transports available
through the underlying SDK.

**Key context:** The ACP-to-A2A merger means BeeAI's A2A implementation benefits from IBM's
prior protocol work, particularly around enterprise agent communication patterns.

**Status:** Active development. The ACP merger is relatively recent; expect continued
refinement of the A2A integration as the unified spec stabilizes.

## Mastra

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Not documented |
| gRPC | Not documented |

**Spec version:** v0.3.0

**Integration:** Native for JSON-RPC. Mastra implements A2A client and server support with
JSON-RPC as the transport layer. The TypeScript/JavaScript framework provides A2A integration
through its agent networking features.

**Key classes:** A2A client and server classes in the Mastra framework. Configuration is
done through the Mastra agent definition.

**Status:** Active development. As a newer framework, A2A support is functional but focused
on the JSON-RPC transport. Multi-transport support may expand as the framework matures.

## Amazon Bedrock AgentCore

| Transport | Support Level |
|-----------|--------------|
| JSON-RPC 2.0 | Supported |
| HTTP+JSON/REST | Via SDK |
| gRPC | Via SDK |

**Spec version:** v0.3.0

**Integration:** Via SDK. Bedrock AgentCore provides managed A2A connectivity as part of
AWS's agent infrastructure. JSON-RPC is explicitly preferred in its protocol contract.
HTTP+JSON/REST and gRPC are available through the underlying SDK layer but are not surfaced
as AgentCore configuration options.

**Key context:** AgentCore is distinct from Strands Agents — it is a managed service layer
that can host Strands-based agents but also supports other frameworks. Its A2A implementation
is tightly integrated with AWS identity and networking services.

**Status:** GA. As a managed AWS service, transport support is controlled by the service
rather than user configuration. JSON-RPC is the production-supported path.

\newpage
# Key Insights

1. **JSON-RPC 2.0 is universal.** All 14 frameworks support JSON-RPC as their primary A2A
   transport. It is the safe default for any integration.

2. **Full multi-transport is rare.** Only four frameworks — Google ADK (Python), Google ADK
   (Go), A2A Java SDK, and CrewAI — expose all three transports as first-class, configurable
   options.

3. **The spec treats transports as equal.** JSON-RPC is the default fallback (used when no
   preference is specified), not a recommendation. This is a common misconception.

4. **SDK-mediated transport is common.** Five frameworks (AG2, Strands, Semantic Kernel,
   BeeAI, Bedrock AgentCore) have multi-transport capability through the `a2a-sdk` but do
   not surface it in their own APIs.

5. **Spec version alignment varies.** Most frameworks target v0.3.0, but PydanticAI (FastA2A)
   targets v0.2.5 and LlamaIndex's initial integration predates v0.2.2. Check spec version
   alignment when evaluating transport capabilities.

6. **Draft v1.0 is in progress.** SDKs are beginning to target the next major version, which
   introduces `supportedInterfaces[]`, unified `Part` types, and modern OAuth 2.1. Transport
   support is expected to remain stable across this transition.

7. **The IBM ACP merger expanded the ecosystem.** BeeAI's transition from ACP to A2A brought
   enterprise agent communication patterns into the A2A community, influencing v0.3.0's
   design.

# Audit Notes

This document incorporates corrections for five discrepancies identified in an independent
audit of an earlier A2A transport protocol analysis. The corrections are:

1. **JSON-RPC "recommendation" language** — Corrected throughout. The A2A spec treats all
   three transports as equal; JSON-RPC is the default fallback, not a recommendation.

2. **LangSmith `tasks/get` support** — Removed. Official LangSmith API documentation lists
   only `message/send` and `message/stream` as supported A2A methods.

3. **Draft v1.0 omission** — Added. The A2A Specification Version History section and Key
   Insights now reference Draft v1.0 and its implications.

4. **FastA2A spec version** — Corrected. PydanticAI's FastA2A targets A2A spec v0.2.5, not
   v0.3.0.

5. **LlamaIndex gRPC claim** — Corrected. The original claim of gRPC "via SDK" was based on
   an April 2025 announcement that predates gRPC's addition to the spec in v0.2.2 (August
   2025). LlamaIndex's transport support is now listed as JSON-RPC only with a note to
   re-evaluate once the SDK version is updated.

For the full audit report, see `A2A_Transport_Protocol_Discrepancies.md`.

\newpage
# Appendix A: References

## A2A Specification and SDKs

1. A2A Protocol Specification — <https://google.github.io/A2A/>
2. A2A Python SDK (`a2a-sdk`) — <https://pypi.org/project/a2a-sdk/>
3. A2A Java SDK — <https://github.com/a2a-java-sdk/a2a-java-sdk>
4. A2A Protocol GitHub Repository — <https://github.com/google/A2A>

## Framework Documentation

5. Google ADK (Python) — <https://google.github.io/adk-docs/>
6. Google ADK (Go) — <https://github.com/google/adk-golang>
7. CrewAI — <https://docs.crewai.com/> · <https://github.com/crewAIInc/crewAI>
8. AG2 / AutoGen — <https://ag2.ai/docs/> · <https://github.com/ag2ai/ag2>
9. AWS Strands Agents — <https://github.com/strands-agents/sdk-python>
10. Amazon Bedrock AgentCore — <https://aws.amazon.com/bedrock/agentcore/>
11. Semantic Kernel — <https://github.com/microsoft/semantic-kernel> · <https://learn.microsoft.com/en-us/semantic-kernel/>
12. LangGraph / LangSmith — <https://docs.smith.langchain.com/> · <https://github.com/langchain-ai/langsmith-sdk>
13. PydanticAI (FastA2A) — <https://ai.pydantic.dev/a2a/> · <https://github.com/pydantic/pydantic-ai>
14. LlamaIndex — <https://www.llamaindex.ai/blog> · <https://github.com/run-llama/llama_index>
15. Spring AI — <https://docs.spring.io/spring-ai/reference/> · <https://github.com/spring-projects/spring-ai>
16. BeeAI Framework — <https://github.com/i-am-bee/beeai-framework>
17. Mastra — <https://mastra.ai/docs> · <https://github.com/mastra-ai/mastra>
