import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:workapp/pdfCallNotes.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PhoneNotes extends StatefulWidget {
  const PhoneNotes({super.key, required this.title});

  final String title;

  @override
  State<PhoneNotes> createState() => _PhoneNotesState();
}

class _PhoneNotesState extends State<PhoneNotes> {
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(items);
    await prefs.setString('Phone Notes', encodedData);
  }

  void loadItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('Phone Notes');
    if (encodedData != null) {
      setState(() {
        items = List<Map<String, dynamic>>.from(json.decode(encodedData));
      });
    }
  }

  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> todayItems = [];
  Map<String, dynamic> details = {};
  String callerName = "";
  String companyName = "";
  String requestOrProblem = "";
  String email = "";
  String phoneNumber = "";
  String date =
      "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";
  DateTime dateDisplayingValue = DateTime.now();
  String dateDisplaying = "";

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
    callerName = items[item]["callerName"];
    companyName = items[item]["companyName"];
    requestOrProblem = items[item]["requestOrProblem"];
    email = items[item]["email"];
    phoneNumber = items[item]["phoneNumber"];
    dateDisplayingValue = DateFormat('M/d/yyyy').parse(items[item]["date"]);

    dateDisplaying =
        "${dateDisplayingValue.month}/${dateDisplayingValue.day}/${dateDisplayingValue.year}";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              contentPadding: const EdgeInsets.only(top: 10.0),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack( clipBehavior: Clip.none,
                          children: [
                            Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.black54,width: 1,strokeAlign: BorderSide.strokeAlignInside,style: BorderStyle.solid),borderRadius: const BorderRadius.all(
                              Radius.circular(4.0), // Radius for rounded corners
                            ),
                            ),
                            child: Text.rich(WidgetSpan(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              dateDisplayingValue = dateDisplayingValue
                                                  .subtract(Duration(days: 1));
                                              dateDisplaying =
                                                  "${dateDisplayingValue.month}/${dateDisplayingValue.day}/${dateDisplayingValue.year}";
                                            });
                                          },
                                          icon: const Icon(Icons.arrow_left)),
                                      Text(dateDisplaying),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (dateDisplaying != date) {
                                                dateDisplayingValue =
                                                    dateDisplayingValue
                                                        .add(Duration(days: 1));
                                                dateDisplaying =
                                                    "${dateDisplayingValue.month}/${dateDisplayingValue.day}/${dateDisplayingValue.year}";
                                              }
                                            });
                                          },
                                          icon: const Icon(Icons.arrow_right)),
                                    ]),
                                  ],
                                ))),
                          ),
                            Positioned(
                              top: -10,  // Move the text upwards
                              left: 7, // Move the text to the left
                              child: Container(
                                color: Color(0xffFEF7FF),
                                padding: EdgeInsets.only(left:4,right:4,top:2),
                                child: const Text(
                                  'Edit The Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    color: Colors.black87,
                                    fontSize: 12,
                                    backgroundColor: Color(0xffFEF7FF), // Optional: Add background color for contrast
                                  ),
                                ),
                              ),
                            ),
                ]
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: TextEditingController()
                              ..text = "${items[item]["callerName"]}",
                            readOnly: false,
                            textCapitalization: TextCapitalization.none,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Caller Name',
                            ),
                            onChanged: (value) => callerName = value,
                            minLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: TextEditingController()
                              ..text = "${items[item]["requestOrProblem"]}",
                            readOnly: false,
                            textCapitalization: TextCapitalization.none,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Request Or Problem',
                              alignLabelWithHint: true
                            ),
                            onChanged: (value) => requestOrProblem = value,
                            maxLines: 5,
                            minLines: 5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: TextEditingController()
                              ..text = "${items[item]["companyName"]}",
                            readOnly: false,
                            textCapitalization: TextCapitalization.none,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Company Name',
                            ),
                            onChanged: (value) => companyName = value,
                            maxLines: 1,
                            minLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: TextEditingController()
                              ..text = "${items[item]["phoneNumber"]}",
                            readOnly: false,
                            textCapitalization: TextCapitalization.none,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone Number',
                            ),
                            onChanged: (value) => phoneNumber = value,
                            maxLines: 1,
                            minLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: TextEditingController()
                              ..text = "${items[item]["email"]}",
                            readOnly: false,
                            textCapitalization: TextCapitalization.none,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                            onChanged: (value) => email = value,
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
                                  if (callerName.isEmpty ||
                                      requestOrProblem.isEmpty ||
                                      companyName.isEmpty) {
                                    errorCode(0);
                                  } else {
                                    details = {
                                      "callerName": callerName,
                                      "companyName": companyName,
                                      "requestOrProblem": requestOrProblem,
                                      "email": email,
                                      "phoneNumber": phoneNumber,
                                      "date": dateDisplaying
                                    };
                                    items[item] = details;
                                  }
                                  saveItems();
                                  setState(() {});
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
      },
    );
  }

  pdfView(List<Map<String, dynamic>> pdfItems) {
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
            child: PdfCallNotes(itemsList: pdfItems,dateDisplayingValue: dateDisplaying,),
          ),
        );
      },
    );
  }

  addItem() {
    final TextEditingController controller = TextEditingController();
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
            "Add Item",
            style: TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
            height: 900,
            width: 800,
            child: SingleChildScrollView(
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
                          textCapitalization: TextCapitalization.none,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Caller Name',
                          ),
                          onChanged: (value) => callerName = value,
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
                            labelText: 'Company Name',
                          ),
                          onChanged: (value) => companyName = value,
                          maxLines: 1,
                          minLines: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          readOnly: false,
                          maxLines: 5,
                          minLines: 5,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                'Request Or Problem',
                              alignLabelWithHint: true
                          ),
                          onChanged: (value) => requestOrProblem =
                              value, // Update state on change
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          readOnly: false,
                          controller: controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                'Phone Number', // Label for the new field
                          ),
                          onChanged: (value) => phoneNumber =
                              value, // Update company state on change
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          readOnly: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email', // Label for the new field
                          ),
                          onChanged: (value) =>
                              email = value, // Update company state on change
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
                            if (callerName == "" || callerName.isEmpty) {
                              errorCode(0);
                            } else {
                              if (companyName == "" || companyName.isEmpty) {
                                companyName = "N/A";
                              }
                              details = {
                                "callerName": callerName,
                                "companyName": companyName,
                                "requestOrProblem": requestOrProblem,
                                "email": email,
                                "phoneNumber": phoneNumber,
                                "date": date
                              };
                              items.add(details);
                            }
                            details = {};
                            callerName = "";
                            companyName = "";
                            requestOrProblem = "";
                            email = "";
                            phoneNumber = "";
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

  List<Widget> buildItemList2() {
    List<Widget> list = [];
    for (int i = 0; i < items.length; i++) {
      if(items[i]["date"] == dateDisplaying){
      list.add(
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText("Caller Name: ${items[i]["callerName"]}"),
                    SelectableText("Company Name: ${items[i]["companyName"]}"),
                    SelectableText("Email: ${items[i]["email"]}"),
                    SelectableText("Phone Number: ${items[i]["phoneNumber"]}"),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            pdfView([items[i]]);
                          },
                          icon: const Icon(Icons.picture_as_pdf),
                        ),
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
                Expanded(
                  child: SizedBox(
                    height: 180,
                    child: SingleChildScrollView(
                      child: Text(
                        "Request Or Problem: ${items[i]["requestOrProblem"]}",
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              color: Colors.black,
            )
          ],
        ),
      );
      }
    }
    return list;
  }

  List<Widget> buildItemList3() {
    List<Widget> list = [];
    for (int i = 0; i < items.length; i++) {
      if (items[i]["date"] == dateDisplaying) {
        list.add(
          Column(
            key: ValueKey(items[i]), // Ensure each item has a unique key for reordering
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText("Caller Name: ${items[i]["callerName"]}"),
                      SelectableText("Company Name: ${items[i]["companyName"]}"),
                      SelectableText("Email: ${items[i]["email"]}"),
                      SelectableText("Phone Number: ${items[i]["phoneNumber"]}"),
                      Row(
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
                  Expanded(
                    child: SizedBox(
                      height: 180,
                      child: SingleChildScrollView(
                        child: Text(
                          "Request Or Problem: ${items[i]["requestOrProblem"]}",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 1,
                color: Colors.black,
              )
            ],
          ),
        );
      }
    }
    return list;
  }

  Widget buildReorderableListView() {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });
      },
      children: buildItemList2(),
    );
  }

  @override
  Widget build(BuildContext context) {
    dateDisplaying =
        "${dateDisplayingValue.month}/${dateDisplayingValue.day}/${dateDisplayingValue.year}";
    loadItems();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text.rich(WidgetSpan(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              IconButton(
                  onPressed: () {
                    dateDisplayingValue =
                        dateDisplayingValue.subtract(Duration(days: 1));
                    setState(() {});
                  },
                  icon: Icon(Icons.arrow_left)),
              Text("${widget.title} $dateDisplaying"),
              IconButton(
                  onPressed: () {
                    if (dateDisplaying != date) {
                      dateDisplayingValue =
                          dateDisplayingValue.add(Duration(days: 1));
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.arrow_right))
            ]))),
        centerTitle: true,
        actions: [
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
          IconButton(
            onPressed: () async {
              pdfView(items);
            },
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
      body: SingleChildScrollView(
              child: Container(
                color: Colors.grey,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Column(children: buildItemList2()),
                    ),
                  ],
                ),
              ),
            ),
     
    );
  }
}
