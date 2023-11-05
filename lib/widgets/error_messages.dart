import 'package:flutter/material.dart';

import '../style/colors.dart';
import '../style/style.dart';

class ErrorMessages extends StatelessWidget {
  final VoidCallback? onRefresh;
  final Widget? onLogout;
  final String msg;
  const ErrorMessages(
      {Key? key, this.onRefresh, this.onLogout, required this.msg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: onRefresh != null ? 400 : 50,
      child: Center(
        child: onRefresh == null
            ? const InfoFont(text: 'Error Occured!')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DescriptionFont(text: msg),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      onPressed: () {
                        onRefresh!();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: AppColors.white,
                      ),
                      label: const InfoFont(
                        text: 'Refresh',
                        color: AppColors.white,
                      )),
                  if (onRefresh != null && onLogout != null) onLogout!
                ],
              ),
      ),
    );
  }
}
