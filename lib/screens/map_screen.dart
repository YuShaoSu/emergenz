import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/shelter_service.dart';
import '../models/shelter_location.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final ShelterService _shelterService = ShelterService();
  List<ShelterLocation> _shelters = [];
  List<ShelterLocation> _filteredShelters = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';
  String _selectedDistrict = 'all';
  final TextEditingController _searchController = TextEditingController();
  late MapController _mapController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Taipei center coordinates
  static const LatLng _taipeiCenter = LatLng(25.0330, 121.5654);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
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

    _loadShelters();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadShelters() async {
    await _shelterService.initialize();

    setState(() {
      _shelters = _shelterService.getAllShelters();
      _filteredShelters = _shelters;
      _isLoading = false;
    });

    _animationController.forward();
  }

  void _filterShelters() {
    setState(() {
      _filteredShelters = _shelters.where((shelter) {
        // Category filter
        if (_selectedCategory != 'all' &&
            shelter.category != _selectedCategory) {
          return false;
        }

        // District filter
        if (_selectedDistrict != 'all' &&
            shelter.district != _selectedDistrict) {
          return false;
        }

        // Search filter
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          return shelter.name.toLowerCase().contains(query) ||
              shelter.nameZh.contains(query) ||
              shelter.address.toLowerCase().contains(query) ||
              shelter.addressZh.contains(query) ||
              shelter.district.toLowerCase().contains(query) ||
              shelter.districtZh.contains(query);
        }

        return true;
      }).toList();
    });
  }

  void _showShelterDetails(ShelterLocation shelter) {
    final locale = Localizations.localeOf(context);
    final isChinese = locale.languageCode == 'zh';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(shelter.category)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(shelter.category),
                            color: _getCategoryColor(shelter.category),
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isChinese ? shelter.nameZh : shelter.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _getCategoryDisplayName(
                                    shelter.category, isChinese),
                                style: TextStyle(
                                  color: _getCategoryColor(shelter.category),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Description
                    Text(
                      isChinese ? shelter.descriptionZh : shelter.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Address
                    _buildInfoRow(
                      Icons.location_on,
                      isChinese ? shelter.addressZh : shelter.address,
                      isChinese ? '地址' : 'Address',
                    ),
                    SizedBox(height: 12),

                    // Phone
                    _buildInfoRow(
                      Icons.phone,
                      shelter.phoneNumber,
                      isChinese ? '電話' : 'Phone',
                      onTap: () => _callShelter(shelter),
                    ),
                    SizedBox(height: 12),

                    // Capacity
                    _buildInfoRow(
                      Icons.people,
                      '${shelter.capacity} ${isChinese ? '人' : 'people'}',
                      isChinese ? '容量' : 'Capacity',
                    ),
                    SizedBox(height: 12),

                    // Operating Hours
                    _buildInfoRow(
                      Icons.access_time,
                      isChinese
                          ? shelter.operatingHoursZh
                          : shelter.operatingHours,
                      isChinese ? '營業時間' : 'Operating Hours',
                    ),
                    SizedBox(height: 20),

                    // Facilities
                    Text(
                      isChinese ? '設施' : 'Facilities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: shelter.facilities.asMap().entries.map((entry) {
                        final index = entry.key;
                        final facility = entry.value;
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            isChinese ? shelter.facilitiesZh[index] : facility,
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),

                    // Special Features
                    if (shelter.isAccessible || shelter.hasParking) ...[
                      Text(
                        isChinese ? '特殊功能' : 'Special Features',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (shelter.isAccessible)
                            _buildFeatureChip(
                              Icons.accessible,
                              isChinese ? '無障礙設施' : 'Wheelchair Accessible',
                              Colors.green,
                            ),
                          if (shelter.hasParking)
                            _buildFeatureChip(
                              Icons.local_parking,
                              isChinese ? '停車場' : 'Parking Available',
                              Colors.orange,
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _callShelter(shelter),
                            icon: Icon(Icons.phone),
                            label: Text(isChinese ? '撥打電話' : 'Call'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _getDirections(shelter),
                            icon: Icon(Icons.directions),
                            label: Text(isChinese ? '路線' : 'Directions'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, String label,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callShelter(ShelterLocation shelter) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: shelter.phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _getDirections(ShelterLocation shelter) async {
    final Uri directionsUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${shelter.latitude},${shelter.longitude}');
    if (await canLaunchUrl(directionsUri)) {
      await launchUrl(directionsUri);
    }
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
        title: Text(
          isChinese ? '避難所地圖' : 'Shelter Map',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              _mapController.move(_taipeiCenter, 13.0);
            },
            tooltip: isChinese ? '我的位置' : 'My Location',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Search and Filter Section
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      children: [
                        // Search Bar
                        TextField(
                          controller: _searchController,
                          onChanged: (value) => _filterShelters(),
                          decoration: InputDecoration(
                            hintText:
                                isChinese ? '搜尋避難所...' : 'Search shelters...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        SizedBox(height: 12),
                        // Filters
                        Row(
                          children: [
                            Expanded(
                              child: _buildFilterDropdown(
                                'Category',
                                isChinese ? '類別' : 'Category',
                                _selectedCategory,
                                ['all', ..._shelterService.getCategories()],
                                (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                    _filterShelters();
                                  });
                                },
                                isChinese,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildFilterDropdown(
                                'District',
                                isChinese ? '區域' : 'District',
                                _selectedDistrict,
                                ['all', ..._shelterService.getDistricts()],
                                (value) {
                                  setState(() {
                                    _selectedDistrict = value!;
                                    _filterShelters();
                                  });
                                },
                                isChinese,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Map
                  Expanded(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _taipeiCenter,
                        initialZoom: 12.0,
                        minZoom: 10.0,
                        maxZoom: 18.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName:
                              'com.example.emergency_app_flutter',
                        ),
                        MarkerLayer(
                          markers: _filteredShelters.map((shelter) {
                            return Marker(
                              point:
                                  LatLng(shelter.latitude, shelter.longitude),
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () => _showShelterDetails(shelter),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(shelter.category),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _getCategoryIcon(shelter.category),
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  // Shelter List
                  if (_filteredShelters.isNotEmpty)
                    Container(
                      height: 140,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Text(
                                  '${_filteredShelters.length} ${isChinese ? '個避難所' : 'shelters found'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // Show full list
                                  },
                                  child: Text(isChinese ? '查看全部' : 'View All'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _filteredShelters.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: Duration(milliseconds: 600),
                                  child: SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: _buildShelterCard(
                                          _filteredShelters[index], isChinese),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterDropdown(
    String title,
    String titleZh,
    String value,
    List<String> options,
    Function(String?) onChanged,
    bool isChinese,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(isChinese ? titleZh : title),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option == 'all'
                    ? (isChinese ? '全部' : 'All')
                    : _getDisplayName(option, isChinese),
                style: TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildShelterCard(ShelterLocation shelter, bool isChinese) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showShelterDetails(shelter),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(shelter.category)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getCategoryIcon(shelter.category),
                        color: _getCategoryColor(shelter.category),
                        size: 14,
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isChinese ? shelter.nameZh : shelter.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  isChinese ? shelter.addressZh : shelter.address,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.people, size: 12, color: Colors.grey[600]),
                    SizedBox(width: 2),
                    Text(
                      '${shelter.capacity}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                    Spacer(),
                    if (shelter.isAccessible)
                      Icon(Icons.accessible, size: 12, color: Colors.green),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDisplayName(String value, bool isChinese) {
    switch (value) {
      case 'emergency':
        return isChinese ? '緊急' : 'Emergency';
      case 'temporary':
        return isChinese ? '臨時' : 'Temporary';
      case 'medical':
        return isChinese ? '醫療' : 'Medical';
      case 'community':
        return isChinese ? '社區' : 'Community';
      case 'school':
        return isChinese ? '學校' : 'School';
      case 'permanent':
        return isChinese ? '永久' : 'Permanent';
      case 'Xinyi':
        return isChinese ? '信義區' : 'Xinyi';
      case 'Zhongzheng':
        return isChinese ? '中正區' : 'Zhongzheng';
      case 'Shilin':
        return isChinese ? '士林區' : 'Shilin';
      default:
        return value;
    }
  }

  String _getCategoryDisplayName(String category, bool isChinese) {
    switch (category) {
      case 'emergency':
        return isChinese ? '緊急避難所' : 'Emergency Shelter';
      case 'temporary':
        return isChinese ? '臨時避難所' : 'Temporary Shelter';
      case 'medical':
        return isChinese ? '醫療避難所' : 'Medical Shelter';
      case 'community':
        return isChinese ? '社區避難所' : 'Community Shelter';
      case 'school':
        return isChinese ? '學校避難所' : 'School Shelter';
      case 'permanent':
        return isChinese ? '永久避難所' : 'Permanent Shelter';
      default:
        return category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'emergency':
        return Colors.red;
      case 'temporary':
        return Colors.orange;
      case 'medical':
        return Colors.green;
      case 'community':
        return Colors.blue;
      case 'school':
        return Colors.purple;
      case 'permanent':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'emergency':
        return Icons.emergency;
      case 'temporary':
        return Icons.hourglass_empty;
      case 'medical':
        return Icons.local_hospital;
      case 'community':
        return Icons.people;
      case 'school':
        return Icons.school;
      case 'permanent':
        return Icons.security;
      default:
        return Icons.place;
    }
  }
}
