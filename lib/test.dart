void main() {
  String timeStamp = '2023-02-08T08:13:35.000+00:00';
  String test = "2023-04-24T00:00:00.000+00:00";
  int a = 1675844015487;
  DateTime dateTime =DateTime.parse(
      "2023-04-24T00:00:00.000+00:00");
  print('${dateTime.year}-${dateTime.month}-${dateTime.day}');
  DateTime.fromMicrosecondsSinceEpoch(1675844015487);
  print(DateTime.fromMicrosecondsSinceEpoch(1675844015487));
  print(DateTime.fromMillisecondsSinceEpoch(1675844015487));
}
