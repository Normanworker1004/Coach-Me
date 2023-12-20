import 'package:flutter/material.dart';
import 'package:cme/graph_import/graphs/hours_of_training.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../ui_widgets/build_base_scaffold.dart';
import 'dart:io';
import 'dart:typed_data';
class ShareWidgetPage extends StatefulWidget {
  final Widget child;
  final String? textToShare;


  ShareWidgetPage({required this.child, this.textToShare});

  @override
  State<ShareWidgetPage> createState() => _ShareWidgetPageState();
}

class _ShareWidgetPageState extends State<ShareWidgetPage> {

  WidgetsToImageController controllerImage = WidgetsToImageController();


  @override
  Widget build(BuildContext context) {
    return
      buildBaseScaffold(
          context: context, body: buildBody(context), title: "Share ! ");
  }
  void shareIt() async {
    var image =  await controllerImage.capture();
    if(image != null ) {
      //  Directory tempDir = await getTemporaryDirectory();
      var directory = (await getTemporaryDirectory()).path;

      File imgFile = new File('$directory/screenshot.png');
      await imgFile.writeAsBytes(image);

      await Share
          .shareFiles(
          ['${imgFile.path}'], text: '... stats');
    }
  }
  Widget buildBody(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), (){shareIt(); });
   return Center(
     child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetsToImage(
            controller: controllerImage,
           child: Column( // this one detains what we want to share.
              children: [
                Container( width:50, child: Image.asset("assets/logo.png")),
                widget.child,
                widget.textToShare != null ? Text( widget.textToShare! ) : Container()
             ],
        ),
         ),
        ],
     ),
   );
  }
}
