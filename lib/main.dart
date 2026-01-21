import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:workapp/camera.dart';
import 'package:workapp/pacman/HomePage.dart';
import 'package:workapp/phoneNotes.dart';
import 'package:workapp/settings_model.dart';
import 'assets/speed_test_card.dart';
import 'browserapp.dart';
import 'contactList.dart';
import 'maps.dart';
import 'dart:math' as math;
import 'package:bitsdojo_window/bitsdojo_window.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WindowManager()),
        ChangeNotifierProvider(create: (_) => SettingsModel()),
      ],
      child: const MyApp(),
    ),
  );
  doWhenWindowReady(() {
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Color invert(Color color) {
    final r = 122 - color.red;
    final g = 122 - color.green;
    final b = 122 - color.blue;
    return Color.fromARGB(color.alpha, r, g, b);
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Home Page',
            theme: ThemeData(
              textTheme:  TextTheme(
                bodyLarge: TextStyle(color: invert(settings.defaultTabColor)),
                bodySmall: TextStyle(color: invert(settings.defaultTabColor)),
              ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: invert(settings.titleBarColor),
              ),
            ),
            colorScheme: ColorScheme.fromSeed(
            seedColor: invert(settings.mainColor),
        ),

              appBarTheme: AppBarTheme(
                backgroundColor: invert(settings.titleBarColor),
              ),
              useMaterial3: true,
            ),
          home: HomeScreen(),
        );
      }
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Size? _widgetSize;
final GlobalKey _widgetKey = GlobalKey();

class _HomeScreenState extends State<HomeScreen> {
  late final List<AppBubbleData> bubbles;
  Size currentOffsetMod = Size(0, 0);
  bool offsetReversed = false;
  Color currentColor = Color(0xFF2C2333);



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsModel>().loadSettingsFromJson(context);
      final RenderBox? renderBox =
          _widgetKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _widgetSize = renderBox.size;
        });
      }
    });
    bubbles = [

      AppBubbleData(
        id: 'contacts',
        icon: Icons.contact_mail_outlined,
        label: 'Contact List',
        position: const Offset(0, 0),
        onDoubleTap: () {
          context.read<WindowManager>().open(
            DesktopWindowData(
                id: 'Contact List',
                title: 'Contact List',
                child: ContactListApp(
                    title:
                    'Contact List Application'),
                position: Offset(
                    currentOffsetMod.width,
                    currentOffsetMod.height),
                focused: false),
          );
        },
      ),
      AppBubbleData(
        id: 'browser',
        icon: Icons.open_in_browser,
        label: 'Browser',
        position: const Offset(0, 48),
        onDoubleTap: () {
          context.read<WindowManager>().open(
            DesktopWindowData(
                id: 'Browser',
                title: 'Browser',
                child: BrowserApp(
                    baseURL:
                    'https://www.google.com'),
                position: Offset(
                    currentOffsetMod.width,
                    currentOffsetMod.height),
                focused: false),
          );
        },
      ),
      AppBubbleData(
        id: 'Camera Application',
        icon: Icons.camera_alt_outlined,
        label: 'Camera Application',
        position: const Offset(0, 96),
        onDoubleTap: () {
          context.read<WindowManager>().open(
            DesktopWindowData(
                id: 'Camera Application',
                title: 'Camera Application',
                child: CameraApp(
                    title:
                    'Camera Application'),
                position: Offset(
                    currentOffsetMod.width,
                    currentOffsetMod.height),
                focused: false),
          );
        },
      ),
      AppBubbleData(
        id: 'Phone Notes',
        icon: Icons.phone,
        label: 'Phone Notes',
        position: const Offset(0, 144),
        onDoubleTap: () {
          context.read<WindowManager>().open(
            DesktopWindowData(
                id: 'Phone Notes',
                title: 'Phone Notes',
                child: PhoneNotes(
                    title: 'Phone Notes'),
                position: Offset(
                    currentOffsetMod.width,
                    currentOffsetMod.height),
                focused: false),
          );
        },
      ),
      AppBubbleData(
        id: 'Speed Test',
        icon: Icons.speed,
        label: 'Speed Test',
        position: const Offset(0, 192),
        onDoubleTap: () {
          context.read<WindowManager>().open(
            DesktopWindowData(
                id: 'Speed Test',
                title: 'Speed Test',
                child: SpeedTestCard(),
                position: Offset(
                    currentOffsetMod.width,
                    currentOffsetMod.height),
                focused: false),
          );
        },
      ),
      AppBubbleData(
        id: 'Technical Magic Locations',
        icon: Icons.map_sharp,
        label: 'Technical Magic Locations',
        position: const Offset(0, 240),
        onDoubleTap: () {
          context.read<WindowManager>().open(
            DesktopWindowData(
                id:
                'Technical Magic Locations',
                title:
                'Technical Magic Locations',
                child: Maps(
                    title:
                    'Technical Magic Locations'),
                position: Offset(
                    currentOffsetMod.width,
                    currentOffsetMod.height),
                focused: false),
          );
        },
      ),
      AppBubbleData(
        id: 'pacman',
        icon: Icons.play_circle_outline,
        label: 'pacman',
        position: const Offset(0, 288),
        onDoubleTap: () {
          context.read<WindowManager>().open(
            DesktopWindowData(
                id: 'pacman',
                title: 'pacman',
                child: PHomePage(),
                position: Offset(
                    currentOffsetMod.width,
                    currentOffsetMod.height),
                size: Size(400, 1000),
                focused: false),
          );
        },
      ),
    ];

  }


  Widget fadingText(String text) {
    int textNoSpace = (text.replaceAll(RegExp(r'\s+'), '')).length;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: textNoSpace > 11 ? text.substring(0, 9) : text,
            style: const TextStyle(color: Colors.black),
          ),
          if (textNoSpace > 11)
            TextSpan(
              text: text.substring(9, 11),
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
        ],
      ),
    );
  }

  void showColorPickerDialog(
      BuildContext context,
      ColorSettingType settingType,
      ) {
    final settings = context.read<SettingsModel>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color'),
        content: SizedBox(
          height: 400,
          child: ColorPicker(
            pickerColor: settings.getColor(settingType),
            onColorChanged: (color) {
              settings.setColor(settingType, color);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              settings.saveSettingsToJson(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _settingsButton(
      BuildContext context,
      String label,
      Color color,
      VoidCallback onTap,
      ) {
    return TextButton(
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(width: 15, height: 15, color: color),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: settings.titleBarColor,
        automaticallyImplyLeading: false,
        flexibleSpace: MoveWindow(),
        leading: SizedBox(
          width: 150,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setStateDialog) {
                            return AlertDialog(
                              title: Text("App Addition"),
                              content: CircularNavMenu(
                                items: [
                                  NavBubble(
                                      icon: Icons.contact_mail_outlined,
                                      label: "Contact List",
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.read<WindowManager>().open(
                                              DesktopWindowData(
                                                  id: 'Contact List',
                                                  title: 'Contact List',
                                                  child: ContactListApp(
                                                      title:
                                                          'Contact List Application'),
                                                  position: Offset(
                                                      currentOffsetMod.width,
                                                      currentOffsetMod.height),
                                                  focused: false),
                                            );
                                        double? x =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.height);
                                        double y =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.width);
                                        currentOffsetMod = Size(y, x);
                                      }),
                                  NavBubble(
                                      icon: Icons.open_in_browser,
                                      label: "Browser",
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.read<WindowManager>().open(
                                              DesktopWindowData(
                                                  id: 'Browser',
                                                  title: 'Browser',
                                                  child: BrowserApp(
                                                      baseURL:
                                                          'https://www.google.com'),
                                                  position: Offset(
                                                      currentOffsetMod.width,
                                                      currentOffsetMod.height),
                                                  focused: false),
                                            );
                                        double? x =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.height);
                                        double y =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.width);
                                        currentOffsetMod = Size(y, x);
                                      }),
                                  NavBubble(
                                      icon: Icons.camera_alt,
                                      label: "Camera",
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.read<WindowManager>().open(
                                              DesktopWindowData(
                                                  id: 'Camera Application',
                                                  title: 'Camera Application',
                                                  child: CameraApp(
                                                      title:
                                                          'Camera Application'),
                                                  position: Offset(
                                                      currentOffsetMod.width,
                                                      currentOffsetMod.height),
                                                  focused: false),
                                            );
                                        double? x =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.height);
                                        double y =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.width);
                                        currentOffsetMod = Size(y, x);
                                      }),
                                  NavBubble(
                                      icon: Icons.phone,
                                      label: "Phone Notes",
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.read<WindowManager>().open(
                                              DesktopWindowData(
                                                  id: 'Phone Notes',
                                                  title: 'Phone Notes',
                                                  child: PhoneNotes(
                                                      title: 'Phone Notes'),
                                                  position: Offset(
                                                      currentOffsetMod.width,
                                                      currentOffsetMod.height),
                                                  focused: false),
                                            );
                                        double? x =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.height);
                                        double y =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.width);
                                        currentOffsetMod = Size(y, x);
                                      }),
                                  NavBubble(
                                      color: Colors.blue,
                                      icon: Icons.terminal,
                                      label: "Terminal Application (NF)",
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.read<WindowManager>().open(
                                              DesktopWindowData(
                                                  id: 'Speed Test',
                                                  title: 'Speed Test',
                                                  child: SpeedTestCard(),
                                                  position: Offset(
                                                      currentOffsetMod.width,
                                                      currentOffsetMod.height),
                                                  focused: false),
                                            );
                                        double? x =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.height);
                                        double y =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.width);
                                        currentOffsetMod = Size(y, x);
                                      }),
                                  NavBubble(
                                      icon: Icons.map_sharp,
                                      label: "Technical Magic Locations",
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.read<WindowManager>().open(
                                              DesktopWindowData(
                                                  id:
                                                      'Technical Magic Locations',
                                                  title:
                                                      'Technical Magic Locations',
                                                  child: Maps(
                                                      title:
                                                          'Technical Magic Locations'),
                                                  position: Offset(
                                                      currentOffsetMod.width,
                                                      currentOffsetMod.height),
                                                  focused: false),
                                            );
                                        double? x =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.height);
                                        double y =
                                            (math.Random().nextDouble() * 1000)
                                                .clamp(0, _widgetSize!.width);
                                        currentOffsetMod = Size(y, x);
                                      }),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                context.read<WindowManager>().open(
                      DesktopWindowData(
                          id: 'Settings',
                          title: 'Settings',
                          child: Consumer<SettingsModel>(
                            builder: (context, settings, _) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _settingsButton(
                                      context,
                                      "Main Color",
                                      settings.mainColor,
                                          () => showColorPickerDialog(context, ColorSettingType.main),
                                    ),
                                    _settingsButton(
                                      context,
                                      "Title Bar Color",
                                      settings.titleBarColor,
                                          () => showColorPickerDialog(context, ColorSettingType.titleBar),
                                    ),
                                    _settingsButton(
                                      context,
                                      "Default Tab Color",
                                      settings.defaultTabColor,
                                          () => showColorPickerDialog(context, ColorSettingType.defaultTab),
                                    ),
                                    _settingsButton(
                                      context,
                                      "Default Tab Title Bar Color",
                                      settings.defaultTabTitleBarColor,
                                          () => showColorPickerDialog(context, ColorSettingType.defaultTabTitleBar),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        settings.saveHistory = !settings.saveHistory;
                                        settings.notifyListeners();
                                        context.read<SettingsModel>().saveSettingsToJson(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Save Browser History"),
                                          Icon(settings.saveHistory
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          position: Offset(
                              currentOffsetMod.width, currentOffsetMod.height),
                          focused: false),
                    );
              },
              icon: Icon(Icons.settings)),
          TextButton(
              onPressed: () {
                context.read<WindowManager>().closeAll();
              },
              child: Text("Close All Windows",style: TextStyle(),)),
          const WindowButtons()
        ],
      ),
      body: Consumer<WindowManager>(
        builder: (context, wm, _) {
          return Stack(
            alignment: AlignmentGeometry.bottomLeft,
            children: [
              Container(key: _widgetKey, color: settings.mainColor),
              AppLinksMenu(
                items: bubbles,
              ),
              for (final window in wm.zOrder)
                DesktopWindow(
                  key: ValueKey(window.id),
                  window: window,
                  onClose: () => wm.close(window),
                  onFocus: () => wm.focus(window),
                ),
              BottomAppBar(
                  height: 70,
                  color: Colors.transparent,
                  child: Consumer<WindowManager>(builder: (context, wm, _) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          for (final window in wm.tabs)
                            TextButton(
                                onPressed: () {
                                  wm.focus(window);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (!window.focused)
                                      ? Colors.grey
                                      : Colors.blueGrey,
                                ),
                                child: SizedBox(
                                  height: 30,
                                  width: 120,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      fadingText(window.title),
                                      IconButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            wm.close(window);
                                          },
                                          icon: Icon(Icons.close))
                                    ],
                                  ),
                                ))
                        ],
                      ),
                    );
                  })),
            ],
          );
        },
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatefulWidget {
  const WindowButtons({super.key});

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        appWindow.isMaximized
            ? RestoreWindowButton(
          colors: buttonColors,
          onPressed: maximizeOrRestore,
        )
            : MaximizeWindowButton(
          colors: buttonColors,
          onPressed: maximizeOrRestore,
        ),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

class DesktopWindow extends StatefulWidget {
  final DesktopWindowData window;
  final VoidCallback onClose;
  final VoidCallback onFocus;

  const DesktopWindow({
    super.key,
    required this.window,
    required this.onClose,
    required this.onFocus,
  });

  @override
  State<DesktopWindow> createState() => _DesktopWindowState();
}

class _DesktopWindowState extends State<DesktopWindow> {
  static const double minWidth = 550;
  static const double minHeight = 200;
  bool maximized = false;
  Color? customTitleBarColor;
  Color tempPickerColor = Colors.white;
  Color? customMainColor;


  void resizeHelper (){
    final RenderBox? renderBox =
    _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _widgetSize = renderBox.size;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final Color mainColor =
        customMainColor ?? settings.defaultTabColor;
    return Positioned(
      left: widget.window.position.dx,
      top: widget.window.position.dy,
      child: GestureDetector(
        onTap: widget.onFocus,
        onLongPress: widget.onFocus,
        child: Material(
          color: mainColor,
          elevation: 12,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: widget.window.size.width,
            height: widget.window.size.height,
            child: Column(
              children: [
                _titleBar(),
                Expanded(child: widget.window.child),
                _resizeHandle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showColorPickerTitleBarDialog(BuildContext context) {
    tempPickerColor = customTitleBarColor ??
        context.read<SettingsModel>().defaultTabTitleBarColor;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color'),
        content: SizedBox(
          height: 400,
          child: ColorPicker(
            pickerColor: tempPickerColor,
            onColorChanged: (color) {
              setState(() {
                tempPickerColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                customTitleBarColor = tempPickerColor;
              });
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
  void showColorPickerMainColorDialog(BuildContext context) {
    tempPickerColor = customMainColor ??
        context.read<SettingsModel>().defaultTabColor;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color'),
        content: SizedBox(
          height: 400,
          child: ColorPicker(
            pickerColor: tempPickerColor,
            onColorChanged: (color) {
              setState(() {
                tempPickerColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                customMainColor = tempPickerColor;
              });
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _titleBar() {

    final settings = context.watch<SettingsModel>();
    final Color titleBarColor =
        customTitleBarColor ?? settings.defaultTabTitleBarColor;
    return GestureDetector(
      onPanStart: (_) {
        widget.onFocus();
        if (maximized) {
          maximized = false;
          widget.window.size = Size(minWidth, minHeight);
        }
      },
      onPanUpdate: (details) {
        setState(() {
          widget.window.position += details.delta;
        });
      },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: titleBarColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              widget.window.title,
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      
                  title: const Text('Pick a color'),
                  content: SizedBox(
                    height: 90,
                    child: SingleChildScrollView(
                      child: Column(children: [TextButton(onPressed: () => showColorPickerTitleBarDialog(context), child: Text("Choose The Title Bar Color")),
                                      TextButton(onPressed: () => showColorPickerMainColorDialog(context), child: Text("Choose The Main Window Color"))
                      ],),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        settings.saveSettingsToJson(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ));
                },
            ),
            IconButton(
                icon: Icon(maximized ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white),
                onPressed: () {
                  resizeHelper();
                  setState(() {
                    maximized = !maximized;
                    maximized
                        ? widget.window.size = ((_widgetSize != null)
                            ? _widgetSize
                            : Size(minWidth, minHeight))!
                        : widget.window.size = Size(minWidth, minHeight);
                    widget.window.position = Offset(0, 0);
                  });
                }),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: widget.onClose,
            ),
          ],
        ),
      ),
    );
  }

  Widget _resizeHandle() {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            widget.window.size = Size(
              (widget.window.size.width + details.delta.dx)
                  .clamp(minWidth, double.infinity),
              (widget.window.size.height + details.delta.dy)
                  .clamp(minHeight, double.infinity),
            );
          });
        },
        child: const Padding(
          padding: EdgeInsets.all(6),
          child: Icon(
            Icons.drag_handle,
            size: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class WindowManager extends ChangeNotifier {
  final List<DesktopWindowData> _tabs = [];
  final List<DesktopWindowData> _zOrder = [];

  List<DesktopWindowData> get tabs => List.unmodifiable(_tabs);

  List<DesktopWindowData> get zOrder => List.unmodifiable(_zOrder);

  int get count => _tabs.length;

  void open(DesktopWindowData window) {
    int counter = 0;
    for (final w in _tabs) {
      if (w.title == window.title || w.title.startsWith('${window.title}(')) {
        counter++;
      }
    }

    final DesktopWindowData finalWindow;
    if (counter == 0) {
      finalWindow = window;
    } else {
      finalWindow = DesktopWindowData(
        id: '${window.id}_$counter',
        title: '${window.title}($counter)',
        child: window.child,
        position: window.position,
        size: window.size,
        focused: false,
      );
    }

    _tabs.add(finalWindow);
    _zOrder.add(finalWindow);

    focus(finalWindow);
    notifyListeners();
  }

  void close(DesktopWindowData window) {
    final wasFocused = window.focused;

    _tabs.remove(window);
    _zOrder.remove(window);

    if (wasFocused && _zOrder.isNotEmpty) {
      focus(_zOrder.last);
    } else {
      notifyListeners();
    }
  }

  void closeAll() {
    _tabs.clear();
    _zOrder.clear();
    notifyListeners();
  }

  void focus(DesktopWindowData window) {
    if (_zOrder.isNotEmpty && identical(_zOrder.last, window)) return;

    for (final w in _zOrder) {
      w.focused = false;
    }

    window.focused = true;

    _zOrder
      ..remove(window)
      ..add(window);

    notifyListeners();
  }

  Offset? getWindowPosition(DesktopWindowData window) {
    final index = _zOrder.indexOf(window);
    if (index == -1) return null;
    return _zOrder[index].position;
  }

  Offset? getWindowPositionByTitle(String title) {
    try {
      return _tabs.firstWhere((w) => w.title == title).position;
    } catch (_) {
      return null;
    }
  }
}

class DesktopWindowData {
  final String id;
  Offset position;
  Size size;
  bool focused;
  final Widget child;
  final String title;

  DesktopWindowData({
    required this.id,
    required this.child,
    required this.title,
    required this.focused,
    this.position = const Offset(100, 100),
    this.size = const Size(550, 300),
  });
}

class AppBubbleData {
  final String id;
  final IconData icon;
  final String label;
  final VoidCallback onDoubleTap;

  Offset position;

  AppBubbleData({
    required this.id,
    required this.icon,
    required this.label,
    required this.onDoubleTap,
    this.position = const Offset(20, 20),
  });
}

class AppLinksMenu extends StatelessWidget {
  final List<AppBubbleData> items;
  final double bubbleSize;

  const AppLinksMenu({
    super.key,
    required this.items,
    this.bubbleSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final item in items)
          DraggableBubble(
            key: ValueKey(item.id),
            item: item,
            bubbleSize: bubbleSize,
          ),
      ],
    );
  }
}

class DraggableBubble extends StatefulWidget {
  final AppBubbleData item;
  final double bubbleSize;

  const DraggableBubble({
    super.key,
    required this.item,
    required this.bubbleSize,
  });

  @override
  State<DraggableBubble> createState() => _DraggableBubbleState();
}

class _DraggableBubbleState extends State<DraggableBubble> {
  static const double spacing = 8;

  Offset snap(Offset position) {
    final grid = widget.bubbleSize + spacing;

    return Offset(
      (position.dx / grid).round() * grid,
      (position.dy / grid).round() * grid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.item.position.dx,
      top: widget.item.position.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          setState(() {
            widget.item.position += details.delta;
          });
        },
        onPanEnd: (_) {
          setState(() {
            widget.item.position = snap(widget.item.position);
          });
        },
        child: InkWell(
          onDoubleTap: widget.item.onDoubleTap,
          borderRadius: BorderRadius.circular(widget.bubbleSize),
          child: Container(
            width: widget.bubbleSize,
            height: widget.bubbleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey,
            ),
            child: Icon(
              widget.item.icon,
              size: widget.bubbleSize * 0.45,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class NavBubble {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  NavBubble({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}

class CircularNavMenu extends StatefulWidget {
  final List<NavBubble> items;
  final double bubbleSize;
  final double padding;
  final Widget? centerWidget;

  const CircularNavMenu({
    super.key,
    required this.items,
    this.bubbleSize = 120,
    this.padding = 24,
    this.centerWidget,
  });

  @override
  State<CircularNavMenu> createState() => _CircularNavMenuState();
}

class _CircularNavMenuState extends State<CircularNavMenu> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = math.min(constraints.maxWidth, constraints.maxHeight);
          final radius = (size / 2) - (widget.bubbleSize / 2) - widget.padding;
          final center = Offset(size / 2, size / 2);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              if (widget.centerWidget != null)
                Positioned(
                  left: center.dx - widget.bubbleSize / 2,
                  top: center.dy - widget.bubbleSize / 2,
                  child: SizedBox(
                    width: widget.bubbleSize,
                    height: widget.bubbleSize,
                    child: Center(child: widget.centerWidget),
                  ),
                ),
              for (int i = 0; i < widget.items.length; i++)
                _positionedBubble(
                  i: i,
                  total: widget.items.length,
                  radius: radius,
                  center: center,
                  bubbleSize: widget.bubbleSize,
                  item: widget.items[i],
                  context: context,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _positionedBubble({
    required int i,
    required int total,
    required double radius,
    required Offset center,
    required double bubbleSize,
    required NavBubble item,
    required BuildContext context,
  }) {
    final double angle = (2 * math.pi * i / total) - math.pi / 2;
    final double x = center.dx + radius * math.cos(angle) - bubbleSize / 2;
    final double y = center.dy + radius * math.sin(angle) - bubbleSize / 2;

    final Color bg =
        item.color ?? Theme.of(context).colorScheme.primaryContainer;
    final Color fg = Theme.of(context).colorScheme.onPrimaryContainer;

    return Positioned(
      left: x,
      top: y,
      child: Tooltip(
        message: item.label,
        waitDuration: const Duration(milliseconds: 400),
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(bubbleSize),
          child: Container(
            width: bubbleSize,
            height: bubbleSize,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
            child: Icon(item.icon, size: bubbleSize * 0.45, color: fg),
          ),
        ),
      ),
    );
  }
}
