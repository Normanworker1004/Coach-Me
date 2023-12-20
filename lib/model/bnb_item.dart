class BNBItem {
  var title;
  String explain;
  var icon;
  var page;
  var height;
  var width;
  var type;
  bool? free = false;
  bool? basic = true;

  Map<dynamic, dynamic> Function()? func = () => {} ;

  BNBItem(
    this.title,
     this.icon, {
    this.page,
    this.height,
    this.width,
    this.free,
    this.basic,

    this.func,
    this.explain = ""
     });
}

class BookingType {
  static const physical = 1;
  static const virtual = 0;
}
