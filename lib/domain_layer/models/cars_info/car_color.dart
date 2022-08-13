import 'package:equatable/equatable.dart';

class CarColor extends Equatable {
  final int id;
  final String name;

  const CarColor({required this.id, required this.name});

  factory CarColor.fromJson(Map<String, dynamic> json) => CarColor(
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
