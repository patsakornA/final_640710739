import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'a.dart';
import 'api_caller.dart';
import 'dialog_utils.dart';
import 'my_list_tile.dart';
import 'my_text_field.dart';
// import api_caller.dart เพื่อใช้งาน ApiCaller

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _url;
  String? _details;
  String? _webType;

  List<WebsiteData> _webCategories =
      []; // ประกาศ List ของ WebsiteData จาก a.dart

  @override
  void initState() {
    super.initState();
    _fetchWebCategories();
  }

  Future<void> _fetchWebCategories() async {
    try {
      final apiCaller = ApiCaller(); // สร้าง instance ของ ApiCaller
      final data = await apiCaller.get(
          "website_data"); // เรียกใช้งานเมธอด get จาก ApiCaller เพื่อดึงข้อมูลประเภทเว็บไซต์
      final jsonData = jsonDecode(data); // แปลงข้อมูล JSON เป็น List
      setState(() {
        _webCategories = jsonData
            .map<WebsiteData>((item) => WebsiteData.fromJson(item))
            .toList();
      });
    } catch (e) {
      print("Error fetching web categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Reporting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(label: Text('URL')),
              onChanged: (value) {
                setState(() {
                  _url = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(label: Text('Details')),
              onChanged: (value) {
                setState(() {
                  _details = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _webType,
              hint: const Text('Select Website Type'),
              onChanged: (String? value) {
                setState(() {
                  _webType = value;
                });
              },
              items:
                  _webCategories.map<DropdownMenuItem<String>>((webCategory) {
                return DropdownMenuItem<String>(
                  value: webCategory.id,
                  child: Text(webCategory.title),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_url != null && _webType != null) {
                  _submitData();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content:
                            const Text('Please fill in all required fields.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitData() {
    // เรียกใช้ API เพื่อส่งข้อมูล
    // ในตัวอย่างนี้จะไม่ส่งข้อมูล เราจะแสดงข้อความ "Success" ใน dialog แทน
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Data submitted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
