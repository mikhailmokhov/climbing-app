import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

class BookmarkButton extends StatefulWidget {
  final IconData icon;
  final IconData iconSelected;
  final IconData iconUnselected;
  final String tooltip;
  final void Function() onTap;
  final void Function(bool selected) onChange;
  final bool selected;
  final double size;
  final bool feedbackVibration;

  const BookmarkButton({
    @required this.icon,
    @required this.tooltip,
    @required this.onTap,
    @required this.size,
    this.feedbackVibration,
    Key key,
  })  : iconSelected = null,
        iconUnselected = null,
        selected = null,
        onChange = null,
        super(key: key);

  const BookmarkButton.toggleable({
    @required this.iconSelected,
    @required this.iconUnselected,
    @required this.tooltip,
    @required this.onChange,
    @required this.selected,
    @required this.size,
    this.feedbackVibration,
    Key key,
  })  : icon = null,
        onTap = null,
        super(key: key);

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton>
    with TickerProviderStateMixin {
  static const Color SELECTED_COLOR = Colors.redAccent;
  AnimationController _controller;
  Animation<double> _curve;
  Animation<num> _alpha;

  bool _canVibrate = false;
  bool _isSelected = false;

  Color _color;

  void _onTap() async {
    if (widget.feedbackVibration == true && _canVibrate)
      Vibrate.feedback(FeedbackType.selection);
    if (widget.icon != null) {
      setState(() {
        _color = SELECTED_COLOR;
      });
    }
    await _controller.forward();
    await _controller.reverse();
    if (widget.icon != null) {
      setState(() {
        _color = null;
      });
    }
    if (widget.onChange != null) {
      setState(() {
        _isSelected = !_isSelected;
      });
      this.widget.onChange(_isSelected);
    } else if (widget.onTap != null) this.widget.onTap();
  }

  @override
  void initState() {
    super.initState();
    if (widget.icon == null) _isSelected = widget.selected;
    if (widget.feedbackVibration == true)
      Vibrate.canVibrate.then((value) => _canVibrate = value);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 30), vsync: this);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _alpha = Tween(begin: 1.0, end: 1.3).animate(_curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  dispose() {
    if (widget.icon == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      child: Tooltip(
        message: this.widget.tooltip,
        child: SizedBox(
          width: 40,
          child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              enableFeedback: widget.feedbackVibration,
              radius: 150,
              customBorder: CircleBorder(),
              onTap: _onTap,
              child: Transform.scale(
                scale: _alpha.value,
                alignment: Alignment.center,
                child: Icon(
                  widget.icon != null
                      ? widget.icon
                      : (_isSelected
                          ? this.widget.iconSelected
                          : this.widget.iconUnselected),
                  color: _isSelected ? SELECTED_COLOR : _color,
                  size: widget.size,
                ),
              )),
        ),
      ),
    );
  }
}
