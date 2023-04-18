//
//  BaseMainVC.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2023/03/22.
//  Copyright © 2023 SloWax. All rights reserved.
//

import UIKit

class BaseMainVC: BaseVC {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
