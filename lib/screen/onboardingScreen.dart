import 'package:appbase/base/base_widget.dart';
import 'package:document_manager/screen/splashScreen.dart';
import 'package:document_manager/viewmodel/onBoarding_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends BaseWidget<OnboardingScreen,OnboardingViewModel> {
  late OnboardingViewModel vm;


  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/slide/slide1.png",
      "title": "Manage Your Documents",
      "description": "Organize and keep track of your important documents effortlessly."
    },
    {
      "image": "assets/slide/slide2.jpg",
      "title": "Secure and Private",
      "description": "Your documents are encrypted and kept safe in the app."
    },
    {
      "image": "assets/slide/slide3.png",
      "title": "Access Anywhere",
      "description": "Access your documents from any device, anytime."
    }
  ];

  @override
  void onCreate() async{
    super.onCreate();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;

    if (hasCompletedOnboarding) {
      // Navigate to the home screen directly
      // vm.navigateHome();
      GoRouter.of(context).go('/home');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }


  @override
  Widget buildContent(BuildContext context, OnboardingViewModel vm) {
    this.vm = vm;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) => OnboardingContent(
                image: _onboardingData[index]["image"]!,
                title: _onboardingData[index]["title"]!,
                description: _onboardingData[index]["description"]!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Skip to the last page
                    _pageController.jumpToPage(_onboardingData.length - 1);
                  },
                  child: Text("Skip"),
                ),
                Row(
                  children: List.generate(
                    _onboardingData.length,
                        (index) => buildDot(index, context),
                  ),
                ),
                TextButton(
                  onPressed: () async{
                    if (_currentPage == _onboardingData.length - 1) {
                      // Navigate to home or main screen
                     // Navigator.pushReplacementNamed(context, '/home');
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('hasCompletedOnboarding', true);
                      // vm.navigateHome();
                      GoRouter.of(context).go('/home');

                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder:
                      //         (context) =>
                      //             SplashScreen()
                      //     )
                      // );
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text(_currentPage == _onboardingData.length - 1 ? "Get Started" : "Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentPage == index ? 20 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: _currentPage == index ? Themer.gradient1 : Colors.grey,
      ),
    );
  }
}


class OnboardingContent extends StatelessWidget {
  final String image, title, description;

  const OnboardingContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Themer.gradient1
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
