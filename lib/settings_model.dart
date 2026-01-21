import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

enum ColorSettingType {
  main,
  titleBar,
  defaultTab,
  defaultTabTitleBar,
  currentTabColor
}

class SettingsModel extends ChangeNotifier {
  Color mainColor = const Color(0xFFfffff);
  Color titleBarColor = const Color(0xFFBBBBBB);
  Color defaultTabColor = const Color(0xFFBB21F3);
  Color defaultTabTitleBarColor = const Color(0xFFBB21F3);
  bool saveHistory = true;
  Color currentTabColor = const Color(0xFFBB21F3);


  Future<void> saveSettingsToJson(BuildContext context) async {
    final file = await getOrCreateLocationsFile();
    final settings = context.read<SettingsModel>();

    final jsonData = {
      "Settings": {
        "Color": "0x${settings.mainColor.value.toRadixString(16)}",
        "TitleBarColor": "0x${settings.titleBarColor.value.toRadixString(16)}",
        "DefaultTabColor": "0x${settings.defaultTabColor.value.toRadixString(16)}",
        "DefaultTabTitleBarColor":
        "0x${settings.defaultTabTitleBarColor.value.toRadixString(16)}",
        "SaveHistory": settings.saveHistory,
      }
    };

    await file.writeAsString(jsonEncode(jsonData));
  }

  Future<File> getOrCreateLocationsFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String workappPath = "${appDocDir.path}/workapp";
    String assetsPath = "$workappPath/assets";
    String filePath = "$assetsPath/settings.json";
    Directory workappDir = Directory(workappPath);
    Directory assetsDir = Directory(assetsPath);
    File locationsFile = File(filePath);
    if (!await workappDir.exists()) {
      await workappDir.create();
    }
    if (!await assetsDir.exists()) {
      await assetsDir.create();
    }
    if (!await locationsFile.exists()) {
      await locationsFile.writeAsString(
          """{"Settings":{"Color":"0xFFBB21F3","TitleBarColor":"0xFFBB21F3","DefaultTabColor":"0xFFBB21F3","DefaultTabTitleBarColor":"0xFFBB21F3","SaveHistory":true}}""");
    }
    return locationsFile;
  }

  Future<void> loadSettingsFromJson(BuildContext context) async {
    final file = await getOrCreateLocationsFile();
    final jsonData = json.decode(await file.readAsString());
    final data = jsonData["Settings"];
    mainColor = Color(int.parse(data["Color"]));
    titleBarColor = Color(int.parse(data["TitleBarColor"]));
    defaultTabColor = Color(int.parse(data["DefaultTabColor"]));
    defaultTabTitleBarColor =
        Color(int.parse(data["DefaultTabTitleBarColor"]));
    saveHistory = data["SaveHistory"];
    notifyListeners();
  }


  Color getColor(ColorSettingType type) {
    switch (type) {
      case ColorSettingType.main:
        return mainColor;
      case ColorSettingType.titleBar:
        return titleBarColor;
      case ColorSettingType.defaultTab:
        return defaultTabColor;
      case ColorSettingType.defaultTabTitleBar:
        return defaultTabTitleBarColor;
      case ColorSettingType.currentTabColor:
        return currentTabColor;
    }
  }

  void setColor(ColorSettingType type, Color color) {
    switch (type) {
      case ColorSettingType.main:
        mainColor = color;
        break;
      case ColorSettingType.titleBar:
        titleBarColor = color;
        break;
      case ColorSettingType.defaultTab:
        defaultTabColor = color;
        break;
      case ColorSettingType.defaultTabTitleBar:
        defaultTabTitleBarColor = color;
        break;
      case ColorSettingType.currentTabColor:
        currentTabColor = color;
    }
    notifyListeners();
  }

  void toggleSaveHistory() {
    saveHistory = !saveHistory;
    notifyListeners();
  }
}
