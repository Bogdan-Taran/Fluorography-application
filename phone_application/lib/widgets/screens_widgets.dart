import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_fluorography/styles.dart';
import 'package:project_fluorography/screens/medic/controller/fluorography_controller.dart';
import '../services/builders_screen.dart';
import '../services/checker_service.dart';

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
    CheckerService _CheckerService = CheckerService();
    
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: switch (_CheckerService.isFluorographyOverdue(
                dataContainer,
              )) {
                DataStatus.unknown => AppStyle.redColorTag.withOpacity(0.5),
                DataStatus.overdue => AppStyle.redColorTag.withOpacity(0.5),
                DataStatus.quitOverdue => AppStyle.yellowColorTag.withOpacity(0.5),
                DataStatus.noOverdue => Colors.transparent,
              },
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Text(
        dataContainer,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppStyle.blackColorMain,
        ),
      ),
    );
  }
}




