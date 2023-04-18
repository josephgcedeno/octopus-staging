import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_dots_indicator.dart';
import 'package:octopus/module/accomplishments_generator/interfaces/widgets/accomplishments_project_card.dart';

class AccomplishmentsProjectSlider extends StatefulWidget {
  const AccomplishmentsProjectSlider({Key? key}) : super(key: key);

  @override
  State<AccomplishmentsProjectSlider> createState() =>
      _AccomplishmentsProjectSliderState();
}

class _AccomplishmentsProjectSliderState
    extends State<AccomplishmentsProjectSlider> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page!.round();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final List<Map<String, Object>> projects = <Map<String, Object>>[
      <String, Object>{
        'name': 'Project Octopus',
        'backgroundColor': theme.primaryColor,
        'textColor': kWhite,
        'image': SvgPicture.asset(whiteLogoSvg),
      },
      <String, Object>{
        'name': 'Coin Mode',
        'backgroundColor': Colors.orange,
        'textColor': kWhite,
        'image': Image.network(
          'https://cdn-icons-png.flaticon.com/512/7880/7880066.png',
        ),
      },
      <String, Object>{
        'name': 'NFT Deals',
        'backgroundColor': kLightGrey,
        'textColor': kBlack,
        'image': Image.network(
          'https://cdn-icons-png.flaticon.com/512/6699/6699362.png',
        ),
      },
    ];

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: height * 0.03),
          height: height * 0.2,
          child: ListView(
            controller: _pageController,
            physics: const PageScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            children: projects.map((Map<String, Object> project) {
              final Color? textColor = project['textColor'] as Color?;
              final Color? backgroundColor =
                  project['backgroundColor'] as Color?;
              final Widget image = project['image']! as Widget;

              return AccomplishmentsProjectCard(
                title: project['name']! as String,
                image: image,
                textColor: textColor,
                backgroundColor: backgroundColor,
              );
            }).toList(),
          ),
        ),
        DotsIndicator(
          currentIndex: _currentPageIndex,
          pageCount: projects.length,
        ),
      ],
    );
  }
}
