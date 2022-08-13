import 'package:equatable/equatable.dart';

import 'car_color.dart';
import 'car_model.dart';
import 'car_year.dart';
import 'service.dart';

class Data extends Equatable {
  final List<Service> service;
  final List<CarModel> carModel;
  final List<CarColor> carColor;
  final List<String> carYear;

  const Data({
    required this.service,
    required this.carModel,
    required this.carColor,
    required this.carYear,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        service: (json['service'] as List<dynamic>)
            .map((e) => Service.fromJson(e as Map<String, dynamic>))
            .toList(),
        carModel: (json['car_model'] as List<dynamic>)
            .map((e) => CarModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        carColor: (json['car_color'] as List<dynamic>)
            .map((e) => CarColor.fromJson(e as Map<String, dynamic>))
            .toList(),
        carYear: (json['car_year'] as Map<String, dynamic>)
            .entries
            .map((e) => e.key)
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'service': service.map((e) => e.toJson()).toList(),
        'car_model': carModel.map((e) => e.toJson()).toList(),
        'car_color': carColor.map((e) => e.toJson()).toList(),
        // 'car_year': carYear.toJson(),
      };

  @override
  List<Object> get props => [
        service,
        carModel,
        carColor,
        // carYear,
      ];
}
