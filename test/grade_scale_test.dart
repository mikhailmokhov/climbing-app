import 'package:climbing/classes/grade_scale_class.dart';
import 'package:test/test.dart';

void main() {
  test("Grade scale object should convert grades to Yosemity scale", () async {
    for (int i = 10; i <= 15; i++) {
      String s = i.toString();
      expect(GradeScale.translate(i.toDouble(), GradeScales.YSD), '5.' + s);
      expect(GradeScale.translate(i + 0.1, GradeScales.YSD), '5.' + s + 'a');
      expect(GradeScale.translate(i + 0.2, GradeScales.YSD), '5.' + s + 'b');
      expect(GradeScale.translate(i + 0.3, GradeScales.YSD), '5.' + s + 'c');
      expect(GradeScale.translate(i + 0.4, GradeScales.YSD), '5.' + s + 'd');
    }
  });

  test("Grade scale object should convert grades to French scale", () async {
    expect(GradeScale.translate(0.0, GradeScales.French), '1');
    expect(GradeScale.translate(1.0, GradeScales.French), '2');
    expect(GradeScale.translate(2.0, GradeScales.French), '2');
    expect(GradeScale.translate(3.0, GradeScales.French), '3');
    expect(GradeScale.translate(4.0, GradeScales.French), '3');
    expect(GradeScale.translate(5.0, GradeScales.French), '4a');
    expect(GradeScale.translate(6.0, GradeScales.French), '4b');
    expect(GradeScale.translate(7.0, GradeScales.French), '4c');
    expect(GradeScale.translate(8.0, GradeScales.French), '5a');
    expect(GradeScale.translate(9.0, GradeScales.French), '5b');
    expect(GradeScale.translate(10.1, GradeScales.French), '6a');
    expect(GradeScale.translate(10.2, GradeScales.French), '6a+');
    expect(GradeScale.translate(10.3, GradeScales.French), '6b');
    expect(GradeScale.translate(10.4, GradeScales.French), '6b+');
    expect(GradeScale.translate(11.1, GradeScales.French), '6c');
    expect(GradeScale.translate(11.2, GradeScales.French), '6c+');
    expect(GradeScale.translate(11.3, GradeScales.French), '7a');
    expect(GradeScale.translate(11.4, GradeScales.French), '7a');
    expect(GradeScale.translate(12.1, GradeScales.French), '7a+');
    expect(GradeScale.translate(12.2, GradeScales.French), '7b');
    expect(GradeScale.translate(12.3, GradeScales.French), '7b+');
    expect(GradeScale.translate(12.4, GradeScales.French), '7c');
    expect(GradeScale.translate(13.1, GradeScales.French), '7c+');
    expect(GradeScale.translate(13.2, GradeScales.French), '8a');
    expect(GradeScale.translate(13.3, GradeScales.French), '8a+');
    expect(GradeScale.translate(13.4, GradeScales.French), '8b');
    expect(GradeScale.translate(14.1, GradeScales.French), '8b+');
    expect(GradeScale.translate(14.2, GradeScales.French), '8c');
    expect(GradeScale.translate(14.3, GradeScales.French), '8c+');
    expect(GradeScale.translate(14.4, GradeScales.French), '9a');
    expect(GradeScale.translate(15.1, GradeScales.French), '9a+');
    expect(GradeScale.translate(15.2, GradeScales.French), '9b');
    expect(GradeScale.translate(15.3, GradeScales.French), '9b+');
    expect(GradeScale.translate(15.4, GradeScales.French), '9c');
  });
}
