import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<String> categories = <String>[
  'Entertainment',
  'Outdoor',
  'Sports',
  'Trip',
  'Meetup',
  'Other'
];

class CreateActivityTab extends StatefulWidget {
  const CreateActivityTab({super.key});

  @override
  State<CreateActivityTab> createState() => _CreateActivityTabState();
}

class _CreateActivityTabState extends State<CreateActivityTab> {
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

  Widget buildResetButton() => Builder(
        builder: (context) => ElevatedButton(
          child: const Text('Reset'),
          onPressed: () {
            _formKey.currentState!.reset();
          },
        ),
      );

  Widget buildSubmitButton() => Builder(
        builder: (context) => ElevatedButton(
          child: const Text('Submit'),
          onPressed: () async {
            final isValid = _formKey.currentState!.validate();
            FocusScope.of(context).unfocus();

            if (isValid) {
              _formKey.currentState!.save();

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 5),
                content: Text('Form Submitted'),
              ));

              // setState(() {
              //   date = null;
              //   time = null;
              // });
              _formKey.currentState!.reset();
            }
          },
        ),
      );
}
