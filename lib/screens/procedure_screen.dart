import 'package:flutter/material.dart';
import 'package:emergency_app_flutter/l10n/app_localizations.dart';
import '../services/emergency_procedure_service.dart';
import '../models/emergency_procedure.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'procedure_detail_screen.dart';

class ProcedureScreen extends StatefulWidget {
  const ProcedureScreen({super.key});

  @override
  State<ProcedureScreen> createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen> {
  List<EmergencyProcedure> _procedures = [];
  List<EmergencyProcedure> _filteredProcedures = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();

  final EmergencyProcedureService _procedureService =
      EmergencyProcedureService();

  @override
  void initState() {
    super.initState();
    _loadProcedures();
  }

  Future<void> _loadProcedures() async {
    await _procedureService.initialize();

    setState(() {
      _procedures = _procedureService.getAllProcedures();
      _filteredProcedures = _procedures;
      _isLoading = false;
    });
  }

  void _filterProcedures() {
    setState(() {
      if (_selectedCategory == 'all') {
        _filteredProcedures = _procedures;
      } else {
        _filteredProcedures = _procedures
            .where((procedure) => procedure.category == _selectedCategory)
            .toList();
      }

      if (_searchController.text.isNotEmpty) {
        _filteredProcedures = _filteredProcedures
            .where((procedure) =>
                procedure.title
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ||
                procedure.titleZh.contains(_searchController.text))
            .toList();
      }
    });
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
          isChinese ? '緊急程序' : 'Emergency Procedures',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                        onChanged: (value) => _filterProcedures(),
                        decoration: InputDecoration(
                          hintText:
                              isChinese ? '搜尋程序...' : 'Search procedures...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      SizedBox(height: 12),
                      // Category Filter
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCategoryChip('all', isChinese ? '全部' : 'All'),
                            ..._procedureService.getCategories().map(
                                  (category) => _buildCategoryChip(
                                      category,
                                      _getCategoryDisplayName(
                                          category, isChinese)),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Procedures List
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _filteredProcedures.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: Duration(milliseconds: 600),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildProcedureCard(
                                  _filteredProcedures[index], isChinese),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryChip(String category, String displayName) {
    final isSelected = _selectedCategory == category;
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(displayName),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
            _filterProcedures();
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue[100],
        checkmarkColor: Colors.blue[700],
      ),
    );
  }

  Widget _buildProcedureCard(EmergencyProcedure procedure, bool isChinese) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProcedureDetailScreen(procedure: procedure),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(procedure.category)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(procedure.category),
                      color: _getCategoryColor(procedure.category),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isChinese ? procedure.titleZh : procedure.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          isChinese
                              ? procedure.descriptionZh
                              : procedure.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(procedure.category)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getCategoryDisplayName(procedure.category, isChinese),
                      style: TextStyle(
                        color: _getCategoryColor(procedure.category),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${procedure.steps.length} ${isChinese ? '步驟' : 'steps'}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category, bool isChinese) {
    switch (category) {
      case 'earthquake':
        return isChinese ? '地震' : 'Earthquake';
      case 'typhoon':
        return isChinese ? '颱風' : 'Typhoon';
      case 'war':
        return isChinese ? '民防' : 'Civil Defense';
      case 'fire':
        return isChinese ? '火災' : 'Fire';
      default:
        return category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'earthquake':
        return Colors.orange;
      case 'typhoon':
        return Colors.blue;
      case 'war':
        return Colors.red;
      case 'fire':
        return Colors.red[700]!;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'earthquake':
        return Icons.vibration;
      case 'typhoon':
        return Icons.air;
      case 'war':
        return Icons.security;
      case 'fire':
        return Icons.local_fire_department;
      default:
        return Icons.emergency;
    }
  }
}
