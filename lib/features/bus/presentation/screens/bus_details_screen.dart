import 'package:dubts/core/models/bus_model.dart';
import 'package:dubts/core/services/bus_service.dart';
import 'package:dubts/features/bus/presentation/widgets/bus_direction_tab_bar.dart';
import 'package:dubts/features/bus/presentation/widgets/bus_schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dubts/core/utils/responsive_utils.dart';

class BusDetailScreen extends StatefulWidget {
  final String? busId;

  const BusDetailScreen({
    super.key,
    this.busId,
  });

  @override
  State<BusDetailScreen> createState() => _BusDetailScreenState();
}

class _BusDetailScreenState extends State<BusDetailScreen> {
  bool _showUp = true;
  BusModel? _bus;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBusDetails();
  }

  Future<void> _loadBusDetails() async {
    if (widget.busId == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final busService = Provider.of<BusService>(context, listen: false);
      final bus = await busService.getBusById(widget.busId!);
      
      setState(() {
        _bus = bus;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onDirectionChanged(bool showUp) {
    setState(() {
      _showUp = showUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = ResponsiveUtils.screenHeight(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Khanika',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Padding(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.getProportionateScreenWidth(context, 16),
                  ),
                  child: Column(
                    children: [
                      BusDirectionTabBar(
                        showUp: _showUp,
                        onDirectionChanged: _onDirectionChanged,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            final times = [
                              '05:50 AM',
                              '06:10 AM',
                              '06:10 AM',
                              '06:40 AM',
                              '06:40 AM',
                              '07:00 AM',
                              '07:30 AM',
                            ];
                            final isCollegeGate = index == 2 || index == 5;
                            
                            return BusScheduleItem(
                              time: times[index],
                              route: isCollegeGate ? 'CollegeGate to Campus' : 'Shib-Bari to Campus',
                              isCollegeGate: isCollegeGate,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFFE53935),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}