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
  final String owner;
  final List<String> cards;
  final List<SocialMedia> socialMedia;

  RadioStation({
    required this.name,
    required this.id,
    required this.slug,
    required this.description,
    required this.owner,
    required this.cards,
    required this.socialMedia,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    var socialMediaList = json['SocialMedia'] as List? ?? [];
    List<SocialMedia> socialMedia =
        socialMediaList.map((i) => SocialMedia.fromJson(i)).toList();

    var cardsList = json['Cards'] as List? ?? [];
    List<String> cards = cardsList.map((i) => i.toString()).toList();

    return RadioStation(
      name: json['Name'],
      id: json['ID'],
      slug: json['Slug'],
      description: json['Description'] ?? '',
      owner: json['Owner'] ?? '',
      cards: cards,
      socialMedia: socialMedia,
    );
  }
}
