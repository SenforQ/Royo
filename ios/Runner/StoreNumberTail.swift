
//: Declare String Begin

/*: "Net Error, Try again later" :*/
fileprivate let showSearchedId:String = "Net Erinfo auto dismiss"
fileprivate let mainGlobalTitle:String = " Try aghand safe kit receive tool"
fileprivate let k_fatalMsg:[Character] = ["a","i","n"," ","l","a","t","e","r"]

/*: "data" :*/
fileprivate let mainEventUrl:String = "throughta"

/*: ":null" :*/
fileprivate let noti_displayMsg:String = ":nullarea disappear search file remote"

/*: "json error" :*/
fileprivate let main_fromReducePath:String = "json errprint local corner"
fileprivate let user_receiveText:String = "OR"

/*: "platform=iphone&version= :*/
fileprivate let noti_feedbackPath:String = "plaok"
fileprivate let main_progressMsg:String = "iphdisplaye"
fileprivate let constResultDeleteActiveValue:[Character] = ["o","n","="]

/*: &packageId= :*/
fileprivate let showHeadValue:String = "&packthat contact product screen"
fileprivate let show_pointUrl:[Character] = ["a","g","e","I","d","="]

/*: &bundleId= :*/
fileprivate let showSubUrl:[Character] = ["&","b","u"]
fileprivate let mainProductZoneMsg:[Character] = ["n","d","l","e","I","d","="]

/*: &lang= :*/
fileprivate let app_addClearFormat:String = "foundation origin center&lang="

/*: ; build: :*/
fileprivate let main_coreMsg:String = "method guard; buil"
fileprivate let user_environmentKey:String = "d:always process"

/*: ; iOS  :*/
fileprivate let data_clickName:String = "persist open tag product previous; iOS "

//: Declare String End

//: import Alamofire
import Alamofire
//: import CoreMedia
import CoreMedia
//: import HandyJSON
import HandyJSON
// __DEBUG__
// __CLOSE_PRINT__
//: import UIKit
import UIKit

//: typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: AppErrorResponse?) -> Void
typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: ServiceConvertErrorResponse?) -> Void

//: @objc class AppRequestTool: NSObject {
@objc class StoreNumberTail: NSObject {
    /// 发起Post请求
    /// - Parameters:
    ///   - model: 请求参数
    ///   - completion: 回调
    //: class func startPostRequest(model: AppRequestModel, completion: @escaping FinishBlock) {
    class func setAbout(model: StuffRequestModel, completion: @escaping FinishBlock) {
        //: let serverUrl = self.buildServerUrl(model: model)
        let serverUrl = self.media(model: model)
        //: let headers = self.getRequestHeader(model: model)
        let headers = self.fieldOf(model: model)
        //: AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
        AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
            //: switch responseData.result {
            switch responseData.result {
            //: case .success:
            case .success:
                //: func__requestSucess(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)
                evaluationCompletion(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)

            //: case .failure:
            case .failure:
                //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "Net Error, Try again later"))
                completion(false, nil, ServiceConvertErrorResponse(errorCode: ThatTitleConvertible.NetError.rawValue, errorMsg: (String(showSearchedId.prefix(6)) + "ror," + String(mainGlobalTitle.prefix(7)) + String(k_fatalMsg))))
            }
        }
    }

    //: class func func__requestSucess(model: AppRequestModel, response: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
    class func evaluationCompletion(model _: StuffRequestModel, response _: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
        //: var responseJson = String(data: responseData, encoding: .utf8)
        var responseJson = String(data: responseData, encoding: .utf8)
        //: responseJson = responseJson?.replacingOccurrences(of: "\"data\":null", with: "\"data\":{}")
        responseJson = responseJson?.replacingOccurrences(of: "\"" + (mainEventUrl.replacingOccurrences(of: "through", with: "da")) + "\"" + (String(noti_displayMsg.prefix(5))), with: "" + "\"" + (mainEventUrl.replacingOccurrences(of: "through", with: "da")) + "\"" + ":{}")
        //: if let responseModel = JSONDeserializer<AppBaseResponse>.deserializeFrom(json: responseJson) {
        if let responseModel = JSONDeserializer<MonitorRandomTransformable>.deserializeFrom(json: responseJson) {
            //: if responseModel.errno == RequestResultCode.Normal.rawValue {
            if responseModel.errno == ThatTitleConvertible.Normal.rawValue {
                //: completion(true, responseModel.data, nil)
                completion(true, responseModel.data, nil)
                //: } else {
            } else {
                //: completion(false, responseModel.data, AppErrorResponse.init(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                completion(false, responseModel.data, ServiceConvertErrorResponse(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                //: switch responseModel.errno {
                switch responseModel.errno {
//                case ThatTitleConvertible.NeedReLogin.rawValue:
//                    NotificationCenter.default.post(name: DID_LOGIN_OUT_SUCCESS_NOTIFICATION, object: nil, userInfo: nil)
                //: default:
                default:
                    //: break
                    break
                }
            }
            //: } else {
        } else {
            //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "json error"))
            completion(false, nil, ServiceConvertErrorResponse(errorCode: ThatTitleConvertible.NetError.rawValue, errorMsg: (String(main_fromReducePath.prefix(8)) + user_receiveText.lowercased())))
        }
    }

    //: class func buildServerUrl(model: AppRequestModel) -> String {
    class func media(model: StuffRequestModel) -> String {
        //: var serverUrl: String = model.requestServer
        var serverUrl: String = model.requestServer
        //: let otherParams = "platform=iphone&version=\(AppNetVersion)&packageId=\(PackageID)&bundleId=\(AppBundle)&lang=\(UIDevice.interfaceLang)"
        let otherParams = (noti_feedbackPath.replacingOccurrences(of: "ok", with: "t") + "form=" + main_progressMsg.replacingOccurrences(of: "display", with: "on") + "&versi" + String(constResultDeleteActiveValue)) + "\(mainPersistValue)" + (String(showHeadValue.prefix(5)) + String(show_pointUrl)) + "\(showFieldMsg)" + (String(showSubUrl) + String(mainProductZoneMsg)) + "\(appLogMessage)" + (String(app_addClearFormat.suffix(6))) + "\(UIDevice.interfaceLang)"
        //: if !model.requestPath.isEmpty {
        if !model.requestPath.isEmpty {
            //: serverUrl.append("/\(model.requestPath)")
            serverUrl.append("/\(model.requestPath)")
        }
        //: serverUrl.append("?\(otherParams)")
        serverUrl.append("?\(otherParams)")

        //: return serverUrl
        return serverUrl
    }

    /// 获取请求头参数
    /// - Parameter model: 请求模型
    /// - Returns: 请求头参数
    //: class func getRequestHeader(model: AppRequestModel) -> HTTPHeaders {
    class func fieldOf(model _: StuffRequestModel) -> HTTPHeaders {
        //: let userAgent = "\(AppName)/\(AppVersion) (\(AppBundle); build:\(AppBuildNumber); iOS \(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        let userAgent = "\(constAlreadyId)/\(k_decisionUrl) (\(appLogMessage)" + (String(main_coreMsg.suffix(6)) + String(user_environmentKey.prefix(2))) + "\(showProgressMessage)" + (String(data_clickName.suffix(6))) + "\(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        //: let headers = [HTTPHeader.userAgent(userAgent)]
        let headers = [HTTPHeader.userAgent(userAgent)]
        //: return HTTPHeaders(headers)
        return HTTPHeaders(headers)
    }
}
