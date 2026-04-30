import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:talker/talker.dart';

import '../../models/get_reference_model/get_reference_model.dart';
import '../../services/api_reference/request_reference_controller.dart';
import '../../styles.dart';

class SecretaryEditDialog extends ConsumerStatefulWidget {
  final GetReferenceModel student;
  final Talker talker;

  const SecretaryEditDialog({
    super.key,
    required this.student,
    required this.talker,
  });

  @override
  ConsumerState<SecretaryEditDialog> createState() => _SecretaryEditDialogState();
}

class _SecretaryEditDialogState extends ConsumerState<SecretaryEditDialog> {
  bool editStatusMode = false;
  final ValueNotifier<String?> valueListenable = ValueNotifier<String?>(null);

  final List<String> itemsStatusId = [
    'В процессе',
    'Готово',
    'Дубликат',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  '${widget.student.lastname} ${widget.student.firstname} ${widget.student.patronymic}',
                  style: const TextStyle(color: AppStyle.blueColorTextTitle),
                ),
                subtitle: Text('группа ${widget.student.group}, ${widget.student.phone}'),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final historyDataAsync = ref.watch(fetchStudentApplications(widget.student.user_id));
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
                        setState(() {
                          editStatusMode = false;
                        });
                      },
                      child: const Text('Отменить')),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          editStatusMode = false;
                        });
                      },
                      child: const Text('Сохранить')),
                ],
              )
                  : ElevatedButton(
                onPressed: () {
                  setState(() {
                    editStatusMode = true;
                  });
                  widget.talker.log('SecretaryScreen: setstate сработал');
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
  }
}
