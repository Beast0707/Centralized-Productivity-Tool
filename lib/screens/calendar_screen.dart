import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/db_service.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();
  DateTime? selectedDay;
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Text('Back'),
          )
        ],
        title: Text("My Calendar"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: today,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            headerStyle: HeaderStyle(formatButtonVisible: false),
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: (selected, focused) async {
              setState(() {
                selectedDay = selected;
                today = focused;
                _isLoading = true;
              });
              final tasks = await DBService.instance.getTasksByDate(selected);
              setState(() {
                _tasks = List<Map<String, dynamic>>.from(tasks);
                _isLoading = false;
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

          // ── Events Section ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDay == null
                      ? "No date selected"
                      : "${selectedDay!.day}/${selectedDay!.month}/${selectedDay!.year}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (selectedDay != null)
                  Text(
                    "${_tasks.length} event${_tasks.length == 1 ? '' : 's'}",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
              ],
            ),
          ),

          SizedBox(height: 10),

          Expanded(
            child: selectedDay == null
                // ── Placeholder when no date is picked ──
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today,
                            size: 48, color: Colors.grey.shade300),
                        SizedBox(height: 12),
                        Text(
                          "Select a date to view events",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : _isLoading
                    // ── Loading spinner ──
                    ? Center(child: CircularProgressIndicator(color: Colors.black))
                    : _tasks.isEmpty
                        // ── Empty state ──
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.event_busy,
                                    size: 48, color: Colors.grey.shade300),
                                SizedBox(height: 12),
                                Text(
                                  "No events for this day",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        // ── Events list ──
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _tasks.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  leading: Container(
                                    width: 4,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  title: Text(
                                    task['title'] ?? 'Untitled',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: task['description'] != null &&
                                          task['description'].toString().isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            task['description'],
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 13),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      : null,
                                  trailing: task['time'] != null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.access_time,
                                                size: 14, color: Colors.grey),
                                            SizedBox(height: 2),
                                            Text(
                                              task['time'],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}