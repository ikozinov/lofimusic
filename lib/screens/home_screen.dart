import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/radio_provider.dart';
import 'package:app/widgets/station_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  Widget build(BuildContext context) {
    return MacosWindow(
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: 0,
            onChanged: (index) {},
            items: const [
              SidebarItem(
                label: Text('Radios'),
              ),
            ],
          );
        },
      ),
      child: MacosScaffold(
        toolBar: const ToolBar(
          title: Text('Lofimusic'),
          titleWidth: 150.0,
        ),
        children: [
          ContentArea(
            builder: (context, scrollController) {
              return Consumer<RadioProvider>(
                builder: (context, provider, child) {
                  if (provider.stations.isEmpty) {
                    return const Center(child: ProgressCircle());
                  }

                  return Column(
                    children: [
                      if (provider.currentStation != null)
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.black,
                          child: StationPlayer(station: provider.currentStation!),
                        ),
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1,
                          ),
                          itemCount: provider.stations.length,
                          itemBuilder: (context, index) {
                            final station = provider.stations[index];
                            return GestureDetector(
                              onTap: () {
                                provider.setCurrentStation(station);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/covers/${station.slug}.png',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey.withValues(alpha: 0.2),
                                            child: const Center(
                                              child: Icon(Icons.music_note, size: 48),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    station.name,
                                    style: MacosTheme.of(context).typography.headline,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
