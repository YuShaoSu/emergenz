import 'package:flutter/material.dart';
import '../services/emergency_contact_service.dart';
import '../models/emergency_contact.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with TickerProviderStateMixin {
  List<EmergencyContact> _contacts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final EmergencyContactService _contactService = EmergencyContactService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _loadContacts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    await _contactService.initialize();

    setState(() {
      _contacts = _contactService.getAllContacts();
      _categories = ['All', ..._contactService.getCategories()];
    });

    _animationController.forward();
  }

  List<EmergencyContact> get _filteredContacts {
    return _contacts.where((contact) {
      final matchesCategory =
          _selectedCategory == 'All' || contact.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          contact.nameZh.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          contact.phoneNumber.contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
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

  Future<void> _callContact(EmergencyContact contact) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: contact.phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch phone app'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showContactDetails(EmergencyContact contact) {
    final locale = Localizations.localeOf(context);
    final isChinese = locale.languageCode == 'zh';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getCategoryColor(contact.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(contact.category),
                color: _getCategoryColor(contact.category),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                isChinese ? contact.nameZh : contact.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone: ${contact.phoneNumber}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            Text(
              isChinese ? contact.descriptionZh : contact.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (contact.isPriority) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  isChinese ? '優先聯絡' : 'Priority Contact',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(isChinese ? '取消' : 'Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _callContact(contact);
            },
            icon: Icon(Icons.phone),
            label: Text(isChinese ? '撥打' : 'Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isChinese = locale.languageCode == 'zh';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: isChinese ? '搜尋聯絡人...' : 'Search contacts...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                  style: TextStyle(color: Colors.black87),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                )
              : Text(
                  isChinese ? '緊急聯絡電話' : 'Emergency Contacts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
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
                  final category = _categories[index];
                  final selected = category == _selectedCategory;
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 600),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
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
                                if (category != 'All')
                                  Icon(
                                    _getCategoryIcon(category),
                                    size: 16,
                                    color: selected
                                        ? Colors.white
                                        : _getCategoryColor(category),
                                  ),
                                if (category != 'All') SizedBox(width: 8),
                                Text(
                                  _getCategoryDisplayName(category, isChinese),
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.black87,
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

            // Priority Contacts Section
            if (_selectedCategory == 'All')
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.priority_high, color: Colors.red.shade600),
                        SizedBox(width: 8),
                        Text(
                          isChinese ? '優先聯絡電話' : 'Priority Contacts',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ..._contactService.getPriorityContacts().take(3).map(
                          (contact) =>
                              _buildPriorityContactItem(contact, isChinese),
                        ),
                  ],
                ),
              ),

            // Contacts List
            Expanded(
              child: _filteredContacts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_disabled,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            isChinese ? '沒有找到聯絡人' : 'No contacts found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            isChinese
                                ? '嘗試調整搜尋條件'
                                : 'Try adjusting your search',
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
                        itemCount: _filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = _filteredContacts[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: Duration(milliseconds: 400),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: _buildContactCard(contact, isChinese),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityContactItem(EmergencyContact contact, bool isChinese) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _callContact(contact),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.phone, color: Colors.red.shade600, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isChinese ? contact.nameZh : contact.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade800,
                      ),
                    ),
                    Text(
                      contact.phoneNumber,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.call, color: Colors.red.shade600, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(EmergencyContact contact, bool isChinese) {
    return Container(
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
            color: _getCategoryColor(contact.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getCategoryIcon(contact.category),
            color: _getCategoryColor(contact.category),
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                isChinese ? contact.nameZh : contact.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (contact.isPriority)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  isChinese ? '優先' : 'PRIORITY',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              contact.phoneNumber,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2),
            Text(
              isChinese ? contact.descriptionZh : contact.description,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.grey[600]),
              onPressed: () => _showContactDetails(contact),
            ),
            IconButton(
              icon: Icon(Icons.phone, color: Colors.green.shade600),
              onPressed: () => _callContact(contact),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category, bool isChinese) {
    switch (category) {
      case 'All':
        return isChinese ? '全部' : 'All';
      case 'police':
        return isChinese ? '警察' : 'Police';
      case 'fire':
        return isChinese ? '消防' : 'Fire';
      case 'medical':
        return isChinese ? '醫療' : 'Medical';
      case 'coast_guard':
        return isChinese ? '海巡' : 'Coast Guard';
      case 'weather':
        return isChinese ? '氣象' : 'Weather';
      case 'utilities':
        return isChinese ? '公用事業' : 'Utilities';
      case 'government':
        return isChinese ? '政府' : 'Government';
      case 'ngo':
        return isChinese ? '非政府組織' : 'NGO';
      case 'rescue':
        return isChinese ? '搜救' : 'Rescue';
      case 'civil_defense':
        return isChinese ? '民防' : 'Civil Defense';
      default:
        return category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'police':
        return Colors.blue;
      case 'fire':
        return Colors.red;
      case 'medical':
        return Colors.green;
      case 'coast_guard':
        return Colors.orange;
      case 'weather':
        return Colors.cyan;
      case 'utilities':
        return Colors.purple;
      case 'government':
        return Colors.indigo;
      case 'ngo':
        return Colors.teal;
      case 'rescue':
        return Colors.amber;
      case 'civil_defense':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'police':
        return Icons.local_police;
      case 'fire':
        return Icons.local_fire_department;
      case 'medical':
        return Icons.medical_services;
      case 'coast_guard':
        return Icons.waves;
      case 'weather':
        return Icons.wb_sunny;
      case 'utilities':
        return Icons.power;
      case 'government':
        return Icons.account_balance;
      case 'ngo':
        return Icons.volunteer_activism;
      case 'rescue':
        return Icons.search;
      case 'civil_defense':
        return Icons.security;
      default:
        return Icons.phone;
    }
  }
}
