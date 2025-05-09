import 'package:dubts/features/home/presentation/widgets/bus_search_bar.dart';
import 'package:dubts/features/home/presentation/widgets/find_bus_banner.dart';
import 'package:flutter/material.dart';
import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:dubts/features/home/presentation/widgets/map_view.dart'; // Import the MapView widget

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    final screenHeight = ResponsiveUtils.screenHeight(context);
    
    return Padding(
      padding: EdgeInsets.all(ResponsiveUtils.getProportionateScreenWidth(context, 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FindBusBanner(),
          SizedBox(height: screenHeight * 0.03),
          const BusSearchBar(),
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              const Icon(Icons.bookmark_border, color: Color(0xFFE53935)),
              SizedBox(width: screenWidth * 0.02),
              const Text('Choose a saved bus'),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            'Around you',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          const Expanded(
            child: MapView(),
          ),
        ],
      ),
    );
  }
}