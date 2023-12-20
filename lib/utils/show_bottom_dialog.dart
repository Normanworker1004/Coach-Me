import 'package:flutter/material.dart';

showBottomDialogue({
  required context,
  required Widget child,
  heightPercent: .7,
}) async {
  FocusScope.of(context).requestFocus(FocusNode());

  return await showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (BuildContext bc) {
      return Container(
          height: MediaQuery.of(context).size.height * heightPercent,
          width: MediaQuery.of(context).size.width,
          child: child);
    },
  );
}
