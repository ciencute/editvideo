// import 'dart:io';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// ///sharing platform
// enum SharePlatform { facebook, instagram, twitter, other }
//
// class ShareUtil {
//   static void tapShareSocial(SharePlatform share,
//       {String? content, String? url, String? imagePath}) {
//     switch (share) {
//       case SharePlatform.facebook:
//         SocialShare.shareFacebookStory(
//             appId: '692848225717166',
//             imagePath: imagePath,
//             backgroundTopColor: "#ffffff",
//             backgroundBottomColor: "#000000",
//             attributionURL: ServiceConstants.homeUrl);
//
//         SocialShare.checkInstalledAppsForShare().then((value) {
//           final isSocial = (value?['facebook'] as bool?) ?? true;
//           if (!isSocial) {
//             AlertUtil.showToastError(msg: 'unknown_error'.tr());
//           }
//         });
//         break;
//       case SharePlatform.instagram:
//         SocialShare.shareInstagramStory(
//             appId: '692848225717166',
//             imagePath: imagePath ?? '',
//             backgroundTopColor: "#ffffff",
//             backgroundBottomColor: "#000000",
//             attributionURL: ServiceConstants.homeUrl);
//         SocialShare.checkInstalledAppsForShare().then((value) {
//           final isSocial = (value?['instagram'] as bool?) ?? true;
//           if (!isSocial) {
//             AlertUtil.showToastError(msg: 'unknown_error'.tr());
//           }
//         });
//         break;
//       case SharePlatform.twitter:
//         SocialShare.shareTwitter(content ?? '',
//             hashtags: ["QR Creator+", "QRCode", "AI", "AI QRCode"],
//             trailingText: content,
//             url: ServiceConstants.homeUrl);
//         SocialShare.checkInstalledAppsForShare().then((value) {
//           final isSocial = (value?['twitter'] as bool?) ?? true;
//           if (!isSocial) {
//             AlertUtil.showToastError(msg: 'unknown_error'.tr());
//           }
//         });
//         break;
//       default:
//         SocialShare.shareOptions(content ?? '', imagePath: imagePath);
//     }
//   }
//
//   static void share({required String title, required String content}) {
//     Share.share(content, subject: title);
//   }
//
//   static void copyTextToClipboard(content) {
//     Clipboard.setData(ClipboardData(text: content));
//     AlertUtil.showToast(msg: 'message_copied'.tr());
//   }
//
//   static void copyImageClipboard(String path) {
//     Clipboard.setData(ClipboardData(text: "content://$path"));
//   }
//
//   static void shareImageClipboard(String path) {
//     Share.shareXFiles([XFile(path)]);
//   }
//
//   static void openAppStore() {
//     String url = Platform.isAndroid
//         ? "market://details?id=com.ai.qrgenerator.qrcodereader.qrartcode"
//         : "https://apps.apple.com/app/6445985539";
//     launchUrl(
//       Uri.parse(url),
//       mode: LaunchMode.externalApplication,
//     );
//   }
//
//   static void rateInAppStore(BuildContext context) {
//     final InAppReview inAppReview = InAppReview.instance;
//     inAppReview.isAvailable().then((value) {
//       if (value) {
//         inAppReview.requestReview();
//       } else {
//         openAppStore();
//       }
//     });
//   }
//
//   static void rateThisApp(BuildContext context) async {
//     if (Platform.isIOS) {
//       rateInAppStore(context);
//     } else {
//       showDialog<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return const RateView();
//         },
//       );
//     }
//   }
//
//   static Future<void> openStoreListing() async {
//     final InAppReview inAppReview = InAppReview.instance;
//     inAppReview.openStoreListing(
//         appStoreId: '6447172077', microsoftStoreId: '');
//   }
// }
