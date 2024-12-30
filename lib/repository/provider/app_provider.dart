import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../viewmodel/contactprofile_viewmodel.dart';
import '../../viewmodel/dashboard_viewmodel.dart';
import '../../viewmodel/home_tabpage_viewmodel.dart';
import '../../viewmodel/homescreen_viewmodel.dart';
import '../../viewmodel/notification_viewmodel.dart';
import '../../viewmodel/profile_viewmodel.dart';

List<SingleChildWidget> providers = [

  ChangeNotifierProvider(create: (_) => DashBoardViewModel()),
  ChangeNotifierProvider(create: (_) => HomeScreenViewModel()),
  ChangeNotifierProvider(create: (_) => NotificationViewModel()),
  ChangeNotifierProvider(create: (_) => ProfileViewModel()),
  ChangeNotifierProvider(create: (_) => ContactProfileViewModel()),
  ChangeNotifierProvider(create: (_) => HomeTabPageViewModel()),

];