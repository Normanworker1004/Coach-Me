import 'package:cme/model/slider_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:cme/utils/navigate_effect.dart';
import 'package:cme/app.dart';
import 'package:cme/register/coach_or_player.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int viewPagerIndex = 0;
  SwiperController swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    // print("runtimeType -> " + runtimeType.toString());
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return     WillPopScope(
        onWillPop: () async {
          if (viewPagerIndex == 0) {
            return true;
          } else {
            swiperController.move(viewPagerIndex - 1);
          }
          return false;
        },
        child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: SafeArea(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: Swiper(
                              autoplayDisableOnInteraction: true,
                              autoplay: false,
                              loop: false,
                              controller: swiperController,
                              index: viewPagerIndex,
                              physics: BouncingScrollPhysics(),
                              itemCount: listSlide.length,
                              itemBuilder: (context, index) {
                                SliderItem item = listSlide[index];
                                return  Column(children:[

                                       Container(
                                          width: width,
                                           height:height/3,
                                           child: ClipRRect(
                                            child: Image.asset(
                                              item.imageUrl,
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          // padding: EdgeInsets.only(
                                          //     left: 10, right: 10, bottom: 32),
                                        ),
                                  Expanded( child:
                                        Padding(
                                          padding: const EdgeInsets.only(top:40, bottom: 60),
                                          child: Column(
                                              children: <Widget>[

                                                Text(
                                                  item.title,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 28),
                                                ),
                                                verticalSpace(),
                                                verticalSpace(),
                                                Text(
                                                  item.heading,
                                                  // item.description,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w100,
                                                      fontSize: 16),
                                                ),
                                                verticalSpace(),


                                              ]
                                          ),
                                        )
                                  ),
                                  ]);
                              },
                              pagination: SwiperPagination(
                                  margin: EdgeInsets.only(top: 16),
                                  builder: DotSwiperPaginationBuilder(
                                      color: colorBg1,
                                      activeColor: colorSectionHead)),
                              onIndexChanged: (index) {
                                setState(() {
                                  viewPagerIndex = index;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w100),
                                  ),
                                  onTap: () {
                                    // print("inside inkwell -> $viewPagerIndex");
                                    viewPagerIndex == (listSlide.length - 1)
                                        ? goToNext()
                                        : swiperController.move(viewPagerIndex + 1);
                                  }))
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.bottomLeft,
                              child: InkWell(
                                  child: Text(
                                    "Back",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w100),
                                  ),
                                  onTap: () {
                                    viewPagerIndex == 0 ? Navigator.of(context).pop() : swiperController.move(viewPagerIndex - 1);
                                    // print("inside inkwell -> $viewPagerIndex");

                                  }))
                        ],
                      ),
                    ],
                  ),
                ))));
  }

  goToNext() async {
    Navigator.push(
        context,
        NavigatePageRoute(
            context, CoachOrPlayer(from: runtimeType.toString())));
  }
}
