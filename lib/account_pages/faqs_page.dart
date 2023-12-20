import 'package:cme/app.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math' as m;

class FAQsPage extends StatefulWidget {
  @override
  _FAQsPageState createState() => _FAQsPageState();
}

class _FAQsPageState extends State<FAQsPage> {
  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        body: buildBody(context), context: context, title: "FAQs");
  }

  Widget buildBody(BuildContext context) {
    return ListView(children: [
      Column(
        children: <Widget>[
          boldText("What can we help you with?"),
          verticalSpace(height: 16),
          buildCard(
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    // shape: StadiumBorder(),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        // alignLabelWithHint: true,
                        hintText: "Type your search here",
                        hintStyle: Style.hintTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              innerPadding: 4),
          verticalSpace(height: 16),
          Text(
            "You can also browse the topics below to find what you are looking for.",
            textAlign: TextAlign.center,
            // color: Colors.grey,
            // size: 14
          ),
        ],
      ),
      verticalSpace(),
      boldText("Coach&Me Setup", color: Colors.blue[900]),
      verticalSpace(height: 16),
      Wrap(
        children: List.generate(4, (index) => FAQItem()),
      ),
      verticalSpace(height: 32),
      boldText("Stats", color: Colors.blue[900]),
      verticalSpace(height: 16),
      Wrap(
        children: List.generate(4, (index) => FAQItem()),
      ),
    ]);
  }
}

class FAQItem extends StatefulWidget {
  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: Row(
            children: <Widget>[
              Transform.rotate(
                angle: m.pi * .5,
                child: Icon(
                  CupertinoIcons.forward,
                  color: Colors.grey,
                ),
              ),
              horizontalSpace(),
              Expanded(
                child: Text(
                  "How to setup Coach&Me?",
                  style: TextStyle(
                    fontFamily: App.font_name,
                    color: Colors.black.withOpacity(.7),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: !isOpen
              ? []
              : <Widget>[
                  verticalSpace(),
                  lightText(
                      "The quick, brown fox jumps over a lazy dog. "
                      "DJs flock by when MTV ax quiz prog. Junk MTV "
                      "quiz graced by fox whelps. Bawds jog, flick quartz,"
                      " vex nymphs. Waltz, bad nymph, for quick jigs vex! "
                      "Fox nymphs grab quick-jived waltz. Brick quiz whangs"
                      " jumpy veldt fox. Bright vixens jump; dozy fowl quack. "
                      "Quick wafting zephyrs vex bold Jim. Quick zephyrs blow, "
                      "vexing daft Jim. Sex-charged fop blew my junk TV quiz."
                      " How quickly daft jumping zebras vex. Two driven jocks help"
                      " fax my big quiz. Quick, Baz, get my woven flax jodhpurs! ",
                      color: Colors.black.withOpacity(.8),
                      maxLines: 100,
                      size: 14)
                ],
        ),
        verticalSpace(height: 16),
      ],
    );
  }
}
