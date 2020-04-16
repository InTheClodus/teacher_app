
import 'package:flutter/material.dart';

class CLoadingDialog extends Dialog {

  final String text;

  CLoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: 144.0,
          height: 144.0,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0))
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(padding: const EdgeInsets.only(top: 20.0), child: Text(text, style: TextStyle(fontSize: 18.0, color: Colors.black87)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}