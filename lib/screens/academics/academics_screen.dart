import 'package:app/providers/academics_provider.dart';
import 'package:app/screens/academics/widgets/days_list.dart';
import 'package:app/screens/academics/models/dropdown_data_with_selection.dart';
import 'package:app/screens/academics/widgets/select_from_dropdown.dart';
import 'package:app/screens/academics/widgets/submit_button.dart';
import 'package:app/screens/academics/widgets/topics_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/batches.dart';
import '../../providers/centres.dart';
import '../splashScreen.dart';

class AcademicsScreen extends StatefulWidget {
  static const routeName = '/academicsScreen';
  @override
  _AcademicsScreenState createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> {
  ValueNotifier<DropdownDataWithSelection<String>> _centresDataNotifier;
  ValueNotifier<DropdownDataWithSelection<String>> _batchesDataNotifier;
  ValueNotifier<String> _helperGuideNotifier;
  AcademicsProvider _academicsProvider;

  @override
  void initState() {
    super.initState();
    _academicsProvider = Provider.of<AcademicsProvider>(context, listen: false)
      ..init();
    _centresDataNotifier =
        ValueNotifier(DropdownDataWithSelection<String>.empty());
    _batchesDataNotifier =
        ValueNotifier(DropdownDataWithSelection<String>.empty());
    _helperGuideNotifier = ValueNotifier('Select Centre');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final centreListProvider = Provider.of<CentreList>(
        context,
        listen: false,
      );
      await centreListProvider.fetchCentres();
      final centres = centreListProvider.getCentreNames;
      _centresDataNotifier.value = DropdownDataWithSelection<String>(
        dataList: centres,
        selectedItem: centres[0],
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _centresDataNotifier.dispose();
    _batchesDataNotifier.dispose();
    _helperGuideNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black87,
          onPressed: Navigator.of(context).pop,
        ),
        title: Text(
          'Academics',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: _centresDataNotifier.value.dataList.isEmpty
          ? SplashScreen()
          : _bodyContent(deviceSize),
    );
  }

  Widget _bodyContent(Size deviceSize) {
    return Column(
      children: [
        Container(
          width: deviceSize.width,
          height: deviceSize.height * 0.08,
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SelectFromDropdown<String>(
                deviceSize: deviceSize,
                dataNotifier: _centresDataNotifier,
                onChanged: (String newItem) {
                  updateBatchesByCentre();
                  _helperGuideNotifier.value = 'Select Batch';
                },
              ),
              SelectFromDropdown<String>(
                deviceSize: deviceSize,
                dataNotifier: _batchesDataNotifier,
                onChanged: (String newValue) async {
                  final selectedCentre =
                      _centresDataNotifier.value.selectedItem;
                  final selectedBatch = _batchesDataNotifier.value.selectedItem;
                  if (_centresDataNotifier.value
                          .isFirstEqualTo(selectedCentre) ||
                      _batchesDataNotifier.value
                          .isFirstEqualTo(selectedBatch)) {
                    return;
                  }

                  _academicsProvider.updateBatchNameTo(selectedBatch);
                  final areTopicsAvailable = await _academicsProvider
                      .fetchNumberOfDaysGiven(selectedBatch);
                  _helperGuideNotifier.value =
                      areTopicsAvailable ? 'Select day' : 'No Topics available';
                },
              ),
            ],
          ),
        ),
        DaysList(
          onDaySelected: (int day) => _helperGuideNotifier.value = null,
        ),
        _helperGuideOrTopicsList(),
      ],
    );
  }

  Widget _helperGuideOrTopicsList() {
    return Expanded(
      child: Center(
        child: ValueListenableBuilder<String>(
          valueListenable: _helperGuideNotifier,
          builder: (context, value, child) {
            if (value != null) return Text(value);
            
            return Column(
              children: [
                Expanded(child: TopicsList()),
                SubmitButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> updateBatchesByCentre() async {
    final batchListProvider = Provider.of<BatchList>(context, listen: false);
    batchListProvider.refreshBatches();
    await batchListProvider
        .fetchBatches(_centresDataNotifier.value.selectedItem);
    final batches = batchListProvider.getBatchNames;
    _batchesDataNotifier.value = DropdownDataWithSelection<String>(
      dataList: batches,
      selectedItem: batches[0],
    );
  }
}
