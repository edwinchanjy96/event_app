class ExternalLinksModel {
  final TwitterModel? twitter;
  final FacebookModel? facebook;
  final WikiModel? wiki;
  final InstagramModel? instagram;
  final HomePageModel? homePage;

  ExternalLinksModel({this.twitter, this.facebook, this.wiki, this.instagram, this.homePage});

  factory ExternalLinksModel.fromJson (Map json){
    return ExternalLinksModel(
      twitter: json['twitter'] == null ? null : TwitterModel.fromJson(json['twitter'].first),
      facebook: json['facebook'] == null ? null : FacebookModel.fromJson(json['facebook'].first),
      wiki: json['wiki'] == null ? null : WikiModel.fromJson(json['wiki'].first),
      instagram: json['instagram'] == null ? null : InstagramModel.fromJson(json['instagram'].first),
      homePage: json['homePage'] == null ? null : HomePageModel.fromJson(json['homepage'].first)
    );
  }
}

class TwitterModel {
  final String? url;

  TwitterModel({this.url});

  factory TwitterModel.fromJson (Map json){
    return TwitterModel(
        url: json['url']
    );
  }
}

class FacebookModel {
  final String? url;

  FacebookModel({this.url});

  factory FacebookModel.fromJson (Map json){
    return FacebookModel(
        url: json['url']
    );
  }
}

class WikiModel {
  final String? url;

  WikiModel({this.url});

  factory WikiModel.fromJson (Map json){
    return WikiModel(
        url: json['url']
    );
  }
}

class InstagramModel {
  final String? url;

  InstagramModel({this.url});

  factory InstagramModel.fromJson (Map json){
    return InstagramModel(
        url: json['url']
    );
  }
}

class HomePageModel {
  final String? url;

  HomePageModel({this.url});

  factory HomePageModel.fromJson (Map json){
    return HomePageModel(
        url: json['url']
    );
  }
}

