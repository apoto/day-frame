import 'package:day_frame/model/artwork.dart';
import 'package:day_frame/service/artwork_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final artworkViewModelProvider =
    StateNotifierProvider<ArtworkViewModel, AsyncValue<Artwork>>((ref) {
  return ArtworkViewModel(ref.read(artworkServiceProvider));
});

class ArtworkViewModel extends StateNotifier<AsyncValue<Artwork>> {
  final ArtworkService _artworkService;

  ArtworkViewModel(this._artworkService) : super(const AsyncValue.loading()) {
    fetchDailyArtwork();
  }

  Future<void> fetchDailyArtwork() async {
    state = const AsyncValue.loading();
    try {
      final artwork = await _artworkService.getDailyArtwork();
      state = AsyncValue.data(artwork);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
