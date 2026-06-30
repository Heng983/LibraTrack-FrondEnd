class StudentModel {
  final int id;
  final String name;
  final String studentId;
  final String email;
  final String? department;
  final String? profileImage;

  StudentModel({
    required this.id,
    required this.name,
    required this.studentId,
    required this.email,
    this.department,
    this.profileImage,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      studentId: json['student_id'],
      email: json['email'],
      department: json['department'],
      profileImage: json['profile_image'],
    );
  }
}
