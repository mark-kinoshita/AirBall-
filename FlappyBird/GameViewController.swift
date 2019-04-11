

import UIKit
import SpriteKit
import GameKit
import GoogleMobileAds

var score = 0
var streak = 0
var highscore = 0
let HighscoreDefault = UserDefaults.standard

class GameViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    //Authenticate Play with gameCenter
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.present(viewController!, animated: true, completion: nil)
            }
            else {
                print((GKLocalPlayer.localPlayer().isAuthenticated))
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Instantiate the banner view with your desired banner size.
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        addBannerViewToView(bannerView)
        bannerView.rootViewController = self
        // Set the ad unit ID to your own ad unit ID here.
        bannerView.adUnitID = "ca-app-pub-2026205430869197/7446415840"
        bannerView.load(GADRequest())
        interstitial = createAndLoadInterstitial()
        if (HighscoreDefault.value(forKey: "Highscore") != nil) {
            highscore = HighscoreDefault.integer(forKey: "Highscore")
        }
        if let scene = MainMenu(fileNamed: "MainMenu") {
            if let view = self.view as! SKView? {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
                view.ignoresSiblingOrder = true
                view.showsFPS = false
                view.showsNodeCount = false
                authenticateLocalPlayer()
            }
        }
    }
    func createAndLoadInterstitial() -> GADInterstitial {
       //let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2026205430869197/6798181606")
        let interstitial = GADInterstitial(adUnitID:"ca-app-pub-2026205430869197/6798181606")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    func addBannerViewToView(_ bannerView: UIView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            positionBannerAtBottomOfSafeArea(bannerView)
        }
        else {
            positionBannerAtBottomOfView(bannerView)
        }
    }
    @available (iOS 11, *)
    func positionBannerAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Centered horizontally.
        let guide: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate(
            [bannerView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
             bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)]
        )
    }
    func positionBannerAtBottomOfView(_ bannerView: UIView) {
        // Center the banner horizontally.
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        // Lock the banner to the top of the bottom layout guide.
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self.bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
    func presentAd() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
}


