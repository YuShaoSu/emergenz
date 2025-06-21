import 'package:flutter/material.dart';
import '../models/checklist_item.dart';
import '../services/checklist_service.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:emergency_app_flutter/l10n/app_localizations.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({Key? key}) : super(key: key);

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<ChecklistItem> _items = [];
  List<String> _categories = ['All'];
  String _filterCategory = 'All';
  String _searchQuery = '';
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadItems());
  }

  void _loadItems() {
    final items = ChecklistService.loadItems();
    final categories = items.map((e) => e.category).toSet().toList();
    setState(() {
      _items = items;
      _categories = [AppLocalizations.of(context)!.all, ...categories];
      _filterCategory = AppLocalizations.of(context)!.all;
    });
  }

  List<ChecklistItem> get _filteredItems {
    return _items.where((item) {
      final allText = AppLocalizations.of(context)!.all;
      final matchesCategory =
          _filterCategory == allText || item.category == _filterCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _toggleDone(ChecklistItem item, bool? value) async {
    item.done = value ?? false;
    await ChecklistService.updateItem(item);
    setState(() {});
  }

  void _resetSelections() async {
    for (var item in _items) {
      item.done = false;
      await ChecklistService.updateItem(item);
    }
    _loadItems();
  }

  void _clearList() async {
    await ChecklistService.clearAll();
    _loadItems();
  }

  void _exportList() {
    final text = _items
        .map((e) => '${e.name} (x${e.quantity}) ${e.done ? '✓' : '✗'}')
        .join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(AppLocalizations.of(context)!.listCopiedToClipboard)),
    );
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'reset':
        _resetSelections();
        break;
      case 'clear':
        _clearList();
        break;
      case 'export':
        _exportList();
        break;
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _showAddEditDialog([ChecklistItem? item]) {
    final isEdit = item != null;
    final nameController = TextEditingController(text: item?.name ?? '');
    final quantityController =
        TextEditingController(text: item?.quantity.toString() ?? '1');
    String selectedCategory =
        item?.category ?? AppLocalizations.of(context)!.food;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit
              ? AppLocalizations.of(context)!.editItem
              : AppLocalizations.of(context)!.addItem),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.itemName,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.categoryField,
                  border: OutlineInputBorder(),
                ),
                items: [
                  AppLocalizations.of(context)!.food,
                  AppLocalizations.of(context)!.water,
                  AppLocalizations.of(context)!.medical,
                  AppLocalizations.of(context)!.tools,
                  AppLocalizations.of(context)!.clothing,
                  AppLocalizations.of(context)!.other,
                ]
                    .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.quantityField,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.itemNameRequired)),
                  );
                  return;
                }

                final quantity = int.tryParse(quantityController.text) ?? 1;

                if (isEdit) {
                  item!.name = nameController.text.trim();
                  item.category = selectedCategory;
                  item.quantity = quantity;
                  await ChecklistService.updateItem(item);
                } else {
                  final newItem = ChecklistItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    category: selectedCategory,
                    quantity: quantity,
                    done: false,
                  );
                  await ChecklistService.addItem(newItem);
                }

                Navigator.of(context).pop();
                _loadItems();
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchItems,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white60),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text(AppLocalizations.of(context)!.emergencyKit),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: '', // 清除預設簡體提示
            onPressed: _toggleSearch,
          ),
          PopupMenuButton(
            tooltip: '', // 清除預設簡體提示
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'reset',
                  child: Text(AppLocalizations.of(context)!.resetSelections)),
              PopupMenuItem(
                  value: 'clear',
                  child: Text(AppLocalizations.of(context)!.clearList)),
              PopupMenuItem(
                  value: 'export',
                  child: Text(AppLocalizations.of(context)!.exportShare)),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final selected = cat == _filterCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _filterCategory = cat;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: selected ? Colors.blueAccent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListTile(
                  leading: Checkbox(
                    value: item.done,
                    onChanged: (value) => _toggleDone(item, value),
                  ),
                  title: Text(item.name),
                  subtitle: Text(AppLocalizations.of(context)!
                      .quantity(item.quantity.toString())),
                  trailing: IconButton(
                    icon: Icon(Icons.info_outline),
                    tooltip: '', // 清除預設簡體提示
                    onPressed: () => _showAddEditDialog(item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
