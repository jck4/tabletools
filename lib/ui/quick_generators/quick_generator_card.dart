import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/quick_generator_model.dart';
import '../../services/quick_generator_service.dart';
import '../../utils/app_theme.dart';
import 'quick_generator_screen.dart';

class QuickGeneratorCard extends StatefulWidget {
  const QuickGeneratorCard({Key? key}) : super(key: key);

  @override
  _QuickGeneratorCardState createState() => _QuickGeneratorCardState();
}

class _QuickGeneratorCardState extends State<QuickGeneratorCard> {
  String _currentResult = '';
  String _currentGeneratorName = '';
  bool _hasResult = false;

  // Selected quick generators for the home screen
  final List<QuickGeneratorType> _featuredGenerators = [
    QuickGeneratorType(
      id: 'character_name',
      name: 'Character Name',
      description: 'Generate a character name',
      icon: Icons.person,
      color: AppTheme.categoryColors['npc']!,
      generate: () => QuickGeneratorService.generateName(),
    ),
    QuickGeneratorType(
      id: 'tavern_name',
      name: 'Tavern',
      description: 'Generate a tavern name',
      icon: Icons.local_bar,
      color: Colors.brown[700]!,
      generate: () => QuickGeneratorService.generateTavernName(),
    ),
    QuickGeneratorType(
      id: 'plot_hook',
      name: 'Plot Hook',
      description: 'Generate a quest idea',
      icon: Icons.auto_stories,
      color: AppTheme.categoryColors['quest']!,
      generate: () => QuickGeneratorService.generatePlotHook(),
    ),
  ];
  
  void _generateAndDisplay(QuickGeneratorType generator) {
    final result = generator.generate();
    setState(() {
      _currentResult = result;
      _currentGeneratorName = generator.name;
      _hasResult = true;
    });
  }
  
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _currentResult));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        backgroundColor: AppTheme.primary,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _openFullGeneratorScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuickGeneratorScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with title and "more" button
        Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Row(
            children: [
              Icon(Icons.flash_on, color: AppTheme.accentDark, size: 20),
              SizedBox(width: 8),
              Text(
                'QUICK GENERATORS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: 1.0,
                ),
              ),
              Spacer(),
              TextButton.icon(
                onPressed: _openFullGeneratorScreen,
                icon: Icon(Icons.more_horiz, size: 18),
                label: Text('More'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accentDark,
                ),
              ),
            ],
          ),
        ),
        
        // Quick generator buttons
        Container(
          height: 90,
          margin: EdgeInsets.only(left: 16, right: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _featuredGenerators.length,
            itemBuilder: (context, index) {
              final generator = _featuredGenerators[index];
              return Container(
                width: 100,
                margin: EdgeInsets.only(right: 12),
                child: ElevatedButton(
                  onPressed: () => _generateAndDisplay(generator),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: generator.color,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(generator.icon, size: 24),
                      SizedBox(height: 4),
                      Text(
                        generator.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Results (only shown when something has been generated)
        if (_hasResult) 
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _currentGeneratorName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      constraints: BoxConstraints.tightFor(width: 30, height: 30),
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      icon: Icon(Icons.refresh, color: AppTheme.primary),
                      tooltip: 'Generate Again',
                      onPressed: () {
                        final generator = _featuredGenerators.firstWhere(
                          (g) => g.name == _currentGeneratorName, 
                          orElse: () => _featuredGenerators.first
                        );
                        _generateAndDisplay(generator);
                      },
                    ),
                    IconButton(
                      constraints: BoxConstraints.tightFor(width: 30, height: 30),
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      icon: Icon(Icons.copy, color: AppTheme.primary),
                      tooltip: 'Copy to Clipboard',
                      onPressed: _copyToClipboard,
                    ),
                  ],
                ),
                Divider(height: 16, color: AppTheme.divider),
                Text(
                  _currentResult,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
} 