import 'package:flutter/material.dart';
import '../services/supabase_services.dart';
import '../models/supabase_class.dart';

class AddBmrPage extends StatefulWidget {
  @override
  State<AddBmrPage> createState() => _AddBmrPageState();
}

class _AddBmrPageState extends State<AddBmrPage> {
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final sexCtrl = TextEditingController();
  final bmrCtrl = TextEditingController();

  final service = Supabase_Services();

  Future<void> saveData() async {
    final double? weight = double.tryParse(weightCtrl.text);
    final double? height = double.tryParse(heightCtrl.text);
    final int? age = int.tryParse(ageCtrl.text);
    final double? bmr = double.tryParse(bmrCtrl.text);

    if (weight == null || height == null || age == null || bmr == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("กรอกข้อมูลไม่ครบหรือไม่ถูกต้อง")),
      );
      return;
    }

    final newBmr = bmr_tb(
      weight: weight,
      height: height,
      age: age,
      sex: sexCtrl.text,
      bmr: bmr,
    );

    final success = await service.addBmr(newBmr);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("บันทึกข้อมูลล้มเหลว")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("เพิ่มข้อมูล BMR")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: weightCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "น้ำหนัก (kg)"),
            ),
            TextField(
              controller: heightCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "ส่วนสูง (cm)"),
            ),
            TextField(
              controller: ageCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "อายุ"),
            ),
            TextField(
              controller: sexCtrl,
              decoration: InputDecoration(labelText: "เพศ (male/female)"),
            ),
            TextField(
              controller: bmrCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "ค่า BMR"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveData,
              child: Text("บันทึกข้อมูล"),
            ),
          ],
        ),
      ),
    );
  }
}
