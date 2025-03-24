import 'package:flutter/material.dart';
import '../services/api_service.dart';
import "../ui/generator/generator_ui.dart" as generatorUI;
import '../utils/app_theme.dart';

// Sort options for the compendium
enum SortOption {
  titleAsc,
  titleDesc,
  recent,
}

class CompendiumScreen extends StatefulWidget {
  @override
  _CompendiumScreenState createState() => _CompendiumScreenState();
}

class _CompendiumScreenState extends State<CompendiumScreen> {
  Map<String, List<Map<String, dynamic>>> _compendiumData = {};
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
        _compendiumData = parsedData;
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
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[700]!),
            ),
            SizedBox(height: 16),
            Text("Loading your compendium...",
                style: TextStyle(
                  color: Colors.brown[800],
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      );
    }

    // Get unique item types for the dropdown
    List<String> itemTypes = ["All"];
    itemTypes.addAll(_compendiumData.keys.toList());

    // Build sections for each type
    List<Widget> sections = [];
    if (_selectedType == "All") {
      for (String type in _compendiumData.keys) {
        sections.addAll(_buildSection(type, _compendiumData[type]!));
      }
    } else if (_compendiumData.containsKey(_selectedType)) {
      sections.addAll(_buildSection(_selectedType, _compendiumData[_selectedType]!));
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/parchment.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.lighten,
            ),
          ),
        ),
        child: Column(
          children: [
            // Header with instructions
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.brown[50]!.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book, color: Colors.brown[700], size: 24),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Your Adventure Compendium",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                      ),
                      // Add action buttons here
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.brown[700]),
                        tooltip: 'Refresh',
                        onPressed: _fetchCompendium,
                      ),
                      IconButton(
                        icon: Icon(Icons.sort, color: Colors.brown[700]),
                        tooltip: 'Sort',
                        onPressed: () => _showSortOptions(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Browse your collected entries or filter by type.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            // Filter dropdown
            _buildFilterDropdown(itemTypes),
            // Compendium content
            Expanded(
              child: sections.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.brown[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No entries found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Try changing the filter or adding new entries",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.brown[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await _fetchCompendium();
                      },
                      color: Colors.brown[700],
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 24),
                        children: sections,
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        backgroundColor: Colors.brown[800],
        child: Icon(Icons.add, color: Colors.amber[100]),
        tooltip: 'Add new entry',
      ),
    );
  }

  Widget _buildFilterDropdown(List<String> itemTypes) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.brown[400]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedType,
          icon: Icon(Icons.filter_list, color: Colors.brown[700]),
          hint: Text("Filter by type"),
          onChanged: (String? newValue) {
            setState(() => _selectedType = newValue ?? "All");
          },
          items: itemTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    value == "All" ? Icons.apps : _getCategoryIcon(value),
                    color: value == "All" ? Colors.brown[700] : _getCategoryColor(value),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    value.toUpperCase(),
                    style: TextStyle(
                      color: Colors.brown[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          style: TextStyle(color: Colors.brown[900]),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _buildAllItems() {
    return _compendiumData.entries.expand((entry) {
      return _buildSection(entry.key, entry.value);
    }).toList();
  }

  List<Widget> _buildFilteredItems(String type) {
    return _buildSection(type, _compendiumData[type] ?? []);
  }

  List<Widget> _buildSection(String title, List<Map<String, dynamic>> items) {
    return [
      Container(
        margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.brown[800],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.amber[100],
            letterSpacing: 1.2,
          ),
        ),
      ),
      if (items.isNotEmpty)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.brown[400]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.brown[200],
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) => _buildCompendiumItem(items[index]),
            ),
          ),
        )
      else
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.brown[400]!),
            ),
            child: Center(
              child: Text(
                "No items found",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
    ];
  }

  Widget _buildCompendiumItem(Map<String, dynamic> item) {
    String category = _selectedType == "All" ? _findItemCategory(item) : _selectedType;
    String entryId = item["id"].toString();
    String itemTitle = item["title"] ?? item["name"] ?? "Unnamed";

    return InkWell(
      onTap: () => _navigateToItemDetails(item),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getCategoryColor(category),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(category),
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.brown[900],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _getItemDescription(item, category),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[400]),
              tooltip: "Delete",
              onPressed: () => _showDeleteConfirmation(context, category, entryId, itemTitle),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.brown[700]),
              tooltip: "View details",
              onPressed: () => _navigateToItemDetails(item),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToItemDetails(Map<String, dynamic> item) {
    // Create a mutable copy of the item to support editing
    Map<String, dynamic> editableItem = Map<String, dynamic>.from(item);
    String category = _findItemCategory(item);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(editableItem["title"] ?? editableItem["name"] ?? "Entry"),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: ElevatedButton.icon(
                  onPressed: () => _saveItemChanges(category, editableItem),
                  icon: Icon(Icons.save, size: 24),
                  label: Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
          body: generatorUI.GeneratorUI(
            generatedData: editableItem,
            isLoading: false,
            onEdit: (updatedData) {
              // Update our local copy with any changes
              editableItem = updatedData;
            },
            // Don't show the title section in the body since it's already in the AppBar
            hideTitleSection: true,
          ),
        ),
      ),
    );
  }

  Future<void> _saveItemChanges(String category, Map<String, dynamic> item) async {
    try {
      final response = await ApiService.updateCompendiumEntry(
        category,
        item["id"].toString(),
        item,
      );
      
      if (response["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"] ?? "Changes saved successfully"),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh the compendium to show updated data
        _fetchCompendium();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"] ?? "Failed to save changes"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Error saving changes: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving changes: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _findItemCategory(Map<String, dynamic> item) {
    return _compendiumData.entries.firstWhere(
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

  // Get a custom icon based on category type
  IconData _getCategoryIcon(String category) {
    return AppTheme.getIconForCategory(category);
  }

  // Get a custom color based on category type
  Color _getCategoryColor(String category) {
    return AppTheme.getColorForCategory(category);
  }

  // Extract a brief description from the item data
  String _getItemDescription(Map<String, dynamic> item, String category) {
    // Try to extract a useful field based on category
    if (category.toLowerCase() == 'npc' && item.containsKey('occupation')) {
      return item['occupation'].toString();
    } else if (item.containsKey('description')) {
      return item['description'].toString();
    } else {
      return "Tap to view details";
    }
  }

  // Show confirmation dialog before deleting
  void _showDeleteConfirmation(BuildContext context, String category, String entryId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Item"),
        content: Text("Are you sure you want to delete '$title'? This cannot be undone."),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              _deleteEntry(category, entryId);
            },
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Sort By",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.sort_by_alpha, color: Colors.brown[700]),
                title: Text("Title (A-Z)"),
                onTap: () {
                  _sortCompendium(SortOption.titleAsc);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.sort_by_alpha_outlined, color: Colors.brown[700]),
                title: Text("Title (Z-A)"),
                onTap: () {
                  _sortCompendium(SortOption.titleDesc);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.access_time, color: Colors.brown[700]),
                title: Text("Recently Added"),
                onTap: () {
                  _sortCompendium(SortOption.recent);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sortCompendium(SortOption option) {
    setState(() {
      for (String key in _compendiumData.keys) {
        switch (option) {
          case SortOption.titleAsc:
            _compendiumData[key]!.sort((a, b) => 
              (a["title"] ?? a["name"] ?? "").toString().toLowerCase()
                .compareTo((b["title"] ?? b["name"] ?? "").toString().toLowerCase()));
            break;
          case SortOption.titleDesc:
            _compendiumData[key]!.sort((a, b) => 
              (b["title"] ?? b["name"] ?? "").toString().toLowerCase()
                .compareTo((a["title"] ?? a["name"] ?? "").toString().toLowerCase()));
            break;
          case SortOption.recent:
            // If your items have a date field, sort by that instead
            _compendiumData[key]!.sort((a, b) => 0); // Placeholder for now
            break;
        }
      }
    });
  }

  void _showAddItemDialog(BuildContext context) {
    String selectedType = _compendiumData.keys.first; // Default to first type
    final nameController = TextEditingController();
    final descController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.add_circle, color: Colors.brown[700]),
            SizedBox(width: 8),
            Text("Add New Entry"),
          ],
        ),
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create a new item for your compendium:",
                style: TextStyle(color: Colors.brown[600]),
              ),
              SizedBox(height: 16),
              // Type selector
              Text(
                "TYPE",
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: StatefulBuilder(
                  builder: (context, setState) => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedType,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => selectedType = newValue);
                        }
                      },
                      items: _compendiumData.keys.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(
                                _getCategoryIcon(value),
                                color: _getCategoryColor(value),
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                value.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.brown[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Name field
              Text(
                "NAME",
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter a name for this item",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.brown[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.brown[700]!, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              // Description field
              Text(
                "DESCRIPTION",
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  hintText: "Enter a description",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.brown[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.brown[700]!, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                minLines: 3,
                maxLines: 5,
              ),
              SizedBox(height: 8),
              Text(
                "Note: You can add more details after creating the entry",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("CANCEL", style: TextStyle(color: Colors.grey[600])),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("CREATE"),
            onPressed: () {
              // Check if name is not empty
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter a name for the item")),
                );
                return;
              }
              
              // Create the new item
              Map<String, dynamic> newItem = {
                "id": DateTime.now().millisecondsSinceEpoch.toString(),
                "title": nameController.text.trim(),
                "description": descController.text.trim(),
                // Add more default fields as needed
              };
              
              // Add to compendium data
              setState(() {
                _compendiumData[selectedType]!.add(newItem);
              });
              
              // Close dialog and refresh
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("New item added to compendium")),
              );
            },
          ),
        ],
      ),
    );
  }
}

