import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class FindBusBanner extends StatelessWidget {
  const FindBusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    
    return Container(
      width: double.infinity,
      height: ResponsiveUtils.getProportionateScreenHeight(context, 120),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(ResponsiveUtils.getProportionateScreenWidth(context, 16)),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Find your bus here!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Just sit back and relax ~',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth * 0.2,
            height: screenWidth * 0.2,
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.map_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}