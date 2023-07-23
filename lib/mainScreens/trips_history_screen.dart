import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:rideshare_driver/infoHandler/app_info.dart';
import 'package:rideshare_driver/widgets/history_design_ui.dart';

class TripsHistoryScreen extends StatefulWidget {

  @override
  State<TripsHistoryScreen> createState() => _TripsHistoryScreenState();

}

class _TripsHistoryScreenState extends State<TripsHistoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2727),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text(
          "Trips History"
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: (){
            SystemNavigator.pop();
          },
        ),
      ),

      body: ListView.separated(
        separatorBuilder: (context, i)=>const Divider(
          thickness: 3,
          height: 3,
          color: Color(0xFFff725e),
        ),
        itemBuilder: (context, i){
          return HistoryDesignUIWidget(
              tripsHistoryModel: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList[i],
            );
        },
        itemCount: Provider.of<AppInfo>(context, listen: false).allTripsHistoryInformationList.length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
