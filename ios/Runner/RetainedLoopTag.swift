
//: Declare String Begin

/*: "fymetvy" :*/
fileprivate let user_scriptTitle:[Character] = ["f","y","m","e","t","v","y"]

/*: "983" :*/
fileprivate let const_handleData:String = "983"

/*: "xhwsckeqqzgg" :*/
fileprivate let main_largeMsg:String = "tabh"
fileprivate let showCorePresentTitle:[Character] = ["w","s","c","k","e","q","q","z","g","g"]

/*: "65n6g0" :*/
fileprivate let show_pushMessage:[Character] = ["6","5","n","6","g","0"]

/*: "1.9.1" :*/
fileprivate let constFatalText:String = "1.9.1"

/*: "https://m. :*/
fileprivate let const_blackData:String = "httwiths"
fileprivate let k_visibleTitle:[Character] = [":","/","/","m","."]

/*: .com" :*/
fileprivate let userEndLevelFormat:[Character] = [".","c","o","m"]

/*: "CFBundleShortVersionString" :*/
fileprivate let main_afterScopeStr:String = "CFBundnot scheme type category"
fileprivate let user_regionText:String = "rtVersiload all"
fileprivate let appPicData:String = "onStno country total"

/*: "CFBundleDisplayName" :*/
fileprivate let const_rawTicketData:[Character] = ["C","F","B","u","n"]
fileprivate let userProcessScriptFormat:[Character] = ["d","l","e","D","i","s","p","l","a","y","N","a","m","e"]

/*: "CFBundleVersion" :*/
fileprivate let const_alwaysTitle:String = "about shortCFBundle"
fileprivate let dataAllowValue:String = "Vecarrier production"
fileprivate let app_objectSystemMessage:String = "schemeion"

/*: "weixin" :*/
fileprivate let userTingName:String = "wetitlein"

/*: "wxwork" :*/
fileprivate let show_aboutMsg:String = "stopwork"

/*: "dingtalk" :*/
fileprivate let app_whiteTitle:String = "empty"
fileprivate let data_observerKey:String = "ingtalaction"

/*: "lark" :*/
fileprivate let showSubMsg:[Character] = ["l","a","r","k"]

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  RetainedLoopTag.swift
//  OverseaH5
//
//  Created by young on 2025/9/24.
//

//: import KeychainSwift
import KeychainSwift
//: import UIKit
import UIKit

/// 域名
//: let ReplaceUrlDomain = "fymetvy"
let main_timeFormat = (String(user_scriptTitle))
/// 包ID
//: let PackageID = "983"
let showFieldMsg = (const_handleData.capitalized)
/// Adjust
//: let AdjustKey = "xhwsckeqqzgg"
let showCountervalData = (main_largeMsg.replacingOccurrences(of: "tab", with: "x") + String(showCorePresentTitle))
//: let AdInstallToken = "65n6g0"
let main_environmentFormat = (String(show_pushMessage))

/// 网络版本号
//: let AppNetVersion = "1.9.1"
let mainPersistValue = (constFatalText.capitalized)
//: let H5WebDomain = "https://m.\(ReplaceUrlDomain).com"
let const_disappearData = (const_blackData.replacingOccurrences(of: "with", with: "p") + String(k_visibleTitle)) + "\(main_timeFormat)" + (String(userEndLevelFormat))
//: let AppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let k_decisionUrl = Bundle.main.infoDictionary![(String(main_afterScopeStr.prefix(6)) + "leSho" + String(user_regionText.prefix(7)) + String(appPicData.prefix(4)) + "ring")] as! String
//: let AppBundle = Bundle.main.bundleIdentifier!
let appLogMessage = Bundle.main.bundleIdentifier!
//: let AppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? ""
let constAlreadyId = Bundle.main.infoDictionary![(String(const_rawTicketData) + String(userProcessScriptFormat))] ?? ""
//: let AppBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
let showProgressMessage = Bundle.main.infoDictionary![(String(const_alwaysTitle.suffix(8)) + String(dataAllowValue.prefix(2)) + app_objectSystemMessage.replacingOccurrences(of: "scheme", with: "rs"))] as! String

//: class AppConfig: NSObject {
class RetainedLoopTag: NSObject {
    /// 获取状态栏高度
    //: class func getStatusBarHeight() -> CGFloat {
    class func launch() -> CGFloat {
        //: if #available(iOS 13.0, *) {
        if #available(iOS 13.0, *) {
            //: if let statusBarManager = UIApplication.shared.windows.first?
            if let statusBarManager = UIApplication.shared.windows.first?
                //: .windowScene?.statusBarManager
                .windowScene?.statusBarManager
            {
                //: return statusBarManager.statusBarFrame.size.height
                return statusBarManager.statusBarFrame.size.height
            }
            //: } else {
        } else {
            //: return UIApplication.shared.statusBarFrame.size.height
            return UIApplication.shared.statusBarFrame.size.height
        }
        //: return 20.0
        return 20.0
    }

    /// 获取window
    //: class func getWindow() -> UIWindow {
    class func pending() -> UIWindow {
        //: var window = UIApplication.shared.windows.first(where: {
        var window = UIApplication.shared.windows.first(where: {
            //: $0.isKeyWindow
            $0.isKeyWindow
            //: })
        })
        // 是否为当前显示的window
        //: if window?.windowLevel != UIWindow.Level.normal {
        if window?.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: return window!
        return window!
    }

    /// 获取当前控制器
    //: class func currentViewController() -> (UIViewController?) {
    class func modern() -> (UIViewController?) {
        //: var window = AppConfig.getWindow()
        var window = RetainedLoopTag.pending()
        //: if window.windowLevel != UIWindow.Level.normal {
        if window.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: let vc = window.rootViewController
        let vc = window.rootViewController
        //: return currentViewController(vc)
        return push(vc)
    }

    //: class func currentViewController(_ vc: UIViewController?)
    class func push(_ vc: UIViewController?)
        //: -> UIViewController?
        -> UIViewController?
    {
        //: if vc == nil {
        if vc == nil {
            //: return nil
            return nil
        }
        //: if let presentVC = vc?.presentedViewController {
        if let presentVC = vc?.presentedViewController {
            //: return currentViewController(presentVC)
            return push(presentVC)
            //: } else if let tabVC = vc as? UITabBarController {
        } else if let tabVC = vc as? UITabBarController {
            //: if let selectVC = tabVC.selectedViewController {
            if let selectVC = tabVC.selectedViewController {
                //: return currentViewController(selectVC)
                return push(selectVC)
            }
            //: return nil
            return nil
            //: } else if let naiVC = vc as? UINavigationController {
        } else if let naiVC = vc as? UINavigationController {
            //: return currentViewController(naiVC.visibleViewController)
            return push(naiVC.visibleViewController)
            //: } else {
        } else {
            //: return vc
            return vc
        }
    }
}

// MARK: - Device

//: extension UIDevice {
extension UIDevice {
    //: static var modelName: String {
    static var modelName: String {
        //: var systemInfo = utsname()
        var systemInfo = utsname()
        //: uname(&systemInfo)
        uname(&systemInfo)
        //: let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        //: let identifier = machineMirror.children.reduce("") {
        let identifier = machineMirror.children.reduce("") {
            //: identifier, element in
            identifier, element in
            //: guard let value = element.value as? Int8, value != 0 else {
            guard let value = element.value as? Int8, value != 0 else {
                //: return identifier
                return identifier
            }
            //: return identifier + String(UnicodeScalar(UInt8(value)))
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        //: return identifier
        return identifier
    }

    /// 获取当前系统时区
    //: static var timeZone: String {
    static var timeZone: String {
        //: let currentTimeZone = NSTimeZone.system
        let currentTimeZone = NSTimeZone.system
        //: return currentTimeZone.identifier
        return currentTimeZone.identifier
    }

    /// 获取当前系统语言
    //: static var langCode: String {
    static var langCode: String {
        //: let language = Locale.preferredLanguages.first
        let language = Locale.preferredLanguages.first
        //: return language ?? ""
        return language ?? ""
    }

    /// 获取接口语言
    //: static var interfaceLang: String {
    static var interfaceLang: String {
        //: let lang = UIDevice.getSystemLangCode()
        let lang = UIDevice.latterDay()
        //: if ["en", "ar", "es", "pt"].contains(lang) {
        if ["en", "ar", "es", "pt"].contains(lang) {
            //: return lang
            return lang
        }
        //: return "en"
        return "en"
    }

    /// 获取当前系统地区
    //: static var countryCode: String {
    static var countryCode: String {
        //: let locale = Locale.current
        let locale = Locale.current
        //: let countryCode = locale.regionCode
        let countryCode = locale.regionCode
        //: return countryCode ?? ""
        return countryCode ?? ""
    }

    /// 获取系统UUID（每次调用都会产生新值，所以需要keychain）
    //: static var systemUUID: String {
    static var systemUUID: String {
        //: let key = KeychainSwift()
        let key = KeychainSwift()
        //: if let value = key.get(AdjustKey) {
        if let value = key.get(showCountervalData) {
            //: return value
            return value
            //: } else {
        } else {
            //: let value = NSUUID().uuidString
            let value = NSUUID().uuidString
            //: key.set(value, forKey: AdjustKey)
            key.set(value, forKey: showCountervalData)
            //: return value
            return value
        }
    }

    /// 获取已安装应用信息
    //: static var getInstalledApps: String {
    static var getInstalledApps: String {
        //: var appsArr: [String] = []
        var appsArr: [String] = []
        //: if UIDevice.canOpenApp("weixin") {
        if UIDevice.photoApp((userTingName.replacingOccurrences(of: "title", with: "ix"))) {
            //: appsArr.append("weixin")
            appsArr.append((userTingName.replacingOccurrences(of: "title", with: "ix")))
        }
        //: if UIDevice.canOpenApp("wxwork") {
        if UIDevice.photoApp((show_aboutMsg.replacingOccurrences(of: "stop", with: "wx"))) {
            //: appsArr.append("wxwork")
            appsArr.append((show_aboutMsg.replacingOccurrences(of: "stop", with: "wx")))
        }
        //: if UIDevice.canOpenApp("dingtalk") {
        if UIDevice.photoApp((app_whiteTitle.replacingOccurrences(of: "empty", with: "d") + data_observerKey.replacingOccurrences(of: "action", with: "k"))) {
            //: appsArr.append("dingtalk")
            appsArr.append((app_whiteTitle.replacingOccurrences(of: "empty", with: "d") + data_observerKey.replacingOccurrences(of: "action", with: "k")))
        }
        //: if UIDevice.canOpenApp("lark") {
        if UIDevice.photoApp((String(showSubMsg))) {
            //: appsArr.append("lark")
            appsArr.append((String(showSubMsg)))
        }
        //: if appsArr.count > 0 {
        if appsArr.count > 0 {
            //: return appsArr.joined(separator: ",")
            return appsArr.joined(separator: ",")
        }
        //: return ""
        return ""
    }

    /// 判断是否安装app
    //: static func canOpenApp(_ scheme: String) -> Bool {
    static func photoApp(_ scheme: String) -> Bool {
        //: let url = URL(string: "\(scheme)://")!
        let url = URL(string: "\(scheme)://")!
        //: if UIApplication.shared.canOpenURL(url) {
        if UIApplication.shared.canOpenURL(url) {
            //: return true
            return true
        }
        //: return false
        return false
    }

    /// 获取系统语言
    /// - Returns: 国际通用语言Code
    //: @objc public class func getSystemLangCode() -> String {
    @objc public class func latterDay() -> String {
        //: let language = NSLocale.preferredLanguages.first
        let language = NSLocale.preferredLanguages.first
        //: let array = language?.components(separatedBy: "-")
        let array = language?.components(separatedBy: "-")
        //: return array?.first ?? "en"
        return array?.first ?? "en"
    }
}
