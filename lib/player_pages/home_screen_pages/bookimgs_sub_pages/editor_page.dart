import 'package:cme/ui_widgets/dropdowns/border_dropdown.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/build_card_with_shadow.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/custom_calendar.dart';
import 'package:cme/ui_widgets/dot_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';

class BookingEditorPage extends StatefulWidget {
  @override
  _BookingEditorPageState createState() => _BookingEditorPageState();
}

class _BookingEditorPageState extends State<BookingEditorPage> {
  var selectedTime = "March 13, 2020";
  List<String> timeSlots = [
    "03:30 PM - 04:30 PM",
    "04:30 PM - 05:30 PM",
    "05:30 PM - 06:30 PM",
    "09:00 PM - 10:00 PM",
  ];
  String? selectedTimeSlot;

  List<String> selectedTimeSlotList = [];

  @override
  void initState() {
    super.initState();

    selectedTimeSlot = timeSlots[0];
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        CustomCalendarView(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            children: <Widget>[
              buildDivider(),
              Row(
                children: <Widget>[
                  Text(
                    "Select Time",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  borderDropDown(
                    title: "March 13, 2020",
                    width: 138,
                    height: 29,
                    textColor: blue,
                    color: Color.fromRGBO(229, 229, 229, 1),
                  )
                ],
              ),
              verticalSpace(height: 12),
              Wrap(
                children: List.generate(
                  timeSlots.length,
                  (index) {
                    String t = timeSlots[index];
                    return Column(
                      children: <Widget>[
                        buildCard(
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: white)),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selectedTimeSlotList.contains(t)) {
                                      selectedTimeSlotList.remove(t);
                                    } else {
                                      selectedTimeSlotList.add(t);
                                    }
                                    // selectedTimeSlot = t;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        t,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 32,
                                        width: 32,
                                        child: Visibility(
                                            visible: selectedTimeSlotList
                                                .contains(t),
                                            child: Icon(Icons.check,
                                                color: white)),
                                        decoration: selectedTimeSlotList
                                                .contains(t)
                                            ? BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                color: blue,
                                                // border: Border.all(color: white),
                                              )
                                            : BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          innerPadding: 0,
                        ),
                        verticalSpace()
                      ],
                    );
                  },
                ),
              ),
              buildDivider(),
              Row(
                children: <Widget>[
                  Text(
                    "Mode of Session",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text(
                        "Virtual",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Transform.scale(
                        scale: .8,
                        child: CupertinoSwitch(
                          activeColor: Color.fromRGBO(25, 87, 234, 1),
                          value: true,
                          onChanged: (c) {},
                        ),
                      ),
                      Text(
                        "Physical",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              verticalSpace(),
              proceedButton(text: "Book Now", onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        context: context, body: buildBody(context), title: "Edit Booking");
  }
}
