class FoodCategoryModel {
  final String name;
  final String imageUrl;

  FoodCategoryModel({required this.name, required this.imageUrl});
}

List<FoodCategoryModel> foodTypes = [
  FoodCategoryModel(
    name: 'offers',
    imageUrl: 'https://www.precisionorthomd.com/wp-content/uploads/2023/10/percision-blog-header-junk-food-102323.jpg',
  ),
  FoodCategoryModel(
    name: 'Sir Lanka',
    imageUrl: 'https://media-cdn.tripadvisor.com/media/photo-s/1a/2a/66/58/for-food-lovers-traditional.jpg',
  ),
  FoodCategoryModel(
    name: 'Sushi',
    imageUrl: 'https://as2.ftcdn.net/jpg/01/35/23/71/1000_F_135237184_vZnNVRuaHQZclXjxJ7ftEa3IyerhDF2y.webp',
  ),
  FoodCategoryModel(
    name: 'Salads',
    imageUrl:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  FoodCategoryModel(
    name: 'Desserts',
    imageUrl:
        'https://media.istockphoto.com/id/2152882524/photo/multicolored-ice-cream-cones-and-fruits-shot-from-above-on-gray-background.webp?s=1024x1024&w=is&k=20&c=wP0DwhW103lKegndCsNHCgCdzWriKCriwkWgC2XmSIo=',
  ),
];
