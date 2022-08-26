import 'package:flutter_application_2/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../styles/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = false;
  

  void changeAppMode({bool? fromShared}) {
   
      isDark = !isDark;
     // CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
     // });
   
  }
}
