import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import 'utils/userBottomsheet.dart';

class Homepage1 extends StatefulWidget {
  static const routeName = '/homepage1';
  Homepage1({Key? key}) : super(key: key);
  @override
  State<Homepage1> createState() => _Homepage1State();
}

class _Homepage1State extends State<Homepage1> {
  // final service = IsarService();
  List<List<dynamic>> _data = [];
  String? filePath;

  // This function is triggered when the  button is pressed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // service.cleanDb();
              },
            ),
          ],
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.white,
            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          title: const Text("Bulk Upload",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              )),
        ),
        body: Column(
          children: [
            ElevatedButton(
              child: const Text("Upload FIle"),
              onPressed: () {
                _pickFile();
              },
            ),
            // StreamBuilder(
            //     stream: service.listenToCourses(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasError) {
            //         return Text(snapshot.error.toString());
            //       }
            //       if (!snapshot.hasData) {
            //         return const Center(child: CircularProgressIndicator());
            //       }
            //       return Expanded(
            //         child: ListView.builder(
            //           itemCount: snapshot.data?.length,
            //           itemBuilder: (context, index) {
            //             final demo = snapshot.data?[index];
            //             return ListTile(
            //               leading: CircleAvatar(
            //                 child: Text(demo?.srno.toString() ?? ''),
            //               ),
            //               title: Text(demo?.party ?? ''),
            //               subtitle: Text(demo?.date.toString() ?? ''),
            //               trailing: Text(demo?.amount.toString() ?? ''),
            //             );
            //           },
            //         ),
            //       );
            //     }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            // showModalBottomSheet(
            //     context: context,
            //     builder: (context) {
            //       return DemoModal();
            //     });
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.red,
        ));
  }

  void _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      // if no file is picked
      if (result == null) return;
      // we will log the name, size and path of the
      // first picked file (if multiple are selected)
      print(result.files.first.name);
      filePath = result.files.first.path!;

      final input = File(filePath!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      print(fields);

      setState(() {
        _data = fields;
      });

      var srno;
      var party;
      var amount;
      var date;
      for (var i = 0; i < _data.length; i++) {
        if (i != 0) {
          srno = _data[i][0] = _data[i][0].toString().trim();
          party = _data[i][1] = _data[i][1].toString().trim();
          amount = _data[i][2] = _data[i][2].toString().trim();
          date = _data[i][3] = _data[i][3].toString().trim();
          DateTime tempDate = DateFormat("dd.MM.yyyy").parse(date);
          tempDate = DateFormat("dd-MM-yyyy")
              .parse(DateFormat("dd-MM-yyyy").format(tempDate));

          // final demo = Demo(
          //   srno: int.parse(srno),
          //   party: party,
          //   amount: double.parse(amount),
          //   date: tempDate,
          // );
          print(srno);
          print(party);
          print(amount);
          print(tempDate);

          // await service.saveData(demo);
        }
      }
      print(_data);
      // for (var element in _data) {

      //     element[0] = element[0].toString().trim();
      // }
    } catch (e) {
      print(e);
    }
  }
}
