import 'package:flutter/material.dart';
import 'package:tabletools/utils/app_theme.dart';

class QuickGeneratorScreen extends StatefulWidget {
  @override
  _QuickGeneratorScreenState createState() => _QuickGeneratorScreenState();
}

class _QuickGeneratorScreenState extends State<QuickGeneratorScreen> {
  String? _generatedResult;
  String? _currentGenerator;

  final Map<String, List<String>> _generators = {
    'Character Names': [
      'Thorne Ironfist',
      'Luna Moonshadow',
      'Grimm Darkwood',
      'Aria Stormwind',
      'Zephyr Swiftblade',
    ],
    'Tavern Names': [
      'The Drunken Dragon',
      'The Copper Cup',
      'The Rusty Anchor',
      'The Golden Griffin',
      'The Wandering Minstrel',
    ],
    'Plot Hooks': [
      'A mysterious letter arrives with a cryptic message',
      'A local merchant reports strange activity in the woods',
      'A powerful artifact has been stolen from the temple',
      'A plague of undead threatens the village',
      'A rival adventuring party is causing trouble',
    ],
    'Treasure': [
      'A magical sword that glows in the dark',
      'A bag of holding with unknown contents',
      'A mysterious map leading to hidden riches',
      'A cursed amulet with powerful properties',
      'A collection of rare magical scrolls',
    ],
    'Quests': [
      'Retrieve a stolen family heirloom',
      'Clear out a monster-infested cave',
      'Escort a merchant caravan safely',
      'Solve a series of mysterious murders',
      'Find a lost ancient temple',
    ],
  };

  void _generate(String generator) {
    final options = _generators[generator]!;
    final randomIndex = DateTime.now().millisecondsSinceEpoch % options.length;
    setState(() {
      _generatedResult = options[randomIndex];
      _currentGenerator = generator;
    });
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: AppTheme.headerDecoration,
                child: Column(
                  children: [
                    // Logo and title
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.auto_stories,
                            color: AppTheme.primaryDark,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TableTools',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textOnPrimary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'Quick Generators',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textOnPrimary.withOpacity(0.8),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Generator buttons
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _generators.length,
                  itemBuilder: (context, index) {
                    final generator = _generators.keys.elementAt(index);
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _generate(generator),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getGeneratorIcon(generator),
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  generator,
                                  style: AppTheme.titleStyle,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppTheme.primary,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Generated result
              if (_generatedResult != null)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.background.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getGeneratorIcon(_currentGenerator!),
                            color: AppTheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            _currentGenerator!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        _generatedResult!,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textPrimary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () => _generate(_currentGenerator!),
                            icon: Icon(Icons.refresh),
                            label: Text('Generate Again'),
                          ),
                          SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Implement copy to clipboard
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Copied to clipboard!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: Icon(Icons.copy),
                            label: Text('Copy'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getGeneratorIcon(String generator) {
    switch (generator) {
      case 'Character Names':
        return Icons.person;
      case 'Tavern Names':
        return Icons.local_bar;
      case 'Plot Hooks':
        return Icons.auto_stories;
      case 'Treasure':
        return Icons.workspace_premium;
      case 'Quests':
        return Icons.assignment;
      default:
        return Icons.help;
    }
  }
} 