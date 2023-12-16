import 'package:any_link_preview/any_link_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/themes/theme.dart';
import '../../../utils/widget/image_until.dart';
import '../../../utils/widget/linear_button.dart';
import '../scan_qrcode_screen.dart';

class ResultQRCodeSheet extends StatelessWidget {
  final Metadata? metaData;
  final String barcodeValue;

  const ResultQRCodeSheet(
      {super.key, required this.barcodeValue, this.metaData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [_contentView(context)],
    );
  }

  Widget _contentView(BuildContext context) {
    bool isShowInfoWifi = barcodeValue.contains("WIFI:");
    return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultRadius * 2),
                topRight: Radius.circular(kDefaultRadius * 2)),
            color: Colors.white),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 64,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Colors.grey),
              ),
              const SizedBox(height: kDefaultPadding),
              metaData != null
                  ? _linkContentView(context)
                  : _contentViewBarcode(context, isShowInfoWifi),
              const SizedBox(height: kDefaultPadding),
              metaData != null
                  ? _openLinkAction(context)
                  : _textActionView(context)
            ],
          ),
        ));
  }

  Future<void> _launchUrl(Uri uri) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      uri,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Widget _openLinkAction(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: AppLinearButton(
                onPressed: () {
                  final uri = Uri.parse(metaData?.url ?? barcodeValue);
                  _launchUrl(uri);
                  Navigator.of(context).pop();
                },
                gradient: kGradient7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.language, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text('open_link'.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white))
                  ],
                ))),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            // ShareUtil.share(
            //     title: 'share_qrcode_title'.tr(),
            //     content: metaData?.url ?? barcodeValue);
            Navigator.of(context).pop();
          },
          child: Container(
            height: kDefaultHeight,
            width: kDefaultHeight,
            decoration: BoxDecoration(
                color: kNeutralColor[2],
                borderRadius:
                    const BorderRadius.all(Radius.circular(kDefaultRadius))),
            child: Icon(
              Icons.share,
              color: kNeutralColor[4],
              size: 24,
            ),
          ),
        )
      ],
    );
  }

  Widget _linkContentView(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: kBackgroundLight2Color),
          child: FCoreImage(metaData?.image ?? "",
              fit: BoxFit.contain, width: 48, height: 48),
        ),
        const SizedBox(width: kDefaultPadding),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              metaData?.title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(metaData?.url ?? barcodeValue,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.blueAccent)),
          ],
        ))
      ],
    );
  }

  Widget _contentViewBarcode(BuildContext context, bool isShowInfoWifi) {
    return isShowInfoWifi ? _textWifiView(context) : _textContentView(context);
  }

  Widget _textContentView(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(kDefaultRadius)),
          color: kNeutralColor[2]),
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'content'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.blueAccent),
          ),
          const SizedBox(height: 8),
          Text(metaData?.url ?? barcodeValue,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _textWifiView(BuildContext context) {
    List<String> wifiParts = barcodeValue.replaceAll('WIFI:', '').split(";");

    String networkName =
        wifiParts.where((e) => e.startsWith("S")).first.replaceAll('S:', '') ??
            '';
    String password =
        wifiParts.where((e) => e.startsWith("P")).first.replaceAll('P:', '') ??
            '';

    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(kDefaultRadius)),
          color: kNeutralColor[2]),
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'wifi'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.blueAccent),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Text(networkName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black87)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'pass'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.blueAccent),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Text(password,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black87)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _textActionView(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: AppLinearButton(
                onPressed: () {
                  // ShareUtil.copyTextToClipboard(barcodeValue);
                  Navigator.of(context).pop();
                },
                gradient: kGradient7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.copy, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text('copy'.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white))
                  ],
                ))),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            // ShareUtil.share(
            //     title: 'share_qrcode_title'.tr(),
            //     content: metaData?.url ?? barcodeValue);
            Navigator.of(context).pop();
          },
          child: Container(
            height: kDefaultHeight,
            width: kDefaultHeight,
            decoration: BoxDecoration(
                color: kNeutralColor[2],
                borderRadius:
                    const BorderRadius.all(Radius.circular(kDefaultRadius))),
            child: Icon(
              Icons.share,
              color: kNeutralColor[4],
              size: 24,
            ),
          ),
        )
      ],
    );
  }
}
