import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cross_fitness/core/service/auth_service.dart';
import 'package:cross_fitness/core/service/user_storage_service.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

// class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
//   SettingsBloc() : super(SettingsInitial());

//   @override
//   Stream<SettingsState> mapEventToState(
//     SettingsEvent event,
//   ) async* {}
// }
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsReloadImageEvent) {
      String? photoURL = await UserStorageService.readSecureData('image');
      if (photoURL == null) {
        photoURL = AuthService.auth.currentUser?.photoURL;
        photoURL != null
            ? await UserStorageService.writeSecureData('image', photoURL)
            : log('no image');
        yield SettingsReloadImageState(photoURL: photoURL);
      }
    } else if (event is SettingsReloadDisplayNameEvent) {
      final displayName = await UserStorageService.readSecureData('name');
      yield SettingsReloadDisplayNameState(displayName: displayName);
    }
  }
}
