import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/guide_service.dart';
import '../../domain/models/bus_schedule.dart';

class SelectBusScreen extends StatefulWidget {
  const SelectBusScreen({super.key});

  @override
  State<SelectBusScreen> createState() => _SelectBusScreenState();
}

class _SelectBusScreenState extends State<SelectBusScreen> {
  final GuideService _guideService = GuideService();
  bool _isTracking = false;
  String? _selectedBusCode;
  String? _selectedTime;

  void _startTracking() async {
    if (_selectedBusCode != null && _selectedTime != null) {
      setState(() => _isTracking = true);
      await _guideService.startBusTracking(
        _selectedBusCode!,
        _selectedTime!,
        'guide_id', // Replace with actual guide ID
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bus tracking started'),
            backgroundColor: Color(0xFFE53935),
          ),
        );
      }
    }
  }

  void _stopTracking() async {
    if (_selectedBusCode != null) {
      await _guideService.stopBusTracking(_selectedBusCode!);
      if (mounted) {
        setState(() => _isTracking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bus tracking stopped'),
            backgroundColor: Color(0xFFE53935),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bus'),
        backgroundColor: const Color(0xFFE53935),
      ),
      body: StreamBuilder<List<BusSchedule>>(
        stream: _guideService.getBusSchedules(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final schedules = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              final isSelected = _selectedBusCode == schedule.busCode && 
                               _selectedTime == schedule.time;

              return Card(
                elevation: isSelected ? 4 : 1,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  selected: isSelected,
                  selectedTileColor: const Color(0xFFFFEBEE),
                  title: Text(
                    'Bus: ${schedule.busCode}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Time: ${schedule.time}\n'
                    'Route: ${schedule.startingPoint} → ${schedule.endingPoint}',
                  ),
                  onTap: _isTracking ? null : () {
                    setState(() {
                      _selectedBusCode = schedule.busCode;
                      _selectedTime = schedule.time;
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selectedBusCode == null
            ? null
            : _isTracking
                ? _stopTracking
                : _startTracking,
        backgroundColor: const Color(0xFFE53935),
        icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
        label: Text(_isTracking ? 'Stop Tracking' : 'Start Tracking'),
      ),
    );
  }
}
