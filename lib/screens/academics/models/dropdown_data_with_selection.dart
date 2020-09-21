import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show required;

class DropdownDataWithSelection<T> extends Equatable {
  final List<T> dataList;
  final T selectedItem;

  DropdownDataWithSelection({
    @required this.dataList,
    @required this.selectedItem,
  });

  factory DropdownDataWithSelection.empty() {
    return DropdownDataWithSelection<T>(
      dataList: <T>[],
      selectedItem: null,
    );
  }

  @override
  List<Object> get props => [dataList, selectedItem];

  bool isFirstEqualTo(T item) => dataList[0] == item;

  DropdownDataWithSelection<T> updateSelectedItem(T newItem) {
    return DropdownDataWithSelection<T>(
      dataList: dataList,
      selectedItem: newItem,
    );
  }
}