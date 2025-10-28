import 'package:flutter/material.dart';

import 'package:t_utils/t_utils.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: TColors().darkGrey,
    suffixIconColor: TColors().darkGrey,
    fillColor: TColors().accent,
    focusColor: TColors().white,
    filled: true,
    // constraints: const BoxConstraints.expand(height: TSizes().inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: TSizes().fontSizeMd, color: TColors().textPrimary, fontFamily: 'Urbanist'),
    hintStyle: const TextStyle().copyWith(fontSize: TSizes().fontSizeSm, color: TColors().textSecondary, fontFamily: 'Urbanist'),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal, fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle().copyWith(color: TColors().textSecondary, fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(TSizes().inputFieldRadius),
      borderSide: BorderSide(width: 1, color: TColors().darkContainer),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(TSizes().inputFieldRadius),
      borderSide: BorderSide(width: 1, color: TColors().darkGrey),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(TSizes().inputFieldRadius),
      borderSide: BorderSide(width: 2, color: TColors().primary),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(TSizes().inputFieldRadius),
      borderSide:  BorderSide(width: 2, color: TColors().error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(TSizes().inputFieldRadius),
      borderSide: BorderSide(width: 2, color: TColors().error),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: TColors().darkGrey,
    suffixIconColor: TColors().darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes().inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: TSizes().fontSizeMd, color: TColors().white, fontFamily: 'Urbanist'),
    hintStyle: const TextStyle().copyWith(fontSize: TSizes().fontSizeSm, color: TColors().white, fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle().copyWith(color: TColors().white.withValues(alpha: 0.8), fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(TSizes().inputFieldRadius),
      borderSide: BorderSide(width: 1, color: TColors().darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(TSizes().inputFieldRadius),
      borderSide: BorderSide(width: 1, color: TColors().darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(TSizes().inputFieldRadius),
      borderSide: BorderSide(width: 2, color: TColors().white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(TSizes().inputFieldRadius),
      borderSide: BorderSide(width: 2, color: TColors().error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(TSizes().inputFieldRadius),
      borderSide: BorderSide(width: 2, color: TColors().error),
    ),
  );
}
