import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as ge;
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants.dart';
import '../../../../core/app_colors.dart';
import '../../core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_cubit.dart';
import '../../core/cubits/upload_image_and_return_request_cubit/upload_image_and_return_request_state.dart';
import '../../manager/font_manager.dart';
import '../../pages/new_tab_pages/image_page.dart';


class ImageGrid extends StatelessWidget {
  const ImageGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<UploadImageAndReturnRequestCubit,
          UploadImageAndReturnRequestState>(

        builder: (context,state) {

           if(state is ShowImages){

            return
              Body(
              hasImages: true,
              imageFiles: state.imageFiles,
            );

          } else if(state is HideAddImagesButton){
             return
               Body(
                 hasImages: true,
                 imageFiles: state.imageFiles,
                 hideAddImageButton: true,
               );
           }else if (state is LoadingState){
             return const SizedBox(
                 height: 200,
                 width: 200,
                 child: Center(child: CircularProgressIndicator()));
           }else{
             return
               const Body();
           }
        }
      );
  }

}

class Body extends StatelessWidget {
  final List<File>? imageFiles;
  final bool? hasImages;
  final bool? hideAddImageButton;
  const Body({Key? key, this.imageFiles, this.hasImages, this.hideAddImageButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 200,
        width: 200,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: hasImages == null ? 4 : imageFiles!.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
          itemBuilder: (context, index){
            if(hideAddImageButton ?? false){
              index = index+1;
              return imageCell(index: index);
            }else if(hideAddImageButton ?? false == false ){
              if(index == 0){
                return
                  InkWell(
                    onTap: () async{

                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: Text('Select One',
                                  style: FontStyleManager().s16fw600Orange),

                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                  child: ElevatedButton(
                                      onPressed: (){
                                        BlocProvider.of<UploadImageAndReturnRequestCubit>
                                          (context).
                                        getImagesFromCamera();
                                        Navigator.pop(context);
                                      },
                                      child:Text("Camera",
                                        style: FontStyleManager().
                                        s14fw700White,)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                  child: ElevatedButton(
                                      onPressed: (){
                                        BlocProvider.of<UploadImageAndReturnRequestCubit>
                                          (context).
                                        getImagesFromGallery();
                                        Navigator.pop(context);
                                      },
                                      child:Text("Gallery",
                                        style: FontStyleManager().s14fw700White,)),
                                ),
                              ],
                            );
                          }
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(imageCellBorderRadius),
                        border: Border.all(
                            color: AppColors().primaryOrange,
                            width: 1
                        ),
                      ),
                      child: Center(
                          child: Icon(
                            Icons.add,color: AppColors().primaryOrange,size: 40,)),
                    ),
                  );

              }
              ///
              else {
                return
                  imageCell(index: index);
              }

            }
          }
        ),
      ),
    );
  }

  Widget imageCell({required int index}){
    return   InkWell(
      onTap: (){
        if(imageFiles?[index] != null){
          Get.to(
                () => ImageViewerPage(
              imgFile: imageFiles![index],
              showCustomImage: true,
              itemImageUrl: '',
            ),
            opaque: false,
            transition: ge.Transition.fadeIn,
          );
        }

      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(imageCellBorderRadius),
            color: AppColors().grey40,
            image: imageFiles?[index] != null ? DecorationImage(
              image: FileImage(imageFiles![index]),
              fit: BoxFit.cover,
            ): null
        ),

      ),
    );
  }

}








