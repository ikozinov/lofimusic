class SocialMedia {
  final String url;
  final String mediaSlug;

  SocialMedia({required this.url, required this.mediaSlug});

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      url: json['URL'],
      mediaSlug: json['MediaSlug'],
    );
  }
}

class RadioStation {
  final String name;
  final String id;
  final String slug;
  final String description;
  final List<SocialMedia> socialMedia;

  RadioStation({
    required this.name,
    required this.id,
    required this.slug,
    required this.description,
    required this.socialMedia,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    var socialMediaList = json['SocialMedia'] as List? ?? [];
    List<SocialMedia> socialMedia =
        socialMediaList.map((i) => SocialMedia.fromJson(i)).toList();

    return RadioStation(
      name: json['Name'],
      id: json['ID'],
      slug: json['Slug'],
      description: json['Description'] ?? '',
      socialMedia: socialMedia,
    );
  }
}
