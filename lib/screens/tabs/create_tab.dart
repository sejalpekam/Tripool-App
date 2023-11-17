import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<String> categories = <String>[
  'Events',
  'Outdoor',
  'Sports',
  'Trip',
  'Meetup',
  'Other'
];

User? user = FirebaseAuth.instance.currentUser;

class CreateActivityTab extends StatefulWidget {
  const CreateActivityTab({super.key});

  @override
  State<CreateActivityTab> createState() => _CreateActivityTabState();
}

class _CreateActivityTabState extends State<CreateActivityTab> {
  // controllers for input
  var _activityTitleController = TextEditingController();
  var _activityDescController = TextEditingController();
  var _activityDestinationController = TextEditingController();

  @override
  void dispose() {
    _activityTitleController.dispose();
    _activityDescController.dispose();
    _activityDestinationController.dispose();
    super.dispose();
  }

  Future submitForm() async {
    print("Submit button clicked");
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return; // If the form is not valid, do not proceed.
    }

    var userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .get();

    String userName = userData.get('Name') as String;

    // Extracting data from controllers
    String activityTitle = _activityTitleController.text.trim();
    String activityDescription = _activityDescController.text.trim();
    String activityDestination = _activityDestinationController.text.trim();
    String category = dropdownValue;
    String? creatorId = user?.uid;

    // Combine date and time for start and end
    DateTime? combinedStartDate = combineDateTime(startdate, starttime);
    DateTime? combinedEndDate = combineDateTime(enddate, endtime);

    // Convert DateTime to Timestamp for Firestore
    Timestamp startTimestamp =
        Timestamp.fromDate(combinedStartDate ?? DateTime.now());
    Timestamp endTimestamp =
        Timestamp.fromDate(combinedEndDate ?? DateTime.now());

    // Calling addActivityDetails function with the collected data
    await addActivityDetails(
        activityTitle,
        activityDescription,
        activityDestination,
        startTimestamp,
        endTimestamp,
        category,
        creatorId!,
        userName);

    // Show confirmation dialog
    await showConfirmationDialog();

    // Optionally reset the form
    _formKey.currentState!.reset();

    // resset all fields
    resetForm();
  }

// error dialog for Time/Date
  Future<void> showDateTimeMissingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Missing Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please fill out Start Date/Time and End Date/Time.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
          ],
        );
      },
    );
  }

  DateTime? combineDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future addActivityDetails(
      String activityTitle,
      String activityDescription,
      String activityDestination,
      Timestamp startDate,
      Timestamp endDate,
      String category,
      String creatorId,
      String userName) async {
    await FirebaseFirestore.instance.collection('Activity').add({
      'Activity_Description': activityDescription,
      'Activity_Name': activityTitle,
      'Category': category,
      'Creator': creatorId,
      'CreatorName': userName,
      'Destination': activityDestination,
      'From': startDate,
      'To': endDate,
      'Members': [
        FirebaseAuth.instance.currentUser!.uid
      ], // Initialize as empty array
      'Requests': [] // Initialize as empty array
    });
  }

  final _formKey = GlobalKey<FormState>();

  String title = '';
  String desc = '';
  String destination = '';

  String dropdownValue = categories.first;

  DateTime? startDateTime;
  DateTime? startdate;
  TimeOfDay? starttime;
  DateTime? endDateTime;
  DateTime? enddate;
  TimeOfDay? endtime;

  String getDateText(DateTime? date) {
    if (date == null) {
      return 'Select Date';
    } else {
      return DateFormat('dd/MM/yyyy').format(date!);
      // return '${date.month}/${date.day}/${date.year}';
    }
  }

  String getTimeText(TimeOfDay? time) {
    if (time == null) {
      return 'Select Time';
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildTitle(),
                  const SizedBox(height: 10),
                  buildDesc(),
                  const SizedBox(height: 10),
                  buildDestination(),
                  const SizedBox(height: 10),
                  buildCategory(),
                  const SizedBox(height: 10),
                  buildStartDate(startdate, starttime),
                  const SizedBox(height: 10),
                  buildEndDate(enddate, endtime),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildResetButton(),
                      buildSubmitButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle() => TextFormField(
        controller: _activityTitleController, // Assign the controller here
        decoration: const InputDecoration(
          labelText: 'Activity Title',
          border: OutlineInputBorder(),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.length < 4) {
            return 'Enter at least 4 characters';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => title = value!),
      );

  Widget buildDesc() => TextFormField(
        controller: _activityDescController,
        decoration: const InputDecoration(
          labelText: 'Activity Description',
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
        ),
        maxLines: 2,
        keyboardType: TextInputType.multiline,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.length < 4) {
            return 'Enter at least 5 characters';
          } else {
            return null;
          }
        },
        maxLength: 250,
        onSaved: (value) => setState(() => desc = value!),
      );

  Widget buildDestination() => TextFormField(
        controller: _activityDestinationController,
        decoration: const InputDecoration(
          labelText: 'Activity Destination',
          border: OutlineInputBorder(),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value!.length < 4) {
            return 'Enter at least 4 characters';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => destination = value!),
      );

  Widget buildStartDate(DateTime? date, TimeOfDay? time) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Start Date'),
            TextButton(
              child: Text(getDateText(date)),
              onPressed: () async {
                final initialDate = DateTime.now();
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: date ?? initialDate,
                  firstDate: DateTime.now().subtract(Duration(days: 0)),
                  lastDate: DateTime(DateTime.now().year + 1),
                );

                if (newDate == null) return;
                if (newDate.isBefore(DateTime.now())) return;

                setState(() => startdate = newDate);
              },
            ),
            Text('Start Time'),
            TextButton(
              child: Text(getTimeText(time)),
              onPressed: () async {
                final initialTime = TimeOfDay(hour: 16, minute: 0);
                final newTime = await showTimePicker(
                  context: context,
                  initialTime: time ?? initialTime,
                );

                if (newTime == null) return;
                setState(() => starttime = newTime);
              },
            )
          ],
        ),
      );

  Widget buildEndDate(DateTime? date, TimeOfDay? time) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('EndDate'),
            TextButton(
              child: Text(getDateText(date)),
              onPressed: () async {
                final initialDate = startdate ?? DateTime.now();
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: date ?? initialDate,
                  firstDate: startdate!,
                  lastDate: DateTime(DateTime.now().year + 1),
                );

                if (newDate == null) return;
                if (newDate.isBefore(DateTime.now())) return;

                setState(() => enddate = newDate);
              },
            ),
            Text('End Time'),
            TextButton(
              child: Text(getTimeText(time)),
              onPressed: () async {
                final initialTime = TimeOfDay(hour: 16, minute: 0);
                final newTime = await showTimePicker(
                  context: context,
                  initialTime: time ?? initialTime,
                );

                if (newTime == null) return;
                setState(() => endtime = newTime);
              },
            ),
          ],
        ),
      );

  Widget buildCategory() => DropdownMenu<String>(
        initialSelection: categories.first,
        onSelected: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        dropdownMenuEntries:
            categories.map<DropdownMenuEntry<String>>((String value) {
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
      );

  Future resetForm() async {
    setState(() {
      _activityTitleController = TextEditingController();
      _activityDescController = TextEditingController();
      _activityDestinationController = TextEditingController();
      dropdownValue = categories.first;
      startdate = null;
      starttime = null;
      enddate = null;
      endtime = null;
    });

    _formKey.currentState!.reset();
  }

  Widget buildResetButton() => Builder(
        builder: (context) => ElevatedButton(
          child: const Text('Reset'),
          onPressed: resetForm,
        ),
      );

  Widget buildSubmitButton() => Builder(
        builder: (context) => ElevatedButton(
          child: const Text('Submit'),
          onPressed: submitForm,
        ),
      );

// pop up dialog
  Future<void> showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Activity Created Successfully'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
