import 'package:day_frame/model/artwork.dart';
import 'package:day_frame/view_model/artwork_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtworkView extends ConsumerWidget {
  const ArtworkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkState = ref.watch(artworkViewModelProvider);

    return Scaffold(
      body: artworkState.when(
        data: (artwork) => _buildArtworkDisplay(context, artwork),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text('エラーが発生しました: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(artworkViewModelProvider.notifier)
                    .fetchDailyArtwork(),
                child: const Text('再試行'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtworkDisplay(BuildContext context, Artwork artwork) {
    return GestureDetector(
      onTap: () => _showArtworkDetails(context, artwork),
      child: CachedNetworkImage(
        imageUrl: artwork.imageUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error)),
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

  const ArtworkDetailsWidget({Key? key, required this.artwork})
      : super(key: key);

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
            onPressed: () => _launchArtworkURL(artwork.id),
            child: const Text('作品詳細を見る'),
          ),
        ],
      ),
    );
  }

  void _launchArtworkURL(String artworkId) async {
    final url = Uri.parse('https://www.artic.edu/artworks/$artworkId');
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('Could not launch $url');
    }
  }
}
