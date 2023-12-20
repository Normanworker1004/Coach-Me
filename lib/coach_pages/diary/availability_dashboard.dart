import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/coach_pages/diary/availability_editor.dart';
import 'package:cme/model/coach/diary/fetch_diary_unavailability_response.dart';
import 'package:cme/model/general_response.dart';
import 'package:cme/network/coach/dairy/diary_request.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:cme/utils/date_functions.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/utils/show_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AvailabilityDashboardPage extends StatefulWidget {
  final UserModel? userModel;

  const AvailabilityDashboardPage({Key? key, required this.userModel})
      : super(key: key);
  @override
  _AvailabilityDashboardPageState createState() =>
      _AvailabilityDashboardPageState();
}

class _AvailabilityDashboardPageState extends State<AvailabilityDashboardPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  UserModel? userModel;
  List<DiaryDetails>? details;

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: buildBaseScaffold(
        context: context,
        body: buildBody(context),
        title: "UNAVAILABILITY",
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 72.0),
          child: FutureBuilder<FetchDiaryUnAvailabilityResponse>(
            future: fetchCoachDairyUnavailability(userModel!.getAuthToken()!),
            builder: (context, snapshot) {
              var r = snapshot == null
                  ? null
                  : snapshot.data == null
                      ? null
                      : snapshot.data;

              if (r != null) {
                details = r.details;
              }
              return details == null
                  ? Container(
                      child: Center(
                      child: CupertinoActivityIndicator(),
                    ))
                  : ListView.separated(
                      itemBuilder: (c, i) => buildItem(details![i]),
                      separatorBuilder: (c, i) => verticalSpace(),
                      itemCount: details!.length);
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: buildButton(),
        )
      ],
    );
  }

  Widget buildButton() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: ElevatedButton(
        onPressed: () async {
          await pushRoute(
              context,
              AvailabilityEditor(
                userModel: userModel,
                diaryDetails: null,
              ));
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          textStyle: TextStyle(color: Colors.white),
          primary: red,
        ),
        // disabledColor: Colors.grey,
        // elevation: 0,
        // textColor: Colors.white,
        // color: red,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.add, size: 32, color: white),
              Text("Add Unavailability",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(DiaryDetails i) {
    String hours =   "${to12hr(i.timingstart!)} - ${to12hr(i.timingend!)}";
     if(i.timingstart == "00:00" && i.timingend == "23:00") hours = "All day";
     return buildCard(
      Expanded(
        child:
        Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            // All actions are defined in the children parameter.
            children:   [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (context){
                  pushRoute(
                      context,
                      AvailabilityEditor(
                        userModel: userModel,
                        diaryDetails: i,
                      ));
                },
                backgroundColor: Color.fromRGBO(206, 206, 206, 1),
                foregroundColor: Colors.black,
                label: 'Edit',
                icon:Icons.edit
                // icon:
                // ImageIcon(
                //   AssetImage( "assets/edit_red.png")
                //  ),
              ),
              SlidableAction(
                onPressed: (context) async {
                  GeneralResponse2 r = await deleteCoachDairyUnavailability(
                    userModel!.getAuthToken()!,
                    bookingid: i.id,
                  );
                  showSnack(context, r.message);
                  setState(() {});
                  // showDeleteDialogue();
                },
                backgroundColor:  Color.fromRGBO(182, 9, 27, 1),
                foregroundColor: Colors.black,
                icon: Icons.delete,
                // icon:
                // ImageIcon(
                //   AssetImage( "assets/trash.png")
                //  ),
              ),
            ],
          ),
          child:  Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      rBoldText(
                          hours,
                          size: 18),
                      verticalSpace(),
                      lightText("${i.availableType}".toUpperCase(),
                          size: 12, color: Colors.grey)
                    ],
                  ),
                ),
                Icon(Icons.more_vert),
              ],
            ),
          ),
        ),
      ),
      innerPadding: 0,
    );
  }

  showDeleteDialogue() {
    showCupertinoDialog(
      context: this.context,
      builder: (c) => CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Are you sure you want to delete this Booking?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        content: Text(
          "Note: all content will be deleted",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Color.fromRGBO(182, 9, 27, 1),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Yes",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
