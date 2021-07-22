import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

class ToggleableCircleButton extends StatefulWidget {
  const ToggleableCircleButton({
    @required this.icon,
    @required this.tooltip,
    @required this.onTap,
    @required this.selected,
    this.feedbackVibration,
    Key key,
  })  : selectedText = null,
        unselectedText = null,
        super(key: key);

  const ToggleableCircleButton.label({
    @required this.icon,
    @required this.tooltip,
    @required this.selectedText,
    @required this.unselectedText,
    @required this.onTap,
    @required this.selected,
    this.feedbackVibration,
    Key key,
  }) : super(key: key);

  final IconData icon;
  final String tooltip;
  final void Function(bool selected) onTap;
  final bool selected;
  final String selectedText;
  final String unselectedText;
  final bool feedbackVibration;

  @override
  _ToggleableCircleButtonState createState() =>
      _ToggleableCircleButtonState(selected);
}

class _ToggleableCircleButtonState extends State<ToggleableCircleButton> {
  _ToggleableCircleButtonState(this._selected);

  bool _selected;
  bool _canVibrate = false;

  Future<void> _onTap() async {
    if (widget.feedbackVibration == true && _canVibrate)
      Vibrate.feedback(FeedbackType.selection);
    setState(() {
      _selected = !_selected;
    });
    widget.onTap(_selected);
  }

  @override
  void initState() {
    super.initState();
    if (widget.feedbackVibration == true)
      Vibrate.canVibrate.then((bool value) => _canVibrate = value);
  }

  @override
  Widget build(BuildContext context) {
    final Widget button = Container(
      child: Tooltip(
        message: widget.tooltip,
        child: SizedBox(
          width: 40,
          child: OutlinedButton(
              //padding: const EdgeInsets.only(left: 0, right: 0),
              //borderSide: _selected
              //    ? BorderSide(color: Theme.of(context).accentColor)
              //    : null,
              //shape: const CircleBorder(),
              onPressed: _onTap,
              child: Icon(
                widget.icon,
                color: _selected ? Theme.of(context).accentColor : null,
                size: 20,
              )),
        ),
      ),
    );

    if (widget.selectedText == null) {
      return button;
    } else {
      return Container(
        child: InkWell(
          onTap: _onTap,
          child: Column(
            children: <Widget>[
              button,
              Text(
                _selected ? widget.selectedText : widget.unselectedText,
                style: TextStyle(
                  color: _selected ? Theme.of(context).accentColor : null,
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
