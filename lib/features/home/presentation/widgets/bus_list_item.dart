import 'package:dubts/core/models/bus_model.dart';
import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class BusListItem extends StatelessWidget {
  final BusModel bus;
  final VoidCallback onTap;

  const BusListItem({
    super.key,
    required this.bus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: ResponsiveUtils.getProportionateScreenHeight(context, 12),
        ),
        padding: EdgeInsets.all(
          ResponsiveUtils.getProportionateScreenWidth(context, 12),
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(
                ResponsiveUtils.getProportionateScreenWidth(context, 8),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
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
              bus.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (bus.isNearby) ...[
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.getProportionateScreenWidth(context, 8),
                  vertical: ResponsiveUtils.getProportionateScreenHeight(context, 4),
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Near you',
                  style: TextStyle(
                    color: Color(0xFFE53935),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}