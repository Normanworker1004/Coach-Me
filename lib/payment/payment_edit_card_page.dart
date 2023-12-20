import 'package:cme/model/fetch_card_response.dart';
import 'package:cme/payment/payment_method.dart';
import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/network/coach/card_request.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/utils/show_snack.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cme/ui_widgets/texts.dart';

import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class PaymnetEditCardPage extends StatefulWidget {
  final Paymentcard card;

  const PaymnetEditCardPage({Key? key, required this.card}) : super(key: key);
  @override
  _PaymnetEditCardPageState createState() => _PaymnetEditCardPageState();
}

class _PaymnetEditCardPageState extends State<PaymnetEditCardPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  String cardType = "Unknown";
  String cardImagePath = "assets/pay2.png";
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late UserModel userModel;

  bool? isDefault; //TODO: add default card info into server
  late Paymentcard card;

  @override
  void initState() {
    super.initState();

    card = widget.card;

    var re = RegExp(r'\d(?!\d{0,12}$)'); // keep last 3 digits
    print( card.cardkey!.replaceAll(re, '-')); // ------789


    card.cardkey = card.cardkey!.replaceAll(re, '-');



    nameController = TextEditingController(text: "${card.nameOnCard}");
    cardNumberController = TextEditingController(text: "${card.cardkey}");
    expiryController = TextEditingController(text: "${card.expiryDate}");
    cvvController = TextEditingController(text: "");//${card.ccv}
    var i = checkCreditCardTypeInf0("${card.cardkey}");
    cardType = i[1];
    cardImagePath = i[0];
    isDefault = true;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (c, widget, model) {
        userModel = model;
        return Scaffold(
          key: _key,
          body: buildBaseScaffold(
              context: context, body: buildBody(context), title: "Edit Card"),
        );
      },
    );
  }

  String checkCreditCardType(String visa) {
    var type = detectCCType(visa);
    switch (type) {
      case CreditCardType.amex:
        setState(() {
          cardImagePath = "assets/pay3.png";
        });
        return "America Express";
        break;
      case CreditCardType.discover:
        setState(() {
          cardImagePath = "assets/pay2.png";
        });
        return "Discover";
        break;
      case CreditCardType.mastercard:
        setState(() {
          cardImagePath = "assets/pay1.png";
        });
        return "Master Card";
        break;
      case CreditCardType.visa:
        setState(() {
          cardImagePath = "assets/pay2.png";
        });
        return "Visa";
        break;
      default:
        setState(() {
          cardImagePath = "assets/pay2.png";
        });
        return "Unknown";
    }
  }

  refresh() {
    setState(() {});
  }

  bool canUpload(BuildContext context) {
    if (nameController.text.isEmpty) {
      showSnack(context, "Enter Account name");
      return false;
    }
    if (cardType == "Unknown") {
      showSnack(context, "Unable to identify Card");
      return false;
    }
    if (cvvController.text.trim().length != 3) {
      showSnack(context, "Enter CVV");
      return false;
    }
    if (expiryController.text.isEmpty) {
      showSnack(context, "Enter Expiry date");
      return false;
    }

    return true;
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        buildCardOnTop(
          expirydate: expiryController.text,
          cardNumber: cardNumberController.text.replaceAll("-", " "),
          nameOnCard: nameController.text,
        ),
        verticalSpace(height: 16),
        buildInputField("Name on card",
            controller: nameController, onChanged: (c) => refresh()),
        verticalSpace(),
        buildInputFieldWithLogo(
          "Card Number",
          controller: cardNumberController,
          cardImage: cardImagePath,
          onChanged: (c) {
            refresh();
            cardType = checkCreditCardType(
                cardNumberController.text.replaceAll("-", ""));
          },
        ),
        verticalSpace(),
        Row(
          children: <Widget>[
            Expanded(
              child: buildExpInputField("Expiry Date",
                  controller: expiryController, onChanged: (c) => refresh()),
            ),
            horizontalSpace(width: 32),
            Expanded(
              child: buildCvvInputField("CVV",
                  controller: cvvController, onChanged: (c) => refresh()),
            ),
          ],
        ),
        verticalSpace(),
        Row(
          children: [
            Checkbox(
              onChanged: (bool? value) {
                setState(() {
                  isDefault = value;
                });
              },
              value: isDefault,
            ),
            horizontalSpace(),
            mediumText('Default')
          ],
        ),
        // Spacer(),
        verticalSpace(height: 16),
        proceedButton(
          text: "Save Card",
          onPressed: () async {
            if (!canUpload(context)) {
              return;
            }
            // Navigator.pop(context);
            var r = await updatePaymentCard(
              userModel.getAuthToken(),
              cardType: cardType,
              ccv: cvvController.text,
              expiryDate: expiryController.text,
              cardkey: cardNumberController.text,
              nameOnCard: nameController.text,
              id: "${card.id}",
            );

            showSnack(context, r.message);
            if (r.status!) {
              await Future.delayed(Duration(seconds: 1));
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}

Widget buildInputWidget(
    String title, TextEditingController controller, Function onChanged) {
  return buildCard(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              TextField(
                onChanged: onChanged as void Function(String)?,
                controller: controller,
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: title),
              ),
            ],
          ),
        ),
      ),
      innerPadding: 0);
}

Widget buildInputField(
  String title, {
  TextEditingController? controller,
  Function? onChanged,
}) {
  return buildCard(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              // verticalSpace(height:4 ),
              TextField(
                onChanged: onChanged as void Function(String)?,
                controller: controller,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: title),
              ),
            ],
          ),
        ),
      ),
      innerPadding: 0);
}

Widget buildChatInputField(
  String title, {
  TextEditingController? controller,
  Function? onChanged,
  Function? onSend,
}) {
  return buildCard(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: onChanged as void Function(String)?,
                      controller: controller,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: title),
                    ),
                  ),
                  horizontalSpace(),
                  InkWell(onTap: onSend as void Function()?, child: Icon(Icons.send))
                ],
              ),
            ],
          ),
        ),
      ),
      innerPadding: 0);
}

Widget buildExpInputField(
  String title, {
  TextEditingController? controller,
  Function? onChanged,
}) {
  return buildCard(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              // verticalSpace(height:4 ),
              TextField(
                inputFormatters: [
                  MaskedTextInputFormatter(
                    mask: 'xx/xx',
                    separator: '/',
                  ),
                ],
                style: TextStyle(fontFamily: App.font_name2),
                keyboardType: TextInputType.number,
                onChanged: onChanged as void Function(String)?,
                controller: controller,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: "--/--"),
              ),
            ],
          ),
        ),
      ),
      innerPadding: 0);
}

Widget buildCvvInputField(
  String title, {
  TextEditingController? controller,
  Function? onChanged,
}) {
  return buildCard(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              // verticalSpace(height:4 ),
              TextField(
                inputFormatters: [
                  MaskedTextInputFormatter(
                    mask: 'xxx',
                    separator: '',
                  ),
                ],
                style: TextStyle(fontFamily: App.font_name2),
                keyboardType: TextInputType.number,
                onChanged: onChanged as void Function(String)?,
                controller: controller,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: "---"),
              ),
            ],
          ),
        ),
      ),
      innerPadding: 0);
}



Widget buildInputFieldWithLogo(String title, {TextEditingController? controller, Function? onChanged, required cardImage   }) {
  return buildCard(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    TextField(
                      inputFormatters: [
                        MaskedTextInputFormatter(
                          mask: 'xxxx-xxxx-xxxx-xxxx',
                          separator: '-',
                        ),
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: onChanged as void Function(String)?,
                      onTap: ()=>{
                        controller!.clear()
                      },
                      style: TextStyle(fontFamily: App.font_name2),
                      controller: controller,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ],
                ),
              ),
              verticalSpace(),
              Image.asset(
                cardImage,
                width: 64,
                // color: Colors.black,
              )
            ],
          ),
        ),
      ),
      innerPadding: 0);
}

Widget buildCardOnTop(
    {String cardNumber: "4343 3445 3434 ****",
    nameOnCard: "Monsoor Mirzo",
    expirydate: "03/25"}) {
  var i = checkCreditCardTypeInf0(cardNumber.replaceAll(" ", ""));

  return Container(
    height: 200,
    decoration: BoxDecoration(
      color: blue,
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 32,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Spacer(),
              Image.asset(
                i[0],
                // "assets/visa.png",
                width: 64,
                color: Colors.transparent,
              )
            ],
          ),
          verticalSpace(),
          Text(
            cardNumber,
            maxLines: 1,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                fontFamily: App.font_name2,
                wordSpacing: 16,
                color: Colors.white),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Text(
                      "Card Holder",
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 12,
                          // wordSpacing: 16,
                          color: Colors.grey),
                    ),
                    Text(
                      nameOnCard,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          // wordSpacing: 16,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Text(
                      "Expiry Date",
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 12,
                          // wordSpacing: 10,
                          color: Colors.grey),
                    ),
                    Text(
                      expirydate,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          // wordSpacing: 16,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
