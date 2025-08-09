# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Testing Commands

Run tests using:
```bash
npm test
# or
mocha --exit
```

The test suite uses Mocha and covers basic usage scenarios as well as features for both free and paid ngrok authtokens. Tests are located in the `test/` directory.

## Project Architecture

This is a Node.js wrapper for the ngrok binary that provides programmatic access to ngrok tunneling functionality. The project follows a modular architecture:

### Core Components

- **index.js**: Main entry point exposing the public API (`connect`, `disconnect`, `kill`, `authtoken`, etc.)
- **src/process.js**: Manages the ngrok binary process lifecycle, including spawning, monitoring, and cleanup. Handles the singleton pattern for the ngrok process and parses ngrok's stdout/stderr for status updates
- **src/client.js**: HTTP client wrapper using `got` library for communicating with ngrok's internal API (typically running on localhost:4040). Provides methods for tunnel management, request inspection, and error handling
- **src/utils.js**: Configuration handling, input validation, and retry logic utilities

### Key Architecture Patterns

- **Singleton Process**: Only one ngrok process runs at a time (`getProcess` function ensures this)
- **Promise-based API**: All operations return promises for async/await compatibility
- **Retry Logic**: Built-in retry mechanism for tunnel creation when ngrok isn't ready (up to 100 retries with 200ms delays)
- **Event-driven Status**: Optional callbacks for connection status changes and log events
- **Configuration Integration**: Supports ngrok's native config files at `~/.ngrok2/ngrok.yml`

### Binary Management

The package uses `@expo/ngrok-bin` for managing ngrok binaries across different platforms. The `postinstall.js` script handles binary downloads, with support for corporate proxies via `HTTPS_PROXY` and custom CDN URLs via `NGROK_CDN_URL`.

### API Client Pattern

The internal API client wraps ngrok's REST API with dedicated methods:
- Tunnel management: `listTunnels`, `startTunnel`, `stopTunnel`, `tunnelDetail`  
- Request inspection: `listRequests`, `replayRequest`, `requestDetail`, `deleteAllRequests`
- Consistent error handling via `NgrokClientError` class

### TypeScript Support

Full TypeScript definitions are provided in `ngrok.d.ts` with types organized under the `Ngrok` namespace. The main options interface is `Ngrok.Options`.