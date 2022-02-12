import 'package:demo/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class Ad {
  @required
  void load() {}
  @required
  void dispose() {}
}

class AdInterstitial implements Ad {
  InterstitialAd? interstitialAd;

  @override
  dispose() async {
    await interstitialAd?.dispose();
  }

  @override
  load() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (loaded) {
          interstitialAd = loaded;
        },
        onAdFailedToLoad: (failed) {
          print('InterstitialAd Loading Failed ${failed.message}');
        },
      ),
    );
  }
}

class AdRewarded implements Ad {
  RewardedAd? rewardedAd;
  @override
  dispose() async {
    await rewardedAd?.dispose();
  }

  @override
  load() async {
    await RewardedAd.load(
      adUnitId: rewardedVideoAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (loaded) {
          rewardedAd = loaded;
        },
        onAdFailedToLoad: (failed) {
          print('RewardedAd Loading Failed ${failed.message}');
        },
      ),
    );
  }
}

void showAdInterstitial() {
  AdInterstitial adInterstitial = AdInterstitial();
  adInterstitial.load();
  adInterstitial.interstitialAd?.fullScreenContentCallback =
      FullScreenContentCallback(
    onAdWillDismissFullScreenContent: (ad) => ad.dispose(),
  );
}

void showAdRewarded() {
  AdRewarded adRewarded = AdRewarded();
  adRewarded.load();
  adRewarded.rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
    onAdWillDismissFullScreenContent: (ad) => ad.dispose(),
  );
}
