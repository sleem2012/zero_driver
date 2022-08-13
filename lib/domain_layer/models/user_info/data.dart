import 'package:equatable/equatable.dart';

class Data extends Equatable {
  final int? id;
  final String? name;
  final String? mobile;
  final String? email;
  final String? image;
  final String? carModels;
  final String? carColor;
  final String? carNumber;
  final int? serviceId;
  final num? rating;

  const Data({
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.image,
    this.carModels,
    this.carColor,
    this.carNumber,
    this.serviceId,
    this.rating,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'] as int?,
        name: json['name'] as String?,
        mobile: json['mobile'] as String?,
        email: json['email'] as String?,
        image: json['image'] as String?,
        carModels: json['car_models'] as String?,
        carColor: json['car_color'] as String?,
        carNumber: json['car_number'] as String?,
        serviceId: json['service_id'] as int?,
        rating: (json['rating'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'email': email,
        'image': image,
        'car_models': carModels,
        'car_color': carColor,
        'car_number': carNumber,
        'service_id': serviceId,
        'rating': rating,
      };

  @override
  List<Object?> get props {
    return [
      id,
      name,
      mobile,
      email,
      image,
      carModels,
      carColor,
      carNumber,
      serviceId,
      rating,
    ];
  }
}
