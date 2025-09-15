import 'package:flutter/material.dart';
import 'package:image_enhancer_app/home/view/widget/home_category_card_widget.dart';
import 'package:image_enhancer_app/sub_category/view/screen/sub_category_screen.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';
import 'package:image_enhancer_app/utils/enum/category_type.dart';
import 'package:image_enhancer_app/utils/extension/common_extension.dart';
import 'package:image_enhancer_app/utils/extension/navigator_extension.dart';
import 'package:image_enhancer_app/utils/extension/widget_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              16.0.hMargin,
              HomeCategoryCardWidget(img: kHomeCategoryImgUtilityImgPath, title: "Image Utilities", subTitle: "Creative hub for smart, stunning images",
                onPressed: () => context.push(widget: SubCategoryScreen(categoryType: CategoryType.img_utils)),
              ),
              context.height(16.0).hMargin,
              HomeCategoryCardWidget(img: kHomeCategoryMagicRemoverImgPath, title: "Magic Remover", subTitle: "Remove distractions with a single touch",
                  onPressed: () => context.push(widget: SubCategoryScreen(categoryType: CategoryType.magic_remover))),
              context.height(16.0).hMargin,
              HomeCategoryCardWidget(img: kHomeCategoryFunPresetImgPath, title: "Fun Presets", subTitle: "Instantly restyle your photos with flair",
                onPressed: () => context.push(widget: SubCategoryScreen(categoryType: CategoryType.fun_preset)),
              ),
              context.height(16.0).hMargin,
            ]
          ).padding(padding: context.width(16.0).horizontalEdgeInsets),
        )
    );
  }

  @override
  bool get wantKeepAlive => true;
}

