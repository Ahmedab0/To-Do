import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/models/task.dart';

import '../../controllers/task_controller.dart';
import '../theme.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('h:m a').format(DateTime.now());
  String _endTime =
      DateFormat('h:m a').format(DateTime.now().add(Duration(minutes: 15)));
  int _selectedRemind = 5;
  final List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  final List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: customAppBar(),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // start header Add Task
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text('Add Task', style: headingStyle),
                  ),
                ),
                // Title InputField
                InputField(
                  label: 'Title',
                  hint: 'Enter Title Here',
                  controller: _titleController,
                ),
                SizedBox(height: 12),
                // Note InputField
                InputField(
                  label: 'Note',
                  hint: 'Enter Note Here',
                  controller: _noteController,
                ),
                SizedBox(height: 12),
                // Date InputField
                InputField(
                  label: 'Date',
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    onPressed: () {
                      getDateFromUser();
                    },
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // Time Row InputField
                Row(
                  children: [
                    // Start Time
                    Expanded(
                      child: InputField(
                        label: 'Start Time',
                        hint: _startTime,
                        widget: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              getTimeFromUser(isStartTime: true);
                            },
                            icon: Icon(
                              Icons.access_time_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 18),
                    // End Time
                    Expanded(
                      child: InputField(
                        label: 'End Time',
                        hint: _endTime,
                        widget: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              getTimeFromUser(isStartTime: false);
                            },
                            icon: Icon(
                              Icons.access_time_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Reminder InputField
                InputField(
                  label: 'Reminder',
                  hint: '$_selectedRemind Minutes Early',
                  widget: Row(
                    children: [
                      DropdownButton(
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 32,
                        iconEnabledColor: Colors.grey,
                        dropdownColor: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(8),
                        underline: Container(height: 0),
                        padding: EdgeInsets.all(0),
                        style: subTitleStyle,
                        items: remindList
                            .map<DropdownMenuItem<String>>((element) =>
                                DropdownMenuItem<String>(
                                  value: element.toString(),
                                  child: Text(
                                    '$element',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedRemind = int.parse(value!);
                          });
                        },
                      ),
                      SizedBox(width: 6),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                // Repeat InputField
                InputField(
                  label: 'Repeat',
                  hint: _selectedRepeat,
                  widget: Row(
                    children: [
                      DropdownButton(
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 32,
                        iconEnabledColor: Colors.grey,
                        dropdownColor: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(8),
                        underline: Container(height: 0),
                        style: subTitleStyle,
                        items: repeatList
                            .map<DropdownMenuItem<String>>(
                              (element) => DropdownMenuItem<String>(
                                value: element,
                                child: Text(element,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedRepeat = value!;
                          });
                        },
                      ),
                      SizedBox(width: 6),
                    ],
                  ),
                ),
                // Start Section Button & Color
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Start Section Colors
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color',
                          style: titleStyle,
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: List.generate(
                              3,
                              (index) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedColor = index;
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: CircleAvatar(
                                        radius: 14,
                                        child: _selectedColor == index
                                            ? Icon(
                                                Icons.done,
                                                size: 16,
                                                color: Colors.white,
                                              )
                                            : null,
                                        backgroundColor: (index == 0)
                                            ? bluishClr
                                            : (index == 1)
                                                ? pinkClr
                                                : orangeClr,
                                      ),
                                    ),
                                  )),
                        ),
                      ],
                    ),
                    // Start ElevatedButton
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                        backgroundColor: MaterialStateProperty.all(primaryClr),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        elevation: MaterialStateProperty.all(0),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
                        fixedSize: MaterialStateProperty.all(Size(100, 45)),
                      ),
                      onPressed: () {
                        validation();
                      },
                      child: Text('Create Task'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom AppBar
  AppBar customAppBar() => AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: context.theme.colorScheme.background,
        leading: IconButton(
          onPressed: () {
            print('arrow_back_ios');
            //Navigator.of(context).pop();
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(50),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/person.jpeg'),
                radius: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      );

  // Start Method Validation
  validation() {
    if (_titleController.text.trim().isNotEmpty && _noteController.text.trim().isNotEmpty) {
      sendTaskToDb();
      Get.back();
    } else if (_titleController.text.trim().isEmpty || _noteController.text.trim().isEmpty) {
      Get.snackbar(
        'Warning!!',
        'All Fields Is Required!',
        colorText: primaryClr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[200]!.withOpacity(0.5),
      );
    } else {
      print('########## Something happen #########');
    }
  }

  // Start sendTaskToDb Method
  sendTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
          title: _titleController.text,
          note: _noteController.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat),
    );
    print('$value');
  }

  void getDateFromUser() async {
    await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
      currentDate: _selectedDate,
    ).then((value){
      if(value != null) {
        setState(() {
          _selectedDate = value;
        });
      }else {
        return print('no date chose!');
      }
    });
  }

  void getTimeFromUser({required bool isStartTime}) async {
    await showTimePicker(
      context: context,//TimeOfDay.now()
      initialTime: isStartTime? TimeOfDay.fromDateTime(DateTime.now()) : TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 15))),
    ).then((value){
      if(value != null) {
        /// to convert TimeOfDay to String
        String _formatTime = value.format(context);
        if(isStartTime) {
          setState(() {
            _startTime = _formatTime;
          });
        }
        if(!isStartTime) {
          setState(() {
            _endTime = _formatTime;
          });
        }
      } else {
        return print('No Time Chose!');
      }
    });
  }
}
