class CategoryModel {
  int? color;

  String? name;
  int? count;
  String? id;

  CategoryModel({
    this.color,
    this.name,
    this.count,
    this.id,
  });
  CategoryModel copyWith({
    int? color,
    String? name,
    int? count,
    String? id,
  }) {
    return CategoryModel(
      color: color ?? this.color,
      name: name ?? this.name,
      count: count ?? this.count,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['name'] = name;
    data['count'] = count;
    data['id'] = id;

    return data;
  }
}
