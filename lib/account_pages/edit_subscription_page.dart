import 'package:cme/app.dart';
import 'package:cme/model/subdetail.dart';
import 'package:cme/payment/payment_method.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/build_subscription_card.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';

class EditSubScriptionPage extends StatefulWidget {
  final SubDetail detail;

  const EditSubScriptionPage({Key? key, required this.detail})
      : super(key: key);
  @override
  _EditSubScriptionPageState createState() => _EditSubScriptionPageState();
}

class _EditSubScriptionPageState extends State<EditSubScriptionPage> {
  late SubDetail detail;

  @override
  void initState() {
    super.initState();

    detail = widget.detail;
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        context: context, body: buildBody(context), title: "Subscription");
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            buildSubCard(widget.detail),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromRGBO(182, 9, 27, 1),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: buildPaymentCardBody(imgUrl: "assets/pay1.png"),
            ),
            verticalSpace(height: 16),
            buildCard(Expanded(
              child: Column(
                children: <Widget>[
                  iconTextText("assets/price.png", "Per Month ",
                      "${detail.perMonth!.split("/").first}"),
                  verticalSpace(height: 4),
                  Divider(
                    color: Colors.grey,
                  ),
                  verticalSpace(height: 4),
                  iconTextText("assets/voucher.png", "Price Months",
                      "${detail.totalMonths}"),
                  verticalSpace(height: 4),
                  Divider(
                    color: Colors.grey,
                  ),
                  verticalSpace(height: 4),
                  Row(
                    children: <Widget>[
                      boldText("Total", size: 13),
                      Spacer(),
                      horizontalSpace(),
                      Text(
                        "${detail.price}",
                        style: TextStyle(fontFamily: "ROBOTO"),
                      ),
                    ],
                  ),
                  verticalSpace(height: 4),
                ],
              ),
            )),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: proceedButton(
            text: "Subscribe Now",
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget iconTextText(String icon, String text1, String text2) {
    return Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Image.asset(
            icon,
            width: 15,
            height: 15,
          ),
          horizontalSpace(),
          mediumText(text1),
          Spacer(),
          horizontalSpace(),
          Text(
            text2,
            style: TextStyle(
                // fontWeight: FontWeight.w100,
                fontFamily: "ROBOTO"),
          ),
        ],
      ),
    );
  }
}
