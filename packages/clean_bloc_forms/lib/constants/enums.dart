enum ScreenType { Venue, Customer }
enum FormType { A, B }

extension GetScreenValue on ScreenType {
  String getEnumValue() {
    return this.toString().split('.').last;
  }
}

extension GetFormValue on FormType {
  String getEnumValue() {
    return this.toString().split('.').last;
  }
}
