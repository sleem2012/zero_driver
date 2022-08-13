import 'package:equatable/equatable.dart';

class Data extends Equatable {
  final int? totalTrip;
  final int? totalCash;
  final String? totalPoint;

  const Data({this.totalTrip, this.totalCash, this.totalPoint});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalTrip: json['total_trip'] as int?,
        totalCash: json['total_cash'] as int?,
        totalPoint: json['total_point'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'total_trip': totalTrip,
        'total_cash': totalCash,
        'total_point': totalPoint,
      };

  @override
  List<Object?> get props => [totalTrip, totalCash, totalPoint];
}
