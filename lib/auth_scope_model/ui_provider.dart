import 'package:cme/subscription/subfunctions.dart';
import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {

  static final UIProvider _uIProvider = UIProvider._internal();
  factory UIProvider() {
    return _uIProvider;
  }

  UIProvider._internal();


  bool _isSubScribed = false;
  int _currentScreenIndex = 0;
  int _currentSubindex = 0;

  int getCurrentScreenIndex() {
    // var tmpIndex  = _currentScreenIndex;
    // _currentScreenIndex = 0;
    return _currentScreenIndex;
  }
  int getCurrentScreenSubIndex() => _currentSubindex;

  setCurrentScrenIndex(int index, { int subIndex = 0 }) {
    print("JEREMY IS IT index??$index");

    _currentScreenIndex = index;
    _currentSubindex = subIndex;
    notifyListeners();
  }

  bool isSubScribed() => _isSubScribed;
  setRefreshNotifications(){
    notifyListeners();
  }
  setIsSubScribed() async {
    var currentSubManager = await getOldPurchases();
    _isSubScribed = currentSubManager.isCoachAdvActive ||  currentSubManager.isPlayerBasicActive ||  currentSubManager.isCoachBasicActive;
    notifyListeners();
  }
}
