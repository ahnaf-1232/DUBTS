import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class BusDirectionTabBar extends StatelessWidget {
  final bool showUp;
  final ValueChanged<bool> onDirectionChanged;

  const BusDirectionTabBar({
    super.key,
    required this.showUp,
    required this.onDirectionChanged,
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
              onTap: () => onDirectionChanged(true),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getProportionateScreenHeight(context, 8),
                ),
                decoration: BoxDecoration(
                  color: showUp ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'UP',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onDirectionChanged(false),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.getProportionateScreenHeight(context, 8),
                ),
                decoration: BoxDecoration(
                  color: !showUp ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Down',
                  style: TextStyle(
                    color: !showUp ? Colors.white : Colors.black,
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