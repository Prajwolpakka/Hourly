class AlarmData {
  AlarmData({this.time, this.key});

  int time;
  String key;
  bool status;

  factory AlarmData.fromJson(Map<String, dynamic> json) => AlarmData(
        time: json["time"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {"key": key, "time": time};
}
