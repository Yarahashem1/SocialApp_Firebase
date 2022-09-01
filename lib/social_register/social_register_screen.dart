
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/myApp/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cubit.dart';
import '../helperClasses/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


class SocialRegisterScreen extends StatelessWidget {
  
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passworddController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialGetUserLoadingState)
            // ignore: curly_braces_in_flow_control_structures, prefer_const_constructors
            Center(child: const CircularProgressIndicator());
          if (state is SocialGetUserSuccessState) {
            navigateAndFinish(
              context,
              //SocialLayout(),
              ProfileScreen(),
            );
          }
        },
        builder: (context, state) {
          var profileImage = SocialRegisterCubit.get(context).profileImage;

          return Scaffold(
            appBar: AppBar(
             backgroundColor:AppCubit.get(context).isDark?Color.fromARGB(255, 34, 31, 31): Color.fromARGB(255, 204, 200, 200),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            if (profileImage == null)
                              CircleAvatar(
                                  radius: 64.0,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: const CircleAvatar(
                                      radius: 80.0,
                                      backgroundImage: NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfqGSpRSWM2LH7fa_Vvrr4V0IGlvG_QWXpJofT1-E&s ',
                                      )
                                    
                                      )),
                            if (profileImage != null)
                              CircleAvatar(
                                  radius: 64.0,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                      radius: 80.0,
                                      backgroundImage: FileImage(profileImage)
                                      // NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfqGSpRSWM2LH7fa_Vvrr4V0IGlvG_QWXpJofT1-E&s')

                                      )),
                            IconButton(
                              icon: const CircleAvatar(
                                radius: 20.0,
                                child: Icon(
                                  Icons.camera_enhance,
                                  size: 16.0,
                                ),
                              ),
                              onPressed: () {
                                SocialRegisterCubit.get(context)
                                    .getProfileImage();
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            }
                          },
                          label: 'User Name',
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: SocialRegisterCubit.get(context).suffix,
                          onSubmit: (value) {},
                          isPassword:
                              SocialRegisterCubit.get(context).isPassword,
                          suffixPressed: () {
                            SocialRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passworddController,
                          type: TextInputType.visiblePassword,
                          suffix: SocialRegisterCubit.get(context).suffix,
                          onSubmit: (value) {},
                          isPassword:
                              SocialRegisterCubit.get(context).isPassword,
                          suffixPressed: () {
                            SocialRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (String? value) {
                            if (passworddController.text !=
                                passwordController.text) {
                              return 'Password does not match';
                            }
                          },
                          label: 'Confirm Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone number';
                            }
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState && state is! SocialGetUserLoadingState 
                          && state is! SocialCreateUserSuccessState&& state is! SocialUserUpdateLoadingState ,
                          builder: (context) => defaultButton(
                            function: () {
                              String images = ' ';
                            
                              if (formKey.currentState!.validate()) {
                                   SocialRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                  image: images,
                                );
                              }
                            },
                            text: 'register',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
