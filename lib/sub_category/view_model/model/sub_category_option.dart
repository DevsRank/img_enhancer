import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/enum/sub_category_type.dart';

class SubCategoryOption {

  static List<Map<String, dynamic>> img_utils = [
    {
      "img": kImgUtilsSubCategoryAiPhotoEnhancerImgPath,
      "title": "AI PHOTO ENHANCER",
      "sub_title": "Make old, blurry photos sharp & vibrant in just seconds.",
      "sub_category_type": SubCategoryType.photo_enhancer
    },
    {
      "img": kImgUtilsSubCategoryMoveCameraImgPath,
      "title": "MOVE CAMERA",
      "sub_title": "Move the camera to reveal new aspects of a scene",
      "sub_category_type": SubCategoryType.move_camera
    },
    {
      "img": kImgUtilsSubCategoryRelightImgPath,
      "title": "RELIGHT",
      "sub_title": "Relight and brilliantly transform your stunning photos",
      "sub_category_type": SubCategoryType.relight
    },
    {
      "img": kImgUtilsSubCategoryProductPhotoImgPath,
      "title": "PRODUCT PHOTO",
      "sub_title": "Turn your photos into professional product photos",
      "sub_category_type": SubCategoryType.product_photo
    },
    {
      "img": kImgUtilsSubCategoryZoomImgPath,
      "title": "ZOOM",
      "sub_title": "Enlarge without losing image quality",
      "sub_category_type": SubCategoryType.zoom
    },
    {
      "img": kImgUtilsSubCategoryColorizeImgPath,
      "title": "COLORIZE",
      "sub_title": "Bring vibrant new life to your photos",
      "sub_category_type": SubCategoryType.colorize
    }
  ];

  static List<Map<String, dynamic>> magic_remover = [
    {
      "img": kMagicRemoverSubCategoryBkgRemoverImgPath,
      "title": "BACKGROUND REMOVER",
      "sub_title": "Remove backgrounds or swap them with new styles in seconds.",
      "sub_category_type": SubCategoryType.bkg_remover
    },
    {
      "img": kMagicRemoverSubCategoryRemoveObjectImgPath,
      "title": "REMOVE OBJECT",
      "sub_title": "Remove distracting elements from your photos quickly and smoothly.",
      "sub_category_type": SubCategoryType.remove_object
    },
    {
      "img": kMagicRemoverSubCategoryRemoveTextImgPath,
      "title": "REMOVE TEXT",
      "sub_title": "Easily remove unwanted text effortlessly",
      "sub_category_type": SubCategoryType.remove_text
    }
  ];

  static List<Map<String, dynamic>> fun_preset = [
    {
      "img": kFunPresetSubCategoryCartoonifyImgPath,
      "title": "CARTOONIFY",
      "sub_title": "Turn photos into vibrant cartoon art",
      "sub_category_type": SubCategoryType.cartoonify
    },
    {
      "img": kFunPresetSubCategoryMoviePosterImgPath,
      "title": "MOVIE POSTER",
      "sub_title": "Turn your photos into movie posters",
      "sub_category_type": SubCategoryType.movie_poster
    },
    {
      "img": kFunPresetSubCategoryHairCutImgPath,
      "title": "HAIR CUT",
      "sub_title": "Change the haircut of the subject",
      "sub_category_type": SubCategoryType.hair_cut
    },
    {
      "img": kFunPresetSubCategoryTurnIntoAvatarImgPath,
      "title": "Turn into Avatar",
      "sub_title": "Create stunning, AI-powered profile avatars",
      "sub_category_type": SubCategoryType.turn_into_avatar
    },
    {
      "img": kFunPresetSubCategoryBodyBuilderImgPath,
      "title": "Body Builder",
      "sub_title": "Add muscle definition to your physique",
      "sub_category_type": SubCategoryType.body_builder
    }
  ];
}