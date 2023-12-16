import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../info/device_util.dart';
import '../../utils/widget/network_error_sheet.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("KIEN"),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // DeviceUtil.checkNetworkState().then((value) {
    //   if (!mounted) {
    //     return;
    //   }
    //   if (!value) {
    //     _showDialogNoNetwork();
    //   }
    // });
  }

  void _showDialogNoNetwork() {
    showModalBottomSheet(
        elevation: 0.0,
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        backgroundColor: Colors.transparent,
        builder: (context) {
          return NetworkErrorBottomSheet(
              message: 'no_network_connect'.tr(),
              callback: () {
                AppSettings.openAppSettings(type: AppSettingsType.wifi)
                    .then((value) => print("openWIFISettings function called"));
              });
        });
  }
}
