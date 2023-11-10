import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateActivity extends StatefulWidget {
  const CreateActivity({super.key});

  @override
  State<CreateActivity> createState() => _CreateActivityState();
}

class _CreateActivityState extends State<CreateActivity> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String desc = '';
  String destination = '';
  int category = 0;
  Map categories = {
    0: 'Entertainment',
    1: 'Outdoor',
    2: 'Sports',
    3: 'Trip',
    4: 'Meetup',
    5: 'Other'
  };

  DateTime? fromDateTime;
  DateTime? fromDate;
  TimeOfDay? fromTime;

  DateTime? toDateTime;
  DateTime? toDate;
  TimeOfDay? toTime;

  String getTimeText(TimeOfDay time) {
    if (time == null) {
      return 'Select Time';
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');

      return '$hours:$minutes';
    }
  }

  String getDateText(DateTime date) {
    if (date == null) {
      return 'Select Date';
    } else {
      return DateFormat('dd/MM/yyyy').format(date!);
      // return '${date.month}/${date.day}/${date.year}';
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
                  // buildCategory(),
                  // const SizedBox(height: 10),
                  // buildDate(),
                  // const SizedBox(height: 10),
                  // buildTime(),
                  // const SizedBox(height: 10),
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
