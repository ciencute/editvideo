import 'package:edit_video/di/locator.dart';
import 'package:edit_video/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:edit_video/modules/edit_video/edit_video_screen.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import '../../service/navigation_service.dart';
import '../settings/settings_screen.dart';
import 'dashboard_bottom_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: _bodyView(context),
        floatingActionButton: _itemCenter(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: HomeBottomView(onTap: _onItemTapped));
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _tabController.index = index;
    });
  }

  Widget _itemCenter(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print("VU TRUNG KIEN");

          locator<NavigationService>().push(const ScanQRCodeScreenRoute());
        },
        child: SizedBox(
            height: 64,
            width: 64,
            child: Image.asset(
              'assets/icons/ic_center_bottom_bar.png',
              fit: BoxFit.cover,
            )));
  }

  _bodyView(BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: const [EditVideoScreen(), SettingsScreen()],
    );
  }
}
