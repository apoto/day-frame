import 'package:day_frame/model/artwork.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:day_frame/data/artwork_ids.dart';

final artworkServiceProvider = Provider((ref) => ArtworkService(Dio()));

class ArtworkService {
  final Dio _dio;

  ArtworkService(this._dio);

  Future<Artwork> getDailyArtwork() async {
    try {
      final response = await _dio.get('https://api.artic.edu/api/v1/artworks/${await _getRandomArtworkId()}');
      print('API Response: ${response.data}'); // レスポンスの内容を確認
      if (response.data['data'] != null) {
        return Artwork.fromJson(response.data['data']);
      } else {
        throw Exception('アートワークデータが見つかりません');
      }
    } catch (e) {
      print('Error fetching artwork: $e');
      rethrow;
    }
  }

  Future<int> _getRandomArtworkId() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final lastFetchDate = prefs.getString('lastFetchDate');
    final today = DateTime(now.year, now.month, now.day).toString();

    if (lastFetchDate != today) {
      final random = Random();
      final randomId = artworkIds[random.nextInt(artworkIds.length)];
      await prefs.setString('lastFetchDate', today);
      await prefs.setInt('dailyArtworkId', randomId);
      return randomId;
    } else {
      return prefs.getInt('dailyArtworkId') ?? artworkIds.first;
    }
  }
}