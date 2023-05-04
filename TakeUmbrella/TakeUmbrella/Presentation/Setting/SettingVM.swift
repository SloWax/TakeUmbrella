//
//  SettingVM.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/05/16.
//


import Foundation
import RxSwift
import RxCocoa


class SettingVM: BaseVM {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    let input: Input
    let output: Output
    
    init(input: Input = Input(), output: Output = Output()) {
        self.input = input
        self.output = output
        super.init()
        
    }
}
