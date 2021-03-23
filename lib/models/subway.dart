// To parse this JSON data, do
//
//     final apiSubways = apiSubwaysFromJson(jsonString);

import 'dart:convert';

Subway upwardSubwayFromJson(String str) {
  var decodedJson = json.decode(str);

  return Subway.fromJson(json.decode(str));
}

String upwardSubwayToJson(Subway data) => json.encode(data.toJson());

class Subway {
  Subway({
    this.result,
  });

  Result result;

  factory Subway.fromJson(Map<String, dynamic> json) {
    if (json == null || json['error'] != null) {
      //print('-----ERROR----- Subway.fromJson ::::: $json');

      return Subway(
        result: Result.fromJson(null),
      );
    }
    return Subway(
      result: Result.fromJson(json["result"]),
    );
  }

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

  int type; //노선종류   1:KTX , 2:새마을 3무궁화 4누리로 5통근 6ITX새마을 7ITX청춘 8SRT
  String laneName; //노선명
  String laneCity; //노선지역명
  OrdListClass ordList; //평일시간표
  OrdListClass satList; //토요일시간표
  OrdListClass sunList; //공휴일시간표
  String upWay; //상행방향 노선 마지막역
  String downWay; //하행방향 노선 마지막역
  int stationId; //역코드
  String stationName; //역이름

  factory Result.fromJson(Map<String, dynamic> json) {
    if (json == null || json['error'] != null) {
      //print('-----ERROR-----  Result.fromJson ::::: $json'); //udemy_provider 프로젝트에서 사용함.

      return Result(
        type: 99,
        laneName: '',
        laneCity: '',
        ordList: OrdListClass.fromJson(null),
        satList: OrdListClass.fromJson(null),
        sunList: OrdListClass.fromJson(null),
        upWay: '',
        downWay: '',
        stationId: 99999,
        stationName: '',
      );
    }

    return Result(
      type: json["type"] ?? 99,
      laneName: json["laneName"] ?? '',
      laneCity: json["laneCity"] ?? '',
      ordList: OrdListClass.fromJson(json["OrdList"]),
      satList: OrdListClass.fromJson(json["SatList"]),
      sunList: OrdListClass.fromJson(json["SunList"]),
      upWay: json["upWay"] ?? '',
      downWay: json["downWay"] ?? '',
      stationId: json["stationID"] ?? 99999,
      stationName: json["stationName"] ?? '',
    );
  }

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
    this.up,
    this.down,
  });

  Up up;
  Up down;

  factory OrdListClass.fromJson(Map<String, dynamic> json) {
    if (json == null || json['error'] != null) {
      //print('-----ERROR-----  OrdListClass.fromJson ::::: $json'); //udemy_provider 프로젝트에서 사용함.
      return OrdListClass(
        up: Up.fromJson(null),
        down: Up.fromJson(null),
      );
    }

    return OrdListClass(
      up: Up.fromJson(json["up"]),
      down: Up.fromJson(json["down"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "up": up.toJson(),
        "down": down.toJson(),
      };
}

class Up {
  Up({
    this.time,
  });

  List<Time> time;

  //추가!! 파베에서는 클래스형식이 없으니, Map형태로 반환하기 위해서~!
  List<Map> toMapList() {
    List<Map> mapTime = [];
    time.forEach((e) {
//      print('idx ${e.idx}');
      mapTime.add({
        'idx': e.idx,
        'list': e.list,
        'expList': e.expList,
      });
    });

//    print('maptime >>>>>>>>>>>>>>  $mapTime');
    return mapTime;
  }

  factory Up.fromJson(Map<String, dynamic> json) {
    if (json == null || json['error'] != null) {
      //print('-----ERROR-----  Up.fromJson ::::: $json');

      return Up(
        time: [Time.fromJson(null)], //어차피 널이니까. null['time']하면 에러날거같아서..
      );
    }

    return Up(
      time: List<Time>.from(json["time"].map((x) => Time.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "time": List<dynamic>.from(time.map((x) => x.toJson())),
      };
}

class Time {
  Time({
    this.idx, //시 0~25  25는 새벽 1시
    this.list, //시간표.
    this.expList, //급행시간표
  });

  int idx;
  String list;
  String expList;

  factory Time.fromJson(Map<String, dynamic> json) {
    if (json == null || json['error'] != null) {
      //print('-----ERROR-----  Time.fromJson ::::: $json');

      return Time(
        idx: 99,
        list: '',
        expList: '',
      );
    }

    return Time(
      idx: json["Idx"] ?? 99,
      list: json["list"] ?? '',
      expList: json["expList"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "Idx": idx ?? 99,
        "list": list ?? '',
        "expList": expList ?? '',
      };
}
