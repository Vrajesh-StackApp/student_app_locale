const String tableStudent = 'students';

class StudentFields {
  static const String id = 'uid';
  static const String marks = 'marks';
  static const String name = 'name';
  static const String studentId = 'studentId';
}

class Student {
  int? studentId;
  String? name;
  int? marks;
  String? id;
  int? rank = 0;

  static Student fromJson(Map<String, Object?> json) => Student(
    json[StudentFields.name] as String,
    json[StudentFields.studentId] as int,
    json[StudentFields.marks] as int,
    json[StudentFields.id] as String,
  );

  Map<String, Object?> toJson() => {
    StudentFields.id: id,
    StudentFields.name: name,
    StudentFields.marks: marks,
    StudentFields.studentId: studentId,
  };

  Student(this.name, this.studentId, this.marks, this.id);
  @override
  String toString() {
    return '{ $name, $studentId,$marks ,$rank, $id}';
  }
}
