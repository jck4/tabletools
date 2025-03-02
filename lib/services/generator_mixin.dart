import 'package:flutter/material.dart';
import 'generator_service.dart';
import 'package:provider/provider.dart';

mixin GeneratorMixin<T extends StatefulWidget> on State<T> {
  Map<String, dynamic>? generatedData;
  bool isLoading = false;

  /// Fetch data from the API, with optional modification support.
  Future<void> fetchData(String generatorType, {bool useModifiedData = false}) async {
    setState(() => isLoading = true);

    try {
      if (useModifiedData && generatedData != null) {
        generatedData = await GeneratorService.sendModifiedData(generatorType, generatedData!);
      } else {
        generatedData = await GeneratorService.fetchGeneratorData(generatorType);
      }
    } catch (e) {
      generatedData = {"error": "Error fetching data."};
    }

    setState(() => isLoading = false);
  }
}
