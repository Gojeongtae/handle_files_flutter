import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FileApp();
}

class _FileApp extends State<FileApp> {
  int _count = 0;
  List<String> itemList = new List.empty(growable: true);
  TextEditingController controller = new TextEditingController();

  Future<List<String>> readListFile() async {
    List<String> itemList = new List.empty(growable: true);
    var key = 'first';
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? firstCheck = pref.getBool(key); //preference의 값이 있는지 bool로 확인
    var dir = await getApplicationDocumentsDirectory();
    bool fileExist = await File(dir.path + 'fruit.txt')
        .exists(); //exist가 함수 내부 저장소에 파일을 찾는 것.

    if (firstCheck == null || firstCheck == false || fileExist == false) {
      //처음 열거나 없으면 file을 만들어 저장해주고 리스트에 넣어주기
      pref.setBool(key, true);
      var file =
          await DefaultAssetBundle.of(context).loadString('repo/fruit.txt');

      File(dir.path + '/fruit.txt').writeAsStringSync(file);
      var array = file.split('\n'); //한칸씩 단위로 파일을 끊겠다.
      for (var item in array) {
        print(item);
        itemList.add(item);
      }
      return itemList;
    } else {
      var file = await File(dir.path + '/fruit.txt')
          .readAsString(); // 있으면 그냥 내부저장소 있는거 그대로 리스트에 넣기
      var array = file.split('\n');
      for (var item in array) {
        print(item);
        itemList.add(item);
      }
      return itemList;
    }
  }

  @override
  void initState() {
    super.initState();
    readCountFile();
    initData();
  }

  void initData() async {
    var result = await readListFile();
    setState(() {
      itemList.addAll(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Example'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Center(
                      child: Text(
                        itemList[index],
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  );
                },
                itemCount: itemList.length,
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  void writeCountFile(int count) async {
    var dir = await getApplicationDocumentsDirectory();
    File(dir.path + '/count.txt').writeAsStringSync(count.toString());
  }

  void readCountFile() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      var file = await File(dir.path + '/count.txt').readAsString();
      print(file);
      setState(() {
        _count = int.parse(file);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
