import 'package:app/screens/academics/models/dropdown_data_with_selection.dart';
import 'package:flutter/material.dart';

class SelectFromDropdown<T> extends StatelessWidget {
  final Size deviceSize;
  final ValueNotifier<DropdownDataWithSelection<T>> dataNotifier;
  final ValueChanged<T> onChanged;

  const SelectFromDropdown({
    Key key,
    @required this.dataNotifier,
    @required this.onChanged,
    @required this.deviceSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DropdownDataWithSelection<T>>(
      valueListenable: dataNotifier,
      builder: (context, dataWithSelection, child) {
        return Container(
          height: deviceSize.height * 0.05,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(width: 1)),
          width: deviceSize.width * 0.43,
          child: DropdownButton<T>(
            value: dataWithSelection.selectedItem,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.brown),
            onChanged: (T newItem) {
              dataNotifier.value =
                  dataNotifier.value.updateSelectedItem(newItem);
              onChanged(newItem);
            },
            items:
                dataWithSelection.dataList.map<DropdownMenuItem<T>>((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Container(
                  width: deviceSize.width * 0.33,
                  child: Text('$value'),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
