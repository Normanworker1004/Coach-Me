import 'package:flutter/material.dart';

Widget buildBaseScaffold({
   scaffoldKey,
  String backgroundImage = "",
  double backgroudOpacity = 0,
  double bottomPadding = 16,
  required context,
  required Widget body,
  color,
  onBackPressed,
  textColor = Colors.black,
  bool hideBack = false,
  double lrPadding = 16,
  leftIcon = Icons.arrow_back,
  Widget rightIconWidget =
      const Visibility(visible: false, child: Icon(Icons.done)),
  required String title,
}) {
  // rightIconWidget = const Visibility(visible: false, child: Icon(Icons.done));
  //TODO remove after filter is rectified
  return Scaffold(
     key: scaffoldKey ,
    backgroundColor: color,
    body: Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Visibility(
            visible: backgroundImage.isNotEmpty,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  backgroundImage,
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Color.fromRGBO(3, 25, 65, 1)
                      .withOpacity(backgroudOpacity), //rgba(3, 25, 65, 1)
                )
              ],
            ),
          ),
        ),
        SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: textColor),
                ),
              ),
            Positioned(top: 0,left: 0,
              child:
              Visibility(
                visible: !hideBack,
              child:Container(
                width: 60,
                height: 50,
                child:
              GestureDetector(
                onTap: onBackPressed != null
                ? onBackPressed
                : () {
        Navigator.pop(context);
        },
              ),
              ),
        ),
            ),
              Positioned(
                  top: 0,
                  left: 0,
                  child: Visibility(
                    visible: !hideBack,
                    child: GestureDetector(
                      onTap: onBackPressed != null
                          ? onBackPressed
                          : () {
                              Navigator.pop(context);
                            },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20,22,20,25.0),
                        child: Image.asset(
                          leftIcon == Icons.arrow_back
                              ? "assets/left-arrow.png"
                              : "assets/close.png",
                          width: 20,
                          height: 20,
                          color: textColor,
                        ),
                      ),
                    ),
                  )),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {},
                  // child:
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: rightIconWidget,
                  // ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 54.0,
                  bottom: bottomPadding,
                  left: lrPadding,
                  right: lrPadding,
                ),
                child: body,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
