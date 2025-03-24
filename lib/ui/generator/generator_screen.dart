import 'package:flutter/material.dart';
import '../../../services/generator_mixin.dart';
import 'generator_ui.dart';
import "../../utils/string_extentions.dart";
import "../../utils/app_theme.dart";

class GeneratorScreen extends StatefulWidget {
  final String generatorType;

  const GeneratorScreen({super.key, required this.generatorType});

  @override
  _GeneratorScreenState createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> with GeneratorMixin {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    fetchData(widget.generatorType);
  }

  // Get appropriate icon for generator type
  IconData _getGeneratorIcon() {
    return AppTheme.getIconForCategory(widget.generatorType);
  }

  // Get appropriate color for generator type
  Color _getGeneratorColor() {
    return AppTheme.getColorForCategory(widget.generatorType);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = _getGeneratorColor();
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(_getGeneratorIcon(), size: 24),
            SizedBox(width: 8),
            Text(widget.generatorType.toUpperCase()),
          ],
        ),
        backgroundColor: primaryColor,
        elevation: 4,
        actions: [
          if (!isLoading)
            Container(
              margin: EdgeInsets.only(right: 10),
              child: _isSaving
                ? Container(
                    width: 48, 
                    height: 24,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: () async {
                      setState(() => _isSaving = true);
                      try {
                        await saveToCompendium(widget.generatorType);
                      } finally {
                        if (mounted) {
                          setState(() => _isSaving = false);
                        }
                      }
                    },
                    icon: Icon(Icons.save, size: 18),
                    label: Text("SAVE"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
            ),
        ],
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
            Expanded(
              child: GeneratorUI(
                generatedData: generatedData,
                isLoading: isLoading,
                onSave: () => saveToCompendium(widget.generatorType),
              ),
            ),
            _buildGenerateButton(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : () => fetchData(widget.generatorType),
        icon: isLoading 
          ? SizedBox(
              width: 20, 
              height: 20, 
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Icon(Icons.refresh, size: 24),
        label: Text(
          isLoading 
              ? "Generating..." 
              : "New ${widget.generatorType.capitalize()}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          disabledBackgroundColor: primaryColor.withOpacity(0.6),
          disabledForegroundColor: Colors.white70,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
