import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'camera.dart';
import 'components.dart';
import 'contactList.dart';
import 'terminal.dart';
import 'maps.dart';
import 'pdfCameras.dart';
import 'phoneNotes.dart';

class Forms extends StatefulWidget {
  const Forms({super.key, required this.items});

  final List<Map<String, dynamic>> items;

  @override
  State<Forms> createState() => _FormsState();
}

class _FormsState extends State<Forms> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    fields = widget.items;
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

  Map<String, dynamic> fieldsVariables = {};
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> fields = [];

  Widget fieldMaker(int fieldType, String fieldVariable, List<String> values,
      String labelText,
      {bool isNumeric = false}) {
    TextInputType keyboardType =
        isNumeric ? TextInputType.number : TextInputType.text;
    List<Widget> fieldTypes = [
      /// Text field-----------------------------------------------------
      Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          readOnly: false,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
          ),
          onChanged: (value) {
            setState(() {
              fieldsVariables[fieldVariable] =
                  value; // Update specific field variable
            });
          },
        ),
      ),

      /// Dropdown List-----------------------------------------------------
      Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
          ),
          initialValue: values[0], // Initial value from variables map
          onChanged: (String? newValue) {
            setState(() {
              fieldsVariables[fieldVariable] = newValue!;
            });
          },
          items: values.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),

      /// Radio list -----------------------------------------------------------
      Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(labelText,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              ...values
                  .map((value) => RadioListTile<String>(
                        title: Text(value),
                        value: value,
                        groupValue: fieldsVariables[fieldVariable],
                        onChanged: (String? newValue) {
                          setState(() {
                            fieldsVariables[fieldVariable] = newValue!;
                          });
                        },
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                      ))
                  ,
            ],
          ),
        ),
      ),

      /// Checkbox-------------------------------------------------------------------
      // Padding(
      //     padding: const EdgeInsets.all(10),
      //     child: Row(
      //       children: [
      //         const Text("numeric"),
      //         Checkbox(value: false, onChanged: (value) {
      //           fieldsVariables[fieldVariable] = value;
      //         }
      //         ),
      //       ],
      //     )
      // ),
    ];

    return SizedBox(height: 100, width: 200, child: fieldTypes[fieldType]);
  }

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
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height: 60,
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              ///edit item submit here -------------------------------------------------

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

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  List<Widget> buildItemList() {
    List<Widget> list = [];
    for (int i = 0; i < items.length; i++) {
      list.add(
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            const Divider(), // Adds a horizontal line between items
          ],
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Form"),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfCameras(itemsList: items),
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text('Navigation'),
            ),
            ListTile(
              title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.home)),WidgetSpan(child: Text("Home"))])),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.list_alt)),WidgetSpan(child: Text("List Maker (Broken)"))])),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SetupPage(title: 'List Maker Application (Broken)')));
              },
            ),
            ListTile(
              title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.contact_mail_outlined)),WidgetSpan(child: Text("Contact List"))])),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactListApp(title: 'Contact List Application')));
              },
            ),
            ListTile(
              title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.camera_alt)),WidgetSpan(child: Text("Camera"))])),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraApp(title: "Camera Application")));
              },
            ),
            ListTile(
              title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.phone)),WidgetSpan(child: Text("Phone Notes"))])),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneNotes(title: "Phone Notes")));
              },
            ),
            ListTile(
              title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.terminal,color: Colors.blue,)),WidgetSpan(child: Text("Terminal Application (NF)"))])),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TerminalPage(title: 'Terminal Application (NF)')));
              },
            ),
            ListTile(
              title: RichText(text:const TextSpan(children: [WidgetSpan(child: Icon(Icons.map_sharp)),WidgetSpan(child: Text("Technical Magic Locations"))])),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Maps(title: 'Technical Magic Locations')));
              },
            ),
          ],
        ),
      ),
      body: (!(MediaQuery.of(context).orientation == Orientation.portrait))
          ? SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          child: Column(
                            children: [
                              for (int i = 0; i < fields.length; i++)
                                fieldMaker(
                                    (fields[i]["Type"] == "Text Field")
                                        ? 0
                                        : (fields[i]["Type"] ==
                                                "List Selection")
                                            ? 1
                                            : 2,
                                    "Default Value",
                                    (fields[i]["Type"] == "Text Field")
                                        ? ["default"]
                                        : [
                                            for (int k = 0;
                                                k <=
                                                    fields[i][
                                                            "NumberOfOptions"] -
                                                        1;
                                                k++)
                                              fields[i]["option$k"]
                                          ],
                                    fields[i]["Label"],
                                    isNumeric:
                                        (fields[i]["Type"] == "Text Field")
                                            ? fields[i]["Numeric"]
                                            : false),
                            ],
                          )),
                      TextButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Row(
                            children: [
                              Text("Add Item"),
                              Icon(Icons.add),
                            ],
                          )),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey,
                      child: SingleChildScrollView(
                        child: Column(children: buildItemList()),
                      ),
                    ),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 200,
                          child: Column(
                            children: [],
                          )),
                      TextButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Row(
                            children: [
                              Text("Add Item"),
                              Icon(Icons.add),
                            ],
                          )),
                    ],
                  ),
                  Container(
                    color: Colors.grey,
                    child: SingleChildScrollView(
                      child: Column(children: buildItemList()),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
