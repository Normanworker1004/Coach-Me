import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:flutter/material.dart';

class FreeSessionPage extends StatefulWidget {
  @override
  _FreeSessionPageState createState() => _FreeSessionPageState();
}

class _FreeSessionPageState extends State<FreeSessionPage> {
  List<String> imgList = [
    "assets/fb.png",
    "assets/wa.png",
    "assets/ig.png",
    "assets/twitter.png",
  ];

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        lrPadding: 0,
        context: context,
        body: buildBody(context),
        title: "Free Session");
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: Text(
            "Taster Session invite",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        buildButtonsGrid(),
      ],
    );
  }

  buildButtonsGrid() {
    return GridView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(32.0),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //3,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 1,
      ),
      children: List.generate(
        imgList.length,
        (index) {
          return InkWell(
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(.2), blurRadius: 8)
              ]),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Image.asset(imgList[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAppBar() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        Text(
          "Refer Friend",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
