import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.widget, required this.onTaped});

  final Widget widget;
  final Function onTaped;

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      leading: widget,
      actions: [
        GestureDetector(
          onTap: onTaped(),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.jpeg'),
            radius: 18,
          ),
        ),
      ],
    );
  }
}
