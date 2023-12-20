import 'package:cme/app.dart';
import 'package:cme/model/bnb_item.dart';
import 'package:flutter/material.dart';

class CoachTopIcon extends StatelessWidget {
  final BNBItem item;

  const CoachTopIcon({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            item.icon,
            height: item.height,
            width: item.width,
            color: (item.basic == true )
                ? Colors.white
                : Color.fromRGBO(81, 114, 175, 1),
          ),
          verticalSpace(height: 9.9),
          Text(
            item.title,
            maxLines: 1,
            style: TextStyle(
                color:   (item.basic == true )
                    ? Colors.white
                    : Color.fromRGBO(81, 114, 175, 1)  ,

                fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
