import 'package:flutter/material.dart';

class GeneratorUI extends StatelessWidget {
  final Map<String, dynamic>? generatedData;
  final bool isLoading;
  final VoidCallback? onSave; // ✅ Optional save function

  const GeneratorUI({
    super.key,
    required this.generatedData,
    required this.isLoading,
    this.onSave, // ✅ Accept save function
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (generatedData == null || generatedData!.containsKey("error")) {
      return Center(
        child: Text("Error loading data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );
    }

    String title = generatedData!["title"] ?? generatedData!["name"] ?? "Untitled";

    List<String> sectionKeys = generatedData!.keys
        .where((key) => !["id", "title", "name", "created_at", "updated_at"].contains(key))
        .toList();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleSection(title),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sectionKeys.map((key) => _buildContentSection(key, context)).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
          if (onSave != null) _buildSaveButton(), // ✅ Only show if onSave is provided
        ],
      ),
    );
  }

  /// **Title Section**
  Widget _buildTitleSection(String title) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Divider(thickness: 2),
      ],
    );
  }

  /// **Handles dynamic sections**
  Widget _buildContentSection(String key, BuildContext context) {
    dynamic content = generatedData![key];

    if (content == null) return SizedBox();

    double boxWidth = MediaQuery.of(context).size.width - 32;

    if (content is String) {
      return _buildDescriptionCard(_formatKey(key), content, boxWidth);
    }

    if (content is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(_formatKey(key)),
          Container(
            width: boxWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: item is Map ? _buildSubSection(item) : _buildBulletPoint(item),
                );
              }).toList(),
            ),
          ),
        ],
      );
    }

    return SizedBox();
  }

  /// **Subsection for nested objects**
  Widget _buildSubSection(Map item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: item.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatKey(entry.key),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown[800]),
              ),
              Text(
                entry.value.toString(),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// **Bullet points for lists**
  Widget _buildBulletPoint(dynamic item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown[700])),
        Expanded(child: Text(item.toString(), style: TextStyle(fontSize: 16))),
      ],
    );
  }

  /// **Section Titles**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 6),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  /// **Description Box**
  Widget _buildDescriptionCard(String title, String content, double width) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(content, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  /// **Formats Key Titles Properly**
  String _formatKey(String key) {
    return key.replaceAll("_", " ").toUpperCase();
  }

  /// **Save Button**
  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onSave, // ✅ Calls Save Function
        icon: Icon(Icons.save),
        label: Text("Save to Compendium"),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      ),
    );
  }
}
