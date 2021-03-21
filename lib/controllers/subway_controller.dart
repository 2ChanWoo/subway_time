import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:subway_time/models/subway.dart';

class SubwayController {
  Subway upSub;

  Future<void> fetchSubwayTime(int stationID) async {
    String _upUrl =
        'https://api.odsay.com/v1/api/subwayTimeTable?lang=0&stationID=$stationID&wayCode=0&showExpressTime=1&sepExpressTime=0&apiKey=%2F1Bb%2FVXoRjjsQjLE0V8I8J2uBFLRSk4xgn%2BOmsoB5dA';
    var upResponse = await http.get(_upUrl);

    if (upResponse.statusCode == 200) {
      print('body >>>>> ${upResponse.body}');
      upSub = upwardSubwayFromJson(upResponse.body);
    } else {
      throw Exception('>>>>>>>>>>>> Failed to load Json <<<<<<<<<<<<<');
    }

  }
}
