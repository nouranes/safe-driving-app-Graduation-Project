import 'package:bloc/bloc.dart';
import 'package:final_project/cubits/app_theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  static const String _themePreferenceKey = 'themePreference';

  AppThemeCubit() : super(AppLightTheme()) {
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDarkTheme =
        prefs.getBool(_themePreferenceKey) ?? false; // Default to light theme
    emit(isDarkTheme ? AppDarkTheme() : AppLightTheme());
  }

  void changeTheme() async {
    bool isCurrentlyLight = state is AppLightTheme;
    emit(isCurrentlyLight ? AppDarkTheme() : AppLightTheme());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, !isCurrentlyLight);
  }
}
