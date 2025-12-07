//класс для построения 1 единицы студента
class Student {
  final int id;
  final String lastname;
  final String firstname;
  final String patronymic;
  final DateTime? dateFluorography;
  final String group;

  Student({
    required this.id,
    required this.lastname,
    required this.firstname,
    required this.patronymic,
    this.dateFluorography,
    required this.group,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int? ?? 0,
      lastname: json['lastname'] as String? ?? '',
      firstname: json['firstname'] as String? ?? '',
      patronymic: json['patronymic'] as String? ?? '',
      dateFluorography: _parseDateTime(json['fluorography']),
      group: json['group'] as String? ?? '',
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lastname': lastname,
    'firstname': firstname,
    'patronymic': patronymic,
    'dateFluorography': dateFluorography?.toIso8601String().split('T').first,
    'group': group,
  };

  String get searchKey =>
      '$lastname $firstname $patronymic $group'.toLowerCase();

  //паттерн для изменения только нужных нам полей (только дата флюры и пр)
  //объект как бы чуть перерисовывается
  Student copyWith({
    int? id,
    String? lastname,
    String? firstname,
    String? patronymic,
    DateTime? dateFluorography,
    String? group,
  }) {
    return Student(
      id: id ?? this.id,
      lastname: lastname ?? this.lastname,
      firstname: firstname ?? this.firstname,
      patronymic: patronymic ?? this.patronymic,
      dateFluorography: dateFluorography ?? this.dateFluorography,
      group: group ?? this.group,
    );
  }
}

// экземпляр для одной группы (модель данных). Она записылвается в список.
class Group {
  final int id; // определяем свойста которые соответствуют полям в нашем json
  final String number;

  Group({required this.id, required this.number});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(id: json['id'], number: json['number']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'number': number};
  }

  Group copyWith({int? id, String? number}) {
    return Group(id: id ?? this.id, number: number ?? this.number);
  }
}

// структурная модель для 1 экземпляра "группа и студенты"
class GroupWithStudents {
  final String groupNumber;
  final List<Student> students;

  GroupWithStudents({required this.groupNumber, required this.students});

  // конструктор для пустой группы, до загрузки
  factory GroupWithStudents.initial(String groupNumber) {
    return GroupWithStudents(groupNumber: groupNumber, students: []);
  }

  //конструктор-копия с обновлёнными студентами
  GroupWithStudents copyWith({String? groupNumber, List<Student>? students}) {
    return GroupWithStudents(
      groupNumber: groupNumber ?? this.groupNumber,
      students: students ?? this.students,
    );
  }
}

//Модель для роли пользователя
enum UserRole { medic, curator, administrator, student, employee }

class User {
  final String login;
  final UserRole role;
  final String? group;

  User({required this.login, required this.role, this.group});
}
