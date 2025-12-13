
//: Declare String Begin

/*: "http://app. :*/
fileprivate let main_domainViewName:String = "phone title data controlhttp://"
fileprivate let appSystemTitle:[Character] = ["a","p","p","."]

/*: .com" :*/
fileprivate let show_agentMessage:String = "data mirror finish on all.com"

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//: import Foundation
import Foundation
//: import HandyJSON
import HandyJSON

//: class AppRequestModel: NSObject {
class StuffRequestModel: NSObject {
    //: @objc var requestPath: String = ""
    @objc var requestPath: String = ""
    //: var requestServer: String = ""
    var requestServer: String = ""
    //: var params: Dictionary<String, Any> = [:]
    var params: [String: Any] = [:]

    //: override init() {
    override init() {
        //: self.requestServer = "http://app.\(ReplaceUrlDomain).com"
        self.requestServer = (String(main_domainViewName.suffix(7)) + String(appSystemTitle)) + "\(main_timeFormat)" + (String(show_agentMessage.suffix(4)))
    }
}

/// 通用Model
//: struct AppBaseResponse: HandyJSON {
struct MonitorRandomTransformable: HandyJSON {
    //: var errno: Int!
    var errno: Int! // 服务端返回码
    //: var msg: String?
    var msg: String? // 服务端返回码
    //: var data: Any?
    var data: Any? // 具体的data的格式和业务相关，故用泛型定义
}

/// 通用Model
//: public struct AppErrorResponse {
public struct ServiceConvertErrorResponse {
    //: let errorCode: Int
    let errorCode: Int
    //: let errorMsg: String
    let errorMsg: String
    //: init(errorCode: Int, errorMsg: String) {
    init(errorCode: Int, errorMsg: String) {
        //: self.errorCode = errorCode
        self.errorCode = errorCode
        //: self.errorMsg = errorMsg
        self.errorMsg = errorMsg
    }
}

//: enum RequestResultCode: Int {
enum ThatTitleConvertible: Int {
    //: case Normal         = 0
    case Normal = 0
    //: case NetError       = -10000
    case NetError = -10000 // w
    //: case NeedReLogin    = -100
    case NeedReLogin = -100 // 需要重新登录
}
