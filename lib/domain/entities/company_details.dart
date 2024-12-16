import 'package:equatable/equatable.dart';

class CompanyDetails extends Equatable {
  final int? id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String? logo;

  const CompanyDetails({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    this.logo,
  });

  CompanyDetails copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? logo,
  }) {
    return CompanyDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      logo: logo ?? this.logo,
    );
  }

  @override
  List<Object?> get props => [id, name, address, phone, email, logo];
}
