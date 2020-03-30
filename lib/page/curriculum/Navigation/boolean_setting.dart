import 'package:flutter/material.dart';

/// 二元设置
class BooleanSetting extends StatefulWidget {
  const BooleanSetting({
    Key key,
    @required this.head,
    @required this.onSelected,
    this.selected = false,
  }) : super(key: key);

  final String head;
  final ValueChanged<bool> onSelected;
  final bool selected;

  @override
  _BooleanSettingState createState() => _BooleanSettingState();
}

const SPACE_NORMAL = const SizedBox(width: 8, height: 8);
const kDividerTiny = const Divider(height: 1);

class _BooleanSettingState extends State<BooleanSetting> {

  bool _selected;
  @override
  void initState() {
    super.initState();

    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          title: Text(widget.head),
          value: _selected,
          onChanged: (selected) {
            setState(() {
              _selected = selected;
              widget.onSelected(selected);
            });
          },
        ),
        kDividerTiny,
      ],
    );
  }
}