import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../services/theme_services.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/task_tile.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotifyHelper notifyHelper = NotifyHelper();

  /// on the page we need to notify
  @override
  void initState() {
    super.initState();
    // Initialise  local notification
    //notifyHelper.initializeNotification();
    //notifyHelper.requestIOSPermissions(); // requestIosPermissions when app start for only one time
    _taskController.getTask();
    //_taskController.taskList;
  }

  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = TaskController();

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    Get.put(TaskController());
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(), // Custom AppBar
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(5),
          child: Column(
            children: [
              // start AddTaskBar Section
              _addTaskBar(),
              // start DatePicker Bar Section
              _addDateBar(),
              SizedBox(height: 6),
              // Start showTaskBar section
              _showTaskBar(),
            ],
          ),
        ),
      ),
    );
  }

  // Method to Build Custom AppBar
  AppBar _appBar() => AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.theme.colorScheme.background,
        leading: IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
            //notifyHelper.displayNotification(title: 'Theme Changes', body: 'body of Notification');
          }, // #3.
          //icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          icon: Icon(Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/person.jpeg'),
              radius: 20,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              _taskController.deleteAllTask();
              //notifyHelper.displayNotification(title: 'Theme Changes', body: 'body of Notification');
              //notifyHelper.cancelAllNotification();
            }, // #3.
            //icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            icon: Icon(Icons.cleaning_services_outlined,color: Get.isDarkMode? Colors.white : Colors.grey,size: 26,),
          ),
          SizedBox(width: 14),

        ],
      );

  // Method to build HeadSection addTask
  Widget _addTaskBar() {
    return Container(
      padding: EdgeInsets.only(left: 8, top: 8, right: 5, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.start,
            children: [
              Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle),
              Text('Today', style: headingStyle),
            ],
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
              backgroundColor: MaterialStateProperty.all(primaryClr),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              elevation: MaterialStateProperty.all(0),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
              fixedSize: MaterialStateProperty.all(Size(100, 45)),
            ),
            onPressed: () async {
              /// async await
              await Get.to(() => AddTaskPage());
            },
            child: Text('+ Add Task'),
          ),
        ],
      ),
    );
  }

  // Method to Build DatePicker Section
  Widget _addDateBar() {
    return Container(
      margin: EdgeInsets.only(left: 8, top: 5, right: 5, bottom: 8),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: _selectedDate,
        monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600)),
        dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w600)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600)),
        //deactivatedColor: Colors.red,
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        onDateChange: (date) {
          // New date selected
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }


  // OnRefresh Method
  Future<void> _refresh() async {
    _taskController.getTask();
  }

  // Method to build Task Section
  _showTaskBar() {
    return Expanded(
      child:  Obx((){
        if(_taskController.taskList.isEmpty) {
          return RefreshIndicator(onRefresh: _refresh,
          child: _noTaskMsg());
        } else {
          return RefreshIndicator(
            onRefresh: _refresh,
            backgroundColor: primaryClr,//Get.isDarkMode? Colors.grey : Colors.white,
            color: Colors.white,//Get.isDarkMode? Colors.white : primaryClr,

            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (BuildContext context, index) {
                var task = _taskController.taskList[index];

                if( task.repeat == 'Daily'
                    || task.date == DateFormat.yMd().format(_selectedDate)
                    || (task.repeat == 'Weekly' && _selectedDate.difference(DateFormat.yMd().parse(task.date!)).inDays %7 == 0)
                    || (task.repeat == 'Monthly' &&  DateFormat.yMd().parse(task.date!).day == _selectedDate.day)
                ) {

                  //var hour = task.startTime.toString().split(':')[0];
                  //var minutes = task.startTime.toString().split(':')[1];

                  //var date = DateFormat.jm().parse(task.startTime!);
                  //var myTime = DateFormat('HH:mm').format(date);

                  //debugPrint('Hours: $hour');
                  //debugPrint('minutes: $minutes');
                  //notifyHelper.scheduledNotification(int.parse(hour.toString().split(':')[0]), int.parse(minutes.toString().split(':')[1]), task);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      //verticalOffset: 300.0,
                      horizontalOffset: 500.0,
                      child: FadeInAnimation(
                        duration: Duration(milliseconds: 500),
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(
                              context,
                              task,
                            );
                          },
                          child: TaskTile(task),
                        ),
                      ),
                    ),
                  );

                } else {
                  return Container();
                }
              },
              itemCount: _taskController.taskList.length,
            ),
          );
        }
      }




      ),
    );
  }

  // showing in case there is no tasks
   Stack _noTaskMsg() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: SizeConfig.orientation == Orientation.landscape
                          ? Axis.horizontal
                          : Axis.vertical,
                      children: [
                        SizeConfig.orientation == Orientation.landscape
                            ? const SizedBox(height: 6)
                            : const SizedBox(height: 220),
                        SvgPicture.asset(
                          'assets/images/task.svg',
                          semanticsLabel: 'task logo',
                          height: 80,
                          color: primaryClr.withOpacity(0.6),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Do You Not Have Any Task Yet!\n Add Anew Task to Make Your Days Productive.',
                            style: subTitleStyle,
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        SizeConfig.orientation == Orientation.landscape
                            ? const SizedBox(height: 6)
                            : const SizedBox(height: 120),
                      ],
                    ),
        ),
      ],
    );
  }

  // // method to show bottom sheet
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 5),
          width: SizeConfig.screenWidth,
          height: SizeConfig.orientation == Orientation.landscape
              ? (task.isCompleted == 1)
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.80
              : (task.isCompleted == 1)
                  ? SizeConfig.screenHeight * 0.3
                  : SizeConfig.screenHeight * 0.39,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  width: 120,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              task.isCompleted == 1
                  ? Container()
                  : _buildButtonBottomSheet(
                      label: 'Task Completed',
                      onTab: () {
                        _taskController.markTaskCompleted(task.id!);
                        //notifyHelper.cancelNotification(task);
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              //
              _buildButtonBottomSheet(
                label: 'Delete Task',
                onTab: () {
                  _taskController.deleteTask(task);
                  //notifyHelper.cancelNotification(task);
                  Get.back();
                },
                clr: Colors.red[300]!,
              ),
              Divider(color: Get.isDarkMode ? Colors.grey[400] : Colors.grey),
              _buildButtonBottomSheet(
                label: 'Cancel',
                onTab: () {
                  Get.back();
                },
                clr: primaryClr.withOpacity(0.6),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // method to build Button in BottomSheet
  _buildButtonBottomSheet({
    required String label,
    required Function() onTab,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        width: SizeConfig.screenWidth * 0.9,
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: isClose
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : clr),
            borderRadius: BorderRadius.circular(12),
            color: isClose ? Colors.transparent : clr),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }


}
