import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CircularImage(
      {Key? key, this.imageUrl = "assets/mou.png", this.size = 42})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        // color: Colors.yellow,
        borderRadius: BorderRadius.circular(size),
        image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
    );
  }
}

class CircularNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CircularNetworkImage(
      {Key? key, this.imageUrl = "assets/mou.png", this.size = 42})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        // color: Colors.yellow,
        borderRadius: BorderRadius.circular(size),
        image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
    );
  }
}
