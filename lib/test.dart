import 'package:flutter/material.dart';
import '../services/supabase_services.dart';
import '../models/supabase_class.dart';

class TestBmrPage extends StatefulWidget {
  @override
  State<TestBmrPage> createState() => _TestBmrPageState();
}

class _TestBmrPageState extends State<TestBmrPage> {
  final service = Supabase_Services();

  List<bmr_tb> bmrList = [];
  bool isLoading = false;

  Future<void> loadData() async {
    setState(() => isLoading = true);

    try {
      final data = await service.getBmr(context);
      setState(() => bmrList = data);
    } catch (e) {
      print("Error: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    loadData(); // โหลดตอนเปิดหน้า
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ทดสอบดึงข้อมูล BMR")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bmrList.length,
              itemBuilder: (context, index) {
                final item = bmrList[index];
                return ListTile(
                  title: Text("เพศ: ${item.sex} | อายุ: ${item.age}"),
                  subtitle: Text(
                      "น้ำหนัก: ${item.weight}, ส่วนสูง: ${item.height}\nBMR: ${item.bmr}"),
                  trailing: Text(
                      item.created_at?.toLocal().toString().split(".")[0] ??
                          ""),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
