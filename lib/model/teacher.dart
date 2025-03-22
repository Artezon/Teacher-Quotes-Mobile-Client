class Teacher {
  final int id;
  final String fullname;

  Teacher({required this.id, required this.fullname});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      fullname: json['fullname'],
    );
  }
}