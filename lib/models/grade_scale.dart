
class GradeScale {
  final double _value;

  GradeScale(double grade) : this._value = grade;

  double getRaw(){
    return this._value;
  }

  String getScaled(GradeScales scale) {
    String result;
    switch (scale) {
      case GradeScales.YSD:
        {
          result = '5.' +
              this._value
                  .toStringAsPrecision(2)
                  .replaceAll('.0', '')
                  .replaceAll('.1', 'a')
                  .replaceAll('.2', 'b')
                  .replaceAll('.3', 'c')
                  .replaceAll('.4', 'd');
        }
        break;
      case GradeScales.French:
        {
          if (this._value == 0.0) {
            result = '1';
          } else if (this._value == 1.0 || this._value == 2.0) {
            result = '2';
          } else if (this._value == 3.0 || this._value == 4.0) {
            result = '3';
          } else if (this._value == 5.0) {
            result = '4a';
          } else if (this._value == 6.0) {
            result = '4b';
          } else if (this._value == 7.0) {
            result = '4c';
          } else if (this._value == 8.0) {
            result = '5a';
          } else if (this._value == 9.0) {
            result = '5b';
          } else if (this._value == 10.1) {
            result = '6a';
          } else if (this._value == 10.2) {
            result = '6a+';
          } else if (this._value == 10.3) {
            result = '6b';
          } else if (this._value == 10.4) {
            result = '6b+';
          } else if (this._value == 11.1) {
            result = '6c';
          } else if (this._value == 11.2) {
            result = '6c+';
          } else if (this._value == 11.3 || this._value == 11.4) {
            result = '7a';
          } else if (this._value == 12.1) {
            result = '7a+';
          } else if (this._value == 12.2) {
            result = '7b';
          } else if (this._value == 12.3) {
            result = '7b+';
          } else if (this._value == 12.4) {
            result = '7c';
          } else if (this._value == 13.1) {
            result = '7c+';
          } else if (this._value == 13.2) {
            result = '8a';
          } else if (this._value == 13.3) {
            result = '8a+';
          } else if (this._value == 13.4) {
            result = '8b';
          } else if (this._value == 14.1) {
            result = '8b+';
          } else if (this._value == 14.2) {
            result = '8c';
          } else if (this._value == 14.3) {
            result = '8c+';
          } else if (this._value == 14.4) {
            result = '9a';
          } else if (this._value == 15.1) {
            result = '9a+';
          } else if (this._value == 15.2) {
            result = '9b';
          } else if (this._value == 15.3) {
            result = '9b+';
          } else if (this._value == 15.4) {
            result = '9c';
          }
        }
        break;
      case GradeScales.UIAA:
      case GradeScales.UK:
      case GradeScales.Australian:
        {
          result = this._value.toString();
        }
    }
    return result;
  }
}

enum GradeScales { YSD, French, UIAA, UK, Australian }
