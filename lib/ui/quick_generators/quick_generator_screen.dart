import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/quick_generator_model.dart';
import '../../services/quick_generator_service.dart';
import '../../utils/app_theme.dart';

class QuickGeneratorScreen extends StatefulWidget {
  const QuickGeneratorScreen({Key? key}) : super(key: key);

  @override
  _QuickGeneratorScreenState createState() => _QuickGeneratorScreenState();
}

class _QuickGeneratorScreenState extends State<QuickGeneratorScreen> {
  String _currentResult = '';
  String _currentGeneratorName = '';
  bool _hasResult = false;
  
  // Create a list of quick generators
  final List<QuickGeneratorType> _generators = [
    QuickGeneratorType(
      id: 'male_name',
      name: 'Male Name',
      description: 'Generate a male character name',
      icon: Icons.person,
      color: AppTheme.categoryColors['npc']!,
      generate: () => QuickGeneratorService.generateName(gender: 'male'),
    ),
    QuickGeneratorType(
      id: 'female_name',
      name: 'Female Name',
      description: 'Generate a female character name',
      icon: Icons.person,
      color: AppTheme.categoryColors['npc']!,
      generate: () => QuickGeneratorService.generateName(gender: 'female'),
    ),
    QuickGeneratorType(
      id: 'tavern_name',
      name: 'Tavern Name',
      description: 'Generate a tavern or inn name',
      icon: Icons.local_bar,
      color: Colors.brown[700]!,
      generate: () => QuickGeneratorService.generateTavernName(),
    ),
    QuickGeneratorType(
      id: 'town_name',
      name: 'Town Name',
      description: 'Generate a town or village name',
      icon: Icons.location_city,
      color: Colors.green[700]!,
      generate: () => QuickGeneratorService.generateTownName(),
    ),
    QuickGeneratorType(
      id: 'treasure_item',
      name: 'Treasure',
      description: 'Generate a treasure item',
      icon: Icons.diamond,
      color: AppTheme.categoryColors['treasure']!,
      generate: () => QuickGeneratorService.generateTreasureItem(),
    ),
    QuickGeneratorType(
      id: 'plot_hook',
      name: 'Plot Hook',
      description: 'Generate a plot hook or quest idea',
      icon: Icons.auto_stories,
      color: AppTheme.categoryColors['quest']!,
      generate: () => QuickGeneratorService.generatePlotHook(),
    ),
  ];

  // Group the generators by category
  Map<String, List<QuickGeneratorType>> get _categorizedGenerators {
    return {
      'Names': _generators.where((g) => g.id.contains('name')).toList(),
      'Locations': _generators.where((g) => g.id.contains('tavern') || g.id.contains('town')).toList(),
      'Items & Adventures': _generators.where((g) => g.id.contains('treasure') || g.id.contains('plot')).toList(),
    };
  }
  
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Generators'),
        backgroundColor: AppTheme.primaryDark,
      ),
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
            // Results card
            if (_hasResult) _buildResultCard(),
            
            // Generator buttons
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _categorizedGenerators.entries.map((category) {
                      return _buildCategory(category.key, category.value);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResultCard() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _currentGeneratorName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.refresh, color: AppTheme.primary),
                  tooltip: 'Generate Again',
                  onPressed: () {
                    // Find the generator and run it again
                    final generator = _generators.firstWhere(
                      (g) => g.name == _currentGeneratorName, 
                      orElse: () => _generators.first
                    );
                    _generateAndDisplay(generator);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: AppTheme.primary),
                  tooltip: 'Copy to Clipboard',
                  onPressed: _copyToClipboard,
                ),
              ],
            ),
            Divider(height: 16, color: AppTheme.divider),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _currentResult,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategory(String title, List<QuickGeneratorType> generators) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Icon(
                _getCategoryIcon(title),
                color: AppTheme.primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.0,
          ),
          itemCount: generators.length,
          itemBuilder: (context, index) {
            final generator = generators[index];
            return _buildGeneratorButton(generator);
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildGeneratorButton(QuickGeneratorType generator) {
    return ElevatedButton(
      onPressed: () => _generateAndDisplay(generator),
      style: ElevatedButton.styleFrom(
        backgroundColor: generator.color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(generator.icon, size: 24),
          SizedBox(height: 4),
          Text(
            generator.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Names':
        return Icons.badge;
      case 'Locations':
        return Icons.place;
      case 'Items & Adventures':
        return Icons.backpack;
      default:
        return Icons.auto_fix_high;
    }
  }
} 