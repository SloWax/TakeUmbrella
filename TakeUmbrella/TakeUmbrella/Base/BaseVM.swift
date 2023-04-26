//
//  BaseVM.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/07/21.
//  Copyright © 2022 SloWax. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseVM {
    deinit {
        print("<<<<<< END \(Self.self) >>>>>>")
    }
    
    var bag = DisposeBag()
    let error = PublishRelay<Error>()
    let toast = PublishRelay<String>()
    
    func clearBag() {
        self.bag = DisposeBag()
    }
}
