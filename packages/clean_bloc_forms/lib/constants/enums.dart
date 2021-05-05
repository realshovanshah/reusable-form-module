enum ScreenType { Venue, Customer }
enum CategoryType { A, B }

extension GetScreenValue on ScreenType {
  String getEnumValue() {
    return this.toString().split('.').last;
  }
}

extension GetFormValue on CategoryType {
  String getEnumValue() {
    return this.toString().split('.').last;
  }
}
