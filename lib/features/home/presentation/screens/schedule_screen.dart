import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/bus_model.dart';
import '../../../../core/services/bus_service.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../widgets/bus_list_item.dart';
import '../widgets/schedule_tab_bar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _showUpcoming = true;
  final _searchController = TextEditingController();
  List<BusModel>? _buses;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBuses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBuses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final busService = Provider.of<BusService>(context, listen: false);
      final buses = await busService.getBuses();
      
      setState(() {
        _buses = buses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _searchBuses(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final busService = Provider.of<BusService>(context, listen: false);
      final buses = await busService.searchBuses(query);
      
      setState(() {
        _buses = buses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onTabChanged(bool showUpcoming) {
    setState(() {
      _showUpcoming = showUpcoming;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    final screenHeight = ResponsiveUtils.screenHeight(context);
    
    return Padding(
      padding: EdgeInsets.all(ResponsiveUtils.getProportionateScreenWidth(context, 16)),
      child: Column(
        children: [
          Text(
            'Schedule',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          ScheduleTabBar(
            showUpcoming: _showUpcoming,
            onTabChanged: _onTabChanged,
          ),
          SizedBox(height: screenHeight * 0.02),
          if (_showUpcoming) ...[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search your bus here',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                _searchBuses(value);
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _buses == null || _buses!.isEmpty
                          ? const Center(child: Text('No buses found'))
                          : ListView.builder(
                              itemCount: _buses!.length,
                              itemBuilder: (context, index) {
                                return BusListItem(
                                  bus: _buses![index],
                                  onTap: () {
                                    // Navigate to bus detail screen
                                  },
                                );
                              },
                            ),
            ),
          ] else ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      size: screenWidth * 0.2,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'No canceled buses',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}