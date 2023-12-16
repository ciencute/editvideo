import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../const/const.dart';
import '../../di/locator.dart';
import '../../utils/themes/theme.dart';



const settingsScreen = "setting_screen";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _bodyView(context),
    );
  }

  Widget _bodyView(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: kDefaultPadding),
                child: SizedBox(
                  width: 32,
                ),
              ),
              Text("setting".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w700)),

            ],
          ),
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: kDefaultPadding),
                    _helpGroupView(context),
                    const SizedBox(height: kDefaultPadding * 1.5)
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget _helpGroupView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: Column(
        children: [
          _itemSettingView(
              context,
              SizedBox(
                height: 24,
                width: 24,
                child: Image.asset(
                  'assets/icons/ic_setting_privacy.png',
                ),
              ),
              'privacy'.tr(), () {
            // locator<NavigationService>().push(WebScreenRoute(
            //     url: ServiceConstants.policyUrl, title: 'privacy_policy'.tr()));
          }),
          _itemSettingView(
              context,
              SizedBox(
                height: 24,
                width: 24,
                child: Image.asset(
                  'assets/icons/ic_setting_term_of_service.png',
                ),
              ),
              'term_of_service'.tr(), () {
            // locator<NavigationService>().push(WebScreenRoute(
            //     url: ServiceConstants.termUrl, title: 'term_of_service'.tr()));
          }),
          _itemSettingView(
              context,
              SizedBox(
                height: 24,
                width: 24,
                child: Image.asset(
                  'assets/icons/ic_setting_rate_us.png',
                ),
              ),
              'rate_us'.tr(), () {
            // ShareUtil.rateThisApp(context);
          }),
          _itemSettingView(
              context,
              SizedBox(
                height: 24,
                width: 24,
                child: Image.asset(
                  'assets/icons/ic_setting_share_app.png',
                ),
              ),
              'share_app'.tr(), () {
            // ShareUtil.tapShareSocial(SharePlatform.other,
            //     content: ServiceConstants.appUrl);
          }),
            _itemSettingValueView(
                context,
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset(
                    'assets/icons/ic_setting_app_version.png',
                  ),
                ),
                'Device info',
                '', () async {
              {
                // locator<NavigationService>()
                //     .push(const DeviceInfoScreenRoute());
              }
            }),
          const SizedBox(height: 16),
          _textVersion()
        ],
      ),
    );
  }

  Widget _textVersion() {
    return Center(
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'app_version'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400)),
              TextSpan(
                  text: ' ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400)),
              TextSpan(
                  text: packageInfo['version'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: kNeutralLightColor[3], fontWeight: FontWeight.w400)),
            ],
          ),
        ));
  }


  Widget _itemSettingView(
      BuildContext context, Widget icon, String content, Function? action,
      {bool isShowNext = false}) {
    return InkWell(
      onTap: () {
        // if (!context.read<UserModel>().isPro &&
        //     locator<AppFirebaseConfig>().getAdsScreenConfig().interSettings ==
        //         true) {
        //   locator<InterstitialAdHelper>().showIfAvailableHome(settingsScreen,
        //       () {
        //     action?.call();
        //   });
        // } else {
        //   action?.call();
        // }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            icon,
            const SizedBox(width: kDefaultPadding),
            Expanded(
                child: Text(
              content,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w400),
            )),
            const SizedBox(width: 16),
            if (isShowNext)
              const Icon(Icons.arrow_forward_ios,
                  color: kInvalidColor, size: 16)
          ],
        ),
      ),
    );
  }

  Widget _itemSettingValueView(BuildContext context, Widget icon,
      String content, String description, Function? action,
      {bool isShowNext = false}) {
    return GestureDetector(
      onTap: () {
        action?.call();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            SizedBox(height: 24, width: 24, child: icon),
            const SizedBox(width: kDefaultPadding),
            Text(
              content,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w400),
            ),
            Expanded(
                child: Text(
              description,
              maxLines: 2,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400, color: kNeutralLightColor[3]),
            )),
            const SizedBox(width: 16),
            if (isShowNext)
              Icon(Icons.arrow_forward_ios,
                  color: kNeutralLightColor[3], size: 16)
          ],
        ),
      ),
    );
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.dark_mode, color: kWhiteColor);
      }
      return const Icon(Icons.light_mode, color: kWhiteColor);
    },
  );
}
