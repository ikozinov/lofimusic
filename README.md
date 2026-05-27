# lofimusic

A multi-platform desktop, web, and mobile application written in **Flutter (Dart)**. It is a port of the `lofimusic` Go-app PWA by [agentcobra](https://github.com/agentcobra/lofimusic/).

The app provides a minimalist, beautiful environment for working, studying, and relaxing, streaming famous YouTube Lo-Fi live radio channels.

## Key Features
- **YouTube Live Stream Integration**: Embeds live streams of popular Lo-Fi radio channels.
- **Lore Cards**: Interactive overlays featuring dynamic descriptions, trivia, and backgrounds.
- **Minimalist Aesthetic**: Sleek glassmorphism style, Montserrat typography, and customizable player controls.
- **State Persistence**: Remembers volume levels and the last played channel between sessions.

## Project Structure
- [/lib](file:///Users/ivk/myprojects/lofimusic/lib) — Core application code.
- [/assets](file:///Users/ivk/myprojects/lofimusic/assets) — Dynamic database of radio stations (`radio.json`) and cover images.
- [/.fcontext](file:///Users/ivk/myprojects/lofimusic/.fcontext) — Knowledge management context files for AI developers.

## Channels Database
The radio channels list is synced with [agentcobra/lofimusic](https://github.com/agentcobra/lofimusic/) and configured in [radio.json](file:///Users/ivk/myprojects/lofimusic/assets/radio.json).

Active channels:
1. Everything Fades To Blue
2. Lofi Girl
3. Lofi Sleepy Girl
4. Synthwave Boy
5. Chillhop Raccoon
6. Chillhop Relaxing Raccoon
7. Steezy Coffee Shop
8. Pop Culture Sunday
9. Star Wars Sunday
10. Bootleg Smoke
11. Dreamhop
12. Taiki
13. House in the Woods

## Getting Started
To run the Flutter app locally:
```bash
flutter pub get
flutter run
```
