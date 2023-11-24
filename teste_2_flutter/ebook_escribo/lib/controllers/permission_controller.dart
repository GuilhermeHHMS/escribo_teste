// import 'package:device_info_plus/device_info_plus.dart';
import 'package:ebook_escribo/controllers/book_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionController {
  BookController bookController = BookController();

/*

Linhas inativas devido aos conflitos do permission_handler nativo do vocsy com o do permission_handler do pacote original, causando falhas ANR

Para mais informações da lógica de permissão de armazenamento, acessar o AndroidManifest.xml
*/
  Future<bool> downloadPermissionAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // int sdk = androidInfo.version.sdkInt;

    // bool isAndroid11Version = sdk > 30;

    // final permissionRequest = isAndroid11Version
    //     ? Permission.manageExternalStorage
    //     : Permission.storage;

    const permissionRequest = Permission.manageExternalStorage;

    final statusStorage = await permissionRequest.request();
    if (statusStorage == PermissionStatus.granted) {
      prefs.setBool('storagePermission', true);

      return true;
    } else {
      return false;
    }
  }
}
