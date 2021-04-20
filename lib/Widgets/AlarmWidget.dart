import 'package:flutter/material.dart';

class AlarmWidget extends StatelessWidget {
  final String time;
  final bool value;
  final Function onChanged;
  AlarmWidget({@required this.time, @required this.value, @required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(time, style: TextStyle(fontFamily: 'avenir', fontSize: 16, fontWeight: FontWeight.w500)),
        Switch(
          onChanged: onChanged,
          value: value,
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}
