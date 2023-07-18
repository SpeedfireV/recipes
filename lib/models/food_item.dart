class FoodItem {
  final String name;
  final String description;
  final int rating;
  final int time;
  final String category;
  final List<String> ingredients;
  final String recipe;
  FoodItem(
      {required this.name,
      required this.description,
      required this.rating,
      required this.time,
      required this.category,
      required this.ingredients,
      required this.recipe});
}
