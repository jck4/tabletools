import 'package:flutter/material.dart';
import '../../services/generator_mixin.dart';
import '../generator_ui.dart';

class EncounterGenerator extends StatefulWidget {
  @override
  _EncounterGeneratorState createState() => _EncounterGeneratorState();
}

class _EncounterGeneratorState extends State<EncounterGenerator> with GeneratorMixin {
  @override
  void initState() {
    super.initState();
    fetchData("encounter");
  }

  @override
  Widget build(BuildContext context) {
    return GeneratorUI(
      generatedData: generatedData,
      isLoading: isLoading,
    );
  }
}
