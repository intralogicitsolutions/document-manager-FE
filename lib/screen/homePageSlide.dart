import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class HomePageSlides extends StatefulWidget {
  @override
  _HomePageSlidesState createState() => _HomePageSlidesState();
}

class _HomePageSlidesState extends State<HomePageSlides> {

  int _currentIndex = 0;

  final List<String> _images = [
    'assets/slide/slide1.png',
    'assets/slide/slide2.jpg',
    'assets/slide/slide3.png',
    //'images/slide/slide4.PNG',
  ];

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: 170.0,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayCurve: Curves.easeInOutSine,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: _images.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(image,width: 200,height: 200,fit: BoxFit.cover,),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _images.map((url) {
            int index = _images.indexOf(url);
            return Container(
              width: 10.0,
              height: 10.0,
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Themer.gradient1
                    : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

}