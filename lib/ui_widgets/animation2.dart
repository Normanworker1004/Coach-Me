import 'package:cme/app.dart';
import 'package:cme/model/user_class/user_details.dart';
import 'package:cme/network/endpoint.dart';
import 'package:cme/ui_widgets/animation_background.dart';
import 'package:cme/ui_widgets/circular_image.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class Animation2 extends StatefulWidget {
  final Userdetails? player1details;
  final Userdetails? player2details;
  // final int myId;

  const Animation2({
    Key? key,
    required this.player1details,
    required this.player2details,
    // @required this.myId,
  }) : super(key: key);

  @override
  _Animation2State createState() => _Animation2State();
}

class _Animation2State extends State<Animation2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BattleAnimationScreen(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 1,
              ),
              Row(
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircularNetworkImage(
                        imageUrl:
                            "${photoUrl + widget.player1details!.profilePic!}",
                        size: 100,
                      ),
                      verticalSpace(),
                      boldText("You", color: white),
                    ],
                  ),
                  Spacer(
                    flex: 3,
                  ),
                ],
              ),
              Spacer(
                flex: 2,
              ),
              Center(child: boldText("VS", color: white, size: 72)),
              Spacer(
                flex: 2,
              ),
              Row(
                children: [
                  Spacer(
                    flex: 3,
                  ),
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircularNetworkImage(
                        size: 100,
                        imageUrl:
                            "${photoUrl + widget.player2details!.profilePic!}",
                      ),
                      verticalSpace(),
                      boldText(
                        "${widget.player2details!.name}",
                        color: white,
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
              Spacer(
                flex: 1,
              ),
            ],
          )
        ],
      ),
    );
  }
}
