// To parse this JSON data, do
//
//     final apiSubways = apiSubwaysFromJson(jsonString);

import 'dart:convert';

DownwardSubway downwardSubwayFromJson(String str) => DownwardSubway.fromJson(json.decode(str));

String downSubwayToJson(DownwardSubway data) => json.encode(data.toJson());

class DownwardSubway {
  DownwardSubway({
    this.result,
  });

  Result result;

  factory DownwardSubway.fromJson(Map<String, dynamic> json) => DownwardSubway(
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
  };
}

class Result {
  Result({
    this.type,
    this.laneName,
    this.laneCity,
    this.ordList,
    this.satList,
    this.sunList,
    this.upWay,
    this.downWay,
    this.stationId,
    this.stationName,
  });

  int type;
  String laneName;
  String laneCity;
  OrdListClass ordList;
  OrdListClass satList;
  OrdListClass sunList;
  String upWay;
  String downWay;
  int stationId;
  String stationName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    type: json["type"],
    laneName: json["laneName"],
    laneCity: json["laneCity"],
    ordList: OrdListClass.fromJson(json["OrdList"]),
    satList: OrdListClass.fromJson(json["SatList"]),
    sunList: OrdListClass.fromJson(json["SunList"]),
    upWay: json["upWay"],
    downWay: json["downWay"],
    stationId: json["stationID"],
    stationName: json["stationName"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "laneName": laneName,
    "laneCity": laneCity,
    "OrdList": ordList.toJson(),
    "SatList": satList.toJson(),
    "SunList": sunList.toJson(),
    "upWay": upWay,
    "downWay": downWay,
    "stationID": stationId,
    "stationName": stationName,
  };
}

class OrdListClass {
  OrdListClass({
    this.down,
  });

  Down down;

  factory OrdListClass.fromJson(Map<String, dynamic> json) => OrdListClass(
    down: Down.fromJson(json["down"]),
  );

  Map<String, dynamic> toJson() => {
    "down": down.toJson(),
  };
}

class Down {
  Down({
    this.time,
  });

  List<Time> time;

  factory Down.fromJson(Map<String, dynamic> json) => Down(
    time: List<Time>.from(json["time"].map((x) => Time.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "time": List<dynamic>.from(time.map((x) => x.toJson())),
  };
}

class Time {
  Time({
    this.idx,
    this.list,
    this.expList,
  });

  int idx;
  String list;
  String expList;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    idx: json["Idx"],
    list: json["list"],
    expList: json["expList"] == null ? null : json["expList"],
  );

  Map<String, dynamic> toJson() => {
    "Idx": idx,
    "list": list,
    "expList": expList == null ? null : expList,
  };
}
