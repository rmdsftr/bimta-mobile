import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputWidget extends StatefulWidget {
  final String label;
  final Function(DateTime?)? onDateSelected;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hintText;

  const DateInputWidget({
    Key? key,
    required this.label,
    this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.hintText,
  }) : super(key: key);

  @override
  _DateInputWidgetState createState() => _DateInputWidgetState();
}

class _DateInputWidgetState extends State<DateInputWidget> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      selectedDate = widget.initialDate;
      _dateController.text = DateFormat('dd/MM/yyyy').format(widget.initialDate!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime.now(),
      lastDate: widget.lastDate ?? DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });

      // Callback ke parent widget
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _dateController,
          readOnly: true,
          onTap: () => _selectDate(context),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.calendar_month,
              size: 23,
              color: Colors.deepPurple,
            ),
            hintText: widget.hintText ?? "Pilih tanggal",
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black12,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF74ADDF),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}

// Widget untuk Input Waktu
class TimeInputWidget extends StatefulWidget {
  final String label;
  final Function(TimeOfDay?)? onTimeSelected;
  final TimeOfDay? initialTime;
  final String? hintText;

  const TimeInputWidget({
    Key? key,
    required this.label,
    this.onTimeSelected,
    this.initialTime,
    this.hintText,
  }) : super(key: key);

  @override
  _TimeInputWidgetState createState() => _TimeInputWidgetState();
}

class _TimeInputWidgetState extends State<TimeInputWidget> {
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null) {
      selectedTime = widget.initialTime;
      _timeController.text = _formatTime(widget.initialTime!);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = _formatTime(picked);
      });

      // Callback ke parent widget
      if (widget.onTimeSelected != null) {
        widget.onTimeSelected!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _timeController,
          readOnly: true,
          onTap: () => _selectTime(context),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.access_time,
              size: 23,
              color: Colors.deepPurple,
            ),
            hintText: widget.hintText ?? "Pilih waktu",
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black12,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF74ADDF),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }
}

// Contoh penggunaan di Parent Widget
class ParentFormExample extends StatefulWidget {
  @override
  _ParentFormExampleState createState() => _ParentFormExampleState();
}

class _ParentFormExampleState extends State<ParentFormExample> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Example')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Widget Input Date
            DateInputWidget(
              label: "Tanggal",
              hintText: "Pilih tanggal",
              firstDate: DateTime.now(),
              lastDate: DateTime(2025),
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                print('Selected Date: $date');
              },
            ),

            SizedBox(height: 20),

            // Widget Input Time
            TimeInputWidget(
              label: "Waktu",
              hintText: "Pilih waktu",
              onTimeSelected: (time) {
                setState(() {
                  selectedTime = time;
                });
                print('Selected Time: $time');
              },
            ),

            SizedBox(height: 20),

            // Field Lokasi biasa
            Text(
              "Lokasi",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.location_on,
                  size: 23,
                  color: Colors.deepPurple,
                ),
                hintText: "Masukkan lokasi",
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF74ADDF),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            // Tombol Submit untuk testing
            ElevatedButton(
              onPressed: () {
                print('Form Data:');
                print('Date: $selectedDate');
                print('Time: $selectedTime');
                print('Location: ${_locationController.text}');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }
}