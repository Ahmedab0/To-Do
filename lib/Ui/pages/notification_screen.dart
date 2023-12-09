import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);

  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';

  @override
  void initState() {
    _payload = widget.payload;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: customAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            //Header
            Column(
              children: [
                Text(
                  'Hello, AHMED',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Get.isDarkMode ? Colors.white : darkGreyClr,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You Have a New Reminder',
                  style: TextStyle(
                    fontSize: 18,
                    color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                  ),
                ),
              ],
            ),
            //const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: primaryClr,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Start Title
                      Row(
                        children: [
                          Icon(Icons.text_format,
                              size: 35, color: Colors.white),
                          const SizedBox(width: 20),
                          Text(
                            'TiTle',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _payload.toString().split('|')[1],
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Start Description
                      Row(
                        children: [
                          Icon(Icons.description,
                              size: 35, color: Colors.white),
                          const SizedBox(width: 20),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 30,
                              //fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _payload.toString().split('|')[2],
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      // Start Date
                      Row(
                        children: [
                          Icon(Icons.date_range, size: 35, color: Colors.white),
                          const SizedBox(width: 20),
                          Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 30,
                              //fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _payload.toString().split('|')[3],
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            //const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  AppBar customAppBar(BuildContext ctx) {
    return AppBar(
      leading: IconButton(
        onPressed: (){
          Get.back();
        },
        //onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios, color: Get.isDarkMode? Colors.white: Colors.grey,),
      ),
      title: Text(
        _payload.toString().split('|')[0],
        style: TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr),
      ),
      elevation: 0,
      backgroundColor: Theme.of(ctx).colorScheme.primary,
      centerTitle: true,
    );
  }
}
