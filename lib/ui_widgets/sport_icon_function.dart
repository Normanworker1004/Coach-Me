import 'package:cme/model/bnb_item.dart';

String getSportIcon(String? sport) {

  // print("search .....$sport");
  for (var item in sportsList) {
    if ("$sport".toLowerCase() == "${item.page}".toLowerCase()) {
      return "${item.height}";
    }
  }
  return "assets/football_1.png";
}
BNBItem getItemFromSport(String? sport) {

  // print("search .....$sport");
  for (var item in sportsList) {
    if ("$sport".toLowerCase() == "${item.page}".toLowerCase()) {
      return item;
    }
  }
  return sportsList.first;
}

List<BNBItem> sportsList = [
  BNBItem(
    -1,
    "assets/football.png",
    page: "Football",
    height: "assets/football_1.png",
    width: "assets/football_2.png",
  ),
  BNBItem(
    -1,
    "assets/tennis.png",
    page: "Tennis",
    height: "assets/tennis_1.png",
    width: "assets/tennis_2.png",
  ),
  BNBItem(
    -1,
    "assets/rugby.png",
    page: "Rugby",
    height: "assets/rugby_1.png",
    width: "assets/rugby_2.png",
  ),
  BNBItem(
    -1,
    "assets/pt.jpg",
    page: "Personal Training",
    height: "assets/personal_1.png",
    width: "assets/personal_2.png",
  ),
];
