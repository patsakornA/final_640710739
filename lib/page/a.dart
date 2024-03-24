class WebsiteData {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath; // เพิ่มตัวแปร imagePath เพื่อเก็บ path ของภาพ

  WebsiteData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  factory WebsiteData.fromJson(Map<String, dynamic> json) {
    return WebsiteData(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      imagePath: 'https://cpsu-api-49b593d4e146.herokuapp.com${json['image']}',
    );
  }
}
