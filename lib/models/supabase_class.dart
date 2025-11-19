class bmr_tb {
  final String? id;
  final DateTime? created_at;
  final double? weight;
  final double? height;
  final int? age;
  final String? sex;
  final double? bmr;

  bmr_tb({
    this.id,
    this.created_at,
    this.weight,
    this.height,
    this.age,
    this.sex,
    this.bmr,
  });

  factory bmr_tb.fromMap(Map<String, dynamic> map) {
    final num? weightValue = map['weight'] as num?;
    final num? heightValue = map['height'] as num?;
    final num? bmrValue = map['bmr'] as num?;

    return bmr_tb(
      id: map['id'] as String?,
      created_at:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      sex: map['sex'] as String?,
      age: map['age'] as int?,
      weight: weightValue?.toDouble(),
      height: heightValue?.toDouble(),
      bmr: bmrValue?.toDouble(),
    );
  }

  Map<String, dynamic> toMapAddBmr() {
    return {
      'weight': weight,
      'height': height,
      'age': age,
      'sex': sex,
      'bmr': bmr,
    };
  }
}
