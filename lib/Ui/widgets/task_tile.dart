import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/task.dart';
import '../size_config.dart';
import '../theme.dart';

class TaskTile extends StatelessWidget {
  TaskTile(this.task, {Key? key}) : super(key: key);

  Task task = Task();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        getProportionateScreenWidth(
            SizeConfig.orientation == Orientation.landscape ? 4 : 10),
      ),
      //margin: EdgeInsets.only(bottom: getProportionateScreenHeight(0.05)),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _getBGClr(task.color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 18,
                          color: Colors.grey[200],
                        ),
                        const SizedBox(width: 5),
                        Text("${task.startTime} - ${task.endTime}",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 14, color: Colors.grey[100]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      task.note!,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            // start vertical divider
            Container(
              height: 70,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
            // start RotatedBox
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0 ? 'Todo' : 'Completed',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
