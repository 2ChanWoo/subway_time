import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:subway_time/controllers/subway_controller.dart';
import 'package:subway_time/models/subways.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatelessWidget {
  SubwayController cont = SubwayController();

  Future<void> getPosition() async {
    if (await Permission.location.request().isGranted) {
      var currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print(currentPosition);

      Subways.subways.forEach((e) {
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
                await cont.fetchSubwayTime(131);
                
                Firestore.instance.collection('subways')
                    .document(cont.upSub.result.stationName).setData({
                  'stationName': cont.upSub.result.stationName,
                  'stationId': cont.upSub.result.stationId,
                  'type' : cont.upSub.result.type,
                  'laneName': cont.upSub.result.laneName,
                  'laneCity': cont.upSub.result.laneCity,
                  'upWay': cont.upSub.result.upWay,
                  'upwardOrdList': cont.upSub.result.ordList.up.toMapList(),
//                  'upwardSatList': cont.upSub.result.satList,
//                  'upwardSunList': cont.upSub.result.sunList,
                  'downWay': cont.downSub.result.downWay,
//                  'downwardOrdList': cont.downSub.result.ordList,
//                  'downwardSatList': cont.downSub.result.satList,
//                  'downwardSunList': cont.downSub.result.sunList,
                });
                /////////////// 최종은 저장해둔subway.json으로 좌표까지 남겨놔야한다~
              }),
        ],
      ),
    );
  }
}
