import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class ScheduleTabBar extends StatelessWidget {
  final bool showUpcoming;
  final ValueChanged<bool> onTabChanged;

  const ScheduleTabBar({
    super.key,
    required this.showUpcoming,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: EdgeInsets.all(
        ResponsiveUtils.getProportionateScreenWidth(context, 4),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(true),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getProportionateScreenHeight(context, 8),
                ),
                decoration: BoxDecoration(
                  color: showUpcoming ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Upcoming',
                  style: TextStyle(
                    color: showUpcoming ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(false),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getProportionateScreenHeight(context, 8),
                ),
                decoration: BoxDecoration(
                  color: !showUpcoming ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Canceled',
                  style: TextStyle(
                    color: !showUpcoming ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}