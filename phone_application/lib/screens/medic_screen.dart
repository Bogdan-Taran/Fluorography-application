import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';
import 'package:project_fluorography/bloc/search/search_bloc.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../models/staff_and_students_model.dart';
import '../services/builders_screen.dart';
import '../widgets/main_content_accordion_builder.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';

class MedicScreen extends StatefulWidget {
  const MedicScreen({super.key});

  @override
  State<MedicScreen> createState() => _MedicScreen();
}

class _MedicScreen extends State<MedicScreen> {
  // late List<StaffAndStudentsModel> filteredEntireMedicData;
  final searchController = TextEditingController();
  late List<StaffAndStudentsModel> staffAndStudentsList;

  @override
  void initState() {
    super.initState();
    (context).read<MedicBloc>().add(MedicInitialEvent());
    //searchController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  FutureOr _printLatestValue() async{
    if(searchController.text.length >= 3){
    print('Введенный текст: ${searchController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    BuildersScreen _buildersScreen = BuildersScreen();
    final appBarHeight = MediaQuery.of(context).size.height * 0.13;

    return ColorfulSafeArea(
      color: Colors.white,
        child: Scaffold(
            // AppBar
            appBar: AppBar(
              backgroundColor: Colors.white,
              flexibleSpace: Container(
                height: appBarHeight,
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                            onPressed: () {
                              context.read<AuthenticationBloc>().add(SignOutEvent());
                              print('Нажата кнопка выхода');
                            },
                            child: const Text(
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
                      ),/*
                      const SizedBox(height: 10),
                      TextField(
                        onTap: (){
                          context.read<MedicBloc>().add(OnTapTextFieldEvent());
                        },
                        // onChanged: (){
                        //   context.read<MedicBloc>().add(event)
                        // },
                        controller: searchController,
                        cursorColor: Color(0xff72A7EB),
                        cursorHeight: 25,
                        cursorWidth: 1.5,
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
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Color(0xff98BFF3), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: Color(0xff72A7EB), width: 2),
                          ),
                          hintText: 'Поиск',
                          hintStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.016,
                            color: Color(0xff98BFF3),
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 30),
                        ),
                        keyboardType: TextInputType.text,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        enableSuggestions: false,
                        autocorrect: false,
                      )*/
                    ],
                  ),
                ),
              ),
              toolbarHeight: appBarHeight,
              elevation: 0,
            ),
            body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    children: [
                      BlocSelector<MedicBloc, MedicState, List<StaffAndStudentsModel>?>(
                          selector: (state){
                            if(state is MedicLoadedCommunitySuccessfulState){
                              return state.medicEntireCommunity;
                            }
                            return null;
                          },
                          builder: (context, data){
                            if(data != null){
                              return TextField(
                                onTap: (){
                                  context.read<MedicBloc>().add(OnTapTextFieldEvent());
                                },
                                // controller: searchController,
                                onChanged: (query){
                                  print('Отправляю query: $query в движок поиска');
                                  context.read<SearchBloc>().add(
                                    SearchChangedEvent(
                                        query: query,
                                        entireGroups: data
                                    )
                                  );
                                  print('Запрос отправил');
                                },
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
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(color: Color(0xff98BFF3), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(color: Color(0xff72A7EB), width: 2),
                                  ),
                                  hintText: 'Поиск',
                                  hintStyle: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height * 0.016,
                                    color: Color(0xff98BFF3),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                                ),
                              );
                            }
                            return TextField(
                              controller: searchController,
                              decoration: InputDecoration(hintText: 'Загрузка...'),
                              onTap: (){
                                context.read<MedicBloc>().add(OnTapTextFieldEvent());
                              },
                              onChanged: (query){
                                if(query.length >= 3 ){
                                  print('Отправляю query: $query в движок поиска');
                                  context.read<SearchBloc>().add(
                                      SearchChangedEvent(
                                          query: query,
                                          entireGroups: data
                                      )
                                  );
                                  print('Запрос отправил');
                                }
                              },
                            );
                          }
                      ),
                      BlocBuilder<SearchBloc, SearchState>(builder: (context, state){
                          switch(state.runtimeType){
                            case SearchUpdatedState:
                              final successfulState = state as SearchUpdatedState;
                              final filtered = successfulState.filteredGroups.cast<StaffAndStudentsModel>();
                              print('Печатаю отфильтрованный список');
                              print(filtered);
                              // return MedicConstructorAccordionBuildWidget(medicEntireCommunity: successfulState.filteredGroups.cast<StaffAndStudentsModel>());
                            case SearchNotFoundState:
                              return Text('Отфильтрованный список пуст, ничего не найдено');
                          }
                          return Text('дефолтное значение');
                      }),
                      MultiBlocListener(
                        listeners: [
                          BlocListener<MedicBloc, MedicState>(
                            listener: (context, state) {
                              switch (state.runtimeType) {
                                case MedicLogoutSuccessfulState:
                                  print('Отработало сосотояния выхода');
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => SignInScreen(),
                                    ),
                                  );
                                  break;
                                case MedicLogoutErrorState:
                                  print('Ошибка при попытке выхода');
                                  break;
                                case MedicFetchingLoadingState:
                                  _buildersScreen.buildLoading();
                                  print('Загрузка выхода');
                                  break;

                                // case MedicOpenDatePickerState:
                                //   _buildersScreen.openDatePicker(context, );
                                //   break;
                                // case MedicCloseDatePickerState:
                                //   Navigator.of(context).pop();
                              }
                            },
                          ),
                          BlocListener<AuthenticationBloc, AuthenticationState>(
                            listener: (context, state) {
                              switch (state.runtimeType) {
                                case AuthenticationLogOutState:
                                  print('Отработало сосотояния выхода');
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => SignInScreen(),
                                    ),
                                  );
                                  break;
                                case AuthenticationLoadingState:
                                  print('Загрузка');
                                  _buildersScreen.buildLoading();
                                  break;
                              }
                            },
                          ),
                          BlocListener<
                            WorkingWithFluorographyBloc,
                            WorkingWithFluorographyState
                          >(
                            listener: (context, state) {
                              switch (state.runtimeType) {
                                case SuccessfullyPatchedSetDatesState:
                                  // здесь подставляются tempDates из главного State
                                  context.read<MedicBloc>().add(
                                    MedicFetchedNewDateSetEvent(
                                      newDateSet: state.tempDates,
                                    ),
                                  );
                              }
                            },
                          ),
                        ],
                        child: BlocBuilder<MedicBloc, MedicState>(
                          builder: (context, medicState) {
                            switch (medicState.runtimeType) {
                              case MedicFetchingLoadingState:
                                return Center(child: _buildersScreen.buildLoading());
                              case MedicFetchingErrorState:
                                return Center(child: Text('Произошла ошибка'));

                              case MedicLoadedCommunitySuccessfulState:
                                final successfulState =
                                    medicState as MedicLoadedCommunitySuccessfulState;
                                print('Печатаю лист');
                                print(successfulState.medicEntireCommunity);
                                // return MedicConstructorAccordionBuildWidget(
                                //   medicEntireCommunity: filteredEntireMedicData,
                                // );

                                return MedicConstructorAccordionBuildWidget(
                                  medicEntireCommunity: successfulState.medicEntireCommunity,
                                );
                                /*
                                return MainContentAccordionBuilder(
                                  context,
                                  role: 'medic',
                                  medicEntireCommunity:
                                      successfulState.medicEntireCommunity,
                                );*/
                              case MedicSearchState:
                                return SizedBox(
                                  height: 100,
                                );
                              default:
                                return Container(
                                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  decoration: BoxDecoration(color: Colors.transparent),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Отсутствуют сотрудники или студенты',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
    );
  }
}
