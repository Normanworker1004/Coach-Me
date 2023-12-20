import 'package:cme/app.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/icon_title.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PlayerBookingsListTile extends StatelessWidget {
  final Function? onEdit;
  final Function? onComment;
  final Function? onDelete;
  final String name;
  final String imgUrl;

  final String dateText;
  final String locationText;
  final String experienceLevel;

  final int count;
  final String status;
  final String? bookingTypeImgUrl;

  const PlayerBookingsListTile({
    Key? key,
    this.onEdit,
    this.bookingTypeImgUrl,
    this.onComment,
    this.experienceLevel= "No set",
    this.onDelete,
    this.name = "Jose Mourinho",
    this.imgUrl="http://178.248.109.145:3000/assets/avatar.png",
    this.count = 0,
    this.status = "",
    this.dateText= "not set.",
    this.locationText= "not set.",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var slidablesActions = [
      SlidableAction(
        onPressed:(c){  if(onEdit != null ) onEdit!(c);   },
        backgroundColor: Color.fromRGBO(150, 150, 150, 1),
        foregroundColor: Colors.white,
        icon:Icons.edit,
    ),

      SlidableAction(
          onPressed:(c){  if(onComment != null ) onComment!(c);   },
          backgroundColor:  Color.fromRGBO(25, 87, 234, 1), //rgba(25, 87, 234, 1)
          foregroundColor: Colors.white,
          icon:Icons.chat_bubble
      ),];
    var deleteAction =   SlidableAction(
        onPressed:(c){  if(onDelete != null ) onDelete!(c);   },
        backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
        foregroundColor: Colors.white,
        // label: 'Delete',
        icon:Icons.cancel
    );
   if(status != "Cancelled") slidablesActions = [...slidablesActions,deleteAction ];
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: Card(
        margin: EdgeInsets.all(0),
        shadowColor: Colors.black.withOpacity(.5),
        child:
        Slidable(
          endActionPane: ActionPane(
             motion: const ScrollMotion(),
             // All actions are defined in the children parameter.
            children:   [ ... slidablesActions  ],
          ),
          child: SessionDetailListTile(
            name: name,
            imgUrl: imgUrl,
            count: count,
            status: status,
            dateText: dateText,
            locationText: locationText,
            experienceLevel: experienceLevel,
            bookingTypeImgUrl: bookingTypeImgUrl,
          ),
        ),
       ),
    );
  }
}

class SessionDetailListTile extends StatelessWidget {
  final String imgUrl;
  final String? bookingTypeImgUrl;
  final String name;
  final int count;
  final String status;
  final String dateText;
  final String locationText;
  final String experienceLevel;
  const SessionDetailListTile({
    Key? key,
    required this.imgUrl,
    required this.name,
    required this.experienceLevel,
    this.count = 0,
    required this.bookingTypeImgUrl,
    required this.status,
    required this.dateText,
    required this.locationText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Stack(
            children: [
              CircularNetworkImage(
                imageUrl: imgUrl,
                size: 48,
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Visibility(
                  visible: count != 0,
                  child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromRGBO(182, 9, 27, 1),
                      ),
                      child: Center(
                        child: Text(
                          "$count",
                          style: TextStyle(
                            color: white,
                            fontSize: 10,
                            fontFamily: App.font_name2,
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
          horizontalSpace(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: App.font_name,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "$experienceLevel",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: App.font_name,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    horizontalSpace(),
                    Visibility(
                      visible: status.isNotEmpty,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            border: Border.all(color: red),
                            borderRadius: BorderRadius.circular(8)),
                        child: mediumText(status, size: 10, color: red),
                      ),
                    ),
                    Visibility(
                      visible: bookingTypeImgUrl != null,
                      child: Image.asset(
                        "$bookingTypeImgUrl",
                        color: red,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
                verticalSpace(height: 4),
                Row(
                  // direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: iconTitleExpanded(
                          "assets/booking_clock.png", "$dateText", Colors.red),
                    ),
                    horizontalSpace(width: 4),
                    Expanded(
                      child: iconTitleExpanded(
                          "assets/map_pin.png", "$locationText", mapPinBlue),
                    ),
                  ],
                )
              ],
            ),
          ),
          Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}
