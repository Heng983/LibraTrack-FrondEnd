class AdminModel {
  final int id;
  final String name;
  final String adminId;
  final DateTime? lastLoginAt;

  AdminModel({
    required this.id,
    required this.name,
    required this.adminId,
    this.lastLoginAt,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      adminId: json['admin_id'] ?? '',
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'].toString())
          : null,
    );
  }
}
