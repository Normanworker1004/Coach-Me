String convertUserName(String? text) {
  if (text == null) return "null";
  var l = text.replaceAll("  ", " ").split(" ");

  var f = "";

  for (var item in l) {
    item.replaceAll(" ", "");
    if (item.isEmpty) {
      continue;
    }
    f += item.substring(0, 1).toUpperCase() + item.substring(1) + " ";
  }
  return f;
}
