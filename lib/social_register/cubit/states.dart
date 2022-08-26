abstract class SocialRegisterStates {}

class SocialRegisterInitialState extends SocialRegisterStates {}

class SocialRegisterLoadingState extends SocialRegisterStates {}

class SocialRegisterSuccessState extends SocialRegisterStates {}

class SocialRegisterErrorState extends SocialRegisterStates
{
  final String error;

  SocialRegisterErrorState(this.error);
}

class SocialCreateUserSuccessState extends SocialRegisterStates {}

class SocialCreateUserErrorState extends SocialRegisterStates
{
  final String error;

  SocialCreateUserErrorState(this.error);
}

class SocialRegisterChangePasswordVisibilityState extends SocialRegisterStates {}



class SocialProfileImagePickedSuccessState extends SocialRegisterStates {}

class SocialProfileImagePickedErrorState extends SocialRegisterStates {}

class SocialUserUpdateLoadingState extends SocialRegisterStates {}

class SocialUserUpdateErrorState extends SocialRegisterStates {}


class SocialUploadProfileImageSuccessState extends SocialRegisterStates {}

class SocialUploadProfileImageErrorState extends SocialRegisterStates {}


class SocialGetUserLoadingState extends SocialRegisterStates{}

class SocialGetUserSuccessState extends SocialRegisterStates {}

class SocialGetUserErrorState extends SocialRegisterStates
{
  final String error;

  SocialGetUserErrorState(this.error);
}

