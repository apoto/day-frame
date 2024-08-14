import 'package:day_frame/model/artwork.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final artworkServiceProvider = Provider((ref) => ArtworkService(Dio()));

class ArtworkService {
  final Dio _dio;

  ArtworkService(this._dio);

  Future<Artwork> getDailyArtwork() async {
    try {
      final response = await _dio.get('https://api.artic.edu/api/v1/artworks/${_getRandomArtworkId()}');
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

  int _getRandomArtworkId() {
    // ランダムなアートワークIDを生成する処理を実装
    // 例えば、APIから取得できるアートワークのIDの範囲を取得し、ランダムに選択することができます
    return 4; // 例として固定値を返しています
  }
}