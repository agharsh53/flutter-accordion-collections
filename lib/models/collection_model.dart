class Collection {
  final String id;
  final String title;
  final List<String> productImageUrls;
  final bool isExpanded;

  Collection({
    required this.id,
    required this.title,
    required this.productImageUrls,
    this.isExpanded = false,
  });

  Collection copyWith({
    String? id,
    String? title,
    List<String>? productImageUrls,
    bool? isExpanded,
  }) {
    return Collection(
      id: id ?? this.id,
      title: title ?? this.title,
      productImageUrls: productImageUrls ?? this.productImageUrls,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}