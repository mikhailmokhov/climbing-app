import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

class ToggleableIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final void Function(bool selected) onTap;
  final bool selected;
  final double size;
  final bool feedbackVibration;

  const ToggleableIconButton({
    @required this.icon,
    @required this.tooltip,
    @required this.onTap,
    @required this.selected,
    @required this.size,
    this.feedbackVibration,
    Key key,
  }) : super(key: key);

  @override
  _ToggleableIconButtonState createState() => _ToggleableIconButtonState();
}

class _ToggleableIconButtonState extends State<ToggleableIconButton> {
  bool _canVibrate = false;

  void _onTap() async {
    if (widget.feedbackVibration == true && _canVibrate)
      Vibrate.feedback(FeedbackType.selection);
    this.widget.onTap(!widget.selected);
  }

  @override
  void initState() {
    super.initState();
    if (widget.feedbackVibration == true)
      Vibrate.canVibrate.then((value) => _canVibrate = value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Tooltip(
        message: this.widget.tooltip,
        child: SizedBox(
          width: 40,
          child: InkWell(
              onTap: _onTap,
              child: Icon(
                this.widget.icon,
                color: widget.selected ? Colors.amber : null,
                size: widget.size,
              )),
        ),
      ),
    );
  }
}
