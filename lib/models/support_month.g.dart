// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_month.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportMonth _$SupportMonthFromJson(Map<String, dynamic> json) => SupportMonth(
      id: (json['id'] as num).toInt(),
      patientId: (json['patientId'] as num).toInt(),
      patientName: json['patientName'] as String,
      townshipId: (json['townshipId'] as num).toInt(),
      township: Township.fromJson(json['township'] as Map<String, dynamic>),
      date: json['date'] as String,
      month: (json['month'] as num).toInt(),
      monthYear: json['monthYear'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      planPackages: json['planPackages'] as String,
      receivePackageStatus: json['receivePackageStatus'] as String,
      receivePackages: (json['receivePackages'] as List<dynamic>)
          .map((e) => SupportPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
      reimbursementStatus: json['reimbursementStatus'] as String,
      reimbursementMonth: (json['reimbursementMonth'] as num?)?.toInt(),
      reimbursementMonthYear: json['reimbursementMonthYear'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      remark: json['remark'] as String?,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$SupportMonthToJson(SupportMonth instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'patientName': instance.patientName,
      'townshipId': instance.townshipId,
      'township': instance.township,
      'date': instance.date,
      'month': instance.month,
      'monthYear': instance.monthYear,
      'height': instance.height,
      'weight': instance.weight,
      'bmi': instance.bmi,
      'planPackages': instance.planPackages,
      'receivePackageStatus': instance.receivePackageStatus,
      'receivePackages': instance.receivePackages,
      'reimbursementStatus': instance.reimbursementStatus,
      'reimbursementMonth': instance.reimbursementMonth,
      'reimbursementMonthYear': instance.reimbursementMonthYear,
      'amount': instance.amount,
      'remark': instance.remark,
      'status': instance.status,
    };
