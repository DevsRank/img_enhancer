import 'package:flutter/material.dart';

const kWhiteColor = Color(0xFFFFFFFF);
const kTransparentColor = Colors.transparent;
const kGreyColor = Colors.grey;
const kBlackColor = Color(0xFF000000);
const kBlack2Color = Color(0xFF12171B);
const kBlack3Color = Color(0xFF1C1D21);
const kGrey2Color = Color(0xFF202125);
const kGrey3Color = Color(0xFF222F39);
const kBlueColor = Color(0xFF3B7FFF);
const kShadowColor = Color(0xCFD0D0D0);
const kHoverColor = Color(0x90E5E5E5);
final kSplashColor = kGreyColor.withOpacity(.3);

const kBlueGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF3B7FFF),
      Color(0xFF2CAA78)
]);

const kWhiteGradient = LinearGradient(
    colors: [
      kWhiteColor,
      kWhiteColor
    ]);

const kGreyGradient = LinearGradient(
    colors: [
      kGreyColor,
      kGreyColor
    ]);

const kTransparentGradient = LinearGradient(
    colors: [
      kTransparentColor,
      kTransparentColor
    ]);