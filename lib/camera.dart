import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pdfCameras.dart';


class CameraApp extends StatefulWidget {
  const CameraApp({super.key, required this.title});
  final String title;

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void saveItems() async {
    print("save");
    sortItems();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(items);
    await prefs.setString('savedItems', encodedData);
  }

  void sortItems() {
    print("sort");
    itemsSorted = items;
    itemsSorted.sort((a, b) {
      final companyA = a['Company'] ?? "";
      final companyB = b['Company'] ?? "";
      return companyA.compareTo(companyB);
    });
    items = itemsSorted;
  }


  void resetButton (){
    items = [{"down nvrs": "babababa", "index": 67}, {"down nvrs": "WCF-NVR", "index": 69}, {"down nvrs": 'WCF-NVR', 'index': 69}, {'down nvrs': 'Taylors - MoValley-Viewer (Windows 7) Needs replaced', 'index': 72}, {'down nvrs': 'Taylors - MoValley-Viewer (Windows 7) Needs replaced', 'index': 72}, {'down nvrs': 'Taylors - MoValley-Viewer (Windows 7) Needs replaced', 'index': 72}, {'down nvrs': 'Taylors - MoValley-Viewer (Windows 7) Needs replaced', 'index': 72}, {'down nvrs': 'PETERSEN-CATTLE', 'index': 76}, {'down nvrs': 'PETERSEN-CATTLE', 'index': 76}, {'down nvrs': 'PETERSEN-CATTLE', 'index': 76}, {'down nvrs': 'PETERSEN-CATTLE', 'index': 77}, {'down nvrs': 'Bauer-Waverly', 'index': 59}, {'down nvrs': 'NEIA - Omaha Office', 'index': 80}, {'down nvrs': 'NEIA - Omaha Office', 'index': 81}, {'down nvrs': 'NEIA - Omaha Office', 'index': 80}, {'down nvrs': 'NEIA - Omaha Office', 'index': 80}, {'down nvrs': 'Medallion', 'index': 83}, {'down nvrs': 'Medallion', 'index': 83}, {'down nvrs': 'LKQ Lincoln', 'index': 85}, {'down nvrs': 'Holiday Inn Express - Lincoln', 'index': 66}, {'down nvrs': 'Holiday Inn Express - Lincoln', 'index': 66}, {'down nvrs': 'Holiday Inn Express - Lincoln', 'index': 87}, {'down nvrs': 'Holiday Inn Express - Lincoln', 'index': 87}, {'down nvrs': 'AHREN-CONST-NVR', 'index': 64}, {'down nvrs': 'AHREN-CONST-NVR', 'index': 64}, {'down nvrs': 'Bababa', 'index': 88}, {'down nvrs': 'Bauer-Norfolk37', 'index': 62}, {'down nvrs': 'Bauer-Norfolk37', 'index': 62}, {'down nvrs': 'Bauer-Waverly', 'index': 59}, {'down nvrs': 'Bauer-Waverly', 'index': 60}, {'down nvrs': 'Bauer-Waverly', 'index': 60}, {'down nvrs': 'Bauer-Waverly', 'index': 60}, {'down nvrs': 'Bierman INC(Michael)', 'index': 54}, {'down nvrs': 'Bierman INC(Michael)', 'index': 56}, {'down nvrs': 'Bierman INC(Michael)', 'index': 54}, {'down nvrs': 'Bierman INC(Michael)', 'index': 56}, {'down nvrs': 'Blair Chamber', 'index': 51}, {'down nvrs': 'Blair Chamber', 'index': 51}, {'down nvrs': 'Greg Hansen NVR (Switch needs Reboot)', 'index': 49}, {'down nvrs': 'Greg Hansen NVR (Switch needs Reboot)', 'index': 47}, {'down nvrs': 'Greg Hansen NVR (Switch needs Reboot)', 'index': 49}, {'down nvrs': 'Greg Hansen NVR (Switch needs Reboot)', 'index': 47}, {'down nvrs': 'Hansen Hay', 'index': 73}, {'down nvrs': 'Hansen Hay', 'index': 73}, {'down nvrs': 'LKQ Lincoln', 'index': 85}, {'Camera': '11 - Drive Entry', 'Camera Description': '(Generic) RTSP Compatible', 'ip': '192.168.100.21', 'Company': 'AHRENHOLTZ-NVR', 'Warranty':'' , 'index': 90}, {'Camera': '7 - Shop 2', 'Camera Description': '(Generic) ONVIF Compatible (legacy)', 'ip': '192.168.100.17', 'Company': 'AHRENHOLTZ-NVR', 'Warranty': '', 'index': 92}, {'Camera': '10 - Dryer', 'Camera Description': '(Generic) RTSP Compatible', 'ip': '192.168.100.20', 'Company': 'AHRENHOLTZ-NVR', 'Warranty':'' , 'index': 94}, {'Camera': '(22) Arena #2 - 10.32', 'Camera Description': 'non Hikvision Bullet', 'ip': '10.10.10.32', 'Company': 'Ag Park', 'Warranty':'' , 'index': 96}, {'Camera': '(18) Hallway to Office - 10.28', 'Camera Description': 'Non Hikvision bullet', 'ip': '10.10.10.28', 'Company': 'Ag Park', 'Warranty':'' , 'index': 98}, {'Camera': '(04) Tracks South View - 10.114', 'Camera Description': '(Generic) ONVIF Compatible', 'ip': '10.10.10.114', 'Company': 'BLAIRAG-NVR', 'Warranty': '', 'index': 102}, {'Camera': '(11) New Bin PTZ - 10.121', 'Camera Description': 'Hikvision DS-2DE4A425IW-DE(B)', 'ip': '10.10.10.121', 'Company': 'BLAIRAG-NVR', 'Warranty':'' , 'index': 101}, {'Camera': 'Breezeway', 'Camera Description': 'Hikvision DS-2CD-2135FWD-IS', 'ip': '10.10.10.17', 'Company': 'Custom Feed', 'Warranty': '', 'index': 104}, {'Camera': '(3) North Side of Building - 10.13', 'Camera Description': 'Grandstream pinking', 'ip': '10.10.10.13', 'Company': 'Harvestore-NVR', 'Warranty': '', 'index': 106}, {'Camera': 'Shouth Shop West Cam', 'Camera Description': '(Generic) RTSP Compatible', 'ip': '10.10.10.14', 'Company': 'Henton', 'Warranty': '', 'index': 108}, {'Camera': 'SE Entrance Outdoor', 'Camera Description': 'Hikvision DS-2CD2T45FWD-I8(4mm)', 'ip': '10.10.10.33', 'Company': 'New Victorian(new)', 'Warranty':'' , 'index': 111}, {'Camera': '(1-1) Ida Gate - 10.201','Camera Description': 'Hikvision DS-2CD2146G2-ISU(2.8mm)', 'ip': '10.10.10.201', 'Company': 'Patriot Crane NVR (155 Ida)', 'Warranty':'' , 'index': 112}, {'Camera': '10 - Showroom', 'Camera Description': '(Generic) RTSP Compatible', 'ip': '10.10.10.20', 'Company': 'SE Smith', 'Warranty':'' , 'index': 114}, {'Camera': '09 - Back Door', 'Camera Description': '(Generic) RTSP Compatible', 'ip': '10.10.10.19', 'Company': 'SE Smith', 'Warranty': '', 'index': 116}, {'Camera': '10.23 - Food Counter', 'Camera Description': 'Hikvision DS-2CD2346G2-I(2.8mm)', 'ip': '10.10.10.23', 'Company': 'TQP - 01 Blair West', 'Warranty':'' , 'index': 118}, {'Camera': 'ATM', 'Camera Description': '(Generic) RTSP Compatible', 'ip': '10.10.10.11', 'Company': 'TQP - 28 Missouri Valley East', 'Warranty': '', 'index': 120}, {'Camera': 'Gas Island East', 'Camera Description': 'Hikvision DS-2CD2347G2-LU(2.8mm)', 'ip': '10.10.10.24', 'Company': 'TQP - 28 Missouri Valley East', 'Warranty':'' , 'index': 122}, {'Camera': '08 - Food Counter', 'Camera Description': 'Hikvision DS-2CD2147G2-SU(2.8mm)', 'ip': '10.10.10.18', 'Company': 'Taylor\'s - 05 Missouri Valley West', 'Warranty':'' , 'index': 124}, {'Camera': '12 - North Merchandise Aisle', 'Camera Description': '(Generic) ONVIF Compatible (legacy)', 'ip': '192.168.1.112', 'Company': 'Taylor\'s - 05 Missouri Valley West', 'Warranty':'' , 'index': 126}, {'Camera': '13 - South Merchandise Aisle', 'Camera Description': '(Generic) ONVIF Compatible (legacy)', 'ip': '192.168.1.113', 'Company': 'Taylor\'s - 05 Missouri Valley West', 'Warranty':'' , 'index': 128}, {'Camera': '04 - East Gas Island', 'Camera Description': '(Generic) ONVIF Compatible (legacy)', 'ip': '192.168.1.116', 'Company': 'Taylor\'s - 05 Missouri Valley West', 'Warranty':'' , 'index': 130}, {'Camera': '5 Beer Cave', 'Camera' 'Description': 'Hikvision DS-2CD2386G2-I(2.8mm)', 'ip': '10.10.10.21', 'Company': "Taylor's - 07 Oakland", 'Warranty': "", 'index': 132}, {'Camera': 'Outer Bay (21)', 'Camera Description': 'Hikvision DS-2CD2145FWD-IS', 'ip': '10.10.10.31', 'Company': 'WASHTEC-NVR', 'Warranty':'' , 'index': 133}];
  saveItems();
  }

  void loadItems() async {
    print("Load");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('savedItems');
    if (encodedData != null) {
      setState(() {
        items = List<Map<String, dynamic>>.from(json.decode(encodedData));
      });
    }
    sortItems();
  }

  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> itemsSorted = [];
  List<Map<String, dynamic>> nvrsSorted = [];
  Map<String, dynamic> details = {};
  String camera = "";
  String cameraDetails = "";
  String ip = "";
  String company = "";
  List<String> companies = [];
  List<String> notes = [];
  String nvrs = "";
  String warrantyDate = "";

  errorCode(int error) {
    List<String> errorCodes = [
      "There is missing Info that is required. Be sure to input the Name of the product and the quantity is above 0",
      "You tried to input an invalid quantity value. Be sure the value is above 0."
    ];
    List<String> errorTitles = ["Missing info", "Invalid Info"];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: Text(
            errorTitles[error],
            style: const TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorCodes[error],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "OK!",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  edit(int item) {
    camera = items[item]["Camera"];
    cameraDetails = items[item]["Camera Description"];
    company = items[item]["Company"];
    ip = items[item]["ip"];
    if (items[item]["Warranty"] != null) {
      warrantyDate = items[item]["Warranty"];
    } else {
      warrantyDate = "not found";
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: const Text(
            "Editing Item",
            style: TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Company (Required)',
                          hintText: 'Select a company',
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            company = newValue!;
                          });
                        },
                        items: companies
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = "${items[item]["Camera"]}",
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Camera (Required)',
                        ),
                        onChanged: (value) => camera = value,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = "${items[item]["Camera Description"]}",
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                        onChanged: (value) => cameraDetails = value,
                        maxLines: 2,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = "${items[item]["ip"]}",
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'IP',
                        ),
                        onChanged: (value) => ip = value,
                        maxLines: 1,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = warrantyDate,
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Warranty',
                        ),
                        onChanged: (value) => warrantyDate = value,
                        maxLines: 1,
                        minLines: 1,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 60,
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              ///edit item submit here -------------------------------------------------
                              if (camera == "" ||
                                  camera.isEmpty ||
                                  company == "" ||
                                  company.isEmpty ||
                                  cameraDetails == "" ||
                                  cameraDetails.isEmpty ||
                                  warrantyDate == "" ||
                                  warrantyDate.isEmpty) {
                                errorCode(0);
                              } else {
                                details = {
                                  "Camera": camera,
                                  "Camera Description": cameraDetails,
                                  "Company": company,
                                  "ip": ip,
                                  "Warranty": warrantyDate
                                };
                                items[item] = details;
                              }
                              camera = "";
                              cameraDetails = "";
                              company = "";
                              ip = "";
                              warrantyDate = "";
                              details = {};
                              saveItems();
                              setState(() {});

                              ///-----------------------------------------------
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              "Apply",
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 60,
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              "Cancel",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  nvr() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: const Text(
            "Adding Down NVR",
            style: TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Company (Required)',
                          hintText: 'Select a company',
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            company = newValue!;
                          });
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 60,
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              ///edit item submit here -------------------------------------------------

                              if (company == "" || company.isEmpty) {
                                errorCode(0);
                              } else {
                                nvrs = company;
                                items.add({"down nvrs": nvrs});
                                nvrs = "";
                              }
                              saveItems();
                              setState(() {});

                              ///-----------------------------------------------
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              "Apply",
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 60,
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              "Cancel",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  editDownNVR(int item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: const Text(
            "Adding Down NVR",
            style: TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Company (Required)',
                          hintText: 'Select a company',
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            company = newValue!;
                          });
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 60,
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              ///edit item submit here -------------------------------------------------

                              if (company == "" || company.isEmpty) {
                                errorCode(0);
                              } else {
                                nvrs = company;
                                items[item] = {"down nvrs": nvrs};
                                nvrs = "";
                              }
                              saveItems();
                              setState(() {});

                              ///-----------------------------------------------
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              "Apply",
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 60,
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text(
                              "Cancel",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  pdfView() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: const Text(
            "PDF",
            style: TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
            height: 900,
            width: 800,
            child: PdfCameras(itemsList: items),
          ),
        );
      },
    );
  }

  addItem() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: const Text(
            "Add Camera",
            style: TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
            height: 900,
            width: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        readOnly: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Company', // Label for the new field
                        ),
                        onChanged: (value) =>
                            company = value, // Update company state on change
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Camera (Required)',
                        ),
                        onChanged: (value) => camera = value,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                        onChanged: (value) => cameraDetails = value,
                        maxLines: 5,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'IP',
                        ),
                        onChanged: (value) => ip = value,
                        maxLines: 5,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Warranty Date (3 years after install)',
                        ),
                        onChanged: (value) => warrantyDate = value,
                        maxLines: 1,
                        minLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 120,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (camera == "" || camera.isEmpty) {
                            errorCode(0);
                          } else {
                            if (cameraDetails == "" || cameraDetails.isEmpty) {
                              cameraDetails = "N/A";
                            }
                            if (!companies.contains(company)) {
                              companies.add(company);
                              companies.sort();
                            }
                            details = {
                              "Camera": camera,
                              "Camera Description": cameraDetails,
                              "ip": ip,
                              "Company": company,
                              "Warranty": warrantyDate
                            };
                            items.add(details);
                          }
                          details = {};
                          camera = "";
                          cameraDetails = "";
                          ip = "";
                          company = "";
                          warrantyDate = "";
                          saveItems();
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          "Apply",
                        ),
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          "Cancel",
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      saveItems();
    });
  }

  List<Widget> buildItemList() {
    List<Widget> list = [];
    List<Widget> downNVRs = [];
    for (int i = 0; i < items.length; i++) {
      if (items[i]["Company"] == null &&
          items[i]["Camera"] == null &&
          items[i]["Camera Description"] == null) {
        downNVRs.add(
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText("Down NVR: ${items[i]["down nvrs"]}"),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editDownNVR(i),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteItem(i),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(), // Adds a horizontal line between items
            ],
          ),
        );
      } else {
        if (items[i]["Warranty"] == null) {
          items[i]["Warranty"] = "not found";
        }
        list.add(
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText("Company: ${items[i]["Company"]}"),
                      SelectableText("Camera: ${items[i]["Camera"]}")
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText(
                          "Description: ${items[i]["Camera Description"]}"),
                      SelectableText("IP: ${items[i]["ip"]}"),
                      SelectableText("Warranty: ${items[i]["Warranty"]}")
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => edit(i),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteItem(i),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(), // Adds a horizontal line between items
            ],
          ),
        );
      }
    }
    list.add(Column(children: downNVRs));
    return list;
  }

  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    if (loaded == false) {
      loadItems();
      loaded = true;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton(
              onPressed: () {
                nvr();
              },
              child: const Row(
                children: [
                  Text("Add down NVR"),
                  Icon(Icons.add),
                ],
              )),
          TextButton(
              onPressed: () {
                addItem();
              },
              child: const Row(
                children: [
                  Text("Add Item"),
                  Icon(Icons.add),
                ],
              )),
          // TextButton(
          //     onPressed: () {
          //       resetButton();
          //     },
          //     child: const Row(
          //       children: [
          //         Text("reset"),
          //       ],
          //     )),
          IconButton(
            onPressed: () async {
              pdfView();
            },
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey,
          child: SingleChildScrollView(
            child: Column(children: buildItemList()),
          ),
        ),
      ),
    );
  }
}
