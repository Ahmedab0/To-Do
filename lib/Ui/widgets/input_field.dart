import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';
import '../size_config.dart';

class InputField extends StatelessWidget {
   InputField(
      {Key? key,
      required this.label,
      required this.hint,
      this.controller,
      this.widget,
      })
      : super(key: key);

  final String label;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Start input field section
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title of input field
                Text(label, style: titleStyle),
                SizedBox(height: 5),
                // input field
                Container(
                  padding: EdgeInsets.only(left: 14),
                  height: 52,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          keyboardType: TextInputType.text,
                          style: subTitleStyle,
                          readOnly: widget != null ? true : false,
                          autofocus: false,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: subTitleStyle,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            //enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.grey),borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      widget ?? Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
