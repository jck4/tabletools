import 'package:flutter/material.dart';

class GeneratorUI extends StatefulWidget {
  final Map<String, dynamic>? generatedData;
  final bool isLoading;
  final VoidCallback? onSave;
  final Function(Map<String, dynamic>)? onEdit;
  final bool hideTitleSection;

  const GeneratorUI({
    super.key,
    required this.generatedData,
    required this.isLoading,
    this.onSave,
    this.onEdit,
    this.hideTitleSection = false,
  });

  @override
  State<GeneratorUI> createState() => _GeneratorUIState();
}

class _GeneratorUIState extends State<GeneratorUI> {
  Map<String, dynamic>? _editedData;

  @override
  void initState() {
    super.initState();
    _editedData = Map<String, dynamic>.from(widget.generatedData ?? {});
  }

  @override
  void didUpdateWidget(GeneratorUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.generatedData != oldWidget.generatedData) {
      _editedData = Map<String, dynamic>.from(widget.generatedData ?? {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (widget.generatedData == null || widget.generatedData!.containsKey("error")) {
      return Center(
        child: Text("Error loading data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );
    }

    String title = _editedData!["title"] ?? _editedData!["name"] ?? "Untitled";

    List<String> sectionKeys = _editedData!.keys
        .where((key) => !["id", "title", "name", "created_at", "updated_at"].contains(key))
        .toList();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.hideTitleSection) _buildTitleSection(title),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sectionKeys.map((key) => _buildContentSection(key, context)).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
          if (widget.onSave != null) _buildSaveButton(),
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

  /// **Handles dynamic sections with editing**
  Widget _buildContentSection(String key, BuildContext context) {
    dynamic content = _editedData![key];

    if (content == null) return SizedBox();

    double boxWidth = MediaQuery.of(context).size.width - 32;

    if (content is String) {
      return _buildEditableDescriptionCard(_formatKey(key), content, boxWidth, (newValue) {
        setState(() {
          _editedData![key] = newValue;
          widget.onEdit?.call(_editedData!);
        });
      });
    }

    if (content is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle(_formatKey(key)),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: () {
                  setState(() {
                    content.add("");  // Add empty string for new item
                    widget.onEdit?.call(_editedData!);
                  });
                },
              ),
            ],
          ),
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
              children: List.generate(content.length, (index) {
                var item = content[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: item is Map 
                    ? _buildEditableSubSection(item, (newValue) {
                        setState(() {
                          content[index] = newValue;
                          widget.onEdit?.call(_editedData!);
                        });
                      })
                    : _buildEditableBulletPoint(item, (newValue) {
                        setState(() {
                          content[index] = newValue;
                          widget.onEdit?.call(_editedData!);
                        });
                      }),
                );
              }),
            ),
          ),
        ],
      );
    }

    return SizedBox();
  }

  /// **Editable Description Card**
  Widget _buildEditableDescriptionCard(String title, String content, double width, Function(String) onChanged) {
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
            TextFormField(
              initialValue: content,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  /// **Editable Bullet Point**
  Widget _buildEditableBulletPoint(dynamic item, Function(String) onChanged) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: item.toString(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: onChanged,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[300]),
              onPressed: () {
                // Get the parent list and remove this item
                final parentList = _editedData!.entries
                    .firstWhere((entry) => entry.value is List && 
                        entry.value.contains(item))
                    .value as List;
                setState(() {
                  parentList.remove(item);
                  widget.onEdit?.call(_editedData!);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// **Editable Subsection**
  Widget _buildEditableSubSection(Map item, Function(Map) onChanged) {
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
              TextFormField(
                initialValue: entry.value.toString(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
                onChanged: (newValue) {
                  item[entry.key] = newValue;
                  onChanged(item);
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// **Section Titles**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 6),
      child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
        onPressed: widget.onSave,
        icon: Icon(Icons.save),
        label: Text("Save to Compendium"),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      ),
    );
  }
}
