import 'package:flutter/material.dart';
import 'generator_service.dart';
import '../services/api_service.dart';

mixin GeneratorMixin<T extends StatefulWidget> on State<T> {
  Map<String, dynamic>? generatedData;
  bool isLoading = false;

  Future<void> fetchData(String generatorType,
      {bool useModifiedData = false}) async {
    setState(() => isLoading = true);

    try {
      if (useModifiedData && generatedData != null) {
        generatedData = await GeneratorService.sendModifiedData(
            generatorType, generatedData!);
      } else {
        generatedData =
            await GeneratorService.fetchGeneratorData(generatorType);
      }
    } catch (e) {
      generatedData = {"error": "Error fetching data."};
    }

    setState(() => isLoading = false);
  }

Future<void> saveToCompendium(String category) async {
  if (generatedData == null) return;

  try {
    final response = await ApiService.saveToCompendium(category, generatedData!);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response["message"] ?? "Saved to Compendium!"), // ✅ Show API message
      backgroundColor: response["success"] == true ? Colors.green : Colors.orange,
    ));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e.toString()), // ✅ Show error message
      backgroundColor: Colors.red,
    ));
  }
}


Future<void> removeFromCompendium(String category, String entryId) async {
  try {
    final response = await ApiService.deleteFromCompendium(category, entryId);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response["message"] ?? "Entry removed from Compendium!"), // ✅ Show API message
      backgroundColor: response["success"] == true ? Colors.orange : Colors.red,
    ));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e.toString()), // ✅ Show error message
      backgroundColor: Colors.red,
    ));
  }
}

}
