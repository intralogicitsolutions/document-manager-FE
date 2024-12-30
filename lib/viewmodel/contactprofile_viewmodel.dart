import 'package:appbase/base/base_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactProfileViewModel extends BaseNotifier{
  @override
  void onDisposeValues() {

  }

  @override
  void onNavigated() {

  }

  void makeCall(String phoneNumber) async{
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
    await launchUrl(callUri);
    } else {
      print("call dosen't exit");
    }
    notifyListeners();
  }

  void openMessenger() async{
    var url = Uri.parse("sms:6354097183");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void sendEmail() async{
    var url = Uri.parse("mailto:feedback@geeksforgeeks.org");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
    notifyListeners();
  }


}