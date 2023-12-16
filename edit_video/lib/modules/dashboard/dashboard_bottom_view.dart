import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utils/themes/theme.dart';

class HomeBottomView extends StatefulWidget {
  final ValueChanged<int>? onTap;

  const HomeBottomView({super.key, this.onTap});

  @override
  State<HomeBottomView> createState() => _HomeBottomViewState();
}

class _HomeBottomViewState extends State<HomeBottomView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        height: 94,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                  colors: [Colors.white70, Color(0xFFECECEC)]),
              borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: _itemBottomBar(context,
                        activeIcon:
                            _bottomBarIcon('assets/icons/ic_home_active.png'),
                        icon: _bottomBarIcon('assets/icons/ic_home.png'),
                        label: "home".tr(),
                        index: 0)),
                Expanded(
                  child: _itemBottomBar(context,
                      activeIcon:
                          _bottomBarIcon('assets/icons/ic_setting_active.png'),
                      icon: _bottomBarIcon('assets/icons/ic_setting.png'),
                      label: "setting".tr(),
                      index: 1),
                ),
              ],
            ),
          ),
        ));
  }

  void _onTab(int index) {
    _onItemTapped(index);
  }

  Widget _itemBottomBar(BuildContext context,
      {required Widget activeIcon,
      required Widget icon,
      required String label,
      required int index}) {
    final isActive = index == _selectedIndex;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _onTab(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isActive) const SizedBox(height: 8),
          isActive ? activeIcon : icon,
          if (isActive) ...[
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: kPrimaryColor[3], fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Container(
              height: 2,
              width: 80,
              margin: const EdgeInsets.only(bottom: 1),
              decoration: BoxDecoration(
                  color: kPrimaryColor[3],
                  borderRadius: const BorderRadius.all(Radius.circular(2))),
            )
          ]
        ],
      ),
    );
  }

  Widget _bottomBarIcon(String icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 24,
      width: 24,
      child: Image.asset(icon, fit: BoxFit.contain),
    );
  }

  void _onItemTapped(int index) {
    widget.onTap?.call(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}
