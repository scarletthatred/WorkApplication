import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:convert';

import 'browserapp.dart';
import 'main.dart';

class Maps extends StatefulWidget {
  const Maps({super.key, required this.title});

  final String title;

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _editXController = TextEditingController();
  final TextEditingController _editYController = TextEditingController();
  final TextEditingController _editUrlController = TextEditingController();
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editNicknameController = TextEditingController();
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];

  String type = "";
  String editID = "";
  List<_Pin> pins = [];
  Color pickerColor = Colors.blue;
  Color currentColor = Colors.blue;
  LatLng? _currentLocation;
  double _currentZoom = 0;
  double mapZoom = 0;

  //Works flawlessly
  Drawer pinDrawer() {
    if (type == "add") {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                  Text(
                    'Add New Pin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Location Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: 'Location Nickname'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _xController,
                decoration: InputDecoration(labelText: 'X Coordinate'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _yController,
                decoration: InputDecoration(labelText: 'Y Coordinate'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => showColorPickerDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      currentColor, // Use the currently selected color for the button
                ),
                child: Text('Choose Color'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _urlController,
                decoration: InputDecoration(labelText: 'Url to controller'),
                keyboardType: TextInputType.url,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                type = "";
                _addPin();
                Navigator.pop(context);
                setState(() {
                  _rebuildMarkers();
                });
              },
              child: Text('Save Location'),
            ),
          ],
        ),
      );
    } else if (type == "Edit") {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Edit Pin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _editNameController,
                decoration: InputDecoration(labelText: 'Location Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _editNicknameController,
                decoration: InputDecoration(labelText: 'Location Nickname'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _editXController,
                decoration: InputDecoration(labelText: 'X Coordinate'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _editYController,
                decoration: InputDecoration(labelText: 'Y Coordinate'),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => showColorPickerDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      currentColor, // Use the currently selected color for the button
                ),
                child: Text('Choose Color'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _editUrlController,
                decoration: InputDecoration(labelText: 'Url to controller'),
                keyboardType: TextInputType.url,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                type = "";
                _editPin(
                    newColor: currentColor,
                    newId: _editNicknameController.text,
                    newLat: double.parse(_editXController.text),
                    newLng: double.parse(_editYController.text),
                    newName: _editNameController.text,
                    newUrl: _editUrlController.text,
                    originalId: editID);
                Navigator.pop(context);
                setState(() {
                  _rebuildMarkers();
                });
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
              child: Text('Save Edit'),
              
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
              child: Text('Cancel'),
            ),
          ],
        ),
      );
    } else {
      type = "";
      return Drawer();
    }
  }

  //Works flawlessly
  Color _convertColor(String colorString) {
    switch (colorString) {
      case "Colors.lightGreen":
        return Colors.lightGreen;
      case "Colors.blue":
        return Colors.blue;
      case "Colors.red":
        return Colors.red;
      case "Colors.green":
        return Colors.green;
      case "Colors.orange":
        return Colors.orange;
      default:
        return Color(int.parse(colorString)); // fallback
    }
  }

  //Works flawlessly
  Future<void> noteTaker(BuildContext context, String pinID) async {
    List<String> noteList = [];

    File file = await getOrCreateLocationsFile();

    String jsonString = await file.readAsString();
    List<dynamic> jsonData = json.decode(jsonString);

    final pin = jsonData.firstWhere(
      (item) => item["Data"]["id"] == pinID,
      orElse: () => null,
    );

    if (pin == null) {
      return;
    }

    if (pin["Data"]["Note"] == null) {
      pin["Data"]["Note"] = "";
    }

    String fullNoteString = pin["Data"]["Note"];

    if (fullNoteString.isNotEmpty) {
      noteList = fullNoteString.split("\n");
    }

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("${pin["Data"]["name"]}"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(noteList.length, (index) {
                      return Row(
                        children: [
                          Expanded(child: SelectableText(noteList[index])),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setStateDialog(() {
                                noteList.removeAt(index);
                                pin["Data"]["Note"] = noteList.join("\n");
                              });
                            },
                          )
                        ],
                      );
                    }),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText: "Type note and press Enter",
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isEmpty) return;
                        setStateDialog(() {
                          noteList.add(value);
                          pin["Data"]["Note"] = noteList.join("\n");
                          _noteController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    const encoder = JsonEncoder.withIndent("  ");
                    await file.writeAsString(encoder.convert(jsonData));
                    setState(() {
                      final index = pins.indexWhere((p) => p.id == pinID);
                      if (index != -1) {
                        pins[index] = _Pin(
                          id: pinID,
                          name: pins[index].name,
                          point: pins[index].point,
                          url: pins[index].url,
                          color: pins[index].color,
                          note: noteList.join("\n"),
                        );
                      }
                      _rebuildMarkers();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Works flawlessly
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  //Works flawlessly
  void _showMenu(BuildContext context, Offset offset, Uri? url, LatLng latlan,
      String pinID) async {
    final long = latlan.longitude.toString();
    final lat = latlan.latitude.toString();
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final double centerX = overlay.size.width / 2;
    final double centerY = overlay.size.height / 2;

    final wm = context.read<WindowManager>();

    final Offset windowPos = wm.getWindowPositionByTitle('Technical Magic Locations')!;

    Offset localMenuOffset = Offset(70+centerX, 40 + centerY);

    final Offset menuAnchor = windowPos + localMenuOffset;


    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        menuAnchor.dx,
        menuAnchor.dy,
        menuAnchor.dx + 1,
        menuAnchor.dy + 1,
      ),
      items: [
        const PopupMenuItem(
          value: 'Controller',
          child: Text('Controller'),
        ),
        const PopupMenuItem(
          value: 'Navigation',
          child: Text('Navigation'),
        ),
        const PopupMenuItem(
          value: 'Note',
          child: Text('Add Note'),
        ),
        const PopupMenuItem(
          value: 'Edit',
          child: Text('Edit Pin'),
        ),
        const PopupMenuItem(
          value: 'Delete',
          child: Text('Delete Pin'),
        ),
      ],
    ).then((value) {
      if (value == 'Controller') {
        openURLInApp(url.toString());
      } else if (value == 'Navigation') {
        final Uri googleMapsUrl = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$long',
        );
        _openUrl(googleMapsUrl);
      } else if (value == 'Delete') {
        _deletePin(pinID);
      } else if (value == 'Edit') {
        type = "Edit";
        editID = pinID;
        _pinDrawerData(pinID);
        _scaffoldKey.currentState?.openEndDrawer();
      } else if (value == "Note") {
        noteTaker(context, pinID);
      }
    });
  }

  //Works, but does not get added after map updates
  void _getPosition() async {
    try {
      final pos = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
        forceAndroidLocationManager: false,
        timeLimit: const Duration(seconds: 10),
      );

      _currentLocation = LatLng(pos.latitude, pos.longitude);
      final me = _Pin(
        id: 'Current Location',
        name: 'You',
        point: _currentLocation!,
        url: null,
        color: Colors.red,
      );

      final existingIndex = pins.indexWhere((p) => p.id == 'Current Location');
      setState(() {
        if (existingIndex == -1) {
          pins.insert(0, me);
        } else {
          pins[existingIndex] = me;
        }
        _rebuildMarkers();
      });
      _mapController.move(_currentLocation!, 15);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location error: $e')),
        );
      }
    }
  }

  //Works flawlessly
  void _rebuildMarkers() {
    _markers
      ..clear()
      ..addAll(
        pins.map(
          (p) => Marker(
            width: 80,
            height: 60,
            point: p.point,
            child: GestureDetector(
              onTap: () {
                _centerOnPin(p, zoom: 15);
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final Offset position = button.localToGlobal(Offset.zero);
                _showMenu(context, position, p.url, p.point, p.id);
                // _openUrl(p.url);
              },
              onLongPress: () => _centerOnPin(p, zoom: 15),
              child: Tooltip(
                message: (p.note == null) ? "" : '${p.note}',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 36,
                      color: p.color ?? Colors.redAccent,
                    ),
                    (_currentZoom > 13)
                        ? SizedBox(
                            width: 72,
                            child: Text(
                              p.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: const TextStyle(
                                  fontSize: 11, backgroundColor: Colors.white),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  //Works flawlessly
  void loadData() async {
    pins = await loadPinsFromJson();
    setState(() {
      _rebuildMarkers();
    });
  }

  //Works flawlessly
  void _openPinList() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: pins.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final p = pins[i];
              return ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text(p.name),
                subtitle: Text(
                  '${p.point.latitude.toStringAsFixed(5)}, ${p.point.longitude.toStringAsFixed(5)}'
                  '${p.note != null ? '\nNotes: ${p.note}' : ''}',
                ),
                onTap: () {
                  Navigator.pop(context);
                  _centerOnPin(p, zoom: 15);
                },
                trailing: SizedBox(
                  width: 160,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            type = "Edit";
                            editID = p.id;
                            _pinDrawerData(p.id);
                            _scaffoldKey.currentState?.openEndDrawer();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            _centerOnPin(p, zoom: 15);
                            noteTaker(context, p.id);
                          },
                          icon: Icon(Icons.book)),
                      IconButton(
                          tooltip: 'Delete Pin',
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  title: const Text("Delete Pin?"),
                                  content: SizedBox(
                                      width: double.maxFinite,
                                      child: Text(
                                        "Are you sure you want to delete this pin?\n${p.name}",
                                        style: TextStyle(fontSize: 45),
                                        textAlign: TextAlign.center,
                                      )),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _deletePin(p.id);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            _openPinList();
                                          },
                                          child: const Text(
                                            "Yes!",
                                            style: TextStyle(
                                                fontSize: 45,
                                                color: Colors.green),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            "No!",
                                            style: TextStyle(
                                                fontSize: 45,
                                                color: Colors.red),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                          }),
                      IconButton(
                        tooltip: 'Open URL',
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () => openURLInApp(p.url.toString()),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  //Works flawlessly
  void _centerOnPin(_Pin pin, {double zoom = 15}) {
    _mapController.move(pin.point, zoom);
    mapZoom = _mapController.camera.zoom;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Centered on: ${pin.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  //Works flawlessly
  void showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Done'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Works flawlessly
  void _addPin() async {
    File file = await getOrCreateLocationsFile();
    String jsonString = await file.readAsString();
    List<dynamic> jsonData = json.decode(jsonString);
    Map<String, dynamic> newPin = {
      "ID": jsonData.last["ID"] + 1,
      "Data": {
        "id": _nicknameController.text,
        "name": _nameController.text,
        "point": [
          double.parse(_xController.text),
          double.parse(_yController.text)
        ],
        "url": _urlController.text,
        "color": "0x${currentColor.toHexString()}"
      }
    };
    jsonData.add(newPin);
    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(jsonData));
    _Pin newpin = _Pin(
        id: _nicknameController.text,
        name: _nameController.text,
        point: LatLng(
            double.parse(_xController.text), double.parse(_yController.text)),
        color: Color(int.parse("0x${currentColor.toHexString()}")),
        url: Uri.parse(_urlController.text));
    pins.add(newpin);
    setState(() {
      _rebuildMarkers();
    });
  }

  //Works flawlessly
  void _pinDrawerData(String pinId) async {
    File file = await getOrCreateLocationsFile();
    String jsonString = await file.readAsString();
    List<dynamic> jsonData = json.decode(jsonString);

    final pin = jsonData.firstWhere(
      (item) => item["Data"]["id"] == pinId,
      orElse: () => null,
    );

    if (pin == null) {
      return;
    }

    final data = pin["Data"];

    _editNameController.text = data["name"] ?? "";
    _editNicknameController.text = data["id"] ?? "";
    _editXController.text = data["point"][0].toString();
    _editYController.text = data["point"][1].toString();
    _editUrlController.text = data["url"] ?? "";

    Color colorFixed = _convertColor(data["color"]);

    if (data["color"] != null) {
      setState(() {
        currentColor = colorFixed;
      });
    }

    editID = pinId;
  }

  //Works flawlessly
  void _deletePin(String pinid) async {

    File file = await getOrCreateLocationsFile();
    String jsonString = await file.readAsString();
    List<dynamic> jsonData = json.decode(jsonString);

    jsonData.removeWhere((item) => item["Data"]["id"] == pinid);

    for (int i = 0; i < jsonData.length; i++) {
      jsonData[i]["ID"] = i;
    }

    const encoder = JsonEncoder.withIndent("  ");
    await file.writeAsString(encoder.convert(jsonData));

    pins.removeWhere((pin) => pin.id == pinid);

    setState(() {
      _rebuildMarkers();
    });
  }


  openURLInApp(String url){
    context.read<WindowManager>().open(
      DesktopWindowData(
          id: url,
        position: Offset(1000,0),
        title: url,
        child: BrowserApp(baseURL: url),
        focused: true
      ),
    );
  }

  void showStyledDialog(BuildContext context, List<dynamic> jsonData) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[100],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Notes Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    itemCount: jsonData.length,
                    separatorBuilder: (context, _) => Divider(height: 1),
                    itemBuilder: (context, i) {
                      String id = jsonData[i]["ID"].toString();
                      String name = jsonData[i]["Data"]["Name"];
                      String note = jsonData[i]["Data"]["Note"];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("ID: $id\nNote: $note"),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Works flawlessly
  Future<void> _openUrl(Uri? url) async {
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No URL for this pin.')),
      );
      return;
    }
    final ok =
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // or LaunchMode.platformDefault
    );
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open: ${url.toString()}')),
      );
    }
  }

  //Works flawlessly
  Future<File> getOrCreateLocationsFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String workappPath = "${appDocDir.path}/workapp";
    String assetsPath = "$workappPath/assets";
    String filePath = "$assetsPath/locationsdata.json";
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
      await locationsFile.writeAsString("[]");
    }
    return locationsFile;
  }

  //Works flawlessly
  Future<List<_Pin>> loadPinsFromJson() async {
    File file = await getOrCreateLocationsFile();

    String jsonString = await file.readAsString();
    List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) {
      final data = item["Data"];
      final id = data["id"];
      final name = data["name"];
      final lat = data["point"][0];
      final lng = data["point"][1];
      final url = data["url"];
      final colorString = data["color"];
      final note = data["Note"];
      final color = _convertColor(colorString);
      return _Pin(
          id: id,
          name: name,
          point: LatLng(lat, lng),
          url: Uri.parse(url),
          color: color,
          note: note);
    }).toList();
  }

  //Works flawlessly
  Future<void> _editPin({
    required String originalId,
    required String newId,
    required String newName,
    required double newLat,
    required double newLng,
    required String newUrl,
    required Color newColor,
  }) async {
    File file = await getOrCreateLocationsFile();
    String jsonString = await file.readAsString();
    List<dynamic> jsonData = json.decode(jsonString);

    // Find the pin by id
    int index = jsonData.indexWhere((item) => item["Data"]["id"] == originalId);

    if (index == -1) {
      return;
    }

    // Update the entry
    jsonData[index]["Data"]["id"] = newId;
    jsonData[index]["Data"]["name"] = newName;
    jsonData[index]["Data"]["point"] = [newLat, newLng];
    jsonData[index]["Data"]["url"] = newUrl;
    jsonData[index]["Data"]["color"] =
        "0x${newColor.value.toRadixString(16).padLeft(8, '0')}";

    // Save pretty JSON back
    const encoder = JsonEncoder.withIndent("  ");
    await file.writeAsString(encoder.convert(jsonData));

    // Update in-memory list
    int pinIndex = pins.indexWhere((p) => p.id == originalId);
    if (pinIndex != -1) {
      pins[pinIndex] = _Pin(
        id: newId,
        name: newName,
        point: LatLng(newLat, newLng),
        url: Uri.parse(newUrl),
        color: newColor,
      );
    }

    // Rebuild markers on screen
    setState(() {
      _rebuildMarkers();
    });
  }

  @override
  void initState() {
    super.initState();
    _rebuildMarkers();
    _getPosition();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (mapZoom <= 15) {
      _rebuildMarkers();
    }
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Container(
          color: Colors.transparent,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            SizedBox(
              width: 304,
              child: pinDrawer(),
            )
          ])),
      body: Stack(
        children: [

          Center(
              child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(41.2565, -95.9345), // Omaha-ish
              initialZoom: 11,
              onMapEvent: (event) {
                if (event is MapEventMove || event is MapEventScrollWheelZoom) {
                  setState(() {
                    _currentZoom = event.camera.zoom;
                  });
                  _rebuildMarkers();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: NetworkTileProvider(headers: {
                  'User-Agent':
                      'com.onsiteinventoryapp/1.4 (joshua.osburn@yahoo.com)',
                }),
                maxZoom: 35,
                minZoom: 1,
              ),
              MarkerLayer(markers: _markers),
            ],
          )),
          SizedBox(
            height: 40,
            child: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),),
                    icon: Icon(Icons.add,),
                    onPressed: () {
                      type = "add";
                      setState(() {});
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),
                ),
                IconButton(
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),),
                  tooltip: 'Location List',
                  icon: const Icon(Icons.list_alt),
                  onPressed: _openPinList,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pin {
  final String id;
  final String name;
  final LatLng point;
  final Uri? url;
  final String? note;
  final Color? color;

  const _Pin({
    required this.id,
    required this.name,
    required this.point,
    this.url,
    this.note,
    this.color,
  });
}
