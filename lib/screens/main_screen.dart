import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:subway_time/controllers/subway_controller.dart';
import 'package:subway_time/models/geo_subways.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatelessWidget {
  SubwayController cont = SubwayController();

  Future<void> getPosition() async {
    if (await Permission.location.request().isGranted) {
      var currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print(currentPosition);

      GeoSubways.gSubways.forEach((e) {
        double lat = e['latitude'];
        double lon = e['longitude'];
        double distance = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          lat,
          lon,
        );

        if (distance < 5000.0) {
          print(e['subwayStationName']);
        }
      });
    } else
      Permission.location.request();
    /******************************** ******************************************/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RaisedButton(
            color: Colors.blueAccent,
            child: Text('Search!'),
            onPressed: getPosition,
          ),
          RaisedButton(
              color: Colors.purpleAccent,
              child: Text('API Test!!'),
              onPressed: () async {
                const String _url =
                    'https://api.odsay.com/v1/api/subwayTimeTable?lang=0&stationID=130&wayCode=1&showExpressTime=1&sepExpressTime=1&apiKey=%2F1Bb%2FVXoRjjsQjLE0V8I8J2uBFLRSk4xgn%2BOmsoB5dA';
                var response = await http.get(_url);
                print(response.body);
                if (response.statusCode == 200) {
                } else {
                throw Exception(
                '>>>>>>>>>>>> Failed to load Json <<<<<<<<<<<<<');
                }
              }),
          RaisedButton(
              color: Colors.purpleAccent,
              child: Text('API Test!!'),
              onPressed: () async {
                int cnt = 0;
                  for (int i = 203; i < 300; i++) {
                  print('$i and..  $cnt');
                  if (await cont.fetchSubwayTime(i)) {
                    cnt++;
                    String yuk = '';
                    String sName = cont.upSub.result.stationName;
                    if (sName[sName.length - 1] != '역')
                      yuk = '역';
                    else {
                      //API가져온 역이름 데이터에 '역'이 붙어있을 경우.  마지막글자인 '역'제거하기!
                      List<String> str = sName.split("");
                      str.removeLast();
                      sName = str.join();
                    }

                    var getSubway = GeoSubways.gSubways.firstWhere((e) {
                      return e['subwayStationName'] ==
                          cont.upSub.result.stationName +
                              yuk; // bool 타입 리턴받아서 요렇게 ㅎ
                    });
                    //print('받아온 ~~~~ ${getSubway['subwayStationName']??'널?!'}');

                    Firestore.instance
                        .collection('subways')
                        .document(cont.upSub.result.laneName)
                        .collection(sName)
                        .document('${cont.upSub.result.stationId}')
                        .setData({
                      'stationName': sName,
                      'stationId': cont.upSub.result.stationId,
                      'type': cont.upSub.result.type,
                      'laneName': cont.upSub.result.laneName,
                      'laneCity': cont.upSub.result.laneCity,
                      'upWay': cont.upSub.result.upWay,
                      'upwardOrdList': cont.upSub.result.ordList.up.toMapList(),
                      'upwardSatList': cont.upSub.result.satList.up.toMapList(),
                      'upwardSunList': cont.upSub.result.sunList.up.toMapList(),
                      'downWay': cont.upSub.result.downWay,
                      'downwardOrdList':
                          cont.upSub.result.ordList.down.toMapList(),
                      'downwardSatList':
                          cont.upSub.result.satList.down.toMapList(),
                      'downwardSunList':
                          cont.upSub.result.sunList.down.toMapList(),
                      'update': Timestamp.now(),
                      'latitude': getSubway['latitude'] ?? 0.0,
                      'longitude': getSubway['longitude'] ?? 0.0,
                    });
                  }
                  await Future.delayed(const Duration(milliseconds: 500), () {});
                  }
              }),
        ],
      ),
    );
  }
}
