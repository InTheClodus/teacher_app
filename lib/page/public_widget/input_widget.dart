import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String title;
  final String hintxt;

  const InputWidget(this.title, this.hintxt);

  @override
  Widget build(BuildContext context) {
    final input = TextEditingController();
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(title),
        ),
        Expanded(
          flex: 4,
          child: TextField(
            style: TextStyle(color: Colors.black, fontSize: 14),
            controller: input,
            onTap: () {
              print(input.text);
            },
            decoration: InputDecoration(
              hintText: hintxt,
              border: InputBorder.none,
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.black54),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 35,
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.keyboard_arrow_right,
              size: 20,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

}
