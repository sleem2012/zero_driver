import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final int id;
  final String name;

  const Service({required this.id, required this.name});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
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
