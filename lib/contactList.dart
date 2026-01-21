import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workapp/pdfContacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


class ContactListApp extends StatefulWidget {
  const ContactListApp({super.key, required this.title});

  final String title;

  @override
  State<ContactListApp> createState() => _ContactListAppState();
}

class _ContactListAppState extends State<ContactListApp> {
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

  final key = "QK2D0TY3kXNz3CeNnYX2bPX4lH5aYz5U";

  loadItemsFromEncryptionKey(String encryptionKey) {
    final decryptedText = decryptData(encryptionKey);
    print("Decrypted: $decryptedText");
    List<Map<String, dynamic>> newItems = [];
    if (decryptedText.isNotEmpty) {
      newItems = List<Map<String, dynamic>>.from(json.decode(decryptedText));
      print("Items: $items");
    }
    return newItems;
  }

  String decryptData(String encryptedText) {
    final keyBytes = encrypt.Key.fromUtf8(key);
    final ivAndCiphertext = base64.decode(encryptedText);
    final iv = encrypt.IV(ivAndCiphertext.sublist(0, 16));
    final ciphertext = ivAndCiphertext.sublist(16);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    try {
      final decrypted =
          encrypter.decryptBytes(encrypt.Encrypted(ciphertext), iv: iv);
      return utf8.decode(decrypted);
    } catch (e) {
      print("Decryption failed: $e");
      return "";
    }
  }

  String encryptData(String plainText) {
    final keyBytes = encrypt.Key.fromUtf8(key);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final ivAndCiphertext = iv.bytes + encrypted.bytes;
    return base64.encode(ivAndCiphertext);
  }

  void saveItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(items);
    await prefs.setString('savedContacts', encodedData);
    final encryptedData = encryptData(encodedData);
    print(encryptedData);
    currentEncryptionKey = encryptedData;
  }

  void loadItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('savedContacts');
    if (encodedData != null) {
      setState(() {
        items = List<Map<String, dynamic>>.from(json.decode(encodedData));
      });
    }
  }

  List<Map<String, dynamic>> items = [];
  Map<String, dynamic> details = {};
  String contactName = "";
  String phoneNumber = "";
  String email = "";
  String company = "";
  String testContactName = "";
  String testPhoneNumber = "";
  String testEmail = "";
  String testCompany = "";
  List<String> companies = [];
  String search = "";
  String currentEncryptionKey = "";
  String newEncryptionKey = "";

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
    testContactName = items[item]["ContactName"];
    testPhoneNumber = items[item]["phoneNumber"];
    testEmail = items[item]["Email"];
    testCompany = items[item]["Company"];
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
                      child: TextField(
                        controller: TextEditingController()..text = testCompany,
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Company',
                        ),
                        onChanged: (value) => testCompany = value,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = testContactName,
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contact Name',
                        ),
                        onChanged: (value) => testContactName = value,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = testPhoneNumber,
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone Number',
                        ),
                        onChanged: (value) => testPhoneNumber = value,
                        onEditingComplete: () {
                          phoneNumber = formatPhoneNumber(phoneNumber);
                        },
                        maxLines: 1,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: TextEditingController()..text = testEmail,
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        onChanged: (value) => testEmail = value,
                        maxLines: 5,
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
                              if (!companies.contains(company)) {
                                companies.add(company);
                                companies.sort();
                              }
                              if (testContactName == "" ||
                                  testContactName.isEmpty ||
                                  testCompany == "" ||
                                  testCompany.isEmpty) {
                                errorCode(0);
                              } else {
                                if (testPhoneNumber == "" ||
                                    testPhoneNumber.isEmpty) {
                                  testPhoneNumber = "N/A";
                                }
                                if (testEmail == "" || testEmail.isEmpty) {
                                  testEmail = "N/A";
                                }
                                details = {
                                  "ContactName": testContactName,
                                  "phoneNumber": testPhoneNumber,
                                  "Company": testCompany,
                                  "Email": testEmail
                                };
                                items[item] = details;
                              }
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

  void newItem() {
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
            "New Contact",
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
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Company',
                        ),
                        onChanged: (value) => company = value,
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
                          labelText: 'Contact Name',
                        ),
                        onChanged: (value) => contactName = value,
                        minLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone Number',
                        ),
                        onChanged: (value) => phoneNumber = value,
                        onEditingComplete: () {
                          phoneNumber = formatPhoneNumber(phoneNumber);
                        },
                        maxLines: 1,
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
                          labelText: 'Email',
                        ),
                        onChanged: (value) => email = value,
                        maxLines: 5,
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
                              if (!companies.contains(company)) {
                                companies.add(company);
                                companies.sort();
                              }
                              if (contactName == "" ||
                                  contactName.isEmpty ||
                                  company == "" ||
                                  company.isEmpty) {
                                errorCode(0);
                              } else {
                                if (phoneNumber == "" || phoneNumber.isEmpty) {
                                  phoneNumber = "N/A";
                                }
                                if (email == "" || email.isEmpty) {
                                  email = "N/A";
                                }
                                details = {
                                  "ContactName": contactName,
                                  "phoneNumber": phoneNumber,
                                  "Company": company,
                                  "Email": email
                                };
                                items.add(details);
                                contactName = "";
                                phoneNumber = "";
                                company = "";
                                email = "";
                              }

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
                              "Add",
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

  void inputEncryptionKey() {
    saveItems();
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
            "Ecnryption Key",
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
                        readOnly: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Encryption Key',
                        ),
                        onChanged: (value) => newEncryptionKey = value,
                        minLines: 1,
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      child: Column(
                        children: [
                          Text("This is your current encrypted list:"),
                          SelectableText(currentEncryptionKey)
                        ],
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
                              if (newEncryptionKey == "" ||
                                  newEncryptionKey.isEmpty) {
                                errorCode(0);
                              } else {
                                try {
                                  items = items +
                                      loadItemsFromEncryptionKey(
                                          newEncryptionKey);
                                } catch (e) {
                                  print("Error:$e");
                                }
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
                              "Add",
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

  String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check if the cleaned number has at least 9 digits
    if (cleaned.length < 9) {
      throw FormatException("Phone number must have at least 9 digits");
    }

    // Take the first 3 digits for the area code
    String areaCode = cleaned.substring(0, 3);
    // Take the next 3 digits
    String firstPart = cleaned.substring(3, 6);
    // Take the remaining digits
    String secondPart = cleaned.substring(6, 9);

    // Format and return the phone number
    return '($areaCode)$firstPart-$secondPart';
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      saveItems();
    });
  }

  List<Widget> buildResultList() {
    List<Widget> list = [];
    for (int i = 0; i < results.length; i++) {
      list.add(
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      SelectableText("Company: ${results[i]["Company"]}"),
                      SelectableText(
                          "Contact Name: ${results[i]["ContactName"]}"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SelectableText(
                          "Phone Number: ${results[i]["phoneNumber"]}"),
                      SelectableText("Email: ${results[i]["Email"]}"),
                    ],
                  ),
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
                SelectableText("Company: ${items[i]["Company"]}"),
                Flexible(
                    flex: 5,
                    child: SelectableText(
                        "Contact Name: ${items[i]["ContactName"]}")),
                Flexible(
                    flex: 3,
                    child: SelectableText(
                        "Phone Number: ${items[i]["phoneNumber"]}")),
                Flexible(
                    flex: 3,
                    child: SelectableText("Email: ${items[i]["Email"]}")),
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

  List<Widget> buildItemList2() {
    List<Widget> list = [];
    for (int i = 0; i < items.length; i++) {
      list.add(
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Main content column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Company: ${items[i]["Company"]} | ",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              "Contact Name: ${items[i]["ContactName"]}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Phone Number: ${items[i]["phoneNumber"]} | ",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              "Email: ${items[i]["Email"]}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Icons column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
    return list;
  }

  List results = [];

  void sortItemsByCompany() {
    items.sort((a, b) => (a['Company'] ?? "").compareTo(b['Company'] ?? ""));
  }

  List searchResults(String search) {
    results = [];
    for (int y = 0; y < items.length; y++) {
      if (items[y]["Company"].contains(search) ||
          items[y]["ContactName"].contains(search) ||
          items[y]["phoneNumber"].contains(search) ||
          items[y]["Email"].contains(search)) {
        if (!results.contains(items[y])) {
          results.add(items[y]);
        }
      } else if (results.contains(items[y])) {
        results.remove(items[y]);
      }
    }
    return results;
  }

  Widget bodyWidget(){
    Widget bodyWidgetByDevice = CircularProgressIndicator();
   try {
     if (Platform.isAndroid) {
       if (!(MediaQuery
           .of(context)
           .orientation == Orientation.portrait)) {
         bodyWidgetByDevice = SingleChildScrollView(child: Column(
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 TextButton(
                   onPressed: () {
                     inputEncryptionKey();
                   },
                   child: Row(
                     children: [
                       Icon(Icons.enhanced_encryption_outlined),
                       Text("List Key"),
                     ],
                   ),
                 ),
                 TextButton(
                   onPressed: () {
                     newItem();
                   },
                   child: Row(
                     children: [
                       Icon(Icons.add_circle),
                       Text("Add Contact"),
                     ],
                   ),
                 ),
                 TextButton(
                   onPressed: () async {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => PdfContact(itemsList: items),
                       ),
                     );
                   },
                   child: Row(
                     children: [
                       Icon(Icons.picture_as_pdf),
                       Text("Print Page"),
                     ],
                   ),
                 ),
                 SizedBox(
                   height: 50,
                   width: 200,
                   child: TextField(
                     readOnly: false,
                     decoration: const InputDecoration(
                       border: OutlineInputBorder(),
                       labelText:
                       'Search', // Label for the new field
                     ),
                     onChanged: (value) {
                       search = value;
                       results = searchResults(search);
                       setState(() {});
                     }, // Update company state on change
                   ),
                 ),
               ],
             ),
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Flexible(
                   flex: 3,
                   child: Container(
                     color: Colors.grey,
                     child: SingleChildScrollView(
                       child: Column(children: buildItemList()),
                     ),
                   ),
                 ),
                 (search != "" ||
                     search.isNotEmpty && items.isNotEmpty)
                     ? Flexible(
                   flex: 2,
                   child: Container(
                     color: Colors.blueGrey,
                     child: SingleChildScrollView(
                       child:
                       Column(children: buildResultList()),
                     ),
                   ),
                 )
                     : Container()
               ],
             ),

           ],
         ));
       }
       else {
         bodyWidgetByDevice = SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [

                   SizedBox(
                     height: 50,
                     width: 200,
                     child: TextField(
                       readOnly: false,
                       decoration: const InputDecoration(
                         border: OutlineInputBorder(),
                         labelText:
                         'Search', // Label for the new field
                       ),
                       onChanged: (value) {
                         search = value;
                         results = searchResults(search);
                         setState(() {});
                       }, // Update company state on change
                     ),
                   ),
                   TextButton(
                     onPressed: () async {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) => PdfContact(itemsList: items),
                         ),
                       );
                     },
                     child: Row(
                       children: [
                         Icon(Icons.picture_as_pdf),
                         Text("Print Page"),
                       ],
                     ),
                   ),
                 ],
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   TextButton(
                     onPressed: () {
                       newItem();
                     },
                     child: Row(
                       children: [
                         Icon(Icons.add_circle),
                         Text("Add Contact"),
                       ],
                     ),
                   ),
                   TextButton(
                     onPressed: () {
                       inputEncryptionKey();
                     },
                     child: Row(
                       children: [
                         Icon(Icons.enhanced_encryption_outlined),
                         Text("List Key"),
                       ],
                     ),
                   ),
                 ],
               ),
               (search != "" || search.isNotEmpty && items.isNotEmpty)
                   ? Container(
                 color: Colors.blueGrey,
                 child: SingleChildScrollView(
                   child: Column(children: buildResultList()),
                 ),
               )
                   : Container(),
               Container(
                 color: Colors.grey,
                 child: SingleChildScrollView(
                   child: Column(children: buildItemList2()),
                 ),
               ),
             ],
           ),
         );
       }
     }
     else {
       if (!(MediaQuery
           .of(context)
           .orientation == Orientation.portrait)) {
         bodyWidgetByDevice = SingleChildScrollView(child: Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Flexible(
               flex: 3,
               child: Container(
                 color: Colors.grey,
                 child: SingleChildScrollView(
                   child: Column(children: buildItemList()),
                 ),
               ),
             ),
             (search != "" || search.isNotEmpty && items.isNotEmpty)
                 ? Flexible(
               flex: 2,
               child: Container(
                 color: Colors.blueGrey,
                 child: SingleChildScrollView(
                   child: Column(children: buildResultList()),
                 ),
               ),
             )
                 : Container()
           ],
         ));
       }
       else {
         bodyWidgetByDevice = SingleChildScrollView(child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             (search != "" || search.isNotEmpty && items.isNotEmpty)
                 ? Container(
               color: Colors.blueGrey,
               child: SingleChildScrollView(
                 child: Column(children: buildResultList()),
               ),
             )
                 : Container(),
             Container(
               color: Colors.grey,
               child: SingleChildScrollView(
                 child: Column(children: buildItemList2()),
               ),
             ),
           ],
         ));
       }
     }
   }
   catch(e){
     bodyWidgetByDevice = SingleChildScrollView(child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         (search != "" || search.isNotEmpty && items.isNotEmpty)
             ? Container(
           color: Colors.blueGrey,
           child: SingleChildScrollView(
             child: Column(children: buildResultList()),
           ),
         )
             : Container(),
         Container(
           color: Colors.grey,
           child: SingleChildScrollView(
             child: Column(children: buildItemList2()),
           ),
         ),
       ],
     ));
   }
    return bodyWidgetByDevice;
  }

  AppBar appBarWidget(){
   AppBar appBarWidgetByDevice = AppBar(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      title: Row(
        children: [
          Image(
            image: AssetImage("lib/images/turnkeyLogo.png"),
            height: 50,
          ),
          SizedBox(width: 8),
          // Add some space between the logo and the title
          Text(widget.title),
          SizedBox(width: 16),
          // Add some space between the title and the button
        ],
      ),
    );
   try{if(!Platform.isAndroid){
     appBarWidgetByDevice = AppBar(
       backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
       actions: [
         TextButton(
             onPressed: () {
               inputEncryptionKey();
             },
             child: Row(
               children: [
                 Icon(Icons.enhanced_encryption_outlined),
                 Text("List Key"),
               ],
             )),
         TextButton(
             onPressed: () {
               newItem();
             },
             child: Row(
               children: [Icon(Icons.add_circle),Text("Add Contact")],
             )),
         SizedBox(
           height: 50,
           width: 200,
           child: TextField(
             readOnly: false,
             decoration: const InputDecoration(
               border: OutlineInputBorder(),
               labelText: 'Search', // Label for the new field
             ),
             onChanged: (value) {
               search = value;
               results = searchResults(search);
               setState(() {});
             }, // Update company state on change
           ),
         ),
         TextButton(
           onPressed: () async {
             Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) => PdfContact(itemsList: items),
               ),
             );
           },
           child:  Row(
             children: [
               Icon(Icons.picture_as_pdf),
               Text("Print Page"),
             ],
           ),
         ),
       ],
     );
   }}
   catch(e){
     appBarWidgetByDevice =AppBar(
       backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
       actions: [
         TextButton(
             onPressed: () {
               inputEncryptionKey();
             },
             child: Row(
               children: [
                 Icon(Icons.enhanced_encryption_outlined),
                 Text("List Key"),
               ],
             )),
         TextButton(
             onPressed: () {
               newItem();
             },
             child: Row(
               children: [Icon(Icons.add_circle),Text("Add Contact")],
             )),
         SizedBox(
           height: 50,
           width: 200,
           child: TextField(
             readOnly: false,
             decoration: const InputDecoration(
               border: OutlineInputBorder(),
               labelText: 'Search', // Label for the new field
             ),
             onChanged: (value) {
               search = value;
               results = searchResults(search);
               setState(() {});
             }, // Update company state on change
           ),
         ),
         TextButton(
           onPressed: () async {
             Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) => PdfContact(itemsList: items),
               ),
             );
           },
           child:  Row(
             children: [
               Icon(Icons.picture_as_pdf),
               Text("Print Page"),
             ],
           ),
         ),
       ],
     );
   }
   return appBarWidgetByDevice;
  }

  @override
  Widget build(BuildContext context) {
    loadItems();
    return Scaffold(
      appBar: appBarWidget(),
      body: bodyWidget()
    );
  }
}
