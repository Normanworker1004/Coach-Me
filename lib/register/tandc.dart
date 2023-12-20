import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:cme/ui_widgets/accordion.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildBaseScaffold(
        context: context,
        body: buildBody(context),
        title: "Legal notice");

  }
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Widget buildBody(context)  {
    return FutureBuilder (
      future: Future.wait([
        getFileData("assets/tandc.md"),
        getFileData("assets/privacy_policy.md"),
      ]) , // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
          return  Center(child: Text('Please wait its loading...'));
        }else{
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return SingleChildScrollView( child: Column(children: [
              Accordion('Terms of use',
                  MarkdownBody(data: snapshot.data![0] )),
              Accordion('Privacy and Policy',
                  MarkdownBody(data: snapshot.data![1] )),
            ]));  // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );    // return

  }
}
