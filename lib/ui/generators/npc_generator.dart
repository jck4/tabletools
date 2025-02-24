import 'package:flutter/material.dart';
import '../../services/generator_mixin.dart';
import '../generator_ui.dart';

class NpcGenerator extends StatefulWidget {
  @override
  _NpcGeneratorState createState() => _NpcGeneratorState();
}

class _NpcGeneratorState extends State<NpcGenerator> with GeneratorMixin {
  @override
  void initState() {
    super.initState();
    fetchData("npc");
  }

  @override
  Widget build(BuildContext context) {
    return GeneratorUI(
      generatedData: generatedData,
      isLoading: isLoading,
    );
  }
}
