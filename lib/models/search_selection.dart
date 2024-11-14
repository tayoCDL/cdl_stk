
class SearchSelectionItem {
  SearchSelectionItem({
    this.label,
    this.value,
  });

  final String label;
  final dynamic value;

  SearchSelectionItem copyWith({
    String label,
    String value,
  }) =>
      SearchSelectionItem(
        label: label ?? this.label,
        value: value ?? this.value,
      );

  factory SearchSelectionItem.fromJson(Map<String, dynamic> json) => SearchSelectionItem(
    label: json["label"],
    value: json[" value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    " value": value,
  };



}
