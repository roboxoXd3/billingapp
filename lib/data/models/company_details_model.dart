import '../../domain/entities/company_details.dart';

class CompanyDetailsModel extends CompanyDetails {
  const CompanyDetailsModel({
    super.id,
    required super.name,
    required super.address,
    required super.phone,
    required super.email,
    super.logo,
  });

  factory CompanyDetailsModel.fromMap(Map<String, dynamic> map) {
    return CompanyDetailsModel(
      id: map['id'],
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      logo: map['logo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      if (logo != null) 'logo': logo,
    };
  }

  factory CompanyDetailsModel.fromEntity(CompanyDetails entity) {
    return CompanyDetailsModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      phone: entity.phone,
      email: entity.email,
      logo: entity.logo,
    );
  }

  @override
  CompanyDetailsModel copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? logo,
  }) {
    return CompanyDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      logo: logo ?? this.logo,
    );
  }
}
