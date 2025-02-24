import 'package:flutter/material.dart';
import 'generators/encounter_generator.dart';
import 'generators/trap_generator.dart';
import 'generators/quest_generator.dart';
import 'generators/npc_generator.dart';
import 'generators/treasure_generator.dart';

class GeneratorWidget extends StatefulWidget {
  @override
  _GeneratorWidgetState createState() => _GeneratorWidgetState();
}

class _GeneratorWidgetState extends State<GeneratorWidget> {
  final Map<String, Widget Function()> generators = {
    "Encounter": () => EncounterGenerator(),
    "Trap": () => TrapGenerator(),
    "Quest": () => QuestGenerator(),
    "NPC": () => NpcGenerator(),
    "Treasure": () => TreasureGenerator(),
  };

  void _openGenerator(String generatorKey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder:
            (context) => GeneratorScreen(
              generatorKey: generatorKey,
              generatorBuilder: generators[generatorKey]!,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Select a Generator",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int columns = constraints.maxWidth > 600 ? 3 : 2;
                        return GridView.builder(
                          itemCount: generators.keys.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.5,
                              ),
                          itemBuilder: (context, index) {
                            String key = generators.keys.elementAt(index);
                            return GestureDetector(
                              onTap: () => _openGenerator(key),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.75)!,
                                      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.75),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    key,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorScreen extends StatefulWidget {
  final String generatorKey;
  final Widget Function() generatorBuilder;

  GeneratorScreen({required this.generatorKey, required this.generatorBuilder});

  @override
  _GeneratorScreenState createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  Key _generatorKey = UniqueKey();

  void _regenerate() {
    setState(() {
      _generatorKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.generatorKey),
        backgroundColor: const Color.fromARGB(255, 145, 151, 199),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        key: _generatorKey, // ✅ Forces complete rebuild
        child: widget.generatorBuilder(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: _regenerate, child: Text("Regenerate")),
            ],
          ),
        ),
      ),
    );
  }
}
