import 'package:day_frame/model/artwork.dart';
import 'package:day_frame/view_model/artwork_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:day_frame/l10n/app_locale.dart';
import 'package:day_frame/view/settings_view.dart';

class ArtworkView extends ConsumerWidget {
  const ArtworkView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkState = ref.watch(artworkViewModelProvider);

    return Scaffold(
      body: artworkState.when(
        data: (artwork) => _buildArtworkDisplay(context, artwork),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildErrorDisplay(context, ref, error),
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

  Widget _buildErrorDisplay(BuildContext context, WidgetRef ref, Object error) {
    return Center(
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
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsView()),
    );
  }

  void _showArtworkDetails(BuildContext context, Artwork artwork) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Stack(
        children: [
          ArtworkDetailsWidget(artwork: artwork),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _navigateToSettings(context),
            ),
          ),
        ],
      ),
    );
  }
}

class ArtworkDetailsWidget extends StatelessWidget {
  final Artwork artwork;

  const ArtworkDetailsWidget({super.key, required this.artwork});

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
            child: Text(AppLocale.viewArtworkDetails.getString(context)),
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