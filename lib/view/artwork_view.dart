import 'package:day_frame/model/artwork.dart';
import 'package:day_frame/view_model/artwork_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:day_frame/l10n/app_locale.dart';
import 'package:day_frame/view/settings_view.dart';

import 'dart:ui';

final isDetailsVisibleProvider = StateNotifierProvider<DetailsVisibilityNotifier, bool>((ref) => DetailsVisibilityNotifier());

class DetailsVisibilityNotifier extends StateNotifier<bool> {
  DetailsVisibilityNotifier() : super(false);

  void toggle() => state = !state;
}

class ArtworkView extends ConsumerWidget {
  const ArtworkView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkState = ref.watch(artworkViewModelProvider);
    final isDetailsVisible = ref.watch(isDetailsVisibleProvider);

    return Scaffold(
      body: Stack(
        children: [
          artworkState.when(
            data: (artwork) => _buildArtworkDisplay(context, ref, artwork),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _buildErrorDisplay(context, ref, error),
          ),
          if (isDetailsVisible)
            _buildOverlay(context, artworkState, ref),
        ],
      ),
    );
  }

  Widget _buildArtworkDisplay(BuildContext context, WidgetRef ref, Artwork artwork) {
    return GestureDetector(
      onTap: () => ref.read(isDetailsVisibleProvider.notifier).toggle(),
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

  Widget _buildOverlay(BuildContext context, AsyncValue<Artwork> artworkState, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(isDetailsVisibleProvider.notifier).toggle(),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: artworkState.when(
                  data: (artwork) => ArtworkDetailsWidget(artwork: artwork),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () => _navigateToSettings(context),
                ),
              ),
            ],
          ),
        ),
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
}

class ArtworkDetailsWidget extends StatelessWidget {
  final Artwork artwork;

  const ArtworkDetailsWidget({super.key, required this.artwork});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(artwork.title, style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white)),
          Text(artwork.artist, style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(artwork.description, style: TextStyle(color: Colors.white70)),
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