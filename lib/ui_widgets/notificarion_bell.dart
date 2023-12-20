import 'package:flutter/material.dart';

class NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/notification_bell.png",
                  width: 22, height: 29),
            ),
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: Visibility(
              visible: false,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Center(
                  child: Text(
                    "1",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
