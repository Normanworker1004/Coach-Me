import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_paymnet_history_response.dart';
import 'package:cme/network/coach/show_payment_history.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scoped_model/scoped_model.dart';

class PaymentHistoryPage extends StatefulWidget {
  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  //TODO FIX PAYMENT

  List<PaymentDetails>? detailsList = [];
  late UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        body: buildBody(context), context: context, title: "Payment History");
  }

  Widget buildBody(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (co, wid, model) {
        userModel = model;
        return FutureBuilder<FetchPaymentHistoryResponse>(
          future: fetchPaymentHistory(userModel.getAuthToken()!),
          builder: (context, snapshot) {
            if (snapshot == null) {
              return Container(
                child: Center(
                  child: mediumText(
                    "Unable to fetch payment history",
                  ),
                ),
              );
            } else {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              } else {
                if (snapshot.data!.status!) {
                  detailsList = snapshot.data!.details;
                }
                if(detailsList!.length == 0){
                  return Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: Container(
                      child: mediumText("You don't have payment history yet, history will show when you have finished a session ", textAlign: TextAlign.center),
                    ),
                  );
                }else {
                  return ListView(
                    children: List.generate(
                      detailsList!.length,
                          (index) =>
                          buildPaymentDetailCard(
                            detailsList![index],
                          ),
                    ),
                  );
                }
              }
            }
          },
        );
      },
    );
  }

  Widget buildPaymentDetailCard(PaymentDetails d) {
    return Column(
      children: <Widget>[
        buildCard(Expanded(
          child: Row(
            children: <Widget>[
              Icon(
                d.paymentType != "debit" ? Icons.add : Icons.remove,
                size: 60,
                color: d.paymentType != "debit"
                    ? Color.fromRGBO(25, 87, 234, 1) //rgba(25, 87, 234, 1)
                    : Color.fromRGBO(182, 9, 27, 1), //rgba(182, 9, 27, 1)
              ),
              horizontalSpace(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    boldText("${d.paymentTitle}", size: 13),
                    verticalSpace(height: 4),
                    rLightText("${composeDate(d.createdAt)}",
                        color: Colors.grey, size: 12)
                  ],
                ),
              ),
              horizontalSpace(),
              rBoldText("£${d.amount}", size: 16)
            ],
          ),
        )),
        verticalSpace(height: 16)
      ],
    );
  }
}

String composeDate(String? time) {
  var j = Jiffy(time);

  return "${j.day}/${j.month}/${j.year}";
}
