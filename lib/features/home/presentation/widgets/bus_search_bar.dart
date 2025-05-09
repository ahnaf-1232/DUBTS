import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class BusSearchBar extends StatelessWidget {
  const BusSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getProportionateScreenWidth(context, 16),
        vertical: ResponsiveUtils.getProportionateScreenHeight(context, 8),
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          SizedBox(width: ResponsiveUtils.getProportionateScreenWidth(context, 8)),
          const Text(
            'Search your bus?',
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getProportionateScreenWidth(context, 12),
              vertical: ResponsiveUtils.getProportionateScreenHeight(context, 4),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.access_time, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  'Now',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}