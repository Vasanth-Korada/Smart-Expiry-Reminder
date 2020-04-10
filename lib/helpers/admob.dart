import 'package:firebase_admob/firebase_admob.dart';
MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>[
    'education',
    'career',
    'coding',
    'programming',
    'games',
    'sports',
    'technology',
    'tech',
    'interview',
    'entertainment'
  ],
  contentUrl: 'https://flutter.io',
  childDirected: false,
  testDevices: <String>[],
);

BannerAd myBanner = BannerAd(
  adUnitId: "ca-app-pub-8559543128044506/7874859398",
  size: AdSize.banner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);