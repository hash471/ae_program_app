import 'package:app/providers/academics_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DaysList extends StatelessWidget {
  final ValueChanged<int> onDaySelected;

  const DaysList({
    Key key,
    this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final daysHeight = kToolbarHeight * 1.4;
    return Consumer<AcademicsProvider>(
      builder: (context, provider, child) {
        if (provider.days == 0) return const SizedBox();

        return Container(
          width: deviceSize.width,
          height: daysHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: provider.days,
            itemBuilder: (context, index) {
              final day = index + 1;
              final isSelected = provider.selectedDay == day;
              return InkWell(
                onTap: () {
                  provider.setSelectedDay(day);
                  if (onDaySelected != null) onDaySelected(day);
                },
                child: Container(
                  width: daysHeight * 0.6,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 2.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: isSelected ? Color(0xff83BB40) : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'DAY',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '$day'.padLeft(2, '0'),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
