import 'package:flutter/material.dart';
import 'package:image_enhancer_app/utils/constant/color.dart';
import 'package:image_enhancer_app/utils/constant/image_path.dart';

class CreateCategoryOption {

  static List<Map<String, dynamic>> bkg_remover = [
    {
      "img": kSurpriseMeImgPath,
      "title": "Surprise Me",
      "color": kTransparentColor,
      "sub_color_list": <Map<String, dynamic>>[]
    },
    {
      "img": "",
      "title": "Red",
      "color": Color(0xFFFF0000),
      "sub_color_list": [
        {"img": "", "title": "Crimson", "color": Color(0xFFDC143C)},
        {"img": "", "title": "FireBrick", "color": Color(0xFFB22222)},
        {"img": "", "title": "IndianRed", "color": Color(0xFFCD5C5C)},
        {"img": "", "title": "Tomato", "color": Color(0xFFFF6347)},
        {"img": "", "title": "Salmon", "color": Color(0xFFFA8072)}
      ]
    },
    {
      "img": "",
      "title": "Pink",
      "color": Color(0xFFFFC0CB),
      "sub_color_list": [
        {"img": "", "title": "HotPink", "color": Color(0xFFFF69B4)},
        {"img": "", "title": "DeepPink", "color": Color(0xFFFF1493)},
        {"img": "", "title": "LightPink", "color": Color(0xFFFFB6C1)},
        {"img": "", "title": "PaleVioletRed", "color": Color(0xFFDB7093)},
        {"img": "", "title": "MediumVioletRed", "color": Color(0xFFC71585)}
      ]
    },
    {
      "img": "",
      "title": "Orange",
      "color": Color(0xFFFFA500),
      "sub_color_list": [
        {"img": "", "title": "DarkOrange", "color": Color(0xFFFF8C00)},
        {"img": "", "title": "Coral", "color": Color(0xFFFF7F50)},
        {"img": "", "title": "OrangeRed", "color": Color(0xFFFF4500)},
        {"img": "", "title": "PeachPuff", "color": Color(0xFFFFDAB9)},
        {"img": "", "title": "PapayaWhip", "color": Color(0xFFFFEFD5)}
      ]
    },
    {
      "img": "",
      "title": "Brown",
      "color": Color(0xFFA52A2A),
      "sub_color_list": [
        {"img": "", "title": "SaddleBrown", "color": Color(0xFF8B4513)},
        {"img": "", "title": "Chocolate", "color": Color(0xFFD2691E)},
        {"img": "", "title": "Peru", "color": Color(0xFFCD853F)},
        {"img": "", "title": "Sienna", "color": Color(0xFFA0522D)},
        {"img": "", "title": "RosyBrown", "color": Color(0xFFBC8F8F)}
      ]
    },
    {
      "img": "",
      "title": "Yellow",
      "color": Color(0xFFFFFF00),
      "sub_color_list": [
        {"img": "", "title": "Gold", "color": Color(0xFFFFD700)},
        {"img": "", "title": "Khaki", "color": Color(0xFFF0E68C)},
        {"img": "", "title": "LemonChiffon", "color": Color(0xFFFFFACD)},
        {"img": "", "title": "LightYellow", "color": Color(0xFFFFFFE0)},
        {"img": "", "title": "Moccasin", "color": Color(0xFFFFE4B5)}
      ]
    },
    {
      "img": "",
      "title": "Green",
      "color": Color(0xFF008000),
      "sub_color_list": [
        {"img": "", "title": "ForestGreen", "color": Color(0xFF228B22)},
        {"img": "", "title": "LimeGreen", "color": Color(0xFF32CD32)},
        {"img": "", "title": "SeaGreen", "color": Color(0xFF2E8B57)},
        {"img": "", "title": "Olive", "color": Color(0xFF808000)},
        {"img": "", "title": "SpringGreen", "color": Color(0xFF00FF7F)}
      ]
    },
    {
      "img": "",
      "title": "Lime",
      "color": Color(0xFF00FF00),
      "sub_color_list": [
        {"img": "", "title": "LawnGreen", "color": Color(0xFF7CFC00)},
        {"img": "", "title": "Chartreuse", "color": Color(0xFF7FFF00)},
        {"img": "", "title": "GreenYellow", "color": Color(0xFFADFF2F)},
        {"img": "", "title": "PaleGreen", "color": Color(0xFF98FB98)},
        {"img": "", "title": "LightGreen", "color": Color(0xFF90EE90)}
      ]
    },
    {
      "img": "",
      "title": "Cyan",
      "color": Color(0xFF00FFFF),
      "sub_color_list": [
        {"img": "", "title": "Aqua", "color": Color(0xFF00FFFF)},
        {"img": "", "title": "Turquoise", "color": Color(0xFF40E0D0)},
        {"img": "", "title": "MediumTurquoise", "color": Color(0xFF48D1CC)},
        {"img": "", "title": "DarkTurquoise", "color": Color(0xFF00CED1)},
        {"img": "", "title": "PaleTurquoise", "color": Color(0xFFAFEEEE)}
      ]
    },
    {
      "img": "",
      "title": "Teal",
      "color": Color(0xFF008080),
      "sub_color_list": [
        {"img": "", "title": "DarkCyan", "color": Color(0xFF008B8B)},
        {"img": "", "title": "LightSeaGreen", "color": Color(0xFF20B2AA)},
        {"img": "", "title": "CadetBlue", "color": Color(0xFF5F9EA0)},
        {"img": "", "title": "MediumAquaMarine", "color": Color(0xFF66CDAA)},
        {"img": "", "title": "PowderBlue", "color": Color(0xFFB0E0E6)}
      ]
    },
    {
      "img": "",
      "title": "Blue",
      "color": Color(0xFF0000FF),
      "sub_color_list": [
        {"img": "", "title": "RoyalBlue", "color": Color(0xFF4169E1)},
        {"img": "", "title": "DodgerBlue", "color": Color(0xFF1E90FF)},
        {"img": "", "title": "SkyBlue", "color": Color(0xFF87CEEB)},
        {"img": "", "title": "DeepSkyBlue", "color": Color(0xFF00BFFF)},
        {"img": "", "title": "CornflowerBlue", "color": Color(0xFF6495ED)}
      ]
    },
    {
      "img": "",
      "title": "Navy",
      "color": Color(0xFF000080),
      "sub_color_list": [
        {"img": "", "title": "MidnightBlue", "color": Color(0xFF191970)},
        {"img": "", "title": "DarkSlateBlue", "color": Color(0xFF483D8B)},
        {"img": "", "title": "SlateBlue", "color": Color(0xFF6A5ACD)},
        {"img": "", "title": "MediumSlateBlue", "color": Color(0xFF7B68EE)},
        {"img": "", "title": "SteelBlue", "color": Color(0xFF4682B4)}
      ]
    },
    {
      "img": "",
      "title": "Indigo",
      "color": Color(0xFF4B0082),
      "sub_color_list": [
        {"img": "", "title": "RebeccaPurple", "color": Color(0xFF663399)},
        {"img": "", "title": "BlueViolet", "color": Color(0xFF8A2BE2)},
        {"img": "", "title": "RoyalPurple", "color": Color(0xFF7851A9)},
        {"img": "", "title": "Grape", "color": Color(0xFF6F2DA8)},
        {"img": "", "title": "Iris", "color": Color(0xFF5A4FCF)}
      ]
    },
    {
      "img": "",
      "title": "Purple",
      "color": Color(0xFF800080),
      "sub_color_list": [
        {"img": "", "title": "Violet", "color": Color(0xFFEE82EE)},
        {"img": "", "title": "MediumPurple", "color": Color(0xFF9370DB)},
        {"img": "", "title": "DarkMagenta", "color": Color(0xFF8B008B)},
        {"img": "", "title": "Orchid", "color": Color(0xFFDA70D6)},
        {"img": "", "title": "Plum", "color": Color(0xFFDDA0DD)}
      ]
    },
    {
      "img": "",
      "title": "Magenta",
      "color": Color(0xFFFF00FF),
      "sub_color_list": [
        {"img": "", "title": "Fuchsia", "color": Color(0xFFFF00FF)},
        {"img": "", "title": "VioletRed", "color": Color(0xFFD02090)},
        {"img": "", "title": "DeepMagenta", "color": Color(0xFFA90193)},
        {"img": "", "title": "LightFuchsia", "color": Color(0xFFF984EF)},
        {"img": "", "title": "Thistle", "color": Color(0xFFD8BFD8)}
      ]
    },
    {
      "img": "",
      "title": "Gold",
      "color": Color(0xFFFFD700),
      "sub_color_list": [
        {"img": "", "title": "LightGold", "color": Color(0xFFFFF44F)},
        {"img": "", "title": "GoldenRod", "color": Color(0xFFDAA520)},
        {"img": "", "title": "DarkGoldenRod", "color": Color(0xFFB8860B)},
        {"img": "", "title": "PaleGold", "color": Color(0xFFE6BE8A)},
        {"img": "", "title": "Amber", "color": Color(0xFFFFBF00)}
      ]
    },
    {
      "img": "",
      "title": "Silver",
      "color": Color(0xFFC0C0C0),
      "sub_color_list": [
        {"img": "", "title": "LightSilver", "color": Color(0xFFD8D8D8)},
        {"img": "", "title": "DarkSilver", "color": Color(0xFFAFAFAF)},
        {"img": "", "title": "Platinum", "color": Color(0xFFE5E4E2)},
        {"img": "", "title": "Pewter", "color": Color(0xFF8E8E8E)},
        {"img": "", "title": "Gainsboro", "color": Color(0xFFDCDCDC)}
      ]
    },
    {
      "img": "",
      "title": "Beige",
      "color": Color(0xFFF5F5DC),
      "sub_color_list": [
        {"img": "", "title": "Cornsilk", "color": Color(0xFFFFF8DC)},
        {"img": "", "title": "AntiqueWhite", "color": Color(0xFFFAEBD7)},
        {"img": "", "title": "Linen", "color": Color(0xFFFAF0E6)},
        {"img": "", "title": "BlanchedAlmond", "color": Color(0xFFFFEBCD)},
        {"img": "", "title": "Seashell", "color": Color(0xFFFFF5EE)}
      ]
    },
    {
      "img": "",
      "title": "White",
      "color": Color(0xFFFFFFFF),
      "sub_color_list": [
        {"img": "", "title": "Snow", "color": Color(0xFFFFFAFA)},
        {"img": "", "title": "Ivory", "color": Color(0xFFFFFFF0)},
        {"img": "", "title": "FloralWhite", "color": Color(0xFFFFFAF0)},
        {"img": "", "title": "GhostWhite", "color": Color(0xFFF8F8FF)},
        {"img": "", "title": "WhiteSmoke", "color": Color(0xFFF5F5F5)}
      ]
    },
    {
      "img": "",
      "title": "Gray",
      "color": Color(0xFF808080),
      "sub_color_list": [
        {"img": "", "title": "DarkGray", "color": Color(0xFFA9A9A9)},
        {"img": "", "title": "DimGray", "color": Color(0xFF696969)},
        {"img": "", "title": "LightGray", "color": Color(0xFFD3D3D3)},
        {"img": "", "title": "SlateGray", "color": Color(0xFF708090)},
        {"img": "", "title": "Gainsboro", "color": Color(0xFFDCDCDC)}
      ]
    },
    {
      "img": "",
      "title": "Black",
      "color": Color(0xFF000000),
      "sub_color_list": [
        {"img": "", "title": "Jet", "color": Color(0xFF343434)},
        {"img": "", "title": "Charcoal", "color": Color(0xFF36454F)},
        {"img": "", "title": "Onyx", "color": Color(0xFF353839)},
        {"img": "", "title": "OuterSpace", "color": Color(0xFF414A4C)},
        {"img": "", "title": "Davy'sGray", "color": Color(0xFF555555)}
      ]
    },
    {
      "img": "",
      "title": "Olive",
      "color": Color(0xFF808000),
      "sub_color_list": [
        {"img": "", "title": "OliveDrab", "color": Color(0xFF6B8E23)},
        {"img": "", "title": "DarkOliveGreen", "color": Color(0xFF556B2F)},
        {"img": "", "title": "ArmyGreen", "color": Color(0xFF4B5320)},
        {"img": "", "title": "MossGreen", "color": Color(0xFF8A9A5B)},
        {"img": "", "title": "FernGreen", "color": Color(0xFF4F7942)}
      ]
    },
    {
      "img": "",
      "title": "Mint",
      "color": Color(0xFF98FF98),
      "sub_color_list": [
        {"img": "", "title": "LightMint", "color": Color(0xFFAAF0D1)},
        {"img": "", "title": "MediumAquamarine", "color": Color(0xFF66CDAA)},
        {"img": "", "title": "Emerald", "color": Color(0xFF50C878)},
        {"img": "", "title": "MediumSpringGreen", "color": Color(0xFF00FA9A)},
        {"img": "", "title": "Seafoam", "color": Color(0xFF93E9BE)}
      ]
    },
    {
      "img": "",
      "title": "Burgundy",
      "color": Color(0xFF800020),
      "sub_color_list": [
        {"img": "", "title": "Wine", "color": Color(0xFF722F37)},
        {"img": "", "title": "Berry", "color": Color(0xFF990F4B)},
        {"img": "", "title": "Oxblood", "color": Color(0xFF4A0404)},
        {"img": "", "title": "Merlot", "color": Color(0xFF73343A)},
        {"img": "", "title": "Garnet", "color": Color(0xFF733635)}
      ]
    },
    {
      "img": "",
      "title": "Maroon",
      "color": Color(0xFF800000),
      "sub_color_list": [
        {"img": "", "title": "DarkRed", "color": Color(0xFF8B0000)},
        {"img": "", "title": "Rosewood", "color": Color(0xFF65000B)},
        {"img": "", "title": "Chestnut", "color": Color(0xFF954535)},
        {"img": "", "title": "Mahogany", "color": Color(0xFFC04000)},
        {"img": "", "title": "Russet", "color": Color(0xFF80461B)}
      ]
    },
    {
      "img": "",
      "title": "BlueGreen",
      "color": Color(0xFF088F8F),
      "sub_color_list": [
        {"img": "", "title": "DeepSea", "color": Color(0xFF123524)},
        {"img": "", "title": "PrussianBlue", "color": Color(0xFF003153)},
        {"img": "", "title": "Pine", "color": Color(0xFF01796F)},
        {"img": "", "title": "Viridian", "color": Color(0xFF40826D)},
        {"img": "", "title": "Seagreen", "color": Color(0xFF2E8B57)}
      ]
    },
    {
      "img": "",
      "title": "Chartreuse",
      "color": Color(0xFF7FFF00),
      "sub_color_list": [
        {"img": "", "title": "GreenYellow", "color": Color(0xFFADFF2F)},
        {"img": "", "title": "SpringBud", "color": Color(0xFFA7FC00)},
        {"img": "", "title": "Inchworm", "color": Color(0xFFB2EC5D)},
        {"img": "", "title": "YellowGreen", "color": Color(0xFF9ACD32)},
        {"img": "", "title": "MossGreen", "color": Color(0xFF8A9A5B)}
      ]
    },
    {
      "img": "",
      "title": "Peach",
      "color": Color(0xFFFFE5B4),
      "sub_color_list": [
        {"img": "", "title": "Apricot", "color": Color(0xFFFBCEB1)},
        {"img": "", "title": "Blush", "color": Color(0xFFF9C1B9)},
        {"img": "", "title": "Melon", "color": Color(0xFFFDBCB4)},
        {"img": "", "title": "Cantaloupe", "color": Color(0xFFFFA177)},
        {"img": "", "title": "LightCoral", "color": Color(0xFFF08080)}
      ]
    },
    {
      "img": "",
      "title": "Rose",
      "color": Color(0xFFFF66CC),
      "sub_color_list": [
        {"img": "", "title": "CherryBlossomPink", "color": Color(0xFFFFB7C5)},
        {"img": "", "title": "Mauvelous", "color": Color(0xFFEF98AA)},
        {"img": "", "title": "Taffy", "color": Color(0xFFFFA09B)},
        {"img": "", "title": "CottonCandy", "color": Color(0xFFFFBCD9)},
        {"img": "", "title": "BubbleGum", "color": Color(0xFFFFC1CC)}
      ]
    },
    {
      "img": "",
      "title": "Ivory",
      "color": Color(0xFFFFFFF0),
      "sub_color_list": [
        {"img": "", "title": "Eggshell", "color": Color(0xFFF0EAD6)},
        {"img": "", "title": "OldLace", "color": Color(0xFFFDF5E6)},
        {"img": "", "title": "Cream", "color": Color(0xFFFFFDD0)},
        {"img": "", "title": "Pearl", "color": Color(0xFFF8F6F0)},
        {"img": "", "title": "Beige", "color": Color(0xFFF5F5DC)}
      ]
    },
    {
      "img": "",
      "title": "Lavender",
      "color": Color(0xFFE6E6FA),
      "sub_color_list": [
        {"img": "", "title": "LavenderBlush", "color": Color(0xFFFFF0F5)},
        {"img": "", "title": "MediumPurple", "color": Color(0xFF9370DB)},
        {"img": "", "title": "Mauve", "color": Color(0xFFE0B0FF)},
        {"img": "", "title": "Thistle", "color": Color(0xFFD8BFD8)},
        {"img": "", "title": "Wisteria", "color": Color(0xFFC9A0DC)}
      ]
    },
    {
      "img": "",
      "title": "Azure",
      "color": Color(0xFFF0FFFF),
      "sub_color_list": [
        {"img": "", "title": "AliceBlue", "color": Color(0xFFF0F8FF)},
        {"img": "", "title": "LightCyan", "color": Color(0xFFE0FFFF)},
        {"img": "", "title": "BabyBlue", "color": Color(0xFF89CFF0)},
        {"img": "", "title": "PaleBlue", "color": Color(0xFFAFEEEE)},
        {"img": "", "title": "PowderBlue", "color": Color(0xFFB0E0E6)}
      ]
    },
    {
      "img": "",
      "title": "Tan",
      "color": Color(0xFFD2B48C),
      "sub_color_list": [
        {"img": "", "title": "BurlyWood", "color": Color(0xFFDEB887)},
        {"img": "", "title": "SandyBrown", "color": Color(0xFFF4A460)},
        {"img": "", "title": "Peru", "color": Color(0xFFCD853F)},
        {"img": "", "title": "Khaki", "color": Color(0xFFF0E68C)},
        {"img": "", "title": "DesertSand", "color": Color(0xFFEDC9AF)}
      ]
    },
    {
      "img": "",
      "title": "Sand",
      "color": Color(0xFFC2B280),
      "sub_color_list": [
        {"img": "", "title": "LightKhaki", "color": Color(0xFFF0E68C)},
        {"img": "", "title": "Buff", "color": Color(0xFFF0DC82)},
        {"img": "", "title": "Ecru", "color": Color(0xFFC2B280)},
        {"img": "", "title": "Wheat", "color": Color(0xFFF5DEB3)},
        {"img": "", "title": "Champagne", "color": Color(0xFFF7E7CE)}
      ]
    },
    {
      "img": "",
      "title": "Plum",
      "color": Color(0xFFDDA0DD),
      "sub_color_list": [
        {"img": "", "title": "Orchid", "color": Color(0xFFDA70D6)},
        {"img": "", "title": "Amethyst", "color": Color(0xFF9966CC)},
        {"img": "", "title": "Mulberry", "color": Color(0xFFC54B8C)},
        {"img": "", "title": "JazzberryJam", "color": Color(0xFFA50B5E)},
        {"img": "", "title": "FrenchMauve", "color": Color(0xFFD473D4)}
      ]
    },
    {
      "img": "",
      "title": "Copper",
      "color": Color(0xFFB87333),
      "sub_color_list": [
        {"img": "", "title": "Penny", "color": Color(0xFFAD6F69)},
        {"img": "", "title": "Bronze", "color": Color(0xFFCD7F32)},
        {"img": "", "title": "RoseGold", "color": Color(0xFFB76E79)},
        {"img": "", "title": "BurnishedCopper", "color": Color(0xFF7C482B)},
        {"img": "", "title": "AntiqueBronze", "color": Color(0xFF665D1E)}
      ]
    },
    {
      "img": "",
      "title": "Apricot",
      "color": Color(0xFFFBCEB1),
      "sub_color_list": [
        {"img": "", "title": "Melon", "color": Color(0xFFFDBCB4)},
        {"img": "", "title": "Cantaloupe", "color": Color(0xFFFFA177)},
        {"img": "", "title": "LightApricot", "color": Color(0xFFFFD2A6)},
        {"img": "", "title": "AtomicTangerine", "color": Color(0xFFFF9966)},
        {"img": "", "title": "Sunset", "color": Color(0xFFFFDAB9)}
      ]
    },
    {
      "img": "",
      "title": "LimeGold",
      "color": Color(0xFFD4EF43),
      "sub_color_list": [
        {"img": "", "title": "Mindaro", "color": Color(0xFFE3F988)},
        {"img": "", "title": "GreenSheen", "color": Color(0xFF8FD400)},
        {"img": "", "title": "MiddleYellowGreen", "color": Color(0xFF8BBA23)},
        {"img": "", "title": "Limerick", "color": Color(0xFF9DC209)},
        {"img": "", "title": "Pistachio", "color": Color(0xFF93C572)}
      ]
    },
    {
      "img": "",
      "title": "Tangerine",
      "color": Color(0xFFF28500),
      "sub_color_list": [
        {"img": "", "title": "Pumpkin", "color": Color(0xFFFF7518)},
        {"img": "", "title": "Carrot", "color": Color(0xFFED9121)},
        {"img": "", "title": "Sunset", "color": Color(0xFFFDB813)},
        {"img": "", "title": "MangoTango", "color": Color(0xFFFF8243)},
        {"img": "", "title": "Tiger", "color": Color(0xFFF7A233)}
      ]
    },
    {
      "img": "",
      "title": "Slate",
      "color": Color(0xFF708090),
      "sub_color_list": [
        {"img": "", "title": "LightSlateGray", "color": Color(0xFF778899)},
        {"img": "", "title": "DarkSlateGray", "color": Color(0xFF2F4F4F)},
        {"img": "", "title": "SlateBlue", "color": Color(0xFF6A5ACD)},
        {"img": "", "title": "GrayBlue", "color": Color(0xFF8C92AC)},
        {"img": "", "title": "Payne'sGray", "color": Color(0xFF536878)}
      ]
    },
    {
      "img": "",
      "title": "Charcoal",
      "color": Color(0xFF36454F),
      "sub_color_list": [
        {"img": "", "title": "Gunmetal", "color": Color(0xFF2A3439)},
        {"img": "", "title": "AshGray", "color": Color(0xFFB2BEB5)},
        {"img": "", "title": "Davy'sGray", "color": Color(0xFF555555)},
        {"img": "", "title": "DimGray", "color": Color(0xFF696969)},
        {"img": "", "title": "Onyx", "color": Color(0xFF353839)}
      ]
    },
    {
      "img": "",
      "title": "Steel",
      "color": Color(0xFF4682B4),
      "sub_color_list": [
        {"img": "", "title": "LightSteelBlue", "color": Color(0xFFB0C4DE)},
        {"img": "", "title": "SkyBlue", "color": Color(0xFF87CEEB)},
        {"img": "", "title": "AliceBlue", "color": Color(0xFFF0F8FF)},
        {"img": "", "title": "PewterBlue", "color": Color(0xFF8BA8B7)},
        {"img": "", "title": "ShadowBlue", "color": Color(0xFF778BA5)}
      ]
    }
  ];

  static List<Map<String, dynamic>> turn_into_avatar = [
    {
      "img": "",
      "title": "Surprise Me"
    },
    {
      "img": kTurnIntoAvatarAnimeImgPath,
      "title": "Anime"
    },
    {
      "img": kTurnIntoAvatarSketchImgPath,
      "title": "Sketch"
    },
    {
      "img": kTurnIntoAvatarCartoonImgPath,
      "title": "Cartoon"
    },
    {
      "img": kTurnIntoAvatar3dAvatarImgPath,
      "title": "3D Avatar"
    },
    {
      "img": kTurnIntoAvatarLineArtImgPath,
      "title": "Line Art"
    },
    {
      "img": kTurnIntoAvatarWaterColorImgPath,
      "title": "Water Color"
    },
    {
      "img": kTurnIntoAvatarFuturisticImgPath,
      "title": "Futuristic"
    }
  ];
}