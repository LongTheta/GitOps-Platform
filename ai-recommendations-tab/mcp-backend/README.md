# MCP Backend for AI Recommendations

MCP (Model Context Protocol) server that provides app health, optimization, and fix recommendations to the Argo CD AI Recommendations tab.

## Overview

The Argo CD Proxy Extension forwards requests to this backend with headers:
- `Argocd-Application-Name`
- `Argocd-Project-Name`

The MCP server exposes tools/resources/prompts for recommendations.

## Setup

1. Implement MCP server (resources, tools for app health, optimizations, fixes)
2. Configure Argo CD `extension.config` to point to this service
3. Enable Proxy Extension: `server.enable.proxy.extension: 'true'`

## References

- [MCP Specification](https://modelcontextprotocol.io/specification/2025-06-18/basic)
- [Build an MCP server](https://modelcontextprotocol.io/docs/develop/build-server)
