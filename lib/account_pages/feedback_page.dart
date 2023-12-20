import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/network/feedback.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FeedBackPage extends StatefulWidget {
  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late UserModel userModel;

  TextEditingController controller = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (co, wid, model) {
        userModel = model;
        return Scaffold(
          key: _key,
          body: buildBaseScaffold(
              context: context, body: buildBody(context), title: "Feedback"),
        );
      },
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            verticalSpace(height: 32),
            Text(
              "Please provide your feedback to improve the app",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                // color: color,
              ),
            ),
            verticalSpace(),
            Container(
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(
                    color: Color.fromRGBO(206, 206, 206, 1),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  minLines: 8,
                  maxLines: 15,
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tell us about your experience",
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: proceedButton(
            text: "Submit Feedback",
            isLoading: isLoading,
            onPressed: () => submitFeedBack(context),
          ),
        )
      ],
    );
  }

  submitFeedBack(BuildContext context) async {
    if (controller.text.isEmpty) {
      showSnack(context, "Enter Message");
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLoading = true;
    });
    var r = await addFeedBack(
      token: userModel.getAuthToken()!,
      name: userModel.getUserDetails()!.name,
      message: "${controller.text}",
    );
    setState(() {
      isLoading = false;
    });
    if (r.status!) {
      showSnack(context, r.message);
    } else {
      showSnack(
          context, "Unable to send feedback\nCheck your internet connection");
    }
  }
}
