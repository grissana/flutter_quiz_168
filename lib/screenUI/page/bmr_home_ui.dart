// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_quiz_168/services/supabase_services.dart';
import 'package:flutter_quiz_168/models/supabase_class.dart';

class BmrHomeUi extends StatefulWidget {
  const BmrHomeUi({super.key});

  @override
  State<BmrHomeUi> createState() => _BmrHomeUiState();
}

class _BmrHomeUiState extends State<BmrHomeUi> {
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

  final service = Supabase_Services();
  File? _image; // เก็บรูปที่ถ่าย
  String? selectedSex;

  // ฟังก์ชัน popup แจ้งเตือน
  Future<void> showPopup(String message) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("แจ้งเตือน"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  // ฟังก์ชันบันทึกข้อมูล
  Future<void> saveData() async {
    final double? weight = double.tryParse(weightCtrl.text);
    final double? height = double.tryParse(heightCtrl.text);
    final int? age = int.tryParse(ageCtrl.text);

    if (weight == null ||
        height == null ||
        age == null ||
        selectedSex == null) {
      await showPopup("กรอกข้อมูลไม่ครบหรือไม่ถูกต้อง");
      return;
    }

    // คำนวณ BMR
    double bmr_value = 0;
    if (selectedSex == 'male') {
      bmr_value = 66 + (13.7 * weight) + (5 * height) - (6.8 * age);
    } else if (selectedSex == 'female') {
      bmr_value = 655 + (9.6 * weight) + (1.8 * height) - (4.7 * age);
    }

    // สร้าง object bmr_tb
    final newBmr = bmr_tb(
      weight: weight,
      height: height,
      age: age,
      sex: selectedSex!,
      bmr: bmr_value,
    );

    // บันทึกลง Supabase
    final success = await service.addBmr(newBmr);

    if (success) {
      await showPopup(
          "บันทึกข้อมูลสำเร็จ\nค่า BMR: ${bmr_value.toStringAsFixed(2)} แคลอรี่/วัน");
      weightCtrl.clear();
      heightCtrl.clear();
      ageCtrl.clear();
      setState(() {
        selectedSex = null;
        _image = null;
      });
    } else {
      await showPopup("บันทึกข้อมูลล้มเหลว");
    }
  }

  // ฟังก์ชันเปิดกล้อง
  Future<void> pickImage() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        await showPopup("ไม่สามารถเข้าถึงกล้องได้ กรุณาอนุญาต");
        return;
      }
    }

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        await showPopup("คุณยกเลิกการถ่ายรูป");
      }
    } catch (e) {
      await showPopup("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('BMR Application', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: Icon(Icons.camera_alt),
          color: Colors.white,
          onPressed: pickImage,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // แสดงรูปถ่าย หรือ รูป default
              _image != null
                  ? Image.file(_image!,
                      height: 200, width: double.infinity, fit: BoxFit.cover)
                  : Image.asset('assets/images/addbmr.jpg',
                      height: 200, width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 30),
              Text(
                "กรอกข้อมูลเพื่อคำนวณค่า BMR",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // เลือกเพศ
              Text("เลือกเพศ", style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Radio<String>(
                    value: "male",
                    groupValue: selectedSex,
                    onChanged: (value) {
                      setState(() {
                        selectedSex = value;
                      });
                    },
                  ),
                  Text("ชาย"),
                  Radio<String>(
                    value: "female",
                    groupValue: selectedSex,
                    onChanged: (value) {
                      setState(() {
                        selectedSex = value;
                      });
                    },
                  ),
                  Text("หญิง"),
                ],
              ),
              const SizedBox(height: 20),

              // ฟอร์มกรอกข้อมูล
              TextField(
                controller: weightCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "น้ำหนัก (kg)"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: heightCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "ส่วนสูง (cm)"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "อายุ"),
              ),
              const SizedBox(height: 40),

              // ปุ่มบันทึก
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: Colors.pinkAccent,
                ),
                onPressed: saveData,
                child: Text(
                  "บันทึกข้อมูล",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
