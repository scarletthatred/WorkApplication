import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:numberpicker/numberpicker.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as xcel;


Future<List<List<dynamic>>> readCsv(String path) async {
  final input = File(path).openRead();
  return await input
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
      .toList();
}

Future<List<List<dynamic>>> readExcel(String path) async {
  var bytes = File(path).readAsBytesSync();
  var excel = xcel.Excel.decodeBytes(bytes);
  var sheet = excel.tables[excel.tables.keys.first];
  return sheet?.rows ?? [];
}

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key, required this.title});

  final String title;

  @override
  State<TerminalPage> createState() => _TerminalPage();
}

class PowerShellSession {
  Process? _process;
  IOSink? _stdin;
  StreamSubscription<String>? _stdoutSub;
  StreamSubscription<String>? _stderrSub;

  final _outputController = StreamController<String>.broadcast();

  Stream<String> get outputStream => _outputController.stream;

  Future<void> start() async {
    if (_process != null) return; // Already running

    _process = await Process.start(
      "C:\\Program Files\\PowerShell\\7\\pwsh.exe",
      ["-NoLogo"],
      mode: ProcessStartMode.normal,
      runInShell: true,
    );

    _stdin = _process!.stdin;
    _stdoutSub = _process!.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) => _outputController.add(line));

    _stderrSub = _process!.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) => _outputController.add("ERROR: $line"));
  }

  void sendCommand(String command) {
    _stdin?.writeln(command);
  }

  Future<void> stop() async {
    _stdin?.writeln("exit");
    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();
    await _process?.exitCode;
    _process = null;
  }
}

const List<String> list = <String>['elmwoodfloor', 'oakridge'];

class _TerminalPage extends State<TerminalPage> {
  final TextEditingController _commandController = TextEditingController();
  final PowerShellSession psSession = PowerShellSession();
  final List<String> _outputLines = [];
  final List<String> _ports = [];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List <Map>_macaddress = [];
  final regex = RegExp(r'([0-9a-fA-F]{4}\.[0-9a-fA-F]{4}\.[0-9a-fA-F]{4})\s+\w+\s+(Gi\d+\/\d+\/\d+)');


  List<List<dynamic>> apData = [];
  int switchNumber = 3;
  String dropdownValue = list.first;

  @override
  void initState() {
    super.initState();
    loadAPData();
    psSession.start();

    psSession.outputStream.listen((line) {
      if(line.contains(" Gi1/0/"))
      {
        final match = regex.firstMatch(line);
        if (match != null) {
          final mac = formatMac(match.group(1).toString().toLowerCase());
          final port = match.group(2);
          if(!_ports.contains("$mac | $port")){_ports.add("$mac | $port");}
        }

      }
      setState(() {
        _outputLines.add(line);
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });

    });

  }



  @override
  void dispose() {
    psSession.stop();
    _scrollController.dispose();
    _commandController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> loadAPData() async {
    final data = await readCsv("C:\\Users\\JoshuaOsburn\\controllerAPexportedlists\\elmwoodtower.csv");
    setState(() {
      apData = data;
    });
  }

  void _sendCommand(String command) {
    psSession.sendCommand(command);
    _commandController.clear();
    _focusNode.requestFocus();
  }

  String formatMac(String input) {
    final cleaned = input.replaceAll('.', '');
    if (cleaned.length != 12) return input; // fallback if format is unexpected

    final buffer = StringBuffer();
    for (int i = 0; i < 12; i += 2) {
      buffer.write(cleaned.substring(i, i + 2).toLowerCase());
      if (i < 10) buffer.write('-');
    }

    return buffer.toString();
  }


  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < apData.length; i++) {
      final row = apData[i];
      final name = row.isNotEmpty ? row[0].toString() : "Unknown";
      final mac = row.length > 1 ? row[2].toString() : "N/A";
      if (!_macaddress.contains(row[2].toString())) {
        ///todo _macaddress.add(:"");
      }
    }

    return Scaffold(
        appBar: AppBar(title: Text("PowerShell Output")),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // AP List (fixed width)
                  Container(
                    width: 500, // Adjust as needed
                    color: Colors.grey[200],
                    child: ListView.builder(
                      itemCount: apData.length,
                      itemBuilder: (context, index) {
                        final row = apData[index];
                        final name =
                        row.isNotEmpty ? row[0].toString() : "Unknown";
                        final mac = row.length > 1
                            ? row[2].toString()
                            : "N/A";
                        return ListTile(
                          title: Text("AP: $name"),
                          subtitle: Text("MAC: $mac"),
                        );
                      },
                    ),
                  ),

                  // Terminal Output (fills remaining space)
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _outputLines.length,
                        itemBuilder: (context, index) {
                          return Text(
                            _outputLines[index],
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Courier',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Command input and controls
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commandController,
                          style: TextStyle(color: Colors.white),
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: "Enter command...",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.black87,
                            border: OutlineInputBorder(),

                          ),
                          onSubmitted: _sendCommand,
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _sendCommand(_commandController.text);
                        },
                        child: Text("Send"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                            height: 2, color: Colors.deepPurpleAccent),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                        list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                      ),
                      Column(
                        children: <Widget>[
                          NumberPicker(
                            value: switchNumber,
                            minValue: 3,
                            maxValue: 21,
                            step: 2,
                            onChanged: (value) =>
                                setState(() => switchNumber = value),
                          ),
                          Text('Current value: $switchNumber'),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _sendCommand("wsl.exe -d Ubuntu");
                          setState(() {});
                          _sendCommand(
                              "sshpass -p '\$arth3d!' ssh $dropdownValue$switchNumber");
                          _sendCommand("show mac address-table vlan 5");
                          _sendCommand("                       ");
                          // _sendCommand("exit");
                          _sendCommand(" ");
                          setState(() {});
                        },
                        child: Text("Switch connection"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print(_ports);
                          print(_ports.length);
                        },
                        child: Text("Print ports"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print(_macaddress);
                          print(_macaddress.length);
                        },
                        child: Text("Print Mac addresses"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}