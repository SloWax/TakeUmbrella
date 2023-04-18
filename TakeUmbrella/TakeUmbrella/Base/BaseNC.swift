//
//  BaseNC.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/07/29.
//  Copyright © 2022 SloWax. All rights reserved.


import UIKit

enum NavigationType {
    case basic(title: String?)
    case main
    case logo
    case logoOnly
    case fullScreen
}

class BaseNC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
    }
    
    private func setupNavigationBarAppearance() {
        let image = UIImage(named: "btn_back_28")
        navigationBar.tintColor = .black
        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image
    }
}
