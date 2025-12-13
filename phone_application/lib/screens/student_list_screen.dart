import 'dart:async';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/student_bloc.dart';
import '../bloc/events.dart';
import '../bloc/states.dart';
import '../models/student_models.dart';
import '../widgets/student_widgets.dart';

class StudentListScreen extends StatefulWidget {
  final UserRole role;
  final List<String> curatorGroup; // для куратора

  const StudentListScreen({Key? key, required this.role, required this.curatorGroup})
    : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
    searchController.addListener(_onSearchChanged);
  }

  void _loadData() {
    switch (widget.role) {
      case UserRole.medic:
        context.read<StudentBloc>().add(LoadAllStudents());
        break;
      case UserRole.curator:
        if (widget.curatorGroup != null) {
          context.read<StudentBloc>().add(
            LoadCuratorStudents(widget.curatorGroup),
          );
        }
        break;
      case UserRole.administrator:
        context.read<StudentBloc>().add(LoadAdminStudents());
        break;
      case UserRole.student:
        // TODO: Handle this case.
        throw UnimplementedError();
      case UserRole.employee:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      final query = searchController.text.trim().toLowerCase();
      context.read<StudentBloc>().add(SearchStudents(query));
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black54,
      ),
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: const Color(0xFFFFFFFF),
        body: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return _buildLoading();
            } else if (state is StudentError) {
              return _buildError(state.message);
            } else if (state is StudentLoaded) {
              return _buildContent(state.groups);
            } else if (state is StudentFiltered) {
              return _buildContent(state.filteredGroups);
            } else if (state is StudentEditState) {
              // Обрабатываем состояние редактирования
              return _buildContent(state.groups);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            bool isLogoutLoading = authState is AuthLogoutLoading;
            return AppBarContent(
              searchController: searchController,
              onLogout: () {
                if (!isLogoutLoading) {
                  context.read<AuthBloc>().add(LogoutRequested());
                }
              },
              isLogoutLoading: isLogoutLoading,
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: LoadingAnimationWidget.halfTriangleDot(
        color: const Color(0xff98BFF3),
        size: 60,
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Ошибка: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _loadData(),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<GroupWithStudents> groups) {
    // Проверяем, в каком состоянии находится блок
    bool isEditing = false;
    if (context.read<StudentBloc>().state is StudentEditState) {
      final state = context.read<StudentBloc>().state as StudentEditState;
      isEditing = state.isEditing;
    }

    if (groups.isEmpty) {
      return const Center(
        child: Text(
          'Нет данных',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: _buildAccordionList(groups, isEditing), // передаем isEditing
      ),
    );
  }

  Widget _buildAccordionList(List<GroupWithStudents> groups, bool isEditing) {
    return Accordion(
      headerBorderColor: const Color(0xffD4EAFF),
      headerBorderColorOpened: const Color(0xffD4EAFF),
      headerBorderWidth: 1,
      headerBackgroundColorOpened: Colors.transparent,
      headerBackgroundColor: Colors.white,
      rightIcon: SvgPicture.asset(
        'assets/images/icon_expand_down.svg',
        height: 14,
        width: 6,
      ),
      contentBackgroundColor: Colors.white,
      contentBorderColor: const Color(0xffD4EAFF),
      contentBorderWidth: 1,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      disableScrolling: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      headerBorderRadius: 30,
      children: groups.map((groupData) {
        return AccordionSection(
          isOpen: false,
          paddingBetweenClosedSections: 30,
          paddingBetweenOpenSections: 30,
          header: GroupHeaderWidget(
            groupNumber: groupData.groupNumber,
            studentCount: groupData.students.length,
          ),
          contentHorizontalPadding: 12,
          contentVerticalPadding: 12,
          content: _buildGroupContent(groupData.students, isEditing),
        );
      }).toList(),
    );
  }

  Widget _buildGroupContent(List<Student> students, bool isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (students.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Студенты не найдены',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          Column(
            children: students.map((student) =>
                StudentRowWidget(
                  student: student,
                  isEditing: isEditing,
                  onDateUpdate: (student, newDate) {
                    // Обновляем дату через Bloc
                    context.read<StudentBloc>().add(
                      UpdateFluorographyDate(student.id, newDate),
                    );
                  },
                )
            ).toList(),
          ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            // Переключаем режим редактирования
            if (isEditing) {
              // Если выходим из режима редактирования
              context.read<StudentBloc>().add(CancelEditMode());
            } else {
              // Если входим в режим редактирования
              context.read<StudentBloc>().add(ToggleEditMode(true));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff98BFF3),
          ),
          child: Text(
            isEditing ? 'Готово' : 'Редактировать',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xffffffff),
              fontFamily: 'Geologica',
            ),
          ),
        ),
      ],
    );
  }
}

class AppBarContent extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback? onLogout;
  final bool isLogoutLoading;

  const AppBarContent({
    Key? key,
    required this.searchController,
    this.onLogout,
    this.isLogoutLoading = false,
  }) : super(key: key);

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
                  IconButton(
                    onPressed: () {},
                    splashRadius: 24,
                    padding: EdgeInsets.zero,
                    icon: SvgPicture.asset(
                      'assets/images/notification_icon.svg',
                      color: const Color(0xff98BFF3),
                      width: 35,
                      height: 35,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return const Color(0xffD5D6D7);
                        }
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xFF72A7EB);
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return const Color(0xFFBADEFF);
                        }
                        return const Color(0xff98BFF3);
                      }),
                      foregroundColor: WidgetStateProperty.all(
                        const Color(0xffffffff),
                      ),
                      minimumSize: WidgetStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.1, 35),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: isLogoutLoading ? null : onLogout,
                    child: isLogoutLoading
                        ? Center(
                            child: LoadingAnimationWidget.halfTriangleDot(
                              color: const Color(0xff98BFF3),
                              size: 60,
                            ),
                          )
                        : const Text(
                            'Выход',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Geologica',
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: searchController,
                cursorColor: const Color(0xff72A7EB),
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color(0xff98BFF3),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color(0xff72A7EB),
                      width: 2,
                    ),
                  ),
                  hintText: 'Поиск',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff98BFF3),
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                ),
                keyboardType: TextInputType.text,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
