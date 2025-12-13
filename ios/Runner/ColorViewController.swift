
//: Declare String Begin

/*: "LaunchImage" :*/
fileprivate let data_frameMessage:[Character] = ["L","a","u","n","c","h","I","m"]
fileprivate let data_mediaTitle:[Character] = ["a","g","e"]

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  ColorViewController.swift
//  OverseaH5
//
//  Created by DouXiu on 2025/11/27.
//

//: import UIKit
import UIKit

//: class WaitViewController: UIViewController {
class ColorViewController: UIViewController {
    //: override func viewDidLoad() {
    override func viewDidLoad() {
        //: super.viewDidLoad()
        super.viewDidLoad()
        //: let bgImgV = UIImageView()
        let bgImgV = UIImageView()
        //: bgImgV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        bgImgV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        //: bgImgV.image = UIImage(named: "LaunchImage")
        bgImgV.image = UIImage(named: (String(data_frameMessage) + String(data_mediaTitle)))
        //: view.addSubview(bgImgV)
        view.addSubview(bgImgV)
    }
}
