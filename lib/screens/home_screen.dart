import 'package:flutter/material.dart';
import 'package:emergency_app_flutter/l10n/app_localizations.dart';
import '../services/emergency_procedure_service.dart';
import '../services/emergency_contact_service.dart';
import '../models/emergency_procedure.dart';
import '../models/emergency_contact.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<EmergencyProcedure> _procedures = [];
  List<EmergencyContact> _priorityContacts = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Service instances
  final EmergencyProcedureService _procedureService =
      EmergencyProcedureService();
  final EmergencyContactService _contactService = EmergencyContactService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _procedureService.initialize();
    await _contactService.initialize();

    setState(() {
      _procedures = _procedureService.getAllProcedures();
      _priorityContacts = _contactService.getPriorityContacts();
      _isLoading = false;
    });

    _animationController.forward();
  }

  void _showEmergencyAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text('Emergency Alert',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you experiencing an emergency?'),
            SizedBox(height: 16),
            Text('Quick Actions:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildQuickActionButton('Call 110 (Police)', Icons.local_police,
                Colors.blue, () => _callEmergency('110')),
            _buildQuickActionButton(
                'Call 119 (Fire/Medical)',
                Icons.local_fire_department,
                Colors.red,
                () => _callEmergency('119')),
            _buildQuickActionButton('Call 118 (Coast Guard)', Icons.waves,
                Colors.orange, () => _callEmergency('118')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 12),
              Expanded(
                  child: Text(title,
                      style: TextStyle(fontWeight: FontWeight.w500))),
              Icon(Icons.phone, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _callEmergency(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
    Navigator.of(context).pop();
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
          isChinese ? '台灣緊急應變指南' : 'Taiwan Emergency Guide',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.warning, color: Colors.red),
            onPressed: _showEmergencyAlert,
            tooltip: 'Emergency Alert',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading emergency information...'),
                ],
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emergency Alert Banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade400, Colors.red.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emergency, color: Colors.white, size: 32),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isChinese ? '緊急情況？' : 'Emergency?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  isChinese
                                      ? '立即撥打緊急電話'
                                      : 'Call emergency services immediately',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.phone, color: Colors.white),
                            onPressed: _showEmergencyAlert,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Emergency Procedures Section
                    Text(
                      isChinese ? '緊急應變程序' : 'Emergency Procedures',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),

                    AnimationLimiter(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: _procedures.length,
                        itemBuilder: (context, index) {
                          final procedure = _procedures[index];
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: Duration(milliseconds: 600),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child:
                                    _buildProcedureCard(procedure, isChinese),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 32),

                    // Priority Contacts Section
                    Text(
                      isChinese ? '緊急聯絡電話' : 'Emergency Contacts',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),

                    AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _priorityContacts.length,
                        itemBuilder: (context, index) {
                          final contact = _priorityContacts[index];
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

                    SizedBox(height: 24),

                    // Quick Tips Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb,
                                  color: Colors.blue.shade600),
                              SizedBox(width: 12),
                              Text(
                                isChinese
                                    ? '緊急準備小貼士'
                                    : 'Emergency Preparedness Tips',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildTipItem(
                            isChinese ? '準備緊急應變包' : 'Prepare an emergency kit',
                            Icons.medical_services,
                          ),
                          _buildTipItem(
                            isChinese
                                ? '了解最近的避難所位置'
                                : 'Know your nearest shelter location',
                            Icons.location_on,
                          ),
                          _buildTipItem(
                            isChinese ? '保持手機電量充足' : 'Keep your phone charged',
                            Icons.battery_full,
                          ),
                          _buildTipItem(
                            isChinese
                                ? '與家人制定應急計劃'
                                : 'Have a family emergency plan',
                            Icons.family_restroom,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProcedureCard(EmergencyProcedure procedure, bool isChinese) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to procedure detail screen
            Navigator.pushNamed(context, '/procedure-detail',
                arguments: procedure);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        _getCategoryColor(procedure.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(procedure.category),
                    color: _getCategoryColor(procedure.category),
                    size: 24,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  isChinese ? procedure.titleZh : procedure.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  isChinese ? procedure.descriptionZh : procedure.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      '${procedure.steps.length} steps',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
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
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.phone,
            color: Colors.red.shade600,
            size: 24,
          ),
        ),
        title: Text(
          isChinese ? contact.nameZh : contact.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          contact.phoneNumber,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.phone, color: Colors.red.shade600),
          onPressed: () => _callEmergency(contact.phoneNumber),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade600, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'earthquake':
        return Colors.orange;
      case 'typhoon':
        return Colors.blue;
      case 'war':
        return Colors.red;
      default:
        return Colors.green;
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
      default:
        return Icons.emergency;
    }
  }
}
