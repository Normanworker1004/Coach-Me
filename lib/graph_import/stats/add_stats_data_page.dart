import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/graph_import/player_stats_page.dart';
import 'package:cme/graph_import/stats/add_unidentified_stats_data.dart';
import 'package:cme/graph_import/stats/height.dart';
import 'package:cme/graph_import/stats/weight.dart';
import 'package:cme/model/fetch_player_stats_response.dart';
import 'package:cme/network/player_stats/fetchplayerstats.dart';
import 'package:cme/network/store_previous_user.dart';
import 'package:cme/ui_widgets/build_base_scaffold.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:provider/provider.dart';

import '../../auth_scope_model/ui_provider.dart';
import '../../controllers/stats_controller.dart';

class AddStatsDataPage extends StatefulWidget {
  final UserModel userModel;
  final TooltipController tooltipController = TooltipController();

  AddStatsDataPage({Key? key, required this.userModel}) : super(key: key);
  @override
  _AddStatsDataPageState createState() => _AddStatsDataPageState();
}

class _AddStatsDataPageState extends State<AddStatsDataPage> {
  /**
   * <FetchPlayerStatsResponse>(
        future: fetchPlayerStatsData(
          token: userModel.getAuthToken(),
        )
   */
  List<Widget> statsEditors = [];
  PageController? controller;
  FetchPlayerStatsResponse? statsResponse;
  int? globalSubIndex;
  final StatsController statsController = Get.find<StatsController>();


  bool showUI = false;
  @override
  void initState() {
    super.initState();
    statsController.currentUserModel.value = widget.userModel;
    shouldAddData();
  }

  shouldAddData() async {
    int lastUpdate = await getStatsLastUpdateDate();
    int todayDate = Jiffy().dayOfYear;

    if (todayDate > lastUpdate) {
      fetchData();
      updateStatsDate(todayDate);
    } else {
      setState(() {
        showUI = true;
      });
    }
  }

  fetchData() async {
    controller = PageController();
    statsResponse = await fetchPlayerStatsData(
      token: statsController.currentUserModel.value.getAuthToken()!,
    );
    var l = statsResponse!.details!;
    print("lebght...${l.length}");
    for (var i in l) {
      if (i.goal == "Weight") {
        statsEditors.add(WeightInputPage(
          onSave: onSaveData,
          onSkip: () {},
          statId: i.id,
          userModel: statsController.currentUserModel.value,
        ));
      } else if (i.goal == "Height") {
        statsEditors.add(HeightInputPage(
          statDetail: i,
          onSave: onSaveData,
          userModel: statsController.currentUserModel.value,
        ));
      } else {
        statsEditors.add(AddUnidentifiedDataScren(
          statDetail: i,
          onSave: onSaveData,
          userModel: statsController.currentUserModel.value,
        ));
      }
    }

    statsEditors.add(PlayerStatsPage(
      tooltipController: widget.tooltipController,
      userModel: statsController.currentUserModel.value,
    ));

    setState(() {
       showUI = true;
      // controller?.jumpToPage(globalSubIndex??0);
    });
  }

  onSaveData() {
    print("Go to...");
    int todayDate = Jiffy().dayOfYear;
    updateStatsDate(todayDate);
    controller!.nextPage(
        duration: Duration(microseconds: 10), curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    return
      OverlayTooltipScaffold(
          overlayColor: Colors.black.withOpacity(.9),
          tooltipAnimationCurve: Curves.linear,
          tooltipAnimationDuration: const Duration(milliseconds: 1000),
          controller: widget.tooltipController,
          builder: (BuildContext context) {
            return  buildBaseScaffold(
          hideBack: true,
          lrPadding: 0,
          bottomPadding: 80,
          context: context,
          body: showUI
              ? PlayerStatsPage(
            tooltipController: widget.tooltipController,
            userModel: statsController.currentUserModel.value,
                )
              : buildBody(context),
          title: "Stats",
        );
      }
    );
  }

  Widget buildBody(BuildContext context) {
    return statsResponse == null
        ? Column(
            children: [
              Spacer(),
              CircularProgressIndicator(),
              mediumText("Fetching data...."),
              Spacer(),
            ],
          )
        : PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: controller,
            itemCount: statsEditors.length,
            itemBuilder: (c, i) => statsEditors[i],
          );
  }
}
