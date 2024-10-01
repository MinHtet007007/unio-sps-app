import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

const TextStyle style = TextStyle(fontSize: 14);

List<DropdownMenuItem<String>> get counselingTypeOptions {
  List<DropdownMenuItem<String>> counselingTypeOptions = [
    DropdownMenuItem(
        value: "In Person",
        child: CustomLabelWidget(style: style, text: "လူကိုယ်တိုင်")),
    DropdownMenuItem(
        value: "Telecounseling",
        child: CustomLabelWidget(style: style, text: "ဖုန်းဖြင့်")),
  ];
  return counselingTypeOptions;
}

const IN_NOT_SYNCED = false;

List<DropdownMenuItem<String>> get years {
  List<DropdownMenuItem<String>> years = [
    DropdownMenuItem(
        value: "2022", child: CustomLabelWidget(style: style, text: "2022")),
    DropdownMenuItem(
        value: "2023", child: CustomLabelWidget(style: style, text: "2023")),
    DropdownMenuItem(
        value: "2024", child: CustomLabelWidget(style: style, text: "2024")),
    DropdownMenuItem(
        value: "2025", child: CustomLabelWidget(style: style, text: "2025")),
    DropdownMenuItem(
        value: "2026", child: CustomLabelWidget(style: style, text: "2026")),
    DropdownMenuItem(
        value: "2027", child: CustomLabelWidget(style: style, text: "2027")),
    DropdownMenuItem(
        value: "2028", child: CustomLabelWidget(style: style, text: "2028")),
    DropdownMenuItem(
        value: "2029", child: CustomLabelWidget(style: style, text: "2029")),
    DropdownMenuItem(
        value: "2030", child: CustomLabelWidget(style: style, text: "2030")),
  ];
  return years;
}

List<DropdownMenuItem<String>> get months {
  List<DropdownMenuItem<String>> months = [
    DropdownMenuItem(
        value: "1", child: CustomLabelWidget(style: style, text: "ဇန်နဝါရီလ")),
    DropdownMenuItem(
        value: "2",
        child: CustomLabelWidget(style: style, text: "ဖေဖော်ဝါရီလ")),
    DropdownMenuItem(
        value: "3", child: CustomLabelWidget(style: style, text: "မတ်လ")),
    DropdownMenuItem(
        value: "4", child: CustomLabelWidget(style: style, text: "ဧပရယ်လ")),
    DropdownMenuItem(
        value: "5", child: CustomLabelWidget(style: style, text: "မေလ")),
    DropdownMenuItem(
        value: "6", child: CustomLabelWidget(style: style, text: "ဇွန်လ")),
    DropdownMenuItem(
        value: "7", child: CustomLabelWidget(style: style, text: "ဇူလိုင်လ")),
    DropdownMenuItem(
        value: "8", child: CustomLabelWidget(style: style, text: "ဩဂုတ်လ")),
    DropdownMenuItem(
        value: "9", child: CustomLabelWidget(style: style, text: "စက်တင်ဘာလ")),
    DropdownMenuItem(
        value: "10",
        child: CustomLabelWidget(style: style, text: "အောက်တိုဘာလ")),
    DropdownMenuItem(
        value: "11", child: CustomLabelWidget(style: style, text: "နိုဝင်ဘာလ")),
    DropdownMenuItem(
        value: "12", child: CustomLabelWidget(style: style, text: "ဒီဇင်ဘာလ")),
    // DropdownMenuItem(
    //     value: "1 Quarter",
    //     child: CustomLabelWidget(style: style, text: "ပထမနှစ်ဝက်")),
    // DropdownMenuItem(
    //     value: "2 Quarter",
    //     child: CustomLabelWidget(style: style, text: "ဒုတိယနှစ်ဝက်")),
    // DropdownMenuItem(
    //     value: "3 Quarter",
    //     child: CustomLabelWidget(style: style, text: "တတိယနှစ်ဝက်")),
    // DropdownMenuItem(
    //     value: "4 Quarter",
    //     child: CustomLabelWidget(style: style, text: "စတုတ္ထနှစ်ဝက်")),
  ];
  return months;
}
