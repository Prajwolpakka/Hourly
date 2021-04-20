import 'package:hourly/Provider/AlarmProvider.dart';
import 'package:hourly/Widgets/AlarmWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<AlarmProvider>(context, listen: false).alarmList;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff1e1e1e),
        appBar: AppBar(
          backgroundColor: Colors.black54,
          elevation: 0,
          title: Text('Hourly', style: TextStyle(fontFamily: 'avenir')),
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.0))),
        ),
        body: Consumer<AlarmProvider>(
          builder: (context, provider, _) {
            if (provider.fetching)
              return Center(child: CircularProgressIndicator());
            else
              return Container(
                margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: true,
                    itemCount: provider.alarmLength,
                    itemBuilder: (BuildContext context, int index) {
                      return AlarmWidget(
                        time: provider.alarmList[index].key,
                        value: provider.alarmList[index].status,
                        onChanged: (status) => provider.alarmStatus(index, status),
                      );
                    },
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
