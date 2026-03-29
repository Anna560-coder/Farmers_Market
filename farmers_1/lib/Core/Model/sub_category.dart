class SubCategory {
  final String name, image;
  SubCategory({required this.name, required this.image});
}

//  we have only used this sample model, remaining all model are fetch from firebase
List<SubCategory> subcategory = [
  SubCategory(
    name: "Tractors",
    image: "assets/category_image/sub_category/tractor.png",
  ),
  SubCategory(
    name: "Root \nvegetables",
    image: "assets/category_image/sub_category/turnip.png",
  ),
  SubCategory(
    name: "Tropical \nfruits",
    image: "assets/category_image/sub_category/Tropicals.png",
  ),
  SubCategory(
    name: "Hand \ntools",
    image: "assets/category_image/sub_category/Hand_Tool.png",
  ),
  SubCategory(
    name: "Vegetable \nseeds",
    image: "assets/category_image/sub_category/vegetable.png",
  ),
  SubCategory(
    name: "Irrigation \ntools",
    image: "assets/category_image/sub_category/Irrigarions.png",
  ),
];
List<String> filterCategory = [
  "Filter",
  "Ratings",
  "Size",
  "Color",
  "Price",
  "Brand",
];
