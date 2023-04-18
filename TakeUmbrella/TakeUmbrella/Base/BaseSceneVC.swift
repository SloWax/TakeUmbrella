//
//  BaseSceneVC.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2023/03/22.
//  Copyright © 2023 SloWax. All rights reserved.
//

import UIKit

class BaseSceneVC: BaseVC {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.navigationController?.isNavigationBarHidden == true {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
}
