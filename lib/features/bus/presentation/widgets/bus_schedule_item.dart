import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class BusScheduleItem extends StatelessWidget {
  final String time;
  final String route;
  final bool isCollegeGate;

  const BusScheduleItem({
    super.key,
    required this.time,
    required this.route,
    this.isCollegeGate = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.getProportionateScreenHeight(context, 12),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getProportionateScreenWidth(context, 16),
        vertical: ResponsiveUtils.getProportionateScreenHeight(context, 12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              ResponsiveUtils.getProportionateScreenWidth(context, 8),
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.directions_bus,
              color: Color(0xFFE53935),
              size: 20,
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getProportionateScreenWidth(context, 12),
              vertical: ResponsiveUtils.getProportionateScreenHeight(context, 6),
            ),
            decoration: BoxDecoration(
              color: isCollegeGate ? const Color(0xFFE53935) : Colors.red.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              route,
              style: TextStyle(
                color: isCollegeGate ? Colors.white : const Color(0xFFE53935),
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}