class FoodItem {
  final String name;
  final String description;
  final String image;
  final int rating;
  final int time;
  final String category;
  final List<String> ingredients;
  final List<String> steps;
  FoodItem(
      {required this.name,
      required this.description,
      required this.image,
      required this.rating,
      required this.time,
      required this.category,
      required this.ingredients,
      required this.steps});
}
