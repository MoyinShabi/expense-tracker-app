// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final int weekdayTotalAmount;
  final double percentageOfTotalAmount;

  const ChartBar(
      {required this.label,
      required this.weekdayTotalAmount,
      required this.percentageOfTotalAmount});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // LayoutBuilder helps to get information about the constraints (sizing) of a particular widget, and
      // in this case, the `ChartBar` widget which is essentially a Column
      builder: (BuildContext ctx, BoxConstraints constraints) {
        return Column(
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text(
                      'N$weekdayTotalAmount')), // To help shrink the text always
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            // Main Bar
            SizedBox(
              height: constraints.maxHeight * 0.6,
              // Sizing the chart bars dynamically based on the constraints
              // of the parent of the LayoutBuilder widget- Row. This is 60% of the available height
              width: 10,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  // Bottomost widget
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: percentageOfTotalAmount,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 3),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
