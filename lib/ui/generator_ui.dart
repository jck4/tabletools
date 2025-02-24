import 'package:flutter/material.dart';

class GeneratorUI extends StatelessWidget {
  final Map<String, dynamic>? generatedData;
  final bool isLoading;

  const GeneratorUI({
    required this.generatedData,
    required this.isLoading,
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

    // ✅ Ensure it gets a title OR a name
    String title = generatedData!["title"] ?? generatedData!["name"] ?? "Untitled";

    List<String> sectionKeys = generatedData!.keys
        .where((key) => key != "id" && key != "title" && key != "name" && key != "created_at" && key != "updated_at")
        .toList();

    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(title),
            ...sectionKeys.map((key) => _buildContentSection(key, context)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// **Title Formatting**
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

  /// **Handles sections dynamically**
  Widget _buildContentSection(String key, BuildContext context) {
    dynamic content = generatedData![key];

    if (content == null) return SizedBox(); // Skip empty sections

    double boxPadding = 12;
    double boxSpacing = 12;
    double boxWidth = MediaQuery.of(context).size.width - 32; // Full width with margin

    if (content is String) {
      return _buildDescriptionCard(_formatKey(key), content, boxWidth, boxPadding, boxSpacing);
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
            padding: EdgeInsets.all(boxPadding),
            margin: EdgeInsets.only(bottom: boxSpacing),
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

  /// **Creates a new subsection for nested objects**
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

  /// **Simple bullet points for lists (like Clues, Outcomes, etc.)**
  Widget _buildBulletPoint(dynamic item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown[700])),
        Expanded(child: Text(item.toString(), style: TextStyle(fontSize: 16))),
      ],
    );
  }

  /// **Section Title Formatting**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 6),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  /// **Description Box Formatting** (Now White & Full Width)
  Widget _buildDescriptionCard(String title, String content, double width, double padding, double spacing) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacing),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        padding: EdgeInsets.all(padding),
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
}
