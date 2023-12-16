import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../themes/theme.dart';
import 'app_button.dart';

class NetworkErrorBottomSheet extends StatefulWidget {
  final String? message;

  final Function? callback;

  const NetworkErrorBottomSheet({super.key, this.message, this.callback});

  @override
  State<StatefulWidget> createState() => _NetworkErrorBottomSheetState();
}

class _NetworkErrorBottomSheetState extends State<NetworkErrorBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [_contentView(context)],
      ),
    );
  }

  Widget _contentView(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double widthFactor = screenSize.width > 480 ? 0.7 : 1.0;
    double maxWidth = widthFactor * screenSize.width;
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              const SizedBox(
                height: 45,
              ),
              Container(
                width: maxWidth,
                margin: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding, horizontal: kDefaultPadding),
                padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding, horizontal: kDefaultPadding),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(kDefaultRadius * 2))),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 110,
                    ),
                    Text('no_network_title'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Text(widget.message ?? 'no_network'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    _saveButton(context),
                  ],
                ),
              )
            ],
          ),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 140,
              width: 200,
              child: Image.asset('assets/icons/ic_network_error.png',
                  fit: BoxFit.contain),
            )),
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    return AppButton(
        color: kPrimaryLightColor,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        child: Center(
            child: Text('ok'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: kWhiteColor))),
        onPressed: () {
          Navigator.of(context).pop();
          widget.callback?.call();
        });
  }
}
