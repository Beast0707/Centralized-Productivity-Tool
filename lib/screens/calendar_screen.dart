import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }, child: Text('Back'))
        ],
        automaticallyImplyLeading: false,
        title: Text("My Calendar"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: today,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),

            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),

            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },

            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = selected;
                today = focused;
              });
            },

            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),

          SizedBox(height: 20),

          Text(
            selectedDay == null
                ? "No date selected"
                : "Selected: ${selectedDay!.day}/${selectedDay!.month}/${selectedDay!.year}",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}