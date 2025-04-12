// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:admin_kdv/constants/app_constants.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    this.id,
    this.imagePath,
    this.name,
    this.role,
    this.villNumber,
    this.lineNumber,
    this.email,
    this.mobileNumber,
    this.password,
    this.isVillaOpen,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      imagePath: json['image_path'] as String?,
      name: json['name'] as String?,
      role: json['role'] as String?,
      villNumber: json['villa_number'] as String?,
      lineNumber: json['line_number'] as String?,
      email: json['email'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      password: json['password'] as String?,
      isVillaOpen: json['is_villa_open'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  final String? id;
  final String? imagePath;
  final String? name;
  final String? role;
  final String? villNumber;
  final String? lineNumber;
  final String? email;
  final String? mobileNumber;
  final String? password;
  final String? isVillaOpen;
  final String? createdAt;
  final String? updatedAt;

  UserModel copyWith({
    String? id,
    String? imagePath,
    String? name,
    String? role,
    String? villNumber,
    String? lineNumber,
    String? email,
    String? mobileNumber,
    String? password,
    String? isVillaOpen,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      role: role ?? this.role,
      villNumber: villNumber ?? this.villNumber,
      lineNumber: lineNumber ?? this.lineNumber,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      password: password ?? this.password,
      isVillaOpen: isVillaOpen ?? this.isVillaOpen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'image_path': imagePath,
        'name': name,
        'role': role,
        'villa_number': villNumber,
        'line_number': lineNumber,
        'email': email,
        'mobile_number': mobileNumber,
        'password': password,
        'is_villa_open': isVillaOpen,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  @override
  List<Object?> get props => [
        id,
        imagePath,
        name,
        role,
        villNumber,
        lineNumber,
        email,
        mobileNumber,
        password,
        isVillaOpen,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;

  String get userLineViewString {
    switch (lineNumber) {
      case AppConstants.firstLine:
        return 'First line';
      case AppConstants.secondLine:
        return 'Second line';
      case AppConstants.thirdLine:
        return 'Third line';
      case AppConstants.fourthLine:
        return 'Fourth line';
      case AppConstants.fifthLine:
        return 'Fifth line';
      default:
        return 'First line';
    }
  }

  String get userRoleViewString {
    switch (role) {
      case AppConstants.admin:
        return 'Admin';
      case AppConstants.lineLead:
        return 'Line head';
      case AppConstants.lineMember:
        return 'Line member';
      default:
        return 'Admin';
    }
  }
}
