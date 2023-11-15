import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santhe/manager/font_manager.dart';
import 'package:santhe/widgets/custom_widgets/customScaffold.dart';
import 'package:santhe/widgets/custom_widgets/custom_button.dart';
import 'package:santhe/widgets/custom_widgets/custom_title_with_back_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/cubits/tutorial_cubit/tutorial_cubit.dart';


class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<TutorialCubit>(context).getLinks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
        ),
        title: AutoSizeText("Santhe",
            style: FontStyleManager().kAppNameStyle),
      ),
        body: BlocBuilder<TutorialCubit, TutorialState>(
          builder: (context, state) {
           if(state is TutorialLoadingState){
             return const Center(child: CircularProgressIndicator());
           }else if(state is TutorialLoadedState){
             return ListView.builder(
               itemCount: state.linkList.length,
                 itemBuilder: (context,index){
               return ListTile(
                 onTap: ()async{
                   await launchUrl(Uri.parse(state.linkList[index].url.toString()),
             mode: LaunchMode.externalApplication);
                 },
                 title: Text(state.linkList[index].title.toString(),
                 style: FontStyleManager().s16fw600Grey),
                 leading: const Icon(Icons.video_collection_outlined),
               );
             });
           }else{
             return const Center(child: Text("Something Went Wrong Please Try After SomeTime"));
           }
          },
        )
    );
  }
}

