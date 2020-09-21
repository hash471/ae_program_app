import 'package:app/providers/academics_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DaysList extends StatelessWidget {
  final ValueChanged<int> onDaySelected;

  const DaysList({
    Key key,
    @required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final daysHeight = deviceSize.height * 0.06;
    return Consumer<AcademicsProvider>(
      builder: (context, provider, child) {
        if (provider.days == 0) return const SizedBox();

        return Container(
          width: deviceSize.width,
          height: daysHeight,
          color: Colors.grey[300],
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: provider.days,
            itemBuilder: (context, index) {
              final day = index + 1;
              return InkWell(
                onTap: () {
                  provider.setSelectedDay(day);
                  onDaySelected(day);
                },
                child: Container(
                  width: daysHeight * 0.9,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: daysHeight * 0.1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: provider.selectedDay == day
                        ? Color(0xff83BB40)
                        : Colors.transparent,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(color: Colors.black87),
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
