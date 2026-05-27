# lofimusic

**lofimusic** is a multi-platform desktop, web, and mobile app written in **Flutter (Dart)**. It is a direct port/clone of the Go-app PWA by agentcobra ([github.com/agentcobra/lofimusic](https://github.com/agentcobra/lofimusic)).

The app provides a minimalist, beautiful environment for working, studying, and relaxing, featuring:
- Streaming of famous YouTube Lo-Fi live radio channels.
- Ambient description overlays (Lore/trivia cards) that rotate dynamically.
- Custom aesthetic player controls (play, pause, shuffle, volume, history).
- Clean, responsive sidebar navigation.
- A premium, pure black (`#000000`) theme with glowing text, Montserrat typography, and smooth micro-animations.

## Knowledge Available

- `_cache/` — (empty, run `fcontext index` to convert documents)
- `_topics/` — (empty, AI writes analysis here)
- `_requirements/` — Requirements board, including the Flutter porting specification in `REQ-001`.

## Key Concepts

- **Multi-Platform Flutter Core**: Target platforms include macOS (native), Web, iOS, Android, Windows, and Linux.
- **YouTube Live Stream Integration**: Embeds YouTube live streams via standard player widgets (using WebView or YouTube IFrame API).
- **State & Local Storage**: Retains user preferences like the volume slider level and the last played radio station across app launches.
- **Aesthetics & Responsive Shell**: Implements a glassmorphic sidebar shell that collapses into a drawer on mobile screens and layouts optimized for wide screens.
