import 'package:climbing/classes/grade_scale_class.dart';
import 'package:flutter/material.dart';
import 'package:climbing/generated/l10n.dart';

class GradeScalePicker extends StatefulWidget {
  @override
  _GradeScalePickerState createState() => _GradeScalePickerState();
}

class _GradeScalePickerState extends State<GradeScalePicker> {
  double _grade;
  List<double> _allGrades = [
    0.0,
    1.0,
    2.0,
    3.0,
    4.0,
    5.0,
    6.0,
    7.0,
    6.0,
    7.0,
    8.0,
    9.0,
    10.1,
    10.2,
    10.3,
    10.4,
    11.1,
    11.2,
    11.3,
    11.4,
    12.1,
    12.2,
    12.3,
    12.4,
    14.1,
    13.2,
    13.3,
    13.4,
    14.1,
    14.2,
    14.3,
    14.4,
    15.1,
    15.2,
    15.3,
    15.4
  ];

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: S.of(context).grades,
        hintText: S.of(context).chooseGrade,
        contentPadding: EdgeInsets.zero,
      ),
      isEmpty: _grade == 0.0,
      child: DropdownButton<double>(
        value: _grade,
        onChanged: (double newValue) {
          setState(() {
            _grade = newValue;
          });
        },
        items: _allGrades.map<DropdownMenuItem<double>>((double value) {
          return DropdownMenuItem<double>(
            value: value,
            child: Text(GradeScale(value).getScaled(GradeScales.YSD)),
          );
        }).toList(),
      ),
    );
  }
}
