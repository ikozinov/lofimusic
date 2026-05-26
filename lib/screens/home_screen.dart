import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:app/models/radio_station.dart';
import 'package:app/providers/radio_provider.dart';
import 'package:app/widgets/station_player.dart';
import 'package:app/widgets/player_loader.dart';
import 'package:app/widgets/svg_icon.dart';

// Links styling constants
const String buyMeACoffeeURL = "https://www.buymeacoffee.com/maxence";
const String coinbaseBusinessURL = "https://commerce.coinbase.com/checkout/851320a4-35b5-41f1-897b-74dd5ee207ae";
const String githubURL = "https://github.com/maxence-charriere/lofimusic";
const String twitterURL = "https://twitter.com/jonhymaxoo";

// Hover Link widget for list items & support
class HoverLink extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final bool isFocused;

  const HoverLink({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isFocused = false,
  });

  @override
  State<HoverLink> createState() => _HoverLinkState();
}

class _HoverLinkState extends State<HoverLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color textColor = widget.isFocused
        ? Colors.white
        : (_isHovered ? Colors.white : const Color(0xFFC0C0C0));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.icon,
                if (widget.label.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      widget.label,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontWeight: widget.isFocused ? FontWeight.w500 : FontWeight.w400,
                        fontSize: 14,
                        shadows: widget.isFocused || _isHovered
                            ? const [
                                Shadow(
                                  blurRadius: 1,
                                  color: Colors.black,
                                  offset: Offset(1, 1),
                                )
                              ]
                            : null,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Info Link widget for social profiles of station owners
class InfoLink extends StatefulWidget {
  final String svgData;
  final String url;
  const InfoLink({super.key, required this.svgData, required this.url});

  @override
  State<InfoLink> createState() => _InfoLinkState();
}

class _InfoLinkState extends State<InfoLink> {
  bool _isHovered = false;
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    double scale = 1.0;
    if (_isActive) {
      scale = 0.98;
    } else if (_isHovered) {
      scale = 1.4;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isActive = true),
        onTapUp: (_) => setState(() => _isActive = false),
        onTapCancel: () => setState(() => _isActive = false),
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: SvgIcon(
              svgData: widget.svgData,
              size: 18,
              color: _isHovered ? Colors.white : const Color(0xFFC0C0C0),
            ),
          ),
        ),
      ),
    );
  }
}

// Hover Control widget for playback buttons
class HoverControl extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final double size;
  final bool isLarge;

  const HoverControl({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 18,
    this.isLarge = false,
  });

  @override
  State<HoverControl> createState() => _HoverControlState();
}

class _HoverControlState extends State<HoverControl> {
  bool _isHovered = false;
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    final double paddingVal = widget.isLarge ? 24 : 12;
    final bool isEnabled = widget.onTap != null;
    
    Color color = isEnabled
        ? (_isHovered ? Colors.white : const Color(0xFFC0C0C0))
        : const Color(0xFF696969); // dimgray

    double scale = 1.0;
    if (isEnabled) {
      if (_isActive) {
        scale = 0.98;
      } else if (_isHovered) {
        scale = 1.15;
      }
    }

    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isActive = true) : null,
        onTapUp: isEnabled ? (_) => setState(() => _isActive = false) : null,
        onTapCancel: isEnabled ? () => setState(() => _isActive = false) : null,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          child: Container(
            margin: const EdgeInsets.all(6),
            padding: EdgeInsets.all(paddingVal),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1),
              color: Colors.transparent,
            ),
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}

// Draggable Window Title Bar Area Channel Wrapper
class WindowDragArea extends StatelessWidget {
  final Widget child;
  const WindowDragArea({super.key, required this.child});

  static const _channel = MethodChannel('lofimusic/window');

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        _channel.invokeMethod('startDragging');
      },
      child: child,
    );
  }
}

// Info Cards Rotating widget (alternating facts / trivia text)
class InfoCardsRotator extends StatefulWidget {
  final List<String> cards;
  final bool isPlaying;
  const InfoCardsRotator({super.key, required this.cards, required this.isPlaying});

  @override
  State<InfoCardsRotator> createState() => _InfoCardsRotatorState();
}

class _InfoCardsRotatorState extends State<InfoCardsRotator> {
  int _currentIndex = -1;
  bool _isVisible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRotation();
  }

  @override
  void didUpdateWidget(InfoCardsRotator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cards != oldWidget.cards) {
      _currentIndex = -1;
      _isVisible = false;
      _timer?.cancel();
      _startRotation();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRotation() {
    if (widget.cards.isEmpty) return;
    _tick();
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      if (_isVisible) {
        _isVisible = false;
        // Stay hidden for 5 seconds
        _timer = Timer(const Duration(seconds: 5), _tick);
      } else {
        _isVisible = true;
        _currentIndex = (_currentIndex + 1) % widget.cards.length;
        // Stay visible for 10 seconds
        _timer = Timer(const Duration(seconds: 10), _tick);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty || _currentIndex == -1 || !widget.isPlaying) {
      return const SizedBox.shrink();
    }
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(seconds: 2), // 2s transition curve
      child: Text(
        widget.cards[_currentIndex],
        style: GoogleFonts.montserrat(
          fontSize: 17,
          fontWeight: FontWeight.w300,
          letterSpacing: 2,
          color: Colors.white,
          height: 1.5,
          shadows: const [
            Shadow(
              blurRadius: 2,
              color: Colors.black,
              offset: Offset(1, 1),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Drawer/Static Sidebar component
class SidebarWidget extends StatelessWidget {
  final bool isDrawer;
  const SidebarWidget({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RadioProvider>(context);
    
    return Container(
      width: 282,
      height: double.infinity,
      color: isDrawer ? const Color(0xFF000000).withOpacity(0.94) : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Logo Area
          Container(
            height: 108,
            padding: const EdgeInsets.symmetric(horizontal: 36),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                if (provider.stations.isNotEmpty) {
                  provider.setCurrentStation(provider.stations.first);
                }
              },
              child: Text(
                'Lofimusic',
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  letterSpacing: 6,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Stations List Scroll Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: provider.stations.length,
                itemBuilder: (context, index) {
                  final station = provider.stations[index];
                  final isFocused = provider.currentStation?.id == station.id;
                  
                  return Padding(
                    key: ValueKey(station.id),
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: HoverLink(
                      icon: SvgIcon(
                        svgData: playSVG,
                        size: 14,
                        color: isFocused ? Colors.white : const Color(0xFFC0C0C0),
                      ),
                      label: station.name.toUpperCase(),
                      isFocused: isFocused,
                      onTap: () {
                        provider.setCurrentStation(station);
                        if (isDrawer) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // Support / Brand Links
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                HoverLink(
                  icon: const SvgIcon(svgData: coffeeSVG, size: 14),
                  label: "BUY ME A COFFEE",
                  onTap: () => launchUrl(Uri.parse(buyMeACoffeeURL)),
                ),
                HoverLink(
                  icon: const SvgIcon(svgData: cryptoSVG, size: 14),
                  label: "DONATE CRYPTOS",
                  onTap: () => launchUrl(Uri.parse(coinbaseBusinessURL)),
                ),
                HoverLink(
                  icon: const SvgIcon(svgData: githubSVG, size: 14),
                  label: "GITHUB",
                  onTap: () => launchUrl(Uri.parse(githubURL)),
                ),
                HoverLink(
                  icon: const SvgIcon(svgData: twitterSVG, size: 14),
                  label: "TWITTER",
                  onTap: () => launchUrl(Uri.parse(twitterURL)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  YoutubePlayerController? _ytController;
  StreamSubscription<YoutubePlayerValue>? _playerSubscription;
  RadioStation? _lastStation;
  RadioProvider? _provider;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String jsonString = await rootBundle.loadString('assets/radio.json');
    if (mounted) {
      Provider.of<RadioProvider>(context, listen: false).loadStations(jsonString);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final newProvider = Provider.of<RadioProvider>(context);
    if (_provider != newProvider) {
      _provider?.removeListener(_onProviderVolumeOrMuteChanged);
      _provider = newProvider;
      _provider!.addListener(_onProviderVolumeOrMuteChanged);
    }
    
    final station = _provider?.currentStation;
    if (station != null && station != _lastStation) {
      _lastStation = station;
      _initControllerForStation(station);
    }
  }

  void _initControllerForStation(RadioStation station) {
    if (_ytController == null) {
      _ytController = YoutubePlayerController.fromVideoId(
        videoId: station.id,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: false,
          showFullscreenButton: false,
          playsInline: true,
          mute: false,
        ),
      );
      _playerSubscription = _ytController!.listen(_onPlayerStateChanged);
      
      // Sync initial audio parameters
      if (_provider != null) {
        _ytController!.setVolume(_provider!.volume);
        if (_provider!.isMuted) {
          _ytController!.mute();
        } else {
          _ytController!.unMute();
        }
      }
    } else {
      _ytController!.loadVideoById(videoId: station.id);
    }
    if (mounted) setState(() {});
  }

  void _onPlayerStateChanged(YoutubePlayerValue value) {
    if (!mounted || _ytController == null || _provider == null) return;
    final state = value.playerState;
    final isPlaying = state == PlayerState.playing;
    final isBuffering = state == PlayerState.buffering ||
                        state == PlayerState.unStarted;
    
    _provider!.setPlaybackState(isPlaying, isBuffering);

    if (value.error != YoutubeError.none) {
      int code = -1;
      String msg = "unknown error";
      
      switch (value.error) {
        case YoutubeError.invalidParam:
          code = 2;
          msg = "invalid video parameter values";
          break;
        case YoutubeError.html5Error:
          code = 5;
          msg = "loading video failed";
          break;
        case YoutubeError.videoNotFound:
          code = 100;
          msg = "video not found";
          break;
        case YoutubeError.cannotFindVideo:
          code = 105;
          msg = "video not found";
          break;
        case YoutubeError.notEmbeddable:
          code = 101;
          msg = "video cannot be played in embedded players";
          break;
        case YoutubeError.sameAsNotEmbeddable:
          code = 150;
          msg = "video cannot be played in embedded players";
          break;
        default:
          code = -1;
          msg = "unknown error";
          break;
      }
      
      final formattedError = "youtube player error:\n  code:        $code\n  description: $msg";
      _provider!.setError(formattedError);
    } else if (isPlaying || isBuffering) {
      _provider!.setError(null);
    }
  }

  void _onProviderVolumeOrMuteChanged() {
    if (!mounted || _ytController == null || _provider == null) return;
    _ytController!.setVolume(_provider!.volume);
    if (_provider!.isMuted) {
      _ytController!.mute();
    } else {
      _ytController!.unMute();
    }
  }

  @override
  void dispose() {
    _provider?.removeListener(_onProviderVolumeOrMuteChanged);
    _playerSubscription?.cancel();
    _ytController?.close();
    super.dispose();
  }

  String getVolumeIcon(int vol, bool isMuted) {
    if (isMuted || vol == 0) return soundMutedSVG;
    if (vol > 60) return soundHighSVG;
    if (vol > 20) return soundMediumSVG;
    return soundLowSVG;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RadioProvider>(context);
    final width = MediaQuery.of(context).size.width;
    
    final currentStation = provider.currentStation;
    final hasStation = currentStation != null && _ytController != null;

    Widget bodyContent = Stack(
      children: [
        // 1. Stretched Background Player with Layout-driven Cover Fit
        if (hasStation)
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final containerWidth = constraints.maxWidth;
                final containerHeight = constraints.maxHeight;
                
                double playerWidth;
                double playerHeight;
                
                // Calculate cover sizes to preserve 16:9 aspect ratio without native scale artifacts
                if (containerWidth / containerHeight > 16 / 9) {
                  playerWidth = containerWidth;
                  playerHeight = containerWidth * 9 / 16;
                } else {
                  playerHeight = containerHeight;
                  playerWidth = containerHeight * 16 / 9;
                }
                
                return Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      left: (containerWidth - playerWidth) / 2,
                      top: (containerHeight - playerHeight) / 2,
                      width: playerWidth,
                      height: playerHeight,
                      child: IgnorePointer(
                        child: StationPlayer(controller: _ytController!),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        else
          Positioned.fill(child: Container(color: Colors.black)),

        // 2. Black Fade Gradient Overlay (.youtube::after)
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black,
                  ],
                  stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                ),
              ),
            ),
          ),
        ),

        // 3. Buffering / Pause / Error Overlay (.youtube-noplay equivalent)
        if (hasStation) ...[
          if (!provider.isPlaying || provider.isBuffering || provider.errorMsg != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.94), // background-overlay
                child: (provider.isBuffering || provider.errorMsg != null)
                    ? PlayerLoader(
                        title: "Buffering",
                        description: currentStation.name,
                        isLoading: provider.isBuffering,
                        errorMsg: provider.errorMsg,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
        ] else if (provider.stations.isEmpty)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2E343A),
                    Color(0xFF1C1D1F),
                  ],
                ),
              ),
              child: const PlayerLoader(
                title: "Loading",
                description: "Fetching radio stations...",
                isLoading: true,
              ),
            ),
          ),

        // 4. Main Screen Grid Content
        Positioned.fill(
          child: Row(
            children: [
              // Show static sidebar if screen is wide enough (> 700px)
              if (width > 700) const SidebarWidget(isDrawer: false),
              
              // Content Area
              Expanded(
                child: hasStation
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                // Info Card facts in upper left (.info-card)
                                Positioned(
                                  top: 108.0 + 18.0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      constraints: const BoxConstraints(maxWidth: 480),
                                      child: InfoCardsRotator(
                                        cards: currentStation.cards,
                                        isPlaying: provider.isPlaying,
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // Right Bottom Station Title / Separator / Social Links
                                Positioned(
                                  right: 0,
                                  bottom: constraints.maxHeight * 0.25,
                                  child: AnimatedOpacity(
                                    opacity: (provider.isPlaying && !provider.isBuffering) ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 500),
                                    child: IntrinsicWidth(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            currentStation.name.toUpperCase(),
                                            style: GoogleFonts.montserrat(
                                              fontSize: 38, // .h1 size
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 7,
                                              color: Colors.white,
                                              shadows: const [
                                                Shadow(
                                                  blurRadius: 2,
                                                  color: Colors.black,
                                                  offset: Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          // Title separator
                                          Container(
                                            height: 1,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(18),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          // Social Links Row
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: currentStation.socialMedia.map((sm) {
                                              return InfoLink(
                                                svgData: socialIcon(sm.mediaSlug),
                                                url: sm.url,
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),

        // 5. Custom Controls Bar Overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isMobile = constraints.maxWidth < 500;
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Spacing to balance volume slider on right (approx 150px)
                    if (!isMobile) const SizedBox(width: 150),
                    
                    const Spacer(),
                    
                    // Controls Center Group
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isMobile)
                          HoverControl(
                            icon: const SvgIcon(svgData: backwardSVG, size: 18),
                            onTap: provider.canBack ? () => provider.goBack() : null,
                          ),
                        HoverControl(
                          icon: SvgIcon(
                            svgData: provider.isPlaying ? pauseSVG : playSVG,
                            size: 18,
                          ),
                          onTap: hasStation
                              ? () {
                                  if (provider.isPlaying) {
                                    _ytController!.pauseVideo();
                                  } else {
                                    _ytController!.playVideo();
                                  }
                                }
                              : null,
                        ),
                        HoverControl(
                          icon: const SvgIcon(svgData: shuffleSVG, size: 30),
                          isLarge: true,
                          onTap: provider.stations.isNotEmpty
                              ? () => provider.playShuffle()
                              : null,
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Audio Controls Group (hidden on <= 500px width)
                    if (!isMobile)
                      SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HoverControl(
                              icon: SvgIcon(
                                svgData: getVolumeIcon(provider.volume, provider.isMuted),
                                size: 18,
                              ),
                              onTap: hasStation ? () => provider.toggleMute() : null,
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 2.0,
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                                  thumbColor: Colors.white,
                                  overlayColor: Colors.white.withOpacity(0.1),
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                                ),
                                child: Slider(
                                  value: provider.volume.toDouble(),
                                  min: 0,
                                  max: 100,
                                  onChanged: hasStation
                                      ? (val) {
                                          provider.setVolume(val.round());
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),

        // 6. Hamburger Drawer Icon for narrow screens
        if (width <= 700)
          Positioned(
            top: 24,
            left: 24,
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),

        // 7. Draggable Window Title Bar Area
        Positioned(
          top: 0,
          left: 80, // leave space for traffic lights on the left
          right: 0,
          height: 40,
          child: const WindowDragArea(child: SizedBox.expand()),
        ),

      ],
    );

    return Title(
      title: currentStation != null ? 'Lofimusic - ${currentStation.name} Radio' : 'Lofimusic',
      color: Colors.black,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        drawer: width <= 700 ? const Drawer(child: SidebarWidget(isDrawer: true)) : null,
        body: hasStation
            ? YoutubePlayerControllerProvider(
                controller: _ytController!,
                child: bodyContent,
              )
            : bodyContent,
      ),
    );
  }
}
