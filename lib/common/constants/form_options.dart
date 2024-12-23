import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:sps/local_database/entity/user_township_entity.dart';

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

List<DropdownMenuItem<String>> get genders {
  List<DropdownMenuItem<String>> genders = [
    DropdownMenuItem(
        value: "Male", child: CustomLabelWidget(style: style, text: "ကျား")),
    DropdownMenuItem(
        value: "Female", child: CustomLabelWidget(style: style, text: "မ")),
  ];
  return genders;
}

List<DropdownMenuItem<String>> get yesOrNoOptions {
  List<DropdownMenuItem<String>> genders = [
    DropdownMenuItem(
        value: "Yes", child: CustomLabelWidget(style: style, text: "Yes")),
    DropdownMenuItem(
        value: "No", child: CustomLabelWidget(style: style, text: "No")),
  ];
  return genders;
}

List<DropdownMenuItem<String>> get treatmentRegimenOptions {
  List<DropdownMenuItem<String>> treatmentRegimenOptions = [
    DropdownMenuItem(
        value: "1. LTR",
        child: CustomLabelWidget(style: style, text: "1. LTR")),
    DropdownMenuItem(
        value: "2. OSSTR",
        child: CustomLabelWidget(style: style, text: "2. OSSTR")),
    DropdownMenuItem(
        value: "3. OLTR",
        child: CustomLabelWidget(style: style, text: "3. OLTR")),
    DropdownMenuItem(
        value: "4. BPal",
        child: CustomLabelWidget(style: style, text: "4. BPal")),
    DropdownMenuItem(
        value: "5. BPalM",
        child: CustomLabelWidget(style: style, text: "5. BPalM")),
    DropdownMenuItem(
        value: "6. Individualized MDR",
        child: CustomLabelWidget(style: style, text: "6. Individualized MDR")),
    DropdownMenuItem(
        value: "7. Individualized Pre-XDR",
        child:
            CustomLabelWidget(style: style, text: "7. Individualized Pre-XDR")),
    DropdownMenuItem(
        value: "8. XDR",
        child: CustomLabelWidget(style: style, text: "8. XDR")),
    DropdownMenuItem(
        value: "9. Other",
        child: CustomLabelWidget(style: style, text: "9. Other")),
  ];

  return treatmentRegimenOptions;
}

const treatmentRegimenOther = "9. Other";
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

List<DropdownMenuItem<String>> convertTownshipsToDropdownOptions(
    List<UserTownshipEntity> townships) {
  return townships
      .map((township) => DropdownMenuItem(
            value: '${township.remoteId}',
            child: CustomLabelWidget(style: style, text: township.name),
          ))
      .toList();
}

List<DropdownMenuItem<String>> get supportMonths {
  List<DropdownMenuItem<String>> supportMonths = [
    DropdownMenuItem(
        value: "-1",
        child: CustomLabelWidget(style: style, text: "Pre-enroll Month")),
    DropdownMenuItem(
        value: "0", child: CustomLabelWidget(style: style, text: "Month 0")),
    DropdownMenuItem(
        value: "1", child: CustomLabelWidget(style: style, text: "Month 1")),
    DropdownMenuItem(
        value: "2", child: CustomLabelWidget(style: style, text: "Month 2")),
    DropdownMenuItem(
        value: "3", child: CustomLabelWidget(style: style, text: "Month 3")),
    DropdownMenuItem(
        value: "4", child: CustomLabelWidget(style: style, text: "Month 4")),
    DropdownMenuItem(
        value: "5", child: CustomLabelWidget(style: style, text: "Month 5")),
    DropdownMenuItem(
        value: "6", child: CustomLabelWidget(style: style, text: "Month 6")),
    DropdownMenuItem(
        value: "7", child: CustomLabelWidget(style: style, text: "Month 7")),
    DropdownMenuItem(
        value: "8", child: CustomLabelWidget(style: style, text: "Month 8")),
    DropdownMenuItem(
        value: "9", child: CustomLabelWidget(style: style, text: "Month 9")),
    DropdownMenuItem(
        value: "10", child: CustomLabelWidget(style: style, text: "Month 10")),
    DropdownMenuItem(
        value: "11", child: CustomLabelWidget(style: style, text: "Month 11")),
    DropdownMenuItem(
        value: "12", child: CustomLabelWidget(style: style, text: "Month 12")),
    DropdownMenuItem(
        value: "13", child: CustomLabelWidget(style: style, text: "Month 13")),
    DropdownMenuItem(
        value: "14", child: CustomLabelWidget(style: style, text: "Month 14")),
    DropdownMenuItem(
        value: "15", child: CustomLabelWidget(style: style, text: "Month 15")),
    DropdownMenuItem(
        value: "16", child: CustomLabelWidget(style: style, text: "Month 16")),
    DropdownMenuItem(
        value: "17", child: CustomLabelWidget(style: style, text: "Month 17")),
    DropdownMenuItem(
        value: "18", child: CustomLabelWidget(style: style, text: "Month 18")),
    DropdownMenuItem(
        value: "19", child: CustomLabelWidget(style: style, text: "Month 19")),
    DropdownMenuItem(
        value: "20", child: CustomLabelWidget(style: style, text: "Month 20")),
    DropdownMenuItem(
        value: "21", child: CustomLabelWidget(style: style, text: "Month 21")),
    DropdownMenuItem(
        value: "22", child: CustomLabelWidget(style: style, text: "Month 22")),
    DropdownMenuItem(
        value: "23", child: CustomLabelWidget(style: style, text: "Month 23")),
    DropdownMenuItem(
        value: "24", child: CustomLabelWidget(style: style, text: "Month 24")),
  ];
  return supportMonths;
}
