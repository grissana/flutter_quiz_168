// ignore_for_file: camel_case_types, strict_top_level_inference, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/supabase_class.dart';

class Supabase_Services {
  final SupabaseClient supabase = Supabase.instance.client;
  final String tablename = 'bmr_tb';

  Future<List<bmr_tb>> getBmr(context) async {
    try {
      final data = await supabase
          .from(tablename)
          .select("*")
          .order('created_at', ascending: false);

      final List<bmr_tb> BmrList =
          (data as List).map((e) => bmr_tb.fromMap(e)).toList();

      return BmrList;
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'พบปัญหาในการดึงข้อมูล BMR : $ex',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      throw Exception('พบปัญหาในการดึงข้อมูล : $ex');
    }
  }

  Future<bool> addBmr(bmr_tb Bmr) async {
    final BmrMap = Bmr.toMapAddBmr();
    try {
      await supabase.from(tablename).insert(BmrMap);
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }
}
