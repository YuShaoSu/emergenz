import 'package:flutter/material.dart';
import '../models/checklist_item.dart';
import '../services/checklist_service.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:emergency_app_flutter/l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({Key? key}) : super(key: key);

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen>
    with TickerProviderStateMixin {
  List<ChecklistItem> _items = [];
  List<String> _categories = ['All'];
  String _filterCategory = 'All';
  String _searchQuery = '';
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  // Animation controllers
  late AnimationController _fabAnimationController;
  late AnimationController _searchAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<Offset> _searchSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));

    _searchSlideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItems();
      _fabAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _searchAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
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
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(AppLocalizations.of(context)!.listCopiedToClipboard),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
        _searchAnimationController.reverse();
      } else {
        _searchAnimationController.forward();
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(
                isEdit ? Icons.edit : Icons.add_circle,
                color: Colors.blue,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                isEdit
                    ? AppLocalizations.of(context)!.editItem
                    : AppLocalizations.of(context)!.addItem,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.itemName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.inventory),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.categoryField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.category),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.numbers),
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
                      content:
                          Text(AppLocalizations.of(context)!.itemNameRequired),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
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
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Water':
        return Colors.blue;
      case 'Medical':
        return Colors.red;
      case 'Tools':
        return Colors.grey;
      case 'Clothing':
        return Colors.purple;
      default:
        return Colors.green;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Water':
        return Icons.water_drop;
      case 'Medical':
        return Icons.medical_services;
      case 'Tools':
        return Icons.build;
      case 'Clothing':
        return Icons.checkroom;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _isSearching
              ? SlideTransition(
                  position: _searchSlideAnimation,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchItems,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    ),
                    style: TextStyle(color: Colors.black87),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                )
              : Text(
                  AppLocalizations.of(context)!.emergencyKit,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
        ),
        actions: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: IconButton(
              key: ValueKey(_isSearching),
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: _toggleSearch,
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.blue),
                    SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.resetSelections),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Colors.red),
                    SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.clearList),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.green),
                    SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.exportShare),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final selected = cat == _filterCategory;
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 600),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _filterCategory = cat;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    )
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (cat != AppLocalizations.of(context)!.all)
                                Icon(
                                  _getCategoryIcon(cat),
                                  size: 16,
                                  color: selected
                                      ? Colors.white
                                      : _getCategoryColor(cat),
                                ),
                              if (cat != AppLocalizations.of(context)!.all)
                                SizedBox(width: 8),
                              Text(
                                cat,
                                style: TextStyle(
                                  color:
                                      selected ? Colors.white : Colors.black87,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Progress indicator
          if (_items.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${_items.where((item) => item.done).length}/${_items.length}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _items.isEmpty
                        ? 0
                        : _items.where((item) => item.done).length /
                            _items.length,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),

          // Items List
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No items found'
                              : 'No items in this category',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Try adjusting your search'
                              : 'Add some items to get started',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: Duration(milliseconds: 400),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(item.category)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(item.category),
                                      color: _getCategoryColor(item.category),
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    item.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      decoration: item.done
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: item.done
                                          ? Colors.grey[600]
                                          : Colors.black87,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4),
                                      Text(
                                        item.category,
                                        style: TextStyle(
                                          color:
                                              _getCategoryColor(item.category),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .quantity(item.quantity.toString()),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        child: Checkbox(
                                          value: item.done,
                                          onChanged: (value) =>
                                              _toggleDone(item, value),
                                          activeColor:
                                              _getCategoryColor(item.category),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit_outlined,
                                            color: Colors.grey[600]),
                                        onPressed: () =>
                                            _showAddEditDialog(item),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: () => _showAddEditDialog(),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 8,
          icon: Icon(Icons.add),
          label: Text('Add Item'),
        ),
      ),
    );
  }
}
