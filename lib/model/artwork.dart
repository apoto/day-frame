class Artwork {
  final String id;
  final String title;
  final String artist;
  final String description;
  final String imageUrl;

  Artwork({
    required this.id,
    required this.title,
    required this.artist,
    required this.description,
    required this.imageUrl,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      artist: json['artist_display'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_id'] != null
          ? 'https://www.artic.edu/iiif/2/${json['image_id']}/full/500,/0/default.jpg'
          : '',
    );
  }
}