import 'package:flutter/material.dart';
import '../../services/generator_mixin.dart';
import '../generator_ui.dart';

class TrapGenerator extends StatefulWidget {
  @override
  _TrapGeneratorState createState() => _TrapGeneratorState();
}

class _TrapGeneratorState extends State<TrapGenerator> with GeneratorMixin {
  @override
  void initState() {
    super.initState();
    fetchData("trap");
  }

  @override
  Widget build(BuildContext context) {
    return GeneratorUI(
      generatedData: generatedData,
      isLoading: isLoading,
    );
  }
}
