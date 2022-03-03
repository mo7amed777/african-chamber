import 'package:demo/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void showAdInterstitial() async {
  await InterstitialAd.load(
    adUnitId: interstitialAdUnitId,
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (loaded) {
        loaded.fullScreenContentCallback = FullScreenContentCallback(
          onAdWillDismissFullScreenContent: (ad) async => await ad.dispose(),
        );
      },
      onAdFailedToLoad: (failed) {
        print('InterstitialAd Loading Failed ${failed.message}');
      },
    ),
  );
}

void showAdRewarded() async {
  await RewardedAd.load(
    adUnitId: rewardedVideoAdUnitId,
    request: AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (loaded) {
        loaded.fullScreenContentCallback = FullScreenContentCallback(
          onAdWillDismissFullScreenContent: (ad) async => await ad.dispose(),
        );
      },
      onAdFailedToLoad: (failed) {
        print('RewardedAd Loading Failed ${failed.message}');
      },
    ),
  );
}
