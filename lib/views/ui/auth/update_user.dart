import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:job_finder_app/controllers/image_provider.dart';
import 'package:job_finder_app/controllers/login_provider.dart';
import 'package:job_finder_app/controllers/zoom_notifier.dart';
import 'package:job_finder_app/model/request/profile_update_model.dart';
import 'package:job_finder_app/views/common/custom_button.dart';
import 'package:job_finder_app/views/common/custom_text_field.dart';
import 'package:job_finder_app/views/common/reusable_text.dart';
import 'package:provider/provider.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  TextEditingController phone = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController skill0 = TextEditingController();
  TextEditingController skill1 = TextEditingController();
  TextEditingController skill2 = TextEditingController();
  TextEditingController skill3 = TextEditingController();
  TextEditingController skill4 = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phone.dispose();
    location.dispose();
    skill0.dispose();
    skill1.dispose();
    skill2.dispose();
    skill3.dispose();
    skill4.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final imageUploader = Provider.of<ImageUploader>(context,listen: true);
    return Scaffold(
     
      body: Consumer<LoginNotifier>(  // LoginNotifier which is provider file(must same this name)
        builder: (context, loginNotifier, child) {  // loginNotifier use any name here
        return Form(
          key: loginNotifier.profileFormKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 60),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
          ReusableText(text: 'Personal Details', style: TextStyle(fontSize: 35,
          color: Colors.black, fontWeight: FontWeight.bold)),

                  // image upload na thakle empty hobe tai image pick korbe
                  imageUploader.imageFil.isEmpty? GestureDetector(
                    onTap: (){
                      // image gallery open hobe
                     imageUploader.pickImage();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      //backgroundImage: ,
                      child: Icon(Icons.photo_filter_rounded),
                    ),
                  ):
                  GestureDetector(
                    onTap: (){
                      // image list ta clear hoye jasse
                      imageUploader.imageFil.clear();
                      setState(() {

                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      // selected image ta show korbe
                      backgroundImage: FileImage(File(imageUploader.imageFil[0])),

                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
          Form(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(controller: location, hintText: 'Location', keyboardType: TextInputType.text,
              validator: (location) {
                if(location!.isEmpty)
          {
            return "Please Enter valid location";
          }
                else{
          return null!;
                }
              },
              ),
              SizedBox(height: 10,),
              CustomTextField(controller: phone, hintText: 'Phone', keyboardType: TextInputType.number,
              validator: (phone) {
                if(phone!.isEmpty)
          {
            return "Please Enter valid phone";
          }
                else{
          return null!;
                }
              },
              ),
              SizedBox(height: 10,),
              ReusableText(text: 'Professional Skills', style: TextStyle(fontSize: 35,
          color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 10,),
              CustomTextField(controller: skill0, hintText: 'Professional Skills', keyboardType: TextInputType.text,
                validator: (skill0) {
          if(skill0!.isEmpty)
          {
            return "Please Enter valid professional skill";
          }
          else{
            return null!;
          }
                },
              ),
              SizedBox(height: 10,),
              CustomTextField(controller: skill1, hintText: 'Professional Skills', keyboardType: TextInputType.text,
                validator: (skill1) {
          if(skill1!.isEmpty)
          {
            return "Please Enter valid professional skill";
          }
          else{
            return null!;
          }
                },
              ),
              SizedBox(height: 10,),
              CustomTextField(controller: skill2, hintText: 'Professional Skills', keyboardType: TextInputType.text,
                validator: (skill2) {
          if(skill2!.isEmpty)
          {
            return "Please Enter valid professional skill";
          }
          else{
            return null!;
          }
                },
              ),
              SizedBox(height: 10,),
              CustomTextField(controller: skill3, hintText: 'Professional Skills', keyboardType: TextInputType.text,
                validator: (skill3) {
          if(skill3!.isEmpty)
          {
            return "Please Enter valid professional skill";
          }
          else{
            return null!;
          }
                },
              ),
              SizedBox(height: 10,),
              CustomTextField(controller: skill4, hintText: 'Professional Skills', keyboardType: TextInputType.text,
                validator: (skill4) {
          if(skill4!.isEmpty)
          {
            return "Please Enter valid professional skill";
          }
          else{
            return null!;
          }
                },
              ),
              SizedBox(height: 20,),
              Consumer<ImageUploader>(builder: (context, imageUploader, child) {
                return CustomButton(onTap: (){
if(imageUploader.imageFil.isEmpty && imageUploader.imageUrl == null)
  {
    Get.snackbar("Image Missing", "Please upload an image to proceed",
        colorText: Colors.white,
        backgroundColor: Colors.orange,
        icon: Icon(Icons.add_alert)
    );
  }else
    {
      ProfileUpdateModel model = ProfileUpdateModel(
          location: location.text,
          phone: phone.text,
          profile: imageUploader.imageUrl??"",
          skills: [skill0.text,skill1.text,skill2.text,skill3.text,skill4.text]
      );

      // call update profile function
      loginNotifier.updateProfile(model);
    }



                },text: 'Update Profile');
              },)
            ],
          ))
            ],
          ),
        );
      },)
    );
  }
}
