import 'package:flutter/foundation.dart';
import 'package:shoryan/models/blood_request.dart';
import 'package:shoryan/models/smart_matching_response.dart';


class SmartCache extends ChangeNotifier {
  SmartCache._internal();
  static final SmartCache instance = SmartCache._internal();

  BloodRequest? request;
  SmartMatchingResponse? smartMatching;
  DateTime? updatedAt;

  bool get hasData => request != null || smartMatching != null;

  void update({
    BloodRequest? request,
    SmartMatchingResponse? smartMatching,
  }) {
    this.request = request;
    this.smartMatching = smartMatching;
    updatedAt = DateTime.now();
    notifyListeners();
  }

  void clear() {
    request = null;
    smartMatching = null;
    updatedAt = null;
    notifyListeners();
  }
}