import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyTaskCard extends StatefulWidget {
  @override
  _MyTaskCardState createState() => _MyTaskCardState();
}

class _MyTaskCardState extends State<MyTaskCard> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  List<Map<String, String>> _tasks = [];

  void _addTask() {
    setState(() {
      _tasks.add({
        'task': _taskController.text.trim(),
        'date': _dateController.text.trim(),
        'time': _timeController.text.trim(),
      });
      _taskController.clear();
      _dateController.clear();
      _timeController.clear();
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 500,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Tasks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: SvgPicture.asset("assets/svg/my-task.svg"),
                          ),
                          const Text("No Tasks")
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_tasks[index]['task']!),
                            subtitle: Text(
                                '${_tasks[index]['date']} at ${_tasks[index]['time']}'),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 10),
              Center(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                            height: 350,
                            width: 700,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "Create Task",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextFormField(
                                  controller: _taskController,
                                  maxLength: 200,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Task",
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _dateController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintText: "Date",
                                          suffixIcon:
                                              const Icon(Icons.date_range),
                                        ),
                                        onTap: () async {
                                          FocusScope.of(context)
                                              .unfocus(); // Remove focus from input fields
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null) {
                                            _dateController.text =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);
                                            // Update button state
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _timeController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintText: "Time",
                                          suffixIcon: const Icon(
                                              Icons.watch_later_outlined),
                                        ),
                                        onTap: () async {
                                          FocusScope.of(context)
                                              .unfocus(); // Remove focus from input fields
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (pickedTime != null) {
                                            _timeController.text =
                                                pickedTime.format(context);
                                            // Update button state
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: _addTask,
                                  child: Container(
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Create",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const CircleAvatar(
                    radius: 25,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
