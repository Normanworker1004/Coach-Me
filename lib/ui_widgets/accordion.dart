import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final String title;
  final Widget content;

  Accordion(this.title, this.content);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        GestureDetector(
        child:
        ListTile(
          title: Text(widget.title),
          trailing: IconButton(
            icon: Icon(
                _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down), onPressed: () {  },

          ),

        ),
          onTap: () {
            setState(() {
              _showContent = !_showContent;
            });
          },
        ),
        _showContent
            ? Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: widget.content,
        )
            : Container()
      ]),
    );
  }
}