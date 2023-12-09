import 'package:flutter/material.dart';

import '../theme.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({Key? key, required this.label, required this.onPress})
      : super(key: key);
  final String label;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        backgroundColor: MaterialStateProperty.all(primaryClr),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(0),
        textStyle: MaterialStateProperty.all(subTitleStyle),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
        fixedSize: MaterialStateProperty.all(Size(100, 45)),
      ),
      onPressed: onPress(),
      child: Text(label),
    );
  }
}
