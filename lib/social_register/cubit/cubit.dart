import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/social.dart';

import 'package:flutter_application_2/social_register/cubit/states.dart';
import 'package:flutter_application_2/styles/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../helperClasses/components.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);
  SocialUserModel? userModel;
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  final _firestore = FirebaseFirestore.instance;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String image,
  }) {
    print('hello');

    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(
        uId: value.user!.uid,
        phone: phone,
        email: email,
        name: name,
        image: image,
      );
      uploadProfileImage();
    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
    required String image,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'write you bio ...',
      image: image,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SocialRegisterChangePasswordVisibilityState());
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  void uploadProfileImage() {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
          image: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void getUserData() async {
    emit(SocialGetUserLoadingState());

    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(signedInUser.uid).get();
        userModel = SocialUserModel.fromJson(userDoc.data());
        emit(SocialGetUserSuccessState());
      }
    } catch (error) {
      print('error');
      emit(SocialGetUserErrorState(error.toString()));
    }
  }

  void updateUser({
    String? image,
  }) {
    SocialUserModel model = SocialUserModel(image: image);
    print(model.image);
    //userModel!.image = model.image;
    final user = _auth.currentUser;
    if (user != null) {
      signedInUser = user;
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(signedInUser.uid);
      docUser.update({'image': image}).then((value) {
        getUserData();
      });
    }
   
  }
}
