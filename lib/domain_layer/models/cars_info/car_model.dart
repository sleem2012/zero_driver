import 'package:equatable/equatable.dart';

class CarModel extends Equatable {
  final int id;
  final String name;

  const CarModel({required this.id, required this.name});

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json['id'] as int,
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object> get props => [id, name];
}
