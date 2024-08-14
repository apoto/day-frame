import 'package:day_frame/model/artwork.dart';
import 'package:day_frame/view_model/artwork_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtworkView extends ConsumerWidget {
  const ArtworkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkState = ref.watch(artworkViewModelProvider);

    return Scaffold(
      body: artworkState.when(
        data: (artwork) => _buildArtworkDisplay(context, artwork),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('エラー: $error')),
      ),
    );
  }

  Widget _buildArtworkDisplay(BuildContext context, Artwork artwork) {
    return GestureDetector(
      onTap: () => _showArtworkDetails(context, artwork),
      child: Image.network(
        artwork.imageUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  void _showArtworkDetails(BuildContext context, Artwork artwork) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ArtworkDetailsWidget(artwork: artwork),
    );
  }
}

class ArtworkDetailsWidget extends StatelessWidget {
  final Artwork artwork;

  const ArtworkDetailsWidget({Key? key, required this.artwork}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(artwork.title, style: Theme.of(context).textTheme.headline6),
          Text(artwork.artist, style: Theme.of(context).textTheme.subtitle1),
          const SizedBox(height: 8),
          Text(artwork.description),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // アーティストのSNSへ遷移する処理を実装
            },
            child: const Text('アーティストのSNSを見る'),
          ),
        ],
      ),
    );
  }
}