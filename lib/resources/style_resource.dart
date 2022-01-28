import 'package:skipq/resources/colour_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResourceStyles {
  final colors = ColorResource();

  TextStyle get fontMosse => TextStyle(fontFamily: 'Mosse', color: colors.black);

  final TextStyle fontColorWhite = TextStyle(color: Colors.white);
  TextStyle get fontColorPrimary => TextStyle(color: colors.primary);
  TextStyle get fontColorPrimaryD1 => TextStyle(color: colors.primaryD1);
  TextStyle get fontColorPrimaryL1 => TextStyle(color: colors.primaryL1);
  TextStyle get fontColorPrimaryL2 => TextStyle(color: colors.primaryL2);
  TextStyle get fontColorGrey => TextStyle(color: Colors.grey[700]);
  TextStyle get fontColorBluishGrey => TextStyle(color: colors.bluishGrey);
  TextStyle get fontColorBlack => TextStyle(color: Colors.black);

  final TextStyle fz12 = TextStyle(fontSize: 12);
  final TextStyle fz14 = TextStyle(fontSize: 14);
  final TextStyle fz16 = TextStyle(fontSize: 16);
  final TextStyle fz18 = TextStyle(fontSize: 18);
  final TextStyle fz20 = TextStyle(fontSize: 20);
  final TextStyle fz22 = TextStyle(fontSize: 22);
  final TextStyle fz24 = TextStyle(fontSize: 24);

  TextStyle get fz12FontColorPrimary => fz12.merge(fontColorPrimary);
  TextStyle get fz12FontColorGrey => fz12.merge(fontColorGrey);
  TextStyle get fz16FontColorGrey => fz16.merge(fontColorGrey);
  TextStyle get fz16FontColorPrimaryD1 => fz16.merge(fontColorPrimaryD1);
  TextStyle get fz16FontColorBlack => fz16.merge(fontColorBlack);
  TextStyle get fz14FontColorGrey => fz14.merge(fontColorGrey);
  TextStyle get fz14FontColorBluishGrey => fz14.merge(fontColorBluishGrey);
  TextStyle get fz14FontColorPrimary => fz14.merge(fontColorPrimary);
  TextStyle get fz16FontColorPrimary => fz16.merge(fontColorPrimary);
  TextStyle get fz16FontColorPrimaryL1 => fz16.merge(fontColorPrimaryL1);

  TextStyle fw300 = TextStyle(fontWeight: FontWeight.w300);
  TextStyle fw500 = TextStyle(fontWeight: FontWeight.w500);
  TextStyle fw700 = TextStyle(fontWeight: FontWeight.w700);

  TextStyle get fz14Fw500 => fz14.merge(fw500);
  TextStyle get fz14Fw700 => fz14.merge(fw700);
  TextStyle get fz16Fw500 => fz16.merge(fw500);
  TextStyle get fz16Fw700 => fz16.merge(fw700);
  TextStyle get fz18Fw700 => fz18.merge(fw700);
  TextStyle get fz18Fw500 => fz18.merge(fw500);
  TextStyle get fz20Fw500 => fz20.merge(fw500);
  TextStyle get fz20Fw700 => fz20.merge(fw700);
  TextStyle get fz24Fw500 => fz24.merge(fw500);
  TextStyle get fz24Fw700 => fz24.merge(fw700);

  BoxDecoration get containerShadow => BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey.shade200,
            offset: Offset(0, 2),
          )
        ],
      );

  // InputBorder get enabledBorder => OutlineInputBorder(
  //       borderSide: BorderSide(
  //         color: colors.grey,
  //         width: 1.0,
  //       ),
  //     );
  // InputBorder get focusedBorder => OutlineInputBorder(
  //       borderSide: BorderSide(
  //         color: colors.primaryColor,
  //         width: 1.0,
  //       ),
  //     );

  // InputBorder get noBorder => OutlineInputBorder(
  //       borderSide: BorderSide.none,
  //     );

  // ShapeBorder get bottomSheetShape => RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topRight: Radius.circular(25),
  //         topLeft: Radius.circular(25),
  //       ),
  //     );

  // ButtonStyle get roundedPrimaryButtonStyle => ElevatedButton.styleFrom(
  //       primary: colors.secondaryColor,
  //       textStyle: fz14.merge(fw700),
  //       shape: RoundedRectangleBorder(
  //         side: BorderSide(
  //           color: colors.secondaryColor,
  //         ),
  //         borderRadius: BorderRadius.circular(50),
  //       ),
  //     );

  // ButtonStyle get roundedSecondaryButtonStyle => ElevatedButton.styleFrom(
  //       textStyle: fz14.merge(fw700),
  //       shape: RoundedRectangleBorder(
  //         // side: BorderSide(
  //         //   color: colors.secondaryColor,
  //         // ),
  //         borderRadius: BorderRadius.circular(50),
  //       ),
  //     );

  // ButtonStyle get roundedOutlinedButtonStyle => ElevatedButton.styleFrom(
  //       textStyle: fz14FontColorPrimary.merge(fw700),
  //       primary: colors.tertiaryColor,
  //       shape: RoundedRectangleBorder(
  //         side: BorderSide(
  //           color: colors.secondaryColor,
  //         ),
  //         borderRadius: BorderRadius.circular(50),
  //       ),
  //     );
}
