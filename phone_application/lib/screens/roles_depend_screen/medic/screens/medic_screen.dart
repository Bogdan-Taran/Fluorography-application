import 'dart:convert';
import 'dart:core';

import 'package:accordion/accordion.dart';
import 'package:accordion/accordion_section.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '';

import '../../../login.dart';

class MedicScreen extends StatefulWidget {
  const MedicScreen({Key? key}) : super(key: key);

  @override
  State<MedicScreen> createState() => _MedicScreenState();
}

class _MedicScreenState extends State<MedicScreen> {
  late final Future<List<GroupWithStudents>> _futureGroups;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureGroups = fetchAllGroupsWithStudents();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }



  static const countTextStyle = TextStyle(
    fontWeight: FontWeight.w300,
    color: Color(0xff26292B),
    fontFamily: 'Geologica',
    fontSize: AppSizes.fontSizeSmall,
  );



  @override
  Widget build(BuildContext context) {
    // TextStyle layout example
    final TextStyle headerStyle = TextStyle(
      color: Color(0xff4482D2),
      fontSize: ResponsiveSizes.getFontSizeMedium(
          context,
          baseSize: AppSizes.fontSizeMedium
      ),
      fontWeight: FontWeight.w300,
      fontFamily: 'Geologica',
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black54,
        // statusBarBrightness: Brightness.light,
        // statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: AppBarContent(),
          ),
        ),

        backgroundColor: Color(0xFFFFFFFF),
        body: FutureBuilder<List<GroupWithStudents>>(
          future: _futureGroups,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingAnimationWidget.halfTriangleDot(
                      color: const Color(0xff98BFF3),
                      size: 60
                  ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка загрузки: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureGroups = fetchAllGroupsWithStudents();
                        });
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Нет данных', style: TextStyle(color: Colors.grey)),
              );
            } else {
              final groups = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: AccordionListBuild(groups: groups),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

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
      firstname: json['name'] as String? ?? '',
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
}

// получение всех групп по API
Future<List<Group>> fetchGroups() async {
  const String _baseurl = 'http://192.168.13.19';
  //const String _baseurl = 'https://176.65.60.218:40003';  //external url
  const String _loginUrl = '$_baseurl/api/login';
  final loginResponse = await http.post(
    Uri.parse(_loginUrl),
    body: {'login': 'hom', 'password': '57020594'},
  );

  if (loginResponse.statusCode != 200) {
    throw Exception('Неверный логин или пароль');
  }

  final loginData = jsonDecode(loginResponse.body);
  final token = loginData['token'] as String?;
  if (token == null) throw Exception('Токен не получен');

  // save token
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
  print(token);

  //get groups
  final response = await http.get(
    Uri.parse('http://192.168.13.19/api/groups'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    //final jsonData = json.decode(response.body);

    final List<Group> groups =
        jsonList //типизированный список с объектом Group (из класса ниже который мы определили)
            .whereType<Map<String, dynamic>>()
            .map((map) => Group.fromJson(map))
            .toList();

    print('Всего групп: ${groups.length}');

    for (var group in groups) {
      print('ID: ${group.id},\nNumber: ${group.number}');
    }
    print('Печатаю группу с индексом 1: ${groups[1].number}'); // для отладки
    return groups;
  } else {
    print('Error - not 200');
    throw Exception('HTTP ${response.statusCode}: ${response.body}');
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
  GroupWithStudents copyWith({List<Student>? students}) {
    return GroupWithStudents(
      groupNumber: groupNumber,
      students: students ?? this.students,
    );
  }
}

// сбор всех данных
Future<List<GroupWithStudents>> fetchAllGroupsWithStudents() async {
  //получаем список групп
  final List<Group> groups = await fetchGroups();

  // здесь хранится данные в формате "группа, студенты"
  final List<GroupWithStudents> result = [];

  for (final group in groups) {
    try {
      // делаем запрос студентов по API
      final List<Student> students = await fetchStudentByGroupNumber(
        group.number,
      );

      // и добавляем в главный список
      result.add(
        GroupWithStudents(groupNumber: group.number, students: students),
      );
    } catch (e) {
      print('Ошибка загрузки студентов для группы ${group.number}: $e');
      result.add(GroupWithStudents.initial(group.number));
    }
  }

  for (var group in result) {
    print('Group: ${group.groupNumber}');
    for (final student in group.students) {
      print('Lastname: ${student.lastname}');
    }
  }
  return result;
}

// API запрос на получение списка студентов по группе
Future<List<Student>> fetchStudentByGroupNumber(String groupNumber) async {
  // получаем токен из памяти
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('auth_token');

  final response = await http.get(
    Uri.parse('http://192.168.13.19/api/students?group=$groupNumber'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    print('Запрос успешен - 200');
    final List<dynamic> rawList = jsonDecode(response.body);
    return rawList
        .whereType<Map<String, dynamic>>()
        .map((json) => Student.fromJson(json))
        .toList();
  } else {
    throw Exception('HTTP ${response.statusCode}');
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
}

//конструктор для построения Виджета аккордион
class AccordionListBuild extends StatelessWidget {
  final List<GroupWithStudents> groups;

  const AccordionListBuild({super.key, required this.groups});


  @override
  Widget build(BuildContext context) {
    return Accordion(
      headerBorderColor: Color(0xffD4EAFF),
      headerBorderColorOpened: Color(0xffD4EAFF),
      headerBorderWidth: 1,
      headerBackgroundColorOpened: Colors.transparent,
      headerBackgroundColor: Colors.white,
      rightIcon: Icon(
        Icons.arrow_drop_down,
        size: 50,
        color: Color(0xffD4EAFF),
      ),
      contentBackgroundColor: Colors.white,
      contentBorderColor: Color(0xffD4EAFF),
      contentBorderWidth: 1,
      contentHorizontalPadding: 5,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      headerBorderRadius: 30,
      children: _buildAccordionSections(),
    );
  }

  List<AccordionSection> _buildAccordionSections() {
    return groups.map((groupData) {
      return createOneAccordionSection.buildAccordionSection(
        groupNumber: groupData.groupNumber,
        numberOfStudents: groupData.students.length.toString(),
        students: groupData.students,
      );
    }).toList();
  }
}

// конструктор для создания одной accordion section
class createOneAccordionSection {
  bool _isOpen = false;
  static AccordionSection buildAccordionSection({
    required String groupNumber,
    required String numberOfStudents,
    required List<Student> students,
  }) {
    return AccordionSection(
      isOpen: false,
      paddingBetweenClosedSections: 30,
      paddingBetweenOpenSections: 30,
      header: _buildHeader(groupNumber, numberOfStudents),
      contentHorizontalPadding: 40,
      contentVerticalPadding: 20,
      content: StudentsFIODate(students: students),
    );
  }

  static Widget _buildHeader(String groupNumber, String count) {
    return Row(
      children: [
        Text(
          'Группа $groupNumber',
          style: headerStyle,
        ),
        SizedBox(width: 30),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xffF29393),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(count, style: _MedicScreenState.countTextStyle),
              const SizedBox(width: 4),
              Icon(Icons.people, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

//конструтор для построения содержимого аккордиона
class StudentsFIODate extends StatelessWidget {
  final List<Student> students;

  const StudentsFIODate({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColumnStudentFIODate(students: students),
        const SizedBox(height: 15),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit),
          label: const Text('Редактировать группу'),
        ),
      ],
    );
  }
}

//конструктор для построения столбца студентов из таблиц
class ColumnStudentFIODate extends StatelessWidget {
  final List<Student> students;

  const ColumnStudentFIODate({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Студенты не найдены',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return Column(
      children: students.map((student) {
        final dateStr = _formatDate(student.dateFluorography);
        final isOverdue = _isFluoroOverdue(student.dateFluorography);

        return RowStudentBuilder.buildRowFromStudent(
          student: student,
          formattedDate: dateStr,
          isOverdue: isOverdue,
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  bool _isFluoroOverdue(DateTime? date) {
    if (date == null) return true;
    final validUntil = date.add(const Duration(days: 365));
    return DateTime.now().isAfter(validUntil);
  }
}

// конструктор для построения строки для одного студента
class RowStudentBuilder {
  static Row buildRowFromStudent({
    required Student student,
    required String formattedDate,
    required bool isOverdue,
  }) {
    return buildRowFromStrings(
      lastname: student.lastname,
      name: student.firstname,
      patronymic: student.patronymic,
      dateFluorography: formattedDate,
      isOverdue: isOverdue,
    );
  }

  static Row buildRowFromStrings({
    required String lastname,
    required String name,
    required String patronymic,
    required String dateFluorography,
    required bool isOverdue,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
    double spacing = 8,
  }) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Expanded(child: Text(lastname, overflow: TextOverflow.ellipsis)),
        SizedBox(width: spacing),
        Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
        SizedBox(width: spacing),
        Expanded(child: Text(patronymic, overflow: TextOverflow.ellipsis)),
        SizedBox(width: spacing),
        Container(
          decoration: BoxDecoration(
            color: isOverdue
                ? Colors.red.shade300
                : Colors.lightBlueAccent.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Text(
              dateFluorography,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isOverdue ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//содержимое AppBar (кнопка уведомления и кнопка)
class AppBarContent extends StatelessWidget {
  AppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // кнопка уведомления
                  IconButton(
                    //iconSize: 35,
                    onPressed: () {},
                    splashRadius: 24,
                    padding: EdgeInsets.zero,
                    icon: SvgPicture.asset(
                      'assets/images/notification_icon.svg',
                      color: const Color(0xff98BFF3),
                      width: 35,
                      height: 35,
                    )
                  ),

                  // кнопка выхода
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStateProperty.resolveWith<double>((
                        Set<WidgetState> states,
                      ) {
                        return 0;
                      }),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return Color(0xffD5D6D7);
                        }
                        if (states.contains(WidgetState.pressed)) {
                          return Color(0xFF72A7EB);
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return Color(0xFFBADEFF);
                        }
                        return Color(0xff98BFF3);
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return Color(0xFF888888);
                        }
                        return Color(0xffffffff);
                      }),
                      minimumSize: WidgetStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.1, 35),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Выход',
                      style: TextStyle(
                        fontSize: ResponsiveSizes.getFontSizeMedium(
                          context,
                          baseSize: AppSizes.fontSizeMedium,
                        ),
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Geologica',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                // controller: searchController,
                cursorColor: Color(0xff72A7EB),
                cursorHeight: 17,
                cursorWidth: 1.2,

                decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                    child: SvgPicture.asset(
                      'assets/images/serch_icon.svg',
                      width: 20,
                      height: 20,
                      color: const Color(0xff98BFF3),
                    ),
                  ),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xff98BFF3),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xff72A7EB), width: 2),
                  ),
                  hintText: 'Поиск',
                  hintStyle: TextStyle(
                    fontSize: ResponsiveSizes.getFontSizeMedium(
                      context,
                      baseSize: AppSizes.fontSizeMedium,
                    ),
                    color: Color(0xff999A9B),
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                ),
                keyboardType: TextInputType.text,
                // maxLength: 25,
                maxLines: 1,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                // obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Icon(Icons.search_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
