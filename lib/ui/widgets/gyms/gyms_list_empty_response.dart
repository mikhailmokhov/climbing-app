import 'package:climbing/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyResponse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final disabledColor = Theme.of(context).disabledColor;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Icon(
              Icons.mood_bad,
              color: disabledColor,
              size: 32,
            )),
        Text(
          S.of(context).noGymsFound,
          style: TextStyle(color: disabledColor),
        ),
      ]),
    );
  }
}
