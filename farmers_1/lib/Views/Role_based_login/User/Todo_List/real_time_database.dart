import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RealTimeDatabase(),
    );
  }
}

class RealTimeDatabase extends StatefulWidget {
  const RealTimeDatabase({super.key});

  @override
  State<RealTimeDatabase> createState() => _RealTimeDatabaseState();
}

class _RealTimeDatabaseState extends State<RealTimeDatabase> {
  late DatabaseReference databaseReference;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in!");
    } else {
      databaseReference = FirebaseDatabase.instance
          .ref("Realtime Database")
          .child(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Please log in to use the Task Manager",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text(
          "Task Manager",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 2,
        //backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: databaseReference.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          Map<dynamic, dynamic>? tasksMap =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

          if (tasksMap == null || tasksMap.isEmpty) {
            return Center(
              child: Text(
                "No tasks found for this Farmer",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            );
          }

          List<Map<dynamic, dynamic>> tasksList = tasksMap.values
              .map((e) => Map<dynamic, dynamic>.from(e))
              .toList();

          tasksList.sort(
            (a, b) => (a['priority'] ?? 1).compareTo(b['priority'] ?? 1),
          );

          return ListView.builder(
            itemCount: tasksList.length,
            itemBuilder: (context, index) {
              final task = tasksList[index];
              bool done = task['done'] ?? false;
              String createdAt = task['createdAt'] ?? "";
              String startDate = task['startDate'] ?? "";
              String endDate = task['endDate'] ?? "";
              String timeFrame = task['timeFrame'] ?? "";
              int priority = task['priority'] ?? 1;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.all(10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  leading: CircleAvatar(child: Text((index + 1).toString())),
                  title: Text(
                    task['name'] ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      decoration: done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task['address'] ?? ""),
                      SizedBox(height: 5),
                      Text("Start: $startDate"),
                      Text("End: $endDate"),
                      Text("Time: $timeFrame"),
                      Text("Priority: $priority"),
                      SizedBox(height: 5),
                      Text(
                        "Created: ${createdAt.split('T').first}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: done,
                        onChanged: (bool? value) {
                          databaseReference.child(task['id']).update({
                            'done': value,
                          });
                        },
                      ),
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                nameController.text = task['name'] ?? "";
                                addressController.text = task['address'] ?? "";

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return myDialogBox(
                                      context: context,
                                      name: "Update Task",
                                      address: "Update",
                                      task: task,
                                      onPressed:
                                          (
                                            String name,
                                            String address,
                                            DateTime startDate,
                                            DateTime endDate,
                                            TimeOfDay? startTime,
                                            TimeOfDay? endTime,
                                            int priority,
                                          ) {
                                            String timeFrameStr =
                                                (startTime != null &&
                                                    endTime != null)
                                                ? "${startTime.format(context)} - ${endTime.format(context)}"
                                                : "";

                                            databaseReference
                                                .child(task['id'])
                                                .update({
                                                  'name': name,
                                                  'address': address,
                                                  'startDate': DateFormat(
                                                    "dd-MMM-yyyy",
                                                  ).format(startDate),
                                                  'endDate': DateFormat(
                                                    "dd-MMM-yyyy",
                                                  ).format(endDate),
                                                  'timeFrame': timeFrameStr,
                                                  'priority': priority,
                                                });

                                            Navigator.pop(context);
                                          },
                                    );
                                  },
                                );
                              },
                              leading: Icon(Icons.edit),
                              title: Text("Edit"),
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                databaseReference.child(task['id']).remove();
                              },
                              leading: Icon(Icons.delete),
                              title: Text("Delete"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nameController.clear();
          addressController.clear();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return myDialogBox(
                context: context,
                name: "Create Task",
                address: "Add Task",
                onPressed:
                    (
                      String name,
                      String address,
                      DateTime startDate,
                      DateTime endDate,
                      TimeOfDay? startTime,
                      TimeOfDay? endTime,
                      int priority,
                    ) {
                      String timeFrameStr =
                          (startTime != null && endTime != null)
                          ? "${startTime.format(context)} - ${endTime.format(context)}"
                          : "";

                      final id = DateTime.now().millisecondsSinceEpoch
                          .toString();

                      databaseReference.child(id).set({
                        'name': name,
                        'address': address,
                        'startDate': DateFormat(
                          "dd-MMM-yyyy",
                        ).format(startDate),
                        'endDate': DateFormat("dd-MMM-yyyy").format(endDate),
                        'timeFrame': timeFrameStr,
                        'priority': priority,
                        'id': id,
                        'createdAt': DateTime.now().toIso8601String(),
                        'done': false,
                      });

                      Navigator.pop(context);
                    },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Dialog myDialogBox({
    required BuildContext context,
    required String name,
    required String address,
    required Function(
      String name,
      String address,
      DateTime startDate,
      DateTime endDate,
      TimeOfDay? startTime,
      TimeOfDay? endTime,
      int priority,
    )
    onPressed,
    Map<dynamic, dynamic>? task,
  }) {
    // Helper function for time parsing
    TimeOfDay _parseTimeOfDay(String timeStr) {
      try {
        final format = DateFormat.jm();
        DateTime dateTime = format.parse(timeStr);
        return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      } catch (e) {
        return TimeOfDay.now();
      }
    }

    DateTime? startDate;
    DateTime? endDate;

    if (task != null) {
      try {
        startDate = (task['startDate'] != null && task['startDate'] != "")
            ? DateFormat("dd-MMM-yyyy").parse(task['startDate'])
            : null;
      } catch (e) {
        startDate = null;
      }
      try {
        endDate = (task['endDate'] != null && task['endDate'] != "")
            ? DateFormat("dd-MMM-yyyy").parse(task['endDate'])
            : null;
      } catch (e) {
        endDate = null;
      }
    }

    TimeOfDay? dialogStartTime;
    TimeOfDay? dialogEndTime;
    int dialogPriority = task?['priority'] ?? 1;

    if (task?['timeFrame'] != null && task!['timeFrame'] != "") {
      try {
        final parts = task['timeFrame'].split(" - ");
        if (parts.length == 2) {
          dialogStartTime = _parseTimeOfDay(parts[0]);
          dialogEndTime = _parseTimeOfDay(parts[1]);
        }
      } catch (e) {
        dialogStartTime = null;
        dialogEndTime = null;
      }
    }

    return Dialog(
      backgroundColor: Colors.blue[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Task Name",
                      labelStyle: TextStyle(color: Colors.green),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.green[600]!,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: Colors.green),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.green[600]!,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: startDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            if (picked != null)
                              setState(() => startDate = picked);
                          },
                          child: Text(
                            startDate != null
                                ? DateFormat("dd-MMM-yyyy").format(startDate!)
                                : "Start Date",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            if (picked != null)
                              setState(() => endDate = picked);
                          },
                          child: Text(
                            endDate != null
                                ? DateFormat("dd-MMM-yyyy").format(endDate!)
                                : "End Date",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Priority (1,2,3…)",
                      labelStyle: TextStyle(color: Colors.green),
                      hintText: "e.g. John Doe",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.green[600]!,
                          width: 2,
                        ),
                      ),
                    ),

                    onChanged: (val) => dialogPriority = int.tryParse(val) ?? 1,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: dialogStartTime ?? TimeOfDay.now(),
                            );
                            if (picked != null)
                              setState(() => dialogStartTime = picked);
                          },
                          child: Text(
                            dialogStartTime != null
                                ? dialogStartTime!.format(context)
                                : "Start Time",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: dialogEndTime ?? TimeOfDay.now(),
                            );
                            if (picked != null)
                              setState(() => dialogEndTime = picked);
                          },
                          child: Text(
                            dialogEndTime != null
                                ? dialogEndTime!.format(context)
                                : "End Time",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Task Name cannot be empty")),
                        );
                        return;
                      }

                      if (startDate == null || endDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please select start and end date"),
                          ),
                        );
                        return;
                      }

                      onPressed(
                        nameController.text,
                        addressController.text,
                        startDate!,
                        endDate!,
                        dialogStartTime,
                        dialogEndTime,
                        dialogPriority,
                      );
                    },
                    child: Text(address),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
