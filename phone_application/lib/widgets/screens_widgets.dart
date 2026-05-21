import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_fluorography/styles.dart';
import 'package:project_fluorography/screens/medic/controller/fluorography_controller.dart';
import '../services/builders_screen.dart';
import '../services/checker_service.dart';
import '../services/converters_service.dart';

class DataFluraContainerBuildWidget extends ConsumerWidget {
  final String dataContainer;
  final String uniqueDateContainerId;
  final String uniqueEditingSectionId;

  const DataFluraContainerBuildWidget({
    super.key,
    required this.dataContainer,
    required this.uniqueDateContainerId,
    required this.uniqueEditingSectionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkerService = CheckerService();
    final converterService = ConverterServices();
    final status = checkerService.isFluorographyOverdue(dataContainer);
    
    final Color textColor = switch (status) {
      DataStatus.unknown => AppStyle.redColorTag,
      DataStatus.overdue => AppStyle.redColorTag,
      DataStatus.quitOverdue => AppStyle.yellowColorTag,
      DataStatus.noOverdue => AppStyle.blueColorAdditional4AABDB,
    };

    return Text(
      converterService.formatFluraDate(dataContainer),
      style: TextStyle(
        fontSize: AppStyle.fontSizeMediumMini_14,
        fontWeight: FontWeight.w400,
        color: textColor,
        fontFamily: 'Geologica',
      ),
    );
  }
}




