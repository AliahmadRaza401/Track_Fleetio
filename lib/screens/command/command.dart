import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:track_flotilla/model/command_model.dart';
import 'package:track_flotilla/providers/loading_provider.dart';
import 'package:track_flotilla/screens/command/command_handler.dart';
import 'package:track_flotilla/screens/geoFence/geoFence_list_page.dart';
import 'package:track_flotilla/screens/staff/group_list_page.dart';
import 'package:track_flotilla/screens/staff/staff_list_page.dart';
import 'package:track_flotilla/screens/widgets/custom_list_tile.dart';
import 'package:track_flotilla/screens/widgets/customAppBar.dart';
import 'package:track_flotilla/screens/widgets/loadingtext_animation.dart';
import 'package:track_flotilla/screens/widgets/my_text.dart';
import 'package:track_flotilla/shared_pref/shared_pref.dart';
import 'package:track_flotilla/utils/appColor.dart';
import 'package:track_flotilla/utils/app_size.dart';
import 'package:track_flotilla/utils/responsive.dart';
import 'package:track_flotilla/utils/shahdow.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../widgets/input_field.dart';

class Command extends StatefulWidget {
  Command({Key? key}) : super(key: key);

  @override
  State<Command> createState() => _CommandState();
}

class _CommandState extends State<Command> {
  List commandList = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  List data = [];
  getData() async {
    commandList = await CommandsHander.fetchAllCommands(context);
    print('Commands: $commandList');
    setState(() {});
  }

  TextEditingController searchController = TextEditingController();
  List filterData = [];
  @override
  Widget build(BuildContext context) {
    bool loading = Provider.of<LoadingProvider>(context).loading;
    data = searchController.text.isEmpty ? commandList : filterData;
    return Scaffold(
      appBar: customAppBar(context, "Command"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 500.w,
              height: 85.h,
              child: TextField(
                controller: searchController,
                onChanged: ((value) {
                  setState(() {
                    filterData = commandList
                        .where((filtData) => filtData['description']
                            .toString()
                            .toUpperCase()
                            .contains(
                                searchController.text.toString().toUpperCase()))
                        .toList();
                  });
                }),
                decoration: myinputDecoration(),
              ),
            ),
            loading
                ? loadingTextAimation()
                : data.isEmpty
                    ? Center(child: Text("No Record Found"))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.isEmpty ? 0 : data.length,
                        itemBuilder: (BuildContext context, i) {
                          return CustomListTile(
                              name: data[i]['description'].toString(),
                              imageUrl: "assets/png/command.png");
                        },
                        
                      ),
          ],
        ),
      ),
 
    );
  }
}
// 