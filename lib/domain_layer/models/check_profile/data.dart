import 'package:equatable/equatable.dart';

class Data extends Equatable {
  final bool frontSideCarLicense;
  final bool licenseNumber;
  final bool frontSideLicense;
  final bool backSideLicense;
  final bool expiryDate;
  final bool backSideCarLicense;
  final bool serviceId;
  final bool carNumber;
  final bool carColor;
  final bool carYear;
  final bool carNumberPicture;
  final bool personalId;
  final bool criminal;
  final int susbended;
  final bool profit;

  const Data({
    required this.frontSideCarLicense,
    required this.licenseNumber,
    required this.frontSideLicense,
    required this.backSideLicense,
    required this.expiryDate,
    required this.backSideCarLicense,
    required this.serviceId,
    required this.carNumber,
    required this.carColor,
    required this.carYear,
    required this.carNumberPicture,
    required this.personalId,
    required this.criminal,
    required this.susbended,
    required this.profit,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        frontSideCarLicense: json['front_side_car_license'] as bool,
        licenseNumber: json['license_number'] as bool,
        frontSideLicense: json['front_side_license'] as bool,
        backSideLicense: json['back_side_license'] as bool,
        expiryDate: json['expiry_date'] as bool,
        backSideCarLicense: json['back_side_car_license'] as bool,
        serviceId: json['service_id'] as bool,
        carNumber: json['car_number'] as bool,
        carColor: json['car_color'] as bool,
        carYear: json['car_year'] as bool,
        carNumberPicture: json['car_number_picture'] as bool,
        personalId: json['personal_id'] as bool,
        criminal: json['criminal'] as bool,
        susbended: json['susbended'] as int,
        profit: json['profit'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'front_side_car_license': frontSideCarLicense,
        'license_number': licenseNumber,
        'front_side_license': frontSideLicense,
        'back_side_license': backSideLicense,
        'expiry_date': expiryDate,
        'back_side_car_license': backSideCarLicense,
        'service_id': serviceId,
        'car_number': carNumber,
        'car_color': carColor,
        'car_year': carYear,
        'car_number_picture': carNumberPicture,
        'personal_id': personalId,
        'criminal': criminal,
      };

  @override
  List<Object> get props {
    return [
      frontSideCarLicense,
      licenseNumber,
      frontSideLicense,
      backSideLicense,
      expiryDate,
      backSideCarLicense,
      serviceId,
      carNumber,
      carColor,
      carYear,
      carNumberPicture,
      personalId,
      criminal,
      susbended,
    ];
  }
}
