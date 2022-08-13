import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final int? id;
  final num? price;
  final String? longitudeStartPoint;
  final String? latitudeStartPoint;
  final String? longitudeEndPoint;
  final String? latitudeEndPoint;
  final dynamic note;
  final String? startAddress;
  final String? endAddress;
  final String? clientName;
  final String? clientMobile;
  final int? points;
  final num? companyProfit;
  final num? finalPrice;

  const Item({
    this.id,
    this.price,
    this.longitudeStartPoint,
    this.latitudeStartPoint,
    this.longitudeEndPoint,
    this.latitudeEndPoint,
    this.note,
    this.startAddress,
    this.endAddress,
    this.clientName,
    this.clientMobile,
    this.points,
    this.companyProfit,
    this.finalPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as int?,
        price: json['price'] as num?,
        longitudeStartPoint: json['longitude_start_point'] as String?,
        latitudeStartPoint: json['latitude_start_point'] as String?,
        longitudeEndPoint: json['longitude_end_point'] as String?,
        latitudeEndPoint: json['latitude_end_point'] as String?,
        note: json['note'] as dynamic,
        startAddress: json['start_address'] as String?,
        endAddress: json['end_address'] as String?,
        clientName: json['client_name'] as String?,
        clientMobile: json['client_mobile'] as String?,
        points: json['points'] as int?,
        companyProfit: json['profit_company_from_value_of_trip'] as num?,
        finalPrice: json['final_price_for_driver'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'longitude_start_point': longitudeStartPoint,
        'latitude_start_point': latitudeStartPoint,
        'longitude_end_point': longitudeEndPoint,
        'latitude_end_point': latitudeEndPoint,
        'note': note,
        'start_address': startAddress,
        'end_address': endAddress,
        'client_name': clientName,
        'client_mobile': clientMobile,
        'points': points,
        'final_price_for_driver': finalPrice,
        'profit_company_from_value_of_trip': companyProfit,
      };

  @override
  List<Object?> get props {
    return [
      id,
      price,
      longitudeStartPoint,
      latitudeStartPoint,
      longitudeEndPoint,
      latitudeEndPoint,
      note,
      startAddress,
      endAddress,
      clientName,
      clientMobile,
      points,
      companyProfit,
      finalPrice,
    ];
  }
}
