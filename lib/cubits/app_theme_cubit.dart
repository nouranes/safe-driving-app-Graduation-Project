import 'package:bloc/bloc.dart';
import 'package:final_project/cubits/app_theme_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit() : super(AppThemeInitial());

  void changeTheme() {
    emit(state is AppLightTheme ? AppDarkTheme() : AppLightTheme());
  }
}
