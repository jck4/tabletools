import 'package:flutter/material.dart';
import '../../services/generator_mixin.dart';
import '../generator_ui.dart';

class QuestGenerator extends StatefulWidget {
  @override
  _QuestGeneratorState createState() => _QuestGeneratorState();
}

class _QuestGeneratorState extends State<QuestGenerator> with GeneratorMixin {
  @override
  void initState() {
    super.initState();
    fetchData("quest");
  }

  @override
  Widget build(BuildContext context) {
    return GeneratorUI(
      generatedData: generatedData,
      isLoading: isLoading,
    );
  }
}
