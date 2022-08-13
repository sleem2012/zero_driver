import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final bool? success;
  final String? message;
  final Map? data;

  const PaymentMethod({this.success, this.message, this.data});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        success: json['success'] as bool?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : (json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data,
      };

  @override
  List<Object?> get props => [success, message, data];
}
