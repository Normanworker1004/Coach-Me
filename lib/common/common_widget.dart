import 'package:flutter/material.dart';

// Widget commonButton(VoidCallback onPressed, String label,
//     {double? red, double? fontSize}) {
//   return Container(
//     child: RaisedButton(
//       onPressed: () {
//         onPressed.call();
//       },
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(red ?? 20.0)),
//       padding: EdgeInsets.all(0.0),
//       child: Ink(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xff9F00C5),
//                 Color(0xff9405BD),
//                 Color(0xff7913A7),
//                 Color(0xff651E96),
//                 Color(0xff522887)
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderRadius: BorderRadius.circular(red ?? 20.0)),
//         child: Container(
//           constraints: BoxConstraints(minHeight: 55.0),
//           alignment: Alignment.center,
//           child: Text(
//             label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w800,
//                 fontSize: fontSize ?? 18),
//           ),
//         ),
//       ),
//     ),
//   );
// }
