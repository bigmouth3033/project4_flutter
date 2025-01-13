import 'package:json_annotation/json_annotation.dart';
part 'booking.g.dart';

@JsonSerializable()
class Booking {
  final int? id;
  final DateTime? checkInDay;
  final DateTime? checkOutDay;
  final int? totalPerson;
  final int? children;
  final int? adult;
  final double? amount;
  final String? bookingType;

  final bool? selfCheckInInstruction;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;
  final String? bookingCode;
  final int? websiteFee;
  final int? hostFee;
  Booking({
    this.id,
    this.checkInDay,
    this.checkOutDay,
    this.totalPerson,
    this.children,
    this.adult,
    this.bookingType,
    this.selfCheckInInstruction,
    this.amount,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.bookingCode,
    this.websiteFee,
    this.hostFee,
  });
  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
