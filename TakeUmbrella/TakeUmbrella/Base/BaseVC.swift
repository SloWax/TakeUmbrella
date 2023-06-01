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
//        titleLabel.attributedText = title.underLine
//        titleLabel.font = .setCustomFont(font: .bold, size: 20)
//        titleLabel.textColor = .setCustomColor(.gray10)
        
        navigationItem.titleView = titleLabel
    }
    
    func openSettingAlert(title: String? = nil, message: String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let defaultAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(url) else { return }
            
            UIApplication.shared.open(url)
        }
        
        let cancelAction = UIAlertAction(title: "종료", style: .cancel) { _ in
            WindowManager.exit()
        }
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
