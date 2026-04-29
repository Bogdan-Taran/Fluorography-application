import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/services/api_reference/request_reference_controller.dart';
import 'package:project_fluorography/styles.dart';
import 'package:talker/talker.dart';
import '../../models/get_reference_model/get_reference_model.dart';
import '../../widgets/expansion_tile.dart' as expansion_tile;

class SecretaryScreenReference extends ConsumerStatefulWidget {
  const SecretaryScreenReference({super.key});

  @override
  ConsumerState<SecretaryScreenReference> createState() => _SecretaryScreenReference();
}

class _SecretaryScreenReference extends ConsumerState<SecretaryScreenReference> {
  final Map<int, bool> _isExpandedTile = {};
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = ref.watch(groupedApplicationsByGroup);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final talker = Talker();

    final List<String> itemsStatusId = [
      'В процессе',
      'Готово',
      'Дубликат',
    ];
    final valueListenable = ValueNotifier<String?>(null);
    bool editStatusMode = false;

    ref.listen<AsyncValue<void>>(updateReferenceStatusControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Ошибка'),
              content: Text(error.toString()),
            ),
          );
        },
        data: (_) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Успешно'),
              content: Text('Статус успешно изменен'),
            ),
          );
        },
      );
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: ColorfulSafeArea(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: AppStyle.whiteColorMain,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 80,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  setState(() {});
                },
                cursorColor: const Color(0xff72A7EB),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/images/serch_icon.svg',
                      width: 20,
                      height: 20,
                      color: const Color(0xff98BFF3),
                    ),
                  ),
                  hintText: 'Поиск',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff26292B),
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: IgnorePointer(
                  child: Stack(
                    children: [
                      Align(
                        alignment: const Alignment(1, -1),
                        child: SvgPicture.asset(
                          'assets/images/vectorRight.svg',
                          semanticsLabel: 'Top SVG Image',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Align(
                        alignment: const Alignment(1, 0.5),
                        child: SvgPicture.asset(
                          'assets/images/vectorLine.svg',
                          semanticsLabel: 'Top SVG Image',
                          fit: BoxFit.fill,
                          width: screenWidth,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SvgPicture.asset(
                          'assets/images/vectorBottom.svg',
                          fit: BoxFit.fitWidth,
                          width: screenWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: groupedData.when(
                  data: (data) {
                    final query = _searchController.text.toLowerCase();
                    final groups = data.keys.where((groupName) {
                      if (query.length < 3) return true;
                      if (groupName.toLowerCase().contains(query)) return true;
                      final students = data[groupName]!;
                      return students.any((s) =>
                          s.firstname.toLowerCase().contains(query) ||
                          s.lastname.toLowerCase().contains(query));
                    }).toList();

                    if (groups.isEmpty) return const Center(child: Text('Нет справок'));

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final groupName = groups[index];
                        final students = data[groupName]!;
                        final bool groupHasActiveReferences = students.any((s) => s.status_id == 1);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: expansion_tile.ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Группа $groupName',
                                  style: const TextStyle(
                                    color: AppStyle.blueColorTextTitle,
                                    fontSize: AppStyle.fontSizeMedium_16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                  decoration: groupHasActiveReferences
                                      ? BoxDecoration(
                                          color: AppStyle.redColorTag,
                                          borderRadius: BorderRadius.circular(10),
                                        )
                                      : BoxDecoration(
                                          color: AppStyle.blueColorAdditional4AABDB,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${students.length}',
                                          style: const TextStyle(
                                            color: AppStyle.whiteColorMain,
                                            fontSize: AppStyle.fontSizeSmall_12,
                                          )),
                                      SvgPicture.asset(
                                        'assets/images/people_icon.svg',
                                        color: AppStyle.whiteColorMain,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1)),
                            trailing: SvgPicture.asset(
                              _isExpandedTile[index] == true
                                  ? 'assets/images/icon_expand_down2.svg'
                                  : 'assets/images/icon_expand_right.svg',
                            ),
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _isExpandedTile[index] = expanded;
                              });
                            },
                            children: students.map((student) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0x330088cc), width: 1))),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.0015),
                                  title: Text(
                                    '${student.firstname} ${student.lastname}',
                                    style: const TextStyle(
                                      color: AppStyle.blackColorMain,
                                      fontSize: AppStyle.fontSizeMedium_16,
                                    ),
                                  ),
                                  trailing: (student.status_id == 1)
                                      ? SvgPicture.asset(
                                          'assets/icon/reference_warn.svg',
                                          width: screenWidth * 0.05,
                                        )
                                      : const SizedBox(),
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setDialogState) {
                                            return AlertDialog(
                                              backgroundColor: Colors.transparent,
                                              contentPadding: EdgeInsets.zero,
                                              titlePadding: EdgeInsets.zero,
                                              title: Stack(
                                                children: [
                                                  Container(
                                                    width: double.maxFinite,
                                                    decoration: const BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1),
                                                        ),
                                                        color: Color(0xffffffff),
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(50),
                                                          topRight: Radius.circular(50),
                                                        )),
                                                    padding: const EdgeInsets.only(bottom: 10, top: 32, left: 32),
                                                    child: const Text(
                                                      'История справок',
                                                      style: TextStyle(
                                                        fontSize: AppStyle.fontSizeExtraLarge,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppStyle.blackColorMain,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 20,
                                                    top: 20,
                                                    child: IconButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: AppStyle.blueColorAdditional4AABDB,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: Container(
                                                decoration: const BoxDecoration(
                                                    color: Color(0xffFDFDFD),
                                                    borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(50),
                                                      bottomRight: Radius.circular(50),
                                                    )),
                                                padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                                                child: SizedBox(
                                                  width: double.maxFinite,
                                                  height: screenHeight * 0.45,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      ListTile(
                                                        contentPadding: EdgeInsets.zero,
                                                        title: Text(
                                                          '${student.lastname} ${student.firstname} ${student.patronymic}',
                                                          style: const TextStyle(color: AppStyle.blueColorTextTitle),
                                                        ),
                                                        subtitle: Text('группа ${student.group}, ${student.phone}'),
                                                      ),
                                                      Expanded(
                                                        child: Consumer(
                                                          builder: (context, ref, child) {
                                                            final historyDataAsync = ref.watch(fetchStudentApplications(student.user_id));
                                                            return historyDataAsync.when(
                                                              data: (data) {
                                                                if (data.isEmpty) {
                                                                  return const Text(
                                                                    'У этого студента нет истории заявок',
                                                                    style: TextStyle(
                                                                        color: AppStyle.blackColorMain,
                                                                        fontSize: AppStyle.fontSizeSmall_12),
                                                                  );
                                                                }
                                                                return ListView.builder(
                                                                    padding: EdgeInsets.zero,
                                                                    itemCount: data.length,
                                                                    itemBuilder: (context, index) {
                                                                      final item = data[index];
                                                                      return Container(
                                                                        decoration: const BoxDecoration(
                                                                            border: Border(
                                                                                bottom: BorderSide(
                                                                                    color: AppStyle.collapsedBlueColorD4EAFF,
                                                                                    width: 1))),
                                                                        child: ListTile(
                                                                            contentPadding: EdgeInsets.zero,
                                                                            title: Text(item.type_id.applicationTypeName,
                                                                                style: const TextStyle(
                                                                                    color: AppStyle.blackColorMain,
                                                                                    fontSize: AppStyle.fontSizeMediumMini_14,
                                                                                    fontWeight: FontWeight.w500)),
                                                                            subtitle: Text(item.date,
                                                                                style: const TextStyle(
                                                                                    color: AppStyle.blueColorTextTitle,
                                                                                    fontSize: AppStyle.fontSizeSmall_12,
                                                                                    fontWeight: FontWeight.w500)),
                                                                            trailing: DropdownButtonHideUnderline(
                                                                              child: DropdownButton2<String>(
                                                                                isExpanded: true,
                                                                                hint: Container(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                                                                                  decoration: BoxDecoration(
                                                                                      color: item.status_id.statusColor,
                                                                                      borderRadius: BorderRadius.circular(10)
                                                                                  ),
                                                                                  child: Text(
                                                                                      item.status_id.statusName,
                                                                                      style: const TextStyle(
                                                                                          color: AppStyle.whiteColorMain,
                                                                                          fontSize: AppStyle.fontSizeSmall_12,
                                                                                          fontWeight: FontWeight.w500
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                items: itemsStatusId.map((String itemStatus) => DropdownItem<String>(
                                                                                    value: itemStatus,
                                                                                    height: 40,
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                                                                                      decoration: BoxDecoration(
                                                                                          color: AppStyle.collapsedBlueColorD4EAFF,
                                                                                          borderRadius: BorderRadius.circular(10)
                                                                                      ),
                                                                                      child: Text(
                                                                                          itemStatus,
                                                                                          style: const TextStyle(
                                                                                              color: AppStyle.whiteColorMain,
                                                                                              fontSize: AppStyle.fontSizeSmall_12,
                                                                                              fontWeight: FontWeight.w500
                                                                                          )
                                                                                      ),
                                                                                    )
                                                                                )).toList(),
                                                                                onChanged: editStatusMode ? (value) {
                                                                                  valueListenable.value = value;
                                                                                } : null,
                                                                                buttonStyleData: const ButtonStyleData(
                                                                                    height: 20,
                                                                                    width: 120
                                                                                ),
                                                                                iconStyleData: const IconStyleData(
                                                                                  icon: Icon(Icons.arrow_forward_ios_outlined),
                                                                                  iconSize: 16,
                                                                                  iconEnabledColor: AppStyle.blueColorAdditional4AABDB,
                                                                                  iconDisabledColor: Colors.grey,
                                                                                ),
                                                                              ),
                                                                            )
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              error: (error, stack) => Center(child: Text('Ошибка загрузки: $error')),
                                                              loading: () => Center(
                                                                child: LoadingAnimationWidget.halfTriangleDot(
                                                                  color: AppStyle.blueColorAdditional4AABDB,
                                                                  size: 50,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(height: 15),
                                                      editStatusMode
                                                          ? Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                ElevatedButton(
                                                                    onPressed: () {
                                                                      setDialogState(() {
                                                                        editStatusMode = false;
                                                                      });
                                                                    },
                                                                    child: const Text('Отменить')),
                                                                ElevatedButton(
                                                                    onPressed: () {
                                                                      setDialogState(() {
                                                                        editStatusMode = false;
                                                                      });
                                                                    },
                                                                    child: const Text('Сохранить')),
                                                              ],
                                                            )
                                                          : ElevatedButton(
                                                              onPressed: () {
                                                                setDialogState(() {
                                                                  editStatusMode = true;
                                                                });
                                                                talker.log('SecretaryScreen: setstate сработал');
                                                              },
                                                              style: ButtonStyle(
                                                                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                                                  if (states.contains(WidgetState.disabled)) return AppStyle.disableBlueColorMain;
                                                                  if (states.contains(WidgetState.pressed)) return AppStyle.activeBlueColorMain;
                                                                  if (states.contains(WidgetState.hovered)) return AppStyle.hoverBlueColorMain;
                                                                  return AppStyle.blueColorAdditional4AABDB;
                                                                }),
                                                                minimumSize: WidgetStateProperty.all(Size(screenWidth * 1, 40)),
                                                                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                                              ),
                                                              child: const Text(
                                                                'Редактировать',
                                                                style: TextStyle(
                                                                  color: AppStyle.whiteColorMain,
                                                                  fontSize: AppStyle.fontSizeMedium_16,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) => Center(child: Text('Ошибка: $error')),
                  loading: () => const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
