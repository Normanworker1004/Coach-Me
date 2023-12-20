import 'package:cme/app.dart';
import 'package:flutter/material.dart';

class MessageRecievedWidget extends StatelessWidget {
  final String? text;

  const MessageRecievedWidget({Key? key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double p = MediaQuery.of(context).size.height * .1;
    return Padding(
      padding: EdgeInsets.only(right: p, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(229, 229, 231, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "$text",
            // "nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut,",
            style: TextStyle(fontWeight: FontWeight.w100),
          ),
        ),
      ),
    );
  }
}

class MessageSentWidget extends StatelessWidget {
  final String? text;

  const MessageSentWidget({Key? key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double p = MediaQuery.of(context).size.height * .1;
    return Padding(
      padding: EdgeInsets.only(left: p),
      child: Container(
        decoration: BoxDecoration(
          color: blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "$text",
            // "rient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut,",
            style: TextStyle(
              fontWeight: FontWeight.w100,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
