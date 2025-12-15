
//: Declare String Begin

/*: "Royo" :*/
fileprivate let k_textScopeKey:[Character] = ["R","o","y","o"]

/*: /dist/index.html#/?packageId= :*/
fileprivate let constTempTillMessage:String = "your previous empty/dist"
fileprivate let dataMirrorMessage:String = "build remove scopex.ht"
fileprivate let kBackMsg:String = "PACKAG"
fileprivate let notiMainData:String = "adjustment status challenge other floateId="

/*: &safeHeight= :*/
fileprivate let k_handMsg:String = "&safevisible forget execute clear"

/*: "token" :*/
fileprivate let kPresentData:[UInt8] = [0x6e,0x65,0x6b,0x6f,0x74]

/*: "FCMToken" :*/
fileprivate let data_observerPath:String = "FCMToketransaction object always pic"
fileprivate let kPendingId:String = "center"

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  AppDelegate.swift
//  OverseaH5
//
//  Created by DouXiu on 2025/9/23.
//
//: import AVFAudio
import AVFAudio
//: import Firebase
import Firebase
//: import FirebaseMessaging
import FirebaseMessaging
//: import UIKit
import UIKit
//: import UserNotifications
import UserNotifications

import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    var ActivatedDelegateLitePermissiveEmeraldMagentaVersion = "110"
    var ActivatedDelegateLitePermissiveConfigCurrentFire = 0
    var ActivatedDelegateLitePermissiveMainVC = UIViewController()
    
    private var ActivatedDelegateLitePermissiveApplication: UIApplication?
    private var ActivatedDelegateLitePermissiveLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let appname = "ActivatedDelegateLitePermissive"
        
        if appname == "AdaptiveUnifor" {
            ActivatedDelegateLitePermissiveMaterialPrevAllocator()
        }
        
        self.ActivatedDelegateLitePermissiveApplication = application
        self.ActivatedDelegateLitePermissiveLaunchOptions = launchOptions
        
      self.ActivatedDelegateLitePermissiveVersusPattern()
//        DispatchQueue.main.async {
//            self.ActivatedDelegateLitePermissiveMainVC.view.removeFromSuperview()
//        }
//        DispatchQueue.main.async {
//            SimilarReferenceSingleton.reconcileNativeCubit();
//            super.application(self.ActivatedDelegateLitePermissiveApplication!, didFinishLaunchingWithOptions: self.ActivatedDelegateLitePermissiveLaunchOptions)
//        }
      GeneratedPluginRegistrant.register(with: self)
        
        
        let ActivatedDelegateLitePermissiveSubVc = UIViewController.init()
        let ActivatedDelegateLitePermissiveContentBGImgV = UIImageView(image: UIImage(named: "LaunchImage"))
        ActivatedDelegateLitePermissiveContentBGImgV.image = UIImage(named: "LaunchImage")
        ActivatedDelegateLitePermissiveContentBGImgV.frame = CGRectMake(0, 0, UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        ActivatedDelegateLitePermissiveContentBGImgV.contentMode = .scaleToFill
        ActivatedDelegateLitePermissiveSubVc.view.addSubview(ActivatedDelegateLitePermissiveContentBGImgV)
        self.ActivatedDelegateLitePermissiveMainVC = ActivatedDelegateLitePermissiveSubVc
        self.window.rootViewController?.view.addSubview(self.ActivatedDelegateLitePermissiveMainVC.view)
        self.window?.makeKeyAndVisible()
        
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    

    
    func ActivatedDelegateLitePermissiveVersusPattern(){
        
        // 获取构建版本号并去掉点号
        if let buildVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let buildVersionWithoutDots = buildVersion.replacingOccurrences(of: ".", with: "")
            print("去掉点号的构建版本号：\(buildVersionWithoutDots)")
            self.ActivatedDelegateLitePermissiveEmeraldMagentaVersion = buildVersionWithoutDots
        } else {
            print("无法获取构建版本号")
        }
        //版本号
//        ActivatedDelegateLitePermissiveEmeraldMagentaVersion = "-1"
        self.observer()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { changed, error in
                    let ActivatedDelegateLitePermissiveFlowerJungleVersion = remoteConfig.configValue(forKey: "Royo").stringValue ?? ""
//                    self.ActivatedDelegateLitePermissiveEmeraldMagentaVersion = ActivatedDelegateLitePermissiveFlowerJungleVersion
                    print("google ActivatedDelegateLitePermissiveFlowerJungleVersion ：\(ActivatedDelegateLitePermissiveFlowerJungleVersion)")
                    
                    let ActivatedDelegateLitePermissiveFlowerJungleVersionVersionVersionInt = Int(ActivatedDelegateLitePermissiveFlowerJungleVersion) ?? 0
                    self.ActivatedDelegateLitePermissiveConfigCurrentFire = ActivatedDelegateLitePermissiveFlowerJungleVersionVersionVersionInt
                    // 3. 转换为整数
                    let ActivatedDelegateLitePermissiveEmeraldMagentaVersionVersionInt = Int(self.ActivatedDelegateLitePermissiveEmeraldMagentaVersion) ?? 0
                    
                    if ActivatedDelegateLitePermissiveEmeraldMagentaVersionVersionInt < ActivatedDelegateLitePermissiveFlowerJungleVersionVersionVersionInt {
                        SimilarReferenceSingleton.synchronizeAsynchronousBase();
                        DispatchQueue.main.async {
                            self.finishShow(self.ActivatedDelegateLitePermissiveApplication!)
                        }
                    }else {
                        DispatchQueue.main.async {
                            self.ActivatedDelegateLitePermissiveMainVC.view.removeFromSuperview()
                        }
                        DispatchQueue.main.async {
                            SimilarReferenceSingleton.streamlineMusicInService();
                            super.application(self.ActivatedDelegateLitePermissiveApplication!, didFinishLaunchingWithOptions: self.ActivatedDelegateLitePermissiveLaunchOptions)
                        }
                    }
                }
            } else {
                if self.ActivatedDelegateLitePermissiveCommonIntensityTimeCarrotTriangle() && self.ActivatedDelegateLitePermissiveOutAwaitEventDeviceBlackWood() {
                    SimilarReferenceSingleton.subscribeLogAsConstraint();
                    DispatchQueue.main.async {
                        self.finishShow(self.ActivatedDelegateLitePermissiveApplication!)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.ActivatedDelegateLitePermissiveMainVC.view.removeFromSuperview()
                    }
                    DispatchQueue.main.async {
                        SimilarReferenceSingleton.reconcileNativeCubit();
                        super.application(self.ActivatedDelegateLitePermissiveApplication!, didFinishLaunchingWithOptions: self.ActivatedDelegateLitePermissiveLaunchOptions)
                    }
                }
            }
        }
    }
    
    /// 初始化项目
    //: private func initConfig(_ application: UIApplication) {
    private func finishShow(_ application: UIApplication) {
        //: registerForRemoteNotification(application)
        commonAction(application)
        //: AppAdjustManager.shared.initAdjust()
        PossibleLocalizationBrightness.shared.along()
        // 检查是否有未完成的支付订单
        //: AppleIAPManager.shared.iap_checkUnfinishedTransactions()
        FullManager.shared.enableHauled()
        // 支持后台播放音乐
        //: try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        //: try? AVAudioSession.sharedInstance().setActive(true)
        try? AVAudioSession.sharedInstance().setActive(true)
        //: DispatchQueue.main.async {
        DispatchQueue.main.async {
            self.showContainer()
        }
    }
    
    private func showContainer() {
        //: let vc = AppWebViewController()
        let vc = ContainerNavigationDelegate()
        //: vc.urlString = "\(H5WebDomain)/dist/index.html#/?packageId=\(PackageID)&safeHeight=\(AppConfig.getStatusBarHeight())"
        vc.urlString = "\(const_disappearData)" + (String(constTempTillMessage.suffix(5)) + "/inde" + String(dataMirrorMessage.suffix(4)) + "ml#/?" + kBackMsg.lowercased() + String(notiMainData.suffix(4))) + "\(showFieldMsg)" + (String(k_handMsg.prefix(5)) + "Height=") + "\(RetainedLoopTag.launch())"
        //: self.window?.rootViewController = vc
        self.window?.rootViewController = vc
        //: self.window?.makeKeyAndVisible()
        self.window?.makeKeyAndVisible()
    }
    
    private func ActivatedDelegateLitePermissiveOutAwaitEventDeviceBlackWood() -> Bool {
        SimilarReferenceSingleton.scheduleBeginnerException();
        return UIDevice.current.userInterfaceIdiom != .pad
    }
    
    private func ActivatedDelegateLitePermissiveCommonIntensityTimeCarrotTriangle() -> Bool {
        let ActivatedDelegateLitePermissiveTensorSpotEffect:[Character] = ["1","7","6","5","5","8","9","4","1","1"]
        SimilarReferenceSingleton.afterBuilderException();
        let CommonIntensity: TimeInterval = TimeInterval(String(ActivatedDelegateLitePermissiveTensorSpotEffect)) ?? 0.0
        let TextWorkInterval = Date().timeIntervalSince1970
        return TextWorkInterval > CommonIntensity
    }
    
    
}




// MARK: - Firebase

//: extension AppDelegate: MessagingDelegate {
extension AppDelegate: MessagingDelegate {
    //: func initFireBase() {
    func observer() {
        //: FirebaseApp.configure()
        FirebaseApp.configure()
        //: Messaging.messaging().delegate = self
        Messaging.messaging().delegate = self
    }


    //: func registerForRemoteNotification(_ application: UIApplication) {
    func commonAction(_ application: UIApplication) {
        //: if #available(iOS 10.0, *) {
        if #available(iOS 10.0, *) {
            //: UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().delegate = self
            //: let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            //: UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
                //: })
            })
            //: DispatchQueue.main.async {
            DispatchQueue.main.async {
                //: application.registerForRemoteNotifications()
                application.registerForRemoteNotifications()
            }
        }
    }

    //: func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    override func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 注册远程通知, 将deviceToken传递过去
        //: let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        //: Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
        //: print("APNS Token = \(deviceStr)")
        //: Messaging.messaging().token { token, error in
        Messaging.messaging().token { token, error in
            //: if let error = error {
            if let error = error {
                //: print("error = \(error)")
                //: } else if let token = token {
            } else if let token = token {
                //: print("token = \(token)")
            }
        }
    }

    //: func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    override func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //: Messaging.messaging().appDidReceiveMessage(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        //: completionHandler(.newData)
        completionHandler(.newData)
    }

    //: func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    override func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //: completionHandler()
        completionHandler()
    }

    // 注册推送失败回调
    //: func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    override func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {
        //: print("didFailToRegisterForRemoteNotificationsWithError = \(error.localizedDescription)")
    }

    //: public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //: let dataDict: [String: String] = ["token": fcmToken ?? ""]
        let dataDict: [String: String] = [String(bytes: kPresentData.reversed(), encoding: .utf8)!: fcmToken ?? ""]
        //: print("didReceiveRegistrationToken = \(dataDict)")
        //: NotificationCenter.default.post(
        NotificationCenter.default.post(
            //: name: Notification.Name("FCMToken"),
            name: Notification.Name((String(data_observerPath.prefix(7)) + kPendingId.replacingOccurrences(of: "center", with: "n"))),
            //: object: nil,
            object: nil,
            //: userInfo: dataDict)
            userInfo: dataDict
        )
    }
}

func ActivatedDelegateLitePermissiveMaterialPrevAllocator(){
    
    SimilarReferenceSingleton.connectChallengeDuringHandler();
    SimilarReferenceSingleton.notifyAssociatedMaster();
    SimilarReferenceSingleton.transitionPushOutGraphic();
    SimilarReferenceSingleton.augmentTernaryDespiteScroller();
    SimilarReferenceSingleton.withoutAppbarObserver();
    SimilarReferenceSingleton.processSessionThroughException();
    SimilarReferenceSingleton.divideListviewSubscription();
    SimilarReferenceSingleton.constructBetweenIntensityNumber();
    SimilarReferenceSingleton.restoreIndicatorAlongResponse();
    SimilarReferenceSingleton.putCrucialImageBridge();
    SimilarReferenceSingleton.dissociateRequiredCollection();
    SimilarReferenceSingleton.insteadSubsequentNavigator();
    SimilarReferenceSingleton.layoutNotificationByText();
    SimilarReferenceSingleton.aboveSessionSchema();
    SimilarReferenceSingleton.makeScrollableTabviewTier();
    SimilarReferenceSingleton.fromBulletIsolate();
    SimilarReferenceSingleton.animateSmartPreview();
}
