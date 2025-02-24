import 'package:flutter/material.dart';
import '../../services/generator_mixin.dart';
import '../generator_ui.dart';

class TreasureGenerator extends StatefulWidget {
  @override
  _TreasureGeneratorState createState() => _TreasureGeneratorState();
}

class _TreasureGeneratorState extends State<TreasureGenerator> with GeneratorMixin {
  @override
  void initState() {
    super.initState();
    fetchData("treasure");
  }

  @override
  Widget build(BuildContext context) {
    return GeneratorUI(
      generatedData: generatedData,
      isLoading: isLoading,
    );
  }
}
