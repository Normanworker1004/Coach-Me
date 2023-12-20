import 'package:cme/account_pages/earning/earning_graph.dart';
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/coach_earning_response.dart';
import 'package:cme/network/coach/show_coach_earning.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/dropdowns/custom_time_drodown.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scoped_model/scoped_model.dart';

// ignore: must_be_immutable
class EarningPage extends StatelessWidget {
  String selected = "Monthly";

  late UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        context: context, body: buildBody(context), title: "Earnings");
  }

  Widget buildBody(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (c, widget, model) {
        userModel = model;
        return FutureBuilder<CoachEarningResponse>(
            future: fetchCoachEarnings(userModel.getAuthToken()!),
            builder: (context, snapshot) {
              if (snapshot == null) {
                return Center(child: Text("unable to fetch data"));
              } else {
                if (snapshot.data == null) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  CoachEarningResponse c = snapshot.data!;
                  List<Details> details = c.details!;

                  double totalAmount = 0;
                  for (var item in details) {
                    totalAmount += (item.amount / 1.0);
                  }
                  return ListView(
                    children: [
                      buildCard(
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  lightText(
                                    "Earning Balance",
                                    size: 16,
                                    color: Color.fromRGBO(153, 153, 153, 1),
                                  ),
                                  Spacer(),
                                  Container(
                                      height: 32,
                                      child: CustomTimeDropDown(
                                        selectedItem: selected,
                                        borderColor: blue,
                                        item: [
                                          "Monthly",
                                          "Annual",
                                          "All Time",
                                        ],
                                      ))
                                ],
                              ),
                              verticalSpace(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        boldText(
                                          "£${totalAmount.toStringAsFixed(2)}",
                                          size: 30,
                                          color: Colors.black,
                                        ),
                                        Visibility(
                                          visible: false,
                                          maintainSize: true,
                                          maintainAnimation: true,
                                          maintainState: true,
                                          child: Row(
                                            children: [
                                              Text(
                                                "+21.01%",
                                                style: TextStyle(
                                                    fontFamily: "ROBOTO",
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color.fromRGBO(
                                                        36, 180, 69, 1)),
                                                // size: 16,, //rgba(36, 180, 69, 1)
                                              ),
                                              Visibility(
                                                  visible: false,
                                                  child: Image.asset(
                                                      "assets/e_graph.png")),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 16,
                                      height: 80,
                                      child: LineChart(
                                        earningChartData(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      verticalSpace(height: 32),
                      boldText("History"),
                      verticalSpace(),
                      Wrap(
                        children: List.generate(
                          details.length,
                          (i) => buildPaymentcard(details[i]),
                        ),
                      )
                    ],
                  );
                }
              }
            });
      },
    );
  }

  Widget buildPaymentcard(Details d) {
    var j = Jiffy(d.createdAt);
    var date = "${j.day}/${j.month}/${j.year}";
    // print(date);
    return Column(
      children: <Widget>[
        buildCard(Expanded(
          child: Row(
            children: <Widget>[
              Icon(
                d.type == "credit" ? Icons.add : Icons.remove,
                size: 60,
                color: d.type == "credit"
                    ? Color.fromRGBO(25, 87, 234, 1) //rgba(25, 87, 234, 1)
                    : Color.fromRGBO(182, 9, 27, 1), //rgba(182, 9, 27, 1)
              ),
              horizontalSpace(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    boldText(d.details, size: 13),
                    verticalSpace(height: 4),
                    lightText(date, color: Colors.grey, size: 12)
                  ],
                ),
              ),
              horizontalSpace(),
              boldText("£${d.amount}", size: 16)
            ],
          ),
        )),
        verticalSpace(height: 16)
      ],
    );
  }
}
