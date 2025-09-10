
class CreateCategoryModel {
  String img;
  String provideImg;
  String? prompt;
  int? firstOptionIndex;

  CreateCategoryModel({
    required this.img,
    required this.provideImg,
    this.prompt,
    this.firstOptionIndex
});
}