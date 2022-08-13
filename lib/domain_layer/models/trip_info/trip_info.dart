import 'package:equatable/equatable.dart';

class TripInfo extends Equatable {
  final int? requestId;
  final String? tripPrice;
  final String? longitudeStartPoint;
  final String? latitudeStartPoint;
  final String? longitudeEndPoint;
  final String? latitudeEndPoint;
  final String? note;
  final String? date;
  final int? currentStatus;
  final String? tripStatus;
  final String? startName;
  final String? endName;
  final String? clientName;
  final String? clientMobile;
  final String? tripDistance;
  final String? tripTime;
  final String? image64;
  final String? image;

  const TripInfo({
    this.requestId,
    this.tripPrice,
    this.longitudeStartPoint,
    this.latitudeStartPoint,
    this.longitudeEndPoint,
    this.latitudeEndPoint,
    this.note,
    this.date,
    this.currentStatus,
    this.tripStatus,
    this.startName,
    this.endName,
    this.clientName,
    this.clientMobile,
    this.tripDistance,
    this.tripTime,
    this.image64,
    this.image,
  });

  factory TripInfo.fromJson(Map<String, dynamic> json) => TripInfo(
        requestId: (json['request_id'] as int?) ?? (json['id'] as int?),
        longitudeStartPoint: (json['longitude_start_point'] as String?),
        latitudeStartPoint: (json['latitude_start_point'] as String?),
        longitudeEndPoint: (json['longitude_end_point'] as String?),
        latitudeEndPoint: (json['latitude_end_point'] as String?),
        tripTime: (json['trip_time'] as String?),
        tripDistance: (json['distance'] as String?),
        startName: (json['start_name'] as String?) ??
            (json['start_address'] as String?),
        endName:
            (json['end_name'] as String?) ?? (json['end_address'] as String?),
        note: json['note'] as String?,
        clientName: json['client_name'] as String?,
        tripPrice:
            (json['trip_price'] as String?) ?? (json['price'] as String?),
        clientMobile: json['client_mobile'] as String?,
        currentStatus: json["current_status"] as int?,
        date: json["date"] as String?,
        tripStatus: json['trip_status'] as String?,
        image64: json['image64'] as String?,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'request_id': requestId,
        'longitude_start_point': longitudeStartPoint,
        'latitude_start_point': latitudeStartPoint,
        'longitude_end_point': longitudeEndPoint,
        'latitude_end_point': latitudeEndPoint,
        'start_name': startName,
        'end_name': endName,
        'note': note,
        'trip_time': tripTime,
        'distance': tripDistance,
        'client_name': clientName,
        'trip_price': tripPrice,
        'client_mobile': clientMobile,
        'current_status': currentStatus,
        'date': date,
        'trip_status': tripStatus,
      };

  @override
  List<Object?> get props {
    return [
      requestId,
      tripPrice,
      longitudeStartPoint,
      latitudeStartPoint,
      longitudeEndPoint,
      latitudeEndPoint,
      tripDistance,
      tripTime,
      note,
      date,
      currentStatus,
      tripStatus,
      startName,
      endName,
      clientName,
      clientMobile,
    ];
  }
}
