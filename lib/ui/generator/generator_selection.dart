import 'package:flutter/material.dart';
import 'generator_screen.dart';
import '../../utils/app_theme.dart';

class GeneratorWidget extends StatefulWidget {
  @override
  GeneratorWidgetState createState() => GeneratorWidgetState();
}

class GeneratorWidgetState extends State<GeneratorWidget> {
  final List<Map<String, dynamic>> generatorTypes = [
    {
      "type": "encounter",
      "icon": AppTheme.categoryIcons['encounter'],
      "color": AppTheme.categoryColors['encounter'],
      "description": "Create random encounters for your adventure"
    },
    {
      "type": "trap", 
      "icon": AppTheme.categoryIcons['trap'],
      "color": AppTheme.categoryColors['trap'],
      "description": "Generate dangerous traps and hazards"
    },
    {
      "type": "quest",
      "icon": AppTheme.categoryIcons['quest'],
      "color": AppTheme.categoryColors['quest'],
      "description": "Create unique quests and missions"
    },
    {
      "type": "npc",
      "icon": AppTheme.categoryIcons['npc'],
      "color": AppTheme.categoryColors['npc'],
      "description": "Generate characters with detailed backgrounds"
    },
    {
      "type": "treasure",
      "icon": AppTheme.categoryIcons['treasure'],
      "color": AppTheme.categoryColors['treasure'],
      "description": "Create magical items and treasure hoards"
    },
  ];

  void _openGenerator(String generatorType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => GeneratorScreen(generatorType: generatorType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/parchment.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.lighten,
            ),
          ),
        ),
        child: Column(
          children: [
            // Header with instructions
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.divider),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_fix_high, color: AppTheme.primary, size: 24),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Content Generator",
                          style: AppTheme.titleStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Create dynamic content for your tabletop games with our specialized generators.",
                    style: AppTheme.subtitleStyle,
                  ),
                ],
              ),
            ),
            
            // Generator cards
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: generatorTypes.length,
                itemBuilder: (context, index) {
                  final generator = generatorTypes[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppTheme.divider, width: 1),
                    ),
                    child: InkWell(
                      onTap: () => _openGenerator(generator["type"]),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: generator["color"],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(generator["icon"], color: Colors.white, size: 28),
                                SizedBox(width: 12),
                                Text(
                                  generator["type"].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Body
                          Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  generator["description"],
                                  style: AppTheme.subtitleStyle,
                                ),
                                SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _openGenerator(generator["type"]),
                                    icon: Icon(Icons.play_arrow),
                                    label: Text("GENERATE"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: generator["color"],
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
