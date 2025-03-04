import 'package:flutter/material.dart';
import '../services/api_service.dart';
import "../ui/generator/generator_ui.dart" as generatorUI;
class CompendiumScreen extends StatefulWidget {
  @override
  _CompendiumScreenState createState() => _CompendiumScreenState();
}

class _CompendiumScreenState extends State<CompendiumScreen> {
  Map<String, List<Map<String, dynamic>>> _compendiumItems = {};
  bool _isLoading = true;
  String _selectedType = "All";

  @override
  void initState() {
    super.initState();
    _fetchCompendium();
  }

  Future<void> _fetchCompendium() async {
    try {
      final compendiumData = await ApiService.fetchCompendium();
      final Map<String, List<Map<String, dynamic>>> parsedData =
          compendiumData.map((key, value) {
        return MapEntry(
          key,
          List<Map<String, dynamic>>.from(value ?? []),
        );
      });

      setState(() {
        _compendiumItems = parsedData;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching compendium: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"), // Use the parchment texture
            fit: BoxFit.cover, // Make sure it covers the full screen
          ),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildCompendiumList(),
      ),
    );
  }

  Widget _buildCompendiumList() {
    List<String> itemTypes = ["All", ..._compendiumItems.keys];

    return Column(
      children: [
        _buildFilterDropdown(itemTypes),
        Expanded(
          child: ListView(
            children: _selectedType == "All"
                ? _buildAllItems()
                : _buildFilteredItems(_selectedType),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(List<String> itemTypes) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: _selectedType,
        onChanged: (String? newValue) {
          setState(() => _selectedType = newValue ?? "All");
        },
        items: itemTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value.toUpperCase(),
              style: TextStyle(color: Colors.brown[900]), // Darker color for a medieval look
            ),
          );
        }).toList(),
        style: TextStyle(color: Colors.brown[900]), // Darker color for a medieval look
        dropdownColor: Colors.white, // Slight transparency for a parchment feel
      ),
    );
  }

  List<Widget> _buildAllItems() {
    return _compendiumItems.entries.expand((entry) {
      return _buildSection(entry.key, entry.value);
    }).toList();
  }

  List<Widget> _buildFilteredItems(String type) {
    return _buildSection(type, _compendiumItems[type] ?? []);
  }

  List<Widget> _buildSection(String title, List<Map<String, dynamic>> items) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown[900], // Darker color for a medieval look
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white!.withOpacity(0.85), // Slight transparency for a parchment feel
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.brown[600]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: items.map((item) => _buildCompendiumItem(item)).toList(),
        ),
      ),
    ];
  }

  Widget _buildCompendiumItem(Map<String, dynamic> item) {
    String category = _selectedType == "All" ? _findItemCategory(item) : _selectedType;
    String entryId = item["id"].toString();

    return ListTile(
      title: Text(
        item["title"] ?? item["name"] ?? "Unnamed",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown[900]),
      ),
      subtitle: Text("Tap to view details"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteEntry(category, entryId),
          ),
          Icon(Icons.arrow_forward, color: Colors.brown[900]),
        ],
      ),
      onTap: () => _navigateToItemDetails(item),
    );
  }  void _navigateToItemDetails(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(item["title"] ?? item["name"] ?? "Entry")),
          body: generatorUI.GeneratorUI(
            generatedData: item,
            isLoading: false,
          ),
        ),
      ),
    );
  }
  String _findItemCategory(Map<String, dynamic> item) {
    return _compendiumItems.entries.firstWhere(
      (entry) => entry.value.contains(item),
      orElse: () => MapEntry("Unknown", []),
    ).key;
  }

  Future<void> _deleteEntry(String category, String entryId) async {
    try {
      await ApiService.deleteFromCompendium(category, entryId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Entry removed from compendium!"), backgroundColor: Colors.red),
      );
      _fetchCompendium();
    } catch (e) {
      print("❌ Error deleting entry: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to remove entry"), backgroundColor: Colors.red),
      );
    }
  }

}
