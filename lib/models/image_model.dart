class ImageModel {
  final String url;
  final String ratio;
  final int width;
  final int height;

  ImageModel(
      {required this.url,
        required this.ratio,
        required this.width,
        required this.height});

  factory ImageModel.fromJson(Map json) {
    return ImageModel(
        url: json['url'],
        ratio: json['ratio'],
        width: json['width'],
        height: json['height']);
  }

  static List<ImageModel> retrieveTicketImages(List images) {
    List<ImageModel> imageList = [];
    images.forEach((element) {
      imageList.add(ImageModel.fromJson(element));
    });
    return imageList;
  }
}