import 'package:cme/app.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class StatsSplashPage extends StatefulWidget {
  @override
  _StatsSplashPageState createState() => _StatsSplashPageState();
}

class _StatsSplashPageState extends State<StatsSplashPage> {
  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        lrPadding: 0,
        hideBack: true,
        bottomPadding: 64,
        color: Colors.white.withOpacity(.8),
        context: context,
        body: buildBody(context),
        title: "Stats");
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(text: "We will need your "),
                  TextSpan(
                    text: "weight ",
                    style: TextStyle(
                      color: Color.fromRGBO(182, 9, 27, 1),
                    ),
                  ),
                  TextSpan(text: "and "),
                  TextSpan(
                    text: "height",
                    style: TextStyle(
                      color: Color.fromRGBO(182, 9, 27, 1),
                    ),
                  ),
                ],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: App.font_name),
              ),
            ),
          ),
          Spacer(),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .7,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              child: Card(
                margin: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      boldText("Why we need it.", size: 20),
                      verticalSpace(),
                      lightText(
                          "The quick, brown fox jumps over a lazy dog."
                          " DJs flock by when MTV ax quiz prog. Junk MTV "
                          "quiz graced by fox whelps. Bawds jog, flick quartz,"
                          " vex nymphs. Waltz, bad nymph, for quick jigs vex!"
                          " Fox nymphs grab quick-jived waltz. Brick quiz whangs"
                          " jumpy veldt fox. Bright vixens jump; dozy fowl quack."
                          " Quick wafting zephyrs vex bold Jim. Quick zephyrs blow,"
                          " vexing daft Jim. Sex-charged fop blew my junk TV quiz."
                          " How quickly daft jumping zebras vex. Two driven jocks help fax my big quiz. "
                          "Quick, Baz, get my woven flax jodhpurs! ",
                          maxLines: 100),
                      Spacer(),
                      verticalSpace(height: 16),
                      proceedButton(
                          text: "Continue",
                          onPressed: () {
                            // pushRoute(context, HeightInputPage());
                          })
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
