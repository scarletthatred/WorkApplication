import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workapp/form.dart';


class SetupPage extends StatefulWidget {
  const SetupPage({super.key, required this.title});

  final String title;

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
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

  List<bool> selected = List<bool>.generate(20, (i) => false);
  List<Map<String, dynamic>> fields = [];
  Map<String, dynamic> fieldsVariables = {};
  Map<String, dynamic> editFieldsVariables = {};
  String type = "Text Field";
  String formName = "";
  String editType = "";
  String labelText = "";
  String editLabelText = "";
  bool numeric = false;
  String initialValue = "";
  int numberOfOptions = 0;
  int textFieldMaxLines = 1;
  List<String> options = [];
  List<String> editOptions = [];
  int editNumberOfOptions = 0;

  List<List<Map<String, dynamic>>> configurations = [];

  errorCode(int error) {
    List<String> errorCodes = ["There is missing Information"];
    List<String> errorTitles = ["Missing info"];
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

  edit(int item, Function refreshGlobalState) {
    editNumberOfOptions = fields[item]["NumberOfOptions"];
    for (int g = 0; g < editNumberOfOptions; g++) {
      editOptions.add(fields[item]["option$g"]);
    }
    editType = fields[item]["Type"];
    editLabelText = fields[item]["Label"];

    String initialType = fields[item]["Type"];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
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
                            labelText: "Field",
                          ),
                          initialValue: initialType,
                          // Initial value from variables map
                          onChanged: (String? newValue) {
                            setState(() {
                              editType = newValue!;
                            });
                          },
                          items: ["Text Field", "List Selection", "Radio Selection"]
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
                          readOnly: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Label",
                          ),
                          controller: TextEditingController()
                            ..text = "${fields[item]["Label"]}",
                          onChanged: (value) {
                            editLabelText = value;
                          },
                        ),
                      ),
                      (fields[item]["Type"] == "Text Field")
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Text("Numeric"),
                                  Checkbox(
                                      value: (fields[item]["Numeric"] == null)
                                          ? false
                                          : fields[item]["Numeric"],
                                      onChanged: (value) {
                                        fields[item]["Numeric"] =
                                            (fields[item]["Numeric"] == null)
                                                ? true
                                                : !fields[item]["Numeric"];
                                        setState(() {});
                                      }),
                                ],
                              ))
                          : Container(),
                      (fields[item]["Type"] != "Text Field" &&
                              fields[item]["Type"] != "")
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            editOptions.add("");
                                            editNumberOfOptions++;
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.arrow_upward)),
                                      Text("$editNumberOfOptions"),
                                      IconButton(
                                          onPressed: () {
                                            if (editNumberOfOptions > 0) {
                                              editOptions.removeAt(
                                                  editNumberOfOptions - 1);
                                              editNumberOfOptions--;
                                            }
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.arrow_downward))
                                    ],
                                  ),
                                ),
                                for (int i = 0; i < editNumberOfOptions; i++)
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: TextField(
                                      readOnly: false,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: "Option${i + 1}",
                                      ),
                                      controller: TextEditingController()
                                        ..text = editOptions[i],
                                      onChanged: (value) {
                                        editOptions[i] =
                                            value; // Update specific field variable
                                      },
                                    ),
                                  ),
                              ],
                            )
                          : Container(),
                      Row(
                        children: [
                          Container(
                            width: 120,
                            height: 60,
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                ///edit item submit here -------------------------------------------------

                                if (editType == "Text Field") {
                                  editFieldsVariables = {
                                    "Type": editType,
                                    "Label": editLabelText,
                                    "Numeric": numeric
                                  };
                                } else {
                                  editFieldsVariables = {
                                    "Type": editType,
                                    "Label": editLabelText,
                                    "NumberOfOptions": editNumberOfOptions,
                                    for (int j = 0;
                                        j <= editNumberOfOptions - 1;
                                        j++)
                                      "option$j": editOptions[j]
                                  };
                                }
                                fields[item]=editFieldsVariables;
                                editFieldsVariables = {};
                                // saveItems();
                                refreshGlobalState();

                                ///-----------------------------------------------
                                editOptions.clear();
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
                                editOptions.clear();
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
        });
      },
    );
  }

  void deleteItem(int index) {
    setState(() {
      fields.removeAt(index);
    });
  }

  List<Widget> buildItemList() {
    List<Widget> list = [];
    for (int i = 0; i < fields.length; i++) {
      list.add(
        Column(
          children: [
            (!(MediaQuery.of(context).orientation == Orientation.portrait))
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ///todo remember to add the field key to the questions!!!
                      fieldMaker((fields[i]["Type"]== "Text Field")?0:(fields[i]["Type"]== "List Selection")?1:2, "Default Value", (fields[i]["Type"]== "Text Field")?["default"]:[for (int k = 0;k <= fields[i]["NumberOfOptions"] -1;k++)fields[i]["option$k"]],fields[i]["Label"],isNumeric: (fields[i]["Type"]== "Text Field")? fields[i]["Numeric"]:false),
                      // Text("Type of field: \n${fields[i]["Type"]}"),
                      // Text("Label: \n${fields[i]["Label"]}"),
                      // (fields[i]["Type"] == "Text Field" &&
                      //         fields[i]["Type"] != "")
                      //     ? Text("only allows numbers: ${fields[i]["Numeric"]}")
                      //     : Column(
                      //         children: [
                      //           const Text("type options:"),
                      //           SizedBox(
                      //               height: 75,
                      //               width: 150,
                      //               child: SingleChildScrollView(
                      //                 child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: [
                      //                       for (int k = 0;
                      //                           k <=
                      //                               fields[i][
                      //                                       "NumberOfOptions"] -
                      //                                   1;
                      //                           k++)
                      //                         Text("• ${fields[i]["option$k"]}")
                      //                     ]),
                      //               ))
                      //         ],
                      //       ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => edit(i, () {
                          setState(() {});
                        }),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteItem(i),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      fieldMaker((fields[i]["Type"]== "Text Field")?0:(fields[i]["Type"]== "List Selection")?1:2, "Default Value", (fields[i]["Type"]== "Text Field")?["default"]:[for (int k = 0;k <= fields[i]["NumberOfOptions"] -1;k++)fields[i]["option$k"]],fields[i]["Label"],isNumeric: (fields[i]["Type"]== "Text Field")? fields[i]["Numeric"]:false),

                      // Column(children: [
                      //   Text("Type of field: \n${fields[i]["Type"]}"),
                      //   Text("Label: \n${fields[i]["Label"]}")
                      // ]),
                      // (fields[i]["Type"] == "Text Field" &&
                      //         fields[i]["Type"] != "")
                      //     ? Text("only allows numbers: ${fields[i]["Numeric"]}")
                      //     : Column(
                      //         children: [
                      //           const Text("type options:"),
                      //           SizedBox(
                      //               height: 75,
                      //               width: 150,
                      //               child: SingleChildScrollView(
                      //                 child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: [
                      //                       for (int k = 0;
                      //                           k <=
                      //                               fields[i][
                      //                                       "NumberOfOptions"] -
                      //                                   1;
                      //                           k++)
                      //                         Text("• ${fields[i]["option$k"]}")
                      //                     ]),
                      //               ))
                      //         ],
                      //       ),
                      Column(children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => edit(i, () {
                            setState(() {});
                          }),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteItem(i),
                        ),
                      ])
                    ],
                  ),
            const Divider(), // Adds a horizontal line between items
          ],
        ),
      );
    }
    return list;
  }
  Widget fieldMaker(int fieldType, String fieldVariable, List<String> values, String labelText, {bool isNumeric = false}) {
    TextInputType keyboardType = isNumeric ? TextInputType.number : TextInputType.text;
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
              fieldsVariables[fieldVariable] = value; // Update specific field variable
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
              Text(labelText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ...values.map((value) => RadioListTile<String>(
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
              )),
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



  @override
  Widget build(BuildContext context) {
    // loadItems();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          SizedBox(
            width: 300,
            height: 50,
            child: TextField(
              readOnly: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Form Name",
              ),
              onChanged: (value) {
                setState(() {
                  formName =
                      value; // Update specific field variable
                });
              },
            ),
          ),],
      ),
      body: (!(MediaQuery.of(context).orientation == Orientation.portrait))
          ? SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Field",
                            ),
                            initialValue:
                                "Text Field", // Initial value from variables map
                            onChanged: (String? newValue) {
                              setState(() {
                                type = newValue!;
                              });
                            },
                            items: ["Text Field", "List Selection", "Radio Selection"]
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
                            readOnly: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Label",
                            ),
                            onChanged: (value) {
                              setState(() {
                                labelText =
                                    value; // Update specific field variable
                              });
                            },
                          ),
                        ),
                        (type == "Text Field")
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Text("numeric"),
                                    Checkbox(
                                        value: numeric,
                                        onChanged: (value) {
                                          numeric = !numeric;
                                          setState(() {});
                                        }),
                                  ],
                                ))
                            : Container(),
                        (type != "Text Field" && type != "")
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              options.add("");
                                              numberOfOptions++;
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.arrow_upward)),
                                        Text("$numberOfOptions"),
                                        IconButton(
                                            onPressed: () {
                                              if (numberOfOptions > 0) {
                                                options.removeAt(
                                                    numberOfOptions - 1);
                                                numberOfOptions--;
                                              }
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.arrow_downward))
                                      ],
                                    ),
                                  ),
                                  for (int i = 0; i < numberOfOptions; i++)
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextField(
                                        readOnly: false,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: "Option${i + 1}",
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            options[i] =
                                                value; // Update specific field variable
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              )
                            : Container(),
                        TextButton(
                            onPressed: () {
                              ///todo this is the last step to add when the list is being created
                              if (type == "Text Field") {
                                fieldsVariables = {
                                  "Type": type,
                                  "Label": labelText,
                                  "Numeric": numeric
                                };
                              } else {
                                fieldsVariables = {
                                  "Type": type,
                                  "Label": labelText,
                                  "NumberOfOptions": numberOfOptions,
                                  for (int j = 0; j <= numberOfOptions - 1; j++)
                                    "option$j": options[j]
                                };
                              }
                              fields.add(fieldsVariables);

                              fieldsVariables = {};
                              // saveItems();
                              setState(() {});
                            },
                            child: const Row(
                              children: [
                                Text("Add Field"),
                                Icon(Icons.add),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    height:800,
                    width: 500,
                    color: Colors.grey,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Column(children: buildItemList()),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            // fields[]
                            configurations.add(fields);
                            fields = [];
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => Forms(items: configurations[0],),
                            //   ),
                            // );
                            setState(() {});
                          },
                          child: const Row(
                            children: [
                              Text("Add this Configuration?"),
                              Icon(Icons.add_circle),
                            ],
                          )),
                      configurations.isNotEmpty
                          ? Expanded(
                        child: ListView.builder(
                          itemCount: configurations.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text("$index"),
                              trailing: selected[index]
                                  ? Icon(Icons.check_box)
                                  : Icon(Icons.check_box_outline_blank),
                              onTap: () {
                                setState(() {
                                  selected[index] = !selected[index];
                                });
                              },
                            );
                          },
                        ),
                      )
                          : Container(),











                    ],
                  ),

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
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Field",
                              ),
                              initialValue:
                                  "Text Field", // Initial value from variables map
                              onChanged: (String? newValue) {
                                setState(() {
                                  type = newValue!;
                                });
                              },
                              items: ["Text Field", "List Selection", "Radio Selection"].map<DropdownMenuItem<String>>(
                                  (String value) {
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
                              readOnly: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Label",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  labelText =
                                      value; // Update specific field variable
                                });
                              },
                            ),
                          ),
                          (type == "Text Field")
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const Text("numeric"),
                                      Checkbox(
                                          value: numeric,
                                          onChanged: (value) {
                                            numeric = !numeric;
                                            setState(() {});
                                          }),
                                    ],
                                  ))
                              : Container(),
                          (type != "Text Field" && type != "")
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                options.add("");
                                                numberOfOptions++;
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.arrow_upward)),
                                          Text("$numberOfOptions"),
                                          IconButton(
                                              onPressed: () {
                                                if (numberOfOptions > 0) {
                                                  options.removeAt(
                                                      numberOfOptions - 1);
                                                  numberOfOptions--;
                                                }
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.arrow_downward))
                                        ],
                                      ),
                                    ),
                                    for (int i = 0; i < numberOfOptions; i++)
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: TextField(
                                          readOnly: false,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: "Option${i + 1}",
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              options[i] =
                                                  value; // Update specific field variable
                                            });
                                          },
                                        ),
                                      ),
                                  ],
                                )
                              : Container(),
                          TextButton(
                              onPressed: () {
                                ///todo this is the last step to add when the list is being created
                                if (type == "Text Field") {
                                  fieldsVariables = {
                                    "Type": type,
                                    "Label": labelText,
                                    "Numeric": numeric
                                  };
                                } else {
                                  fieldsVariables = {
                                    "Type": type,
                                    "Label": labelText,
                                    "NumberOfOptions": numberOfOptions,
                                    for (int j = 0;
                                        j <= numberOfOptions - 1;
                                        j++)
                                      "option$j": options[j]
                                  };
                                }
                                fields.add(fieldsVariables);

                                fieldsVariables = {};
                                // saveItems();
                                setState(() {});
                              },
                              child: const Row(
                                children: [
                                  Text("Add Field"),
                                  Icon(Icons.add),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.grey,
                    child: SingleChildScrollView(
                      child: Column(children: buildItemList()),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        configurations.add(fields);
                        fields = [];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Forms(items: configurations[0],),
                          ),
                        );
                        setState(() {});
                      },
                      child: const Row(
                        children: [
                          Text("Use this Configuration?"),
                          Icon(Icons.add_circle),
                        ],
                      )),
                ],
              ),
            ),
    );
  }
}
