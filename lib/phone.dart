class PhoneListItem {
  String cover;
  String model;
  String vendor;

  PhoneListItem({this.cover, this.model, this.vendor});

  factory PhoneListItem.fromJson(Map<dynamic, dynamic> parsedJson) {
    return PhoneListItem(
        cover: parsedJson['cover'],
        model: parsedJson['model'],
        vendor: parsedJson['vendor']);
  }
}
