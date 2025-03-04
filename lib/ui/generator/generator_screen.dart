import 'package:flutter/material.dart';
import '../../../services/generator_mixin.dart';
import 'generator_ui.dart';
import "../../utils/string_extentions.dart";

class GeneratorScreen extends StatefulWidget {
  final String generatorType;

  const GeneratorScreen({super.key, required this.generatorType});

  @override
  _GeneratorScreenState createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> with GeneratorMixin {
  @override
  void initState() {
    super.initState();
    fetchData(widget.generatorType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.generatorType.toUpperCase()),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: GeneratorUI(
              generatedData: generatedData,
              isLoading: isLoading,
              onSave: () => saveToCompendium(widget.generatorType), // ✅ Save function
            ),
          ),
          _buildGenerateButton(), // ✅ Generate button
        ],
      ),
    );
  }

  /// **Generate Button**
  Widget _buildGenerateButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () => fetchData(widget.generatorType), // ✅ Calls `fetchData` again
        icon: Icon(Icons.refresh),
        label: Text("Generate New ${widget.generatorType.toUpperCase()}"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
