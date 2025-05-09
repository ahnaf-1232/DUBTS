import 'package:dubts/core/controllers/bus_tracker_controller.dart';
import 'package:dubts/core/models/bus_location_model.dart';
import 'package:dubts/core/models/bus_model.dart';
import 'package:dubts/core/models/user_model.dart';
import 'package:dubts/screens/home/bus_tracking_screen.dart';
import 'package:dubts/screens/home/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusDetailsScreen extends StatefulWidget {
  final BusModel bus;
  
  const BusDetailsScreen({Key? key, required this.bus}) : super(key: key);

  @override
  _BusDetailsScreenState createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
  final BusTrackerController _busTrackerController = BusTrackerController();
  bool _isNotifying = false;
  bool _isDriver = false;

  @override
  void initState() {
    super.initState();
    _checkIfDriver();
  }

  Future<void> _checkIfDriver() async {
    // In a real app, you would check if the current user is a driver for this bus
    // For demo purposes, we'll just set it to true
    setState(() {
      _isDriver = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: Text(widget.bus.name),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bus Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
              ),
              child: widget.bus.imageUrl != null
                  ? Image.network(
                      widget.bus.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/bus.png',
                      fit: BoxFit.contain,
                    ),
            ),
            
            // Bus Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bus.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const Divider(color: Colors.red),
                      _buildDetailRow('Route', widget.bus.route),
                      _buildDetailRow('Company', widget.bus.company),
                      _buildDetailRow('Type', widget.bus.type),
                      _buildDetailRow('Fare', '৳${widget.bus.fare.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
            ),
            
            // Driver Controls (only visible to drivers)
            if (_isDriver && user != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Driver Controls',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const Divider(color: Colors.red),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.location_on),
                          label: const Text('Start Tracking Location'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusTrackingScreen(
                                  bus: widget.bus,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            
            // Bus Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live Location',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const Divider(color: Colors.red),
                      StreamBuilder<BusLocationModel?>(
                        stream: _busTrackerController.getBusLocation(widget.bus.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text(
                              'Error loading location data',
                              style: TextStyle(color: Colors.red),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            );
                          }

                          final busLocation = snapshot.data;
                          
                          if (busLocation == null || !busLocation.isActive) {
                            return Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: Text(
                                      'No live location available',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.map),
                                  label: const Text('View on Map'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 45),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('No location data available for this bus'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }

                          return Column(
                            children: [
                              const SizedBox(height: 16),
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(
                                        Icons.map,
                                        size: 80,
                                        color: Colors.red.shade300,
                                      ),
                                    ),
                                    Positioned(
                                      right: 8,
                                      bottom: 8,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.fullscreen),
                                        label: const Text('Expand'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MapScreen(
                                                bus: widget.bus,
                                                initialLocation: busLocation.location,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.map),
                                label: const Text('View on Map'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 45),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapScreen(
                                        bus: widget.bus,
                                        initialLocation: busLocation.location,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Last updated: ${_formatTimestamp(busLocation.timestamp)}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Notification Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: Icon(_isNotifying ? Icons.notifications_active : Icons.notifications),
                label: Text(_isNotifying ? 'Cancel Notification' : 'Notify When Bus Approaches'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isNotifying ? Colors.grey : Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  setState(() {
                    _isNotifying = !_isNotifying;
                  });
                  
                  if (_isNotifying) {
                    _busTrackerController.notifyWhenBusApproaching(
                      widget.bus.id,
                      widget.bus.name,
                      500, // 500 meters threshold
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You will be notified when the bus is approaching'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
