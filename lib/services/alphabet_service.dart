import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/letter_model.dart';
import '../constants/app_constants.dart';

class AlphabetService {
  static List<LetterModel>? _cache;

  static Future<List<LetterModel>> loadAlphabet() async {
    if (_cache != null) return _cache!;
    final jsonStr = await rootBundle.loadString(AppAssets.alphabetData);
    final List<dynamic> jsonList = json.decode(jsonStr);
    _cache = jsonList.map((e) => LetterModel.fromJson(e)).toList();
    return _cache!;
  }
}
