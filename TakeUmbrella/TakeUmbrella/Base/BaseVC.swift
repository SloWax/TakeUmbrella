//
//  BaseVC.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/07/21.
//  Copyright © 2022 SloWax. All rights reserved.
//

import UIKit
import RxSwift


class BaseVC: UIViewController {
    deinit {
        print("<<<<<< END \(Self.self) >>>>>>")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
    }
    
    func setNavigationTitle(title: String) {
        let titleLabel = UILabel()
        titleLabel.attributedText = title.underLine
        titleLabel.font = .setCustomFont(font: .bold, size: 20)
        titleLabel.textColor = .setCustomColor(.gray10)
        
        navigationItem.titleView = titleLabel
    }
    
    func clearBag(vm: BaseVM = BaseVM()) {
        vm.clearBag()
    }
}
