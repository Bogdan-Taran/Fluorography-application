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
  final Map<int, int> _updatedStatuses = {};

  Future<void> _saveChanges() async {
    await ref.read(updateReferenceStatusControllerProvider.notifier)
        .updateMultipleStatuses(updates: _updatedStatuses, userId: widget.student.user_id);
    
    if (mounted) {
      final state = ref.read(updateReferenceStatusControllerProvider);
      if (!state.hasError) {
        setState(() {
          editStatusMode = false;
          _updatedStatuses.clear();
        });
        Navigator.pop(context);
      }
    }
  }

  Widget _buildStatusTag(int statusId, {bool isActive = true, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? statusId.statusColor : statusId.statusColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          statusId.statusName,
          style: const TextStyle(
            color: AppStyle.whiteColorMain,
            fontSize: AppStyle.fontSizeSmall_12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.student.lastname} ${widget.student.firstname} ${widget.student.patronymic}',
                        style: const TextStyle(
                          color: AppStyle.blueColorTextTitle,
                          fontSize: AppStyle.fontSizeLarge,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'группа ${widget.student.group}, ${widget.student.phone}',
                        style: const TextStyle(
                          color: AppStyle.blackColorMain,
                          fontSize: AppStyle.fontSizeMediumMini_14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppStyle.blueColorAdditional4AABDB),
                ),
              ],
            ),
            const Divider(color: AppStyle.collapsedBlueColorD4EAFF, thickness: 1, height: 32),
            Flexible(
              child: Consumer(
                builder: (context, ref, child) {
                  final historyDataAsync = ref.watch(fetchStudentApplications(widget.student.user_id));
                  return historyDataAsync.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'У этого студента нет истории заявок',
                            style: TextStyle(color: AppStyle.blackColorMain),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          final currentStatusId = _updatedStatuses[item.id] ?? item.status_id;

                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.type_id.applicationTypeName,
                                            style: const TextStyle(
                                              color: AppStyle.blackColorMain,
                                              fontSize: AppStyle.fontSizeMediumMini_14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            item.date,
                                            style: const TextStyle(
                                              color: AppStyle.activeBlueColorMain,
                                              fontSize: AppStyle.fontSizeSmall_12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!editStatusMode) _buildStatusTag(item.status_id),
                                  ],
                                ),
                                if (editStatusMode) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _buildStatusTag(2, // Готова
                                          isActive: currentStatusId == 2,
                                          onTap: () => setState(() => _updatedStatuses[item.id] = 2)),
                                      const SizedBox(width: 8),
                                      _buildStatusTag(1, // В процессе
                                          isActive: currentStatusId == 1,
                                          onTap: () => setState(() => _updatedStatuses[item.id] = 1)),
                                      const SizedBox(width: 8),
                                      _buildStatusTag(3, // Дубликат
                                          isActive: currentStatusId == 3,
                                          onTap: () => setState(() => _updatedStatuses[item.id] = 3)),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      );
                    },
                    error: (error, stack) => Center(child: Text('Ошибка: $error')),
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
            const SizedBox(height: 24),
            _buildBottomButtons(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(double screenWidth) {
    if (editStatusMode) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  editStatusMode = false;
                  _updatedStatuses.clear();
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppStyle.activeBlueColorMain),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Отменить',
                style: TextStyle(
                  color: AppStyle.activeBlueColorMain,
                  fontSize: AppStyle.fontSizeMedium_16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _updatedStatuses.isEmpty ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.activeBlueColorMain,
                disabledBackgroundColor: AppStyle.disableBlueColorMain,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: const Text(
                'Сохранить',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppStyle.fontSizeMedium_16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            editStatusMode = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.activeBlueColorMain,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: const Text(
          'Редактировать',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppStyle.fontSizeMedium_16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }
}
