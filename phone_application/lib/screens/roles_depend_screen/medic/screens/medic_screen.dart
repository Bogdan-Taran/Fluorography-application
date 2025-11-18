import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:accordion/accordion_section.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '';

import '../../../login.dart';

class MedicScreen extends StatefulWidget {
  const MedicScreen({Key? key}) : super(key: key);


  @override
  State<MedicScreen> createState() => _MedicScreenState();
}

class _MedicScreenState extends State<MedicScreen> {
  TextEditingController searchController = TextEditingController();
  bool active = false;

  final Future<List<Group>> products = fetchGroups();




  static const headerStyle = TextStyle(
    color: Color(0xff4482D2),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const contentStyleHeader = TextStyle(
    color: Color(0xff999999),
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  static const contentStyle = TextStyle(
    color: Color(0xff999999),
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  static const loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';
  static const slogan =
      'Do not forget to play around with all sorts of colors, backgrounds, borders, etc.';

  @override
  Widget build(BuildContext context) {

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
        body: SingleChildScrollView(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              AccordionListBuild()],
          ),
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
      id: json['id'] as int,
      lastname: json['lastname'] as String,
      firstname: json['name'] as String,
      patronymic: json['patronymic'] as String,
      dateFluorography: json['fluorography'] != null ? DateTime.tryParse(json['fluorography'] as String) : null,
      group: json['group'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lastname': lastname,
    'firstname': firstname,
    'patronymic': patronymic,
    'dateFluorography': dateFluorography?.toIso8601String(),
    'group': group,
  };
}




// получение всех групп по API
Future<List<Group>> fetchGroups() async {

  const String _baseurl = 'http://192.168.13.19';
  const String _loginUrl = '$_baseurl/api/login';
  final loginResponse = await http.post(
      Uri.parse(_loginUrl),
      body: {'login': 'hom', 'password': '57020594'}
  );

  if(loginResponse.statusCode != 200){
    throw Exception('Неверный логин или пароль');
  }

  final loginData = jsonDecode(loginResponse.body);
  final token = loginData['token'] as String?;
  if(token == null) throw Exception('Токен не получен');

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


    final List<Group> groups = jsonList
        .whereType<Map<String, dynamic>>()
        .map((map) => Group.fromJson(map))
        .toList();

    print('Всего групп: ${groups.length}');

    for (var group in groups){
      print('ID: ${group.id},\nNumber: ${group.number}');
    }
    return groups;

  } else {
    print('Error - not 200');
    throw Exception('HTTP ${response.statusCode}: ${response.body}');
  }
}




// экземпляр для одной группы (модель данных)
class Group {
  final int id; // определяем свойста которые соответствуют полям в нашем json
  final String number;

  Group({required this.id, required this.number});

  factory Group.fromJson(Map<String, dynamic> json){
    return Group(
      id: json['id'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'number': number,
    };
  }
}






//конструктор для построения Аккордионов
class AccordionListBuild extends StatelessWidget {
  final List<AccordionSection> accordions = [
    createOneAccordionSection.buildAccordionSection('321', '12'),
    createOneAccordionSection.buildAccordionSection('321', '12'),
  ];

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
      children: accordions,
    );
  }
}

// конструктор для создания одной accordion section
class createOneAccordionSection {
  static AccordionSection buildAccordionSection(
    String groupNumber,
    String numberOfStudents,
  ) {
    return AccordionSection(
      isOpen: false,
      paddingBetweenClosedSections: 30,
      paddingBetweenOpenSections: 30,
      header: Row(
        children: [
          Text('Группа ${groupNumber}'),
          SizedBox(width: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Color(0xffF29393),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [Text(numberOfStudents), Icon(Icons.man_outlined)],
            ),
          ),
        ],
      ),
      contentHorizontalPadding: 40,
      contentVerticalPadding: 20,
      content: const StudentsFIODate(),
    );
  }
}

//конструтор для построения содержимого аккордиона
class StudentsFIODate extends StatelessWidget {
  const StudentsFIODate({super.key});

  @override
  Widget build(context) {
    return Column(
      children: [
        ColumnStudentFIODate(),
        ElevatedButton(onPressed: () {}, child: const Text('Редактировать')),
      ],
    );
  }
}

//конструктор для построения столбца студентов из таблиц
class ColumnStudentFIODate extends StatelessWidget {
  final List<Widget> rows = [
    RowStudentBuilder.buildRowFromStrings(
      'Фамилия',
      'Имя',
      'Отчество',
      '01.01.2003',
      true,
    ),
    RowStudentBuilder.buildRowFromStrings(
      'Фамилия',
      'Имя',
      'Отчество',
      '01.01.2003',
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: rows);
  }
}

// конструктор для построения строки для одного студента
class RowStudentBuilder {
  static Row buildRowFromStrings(
    String lastname,
    String name,
    String patronumic,
    String dateFluorography,
    bool isOverdue, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
    double spacing = 8,
  }) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Text(lastname),
        SizedBox(width: spacing),
        Text(name),
        SizedBox(width: spacing),
        Text(patronumic),
        SizedBox(width: spacing),
        Container(
          decoration: BoxDecoration(
            color: isOverdue ? Colors.red : Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Text(dateFluorography),
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
                    color: Color(0xff98BFF3),
                    iconSize: 45,
                    onPressed: () {},
                    icon: Icon(Icons.notifications_none_outlined),
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
              TextField(
                // controller: searchController,
                cursorColor: Color(0xff72A7EB),
                cursorHeight: 17,
                cursorWidth: 1.2,
                decoration: InputDecoration(
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
                    fontSize: ResponsiveSizes.getfontSizeSmall(
                      context,
                      baseSize: AppSizes.fontSizeSmall,
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

// classo
//
//
// class GetDataToExpansionCardFromApi {
//   int group_number;
//   String lastname_student;
//   String name_student;
//   String patroymic;
//   String date_fluorography;
//   int number_of_students_in_group;
//
//
//
//
// }

// class OneCardToExpand extends StatelessWidget {
//   OneCardToExpand(
//   {@
//   required
//   this.title,
//     this.
//   })
//
//
//
//   OneCardToExpand({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column();
//   }
// }
