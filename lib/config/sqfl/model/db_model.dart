class DbModel {

  String img;
  String provideImg;
  String? prompt;
  int? firstAttributeIndex;
  DateTime createAt;

  DbModel({
    required this.img,
    required this.provideImg,
    required this.prompt,
    required this.firstAttributeIndex,
    required this.createAt
  });

   Map<String, dynamic> toJson() {
     return {
       "img": img,
       "provide_img": provideImg,
       if(prompt != null) "prompt": prompt,
       if(firstAttributeIndex != null) "first_attribute_index": firstAttributeIndex,
       "create_at": createAt.toIso8601String()
     };
  }
}