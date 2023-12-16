import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../themes/theme.dart';



class GalleryPopUp extends StatelessWidget {
  final Function onAllow;

  const GalleryPopUp({Key? key, required this.onAllow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
            color: kNeutralLightColor[1],
            borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconClose(context),
            SizedBox(
                width: 128,
                height: 128,
                child: Image.asset('assets/icons/ic_gallery.png')),
            const SizedBox(height: 8),
            Text("gallery_access".tr(),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text("gallery_access_des".tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: kNeutralLightColor[3])),
            const SizedBox(height: 32),
            _buttonAllow(context),
            const SizedBox(height: 12),
            _buttonCancel(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buttonCancel(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Text("cancel".tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: kPrimaryColor[3], fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buttonAllow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onAllow();
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), gradient: kGradient7),
        child: Text("continue".tr(),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: kWhiteColor, fontWeight: FontWeight.w400)),
      ),
    );
  }

  Widget _iconClose(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
                height: 24,
                width: 24,
                child: Image.asset('assets/icons/ic_close_popup.png'))),
      ),
    );
  }
}
