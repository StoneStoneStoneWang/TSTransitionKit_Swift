//
//  MainViewController.swift
//  TSTransitionKit_SwiftDemo
//
//  Created by three stone 王 on 2018/11/21.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit
import WLToolsKit
import WLBaseViewController
import LGSideMenuController

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printLog(message: "viewDidLoad")
        
        let vc = WLHomeViewController()
        
        addChildVC(childVC: vc, title: "首页", fontSize: 12, titleColor: .red, highColor: .yellow, imageName: "", selectedImageName: "")
        
        let vc1 = ViewController()
        
        addChildVC(childVC: vc1, title: "我的", fontSize: 12, titleColor: .red, highColor: .yellow, imageName: "", selectedImageName: "")
        
        selectedViewController = children[0]
    }
}
