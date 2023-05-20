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
        let loadData = PublishRelay<Void>()
        let bindSwitch = PublishRelay<Bool>()
    }
    
    struct Output {
        let setData = PublishRelay<Bool>()
        let bindSwitch = PublishRelay<Bool>()
    }
    
    let input: Input
    let output: Output
    
    init(input: Input = Input(), output: Output = Output()) {
        self.input = input
        self.output = output
        super.init()
        
        self.input
            .loadData
            .map { UserDefaults.standard.bool(forKey: "PUSH") }
            .bind(to: self.output.setData)
            .disposed(by: bag)
        
        self.input
            .bindSwitch
            .map {
                UserDefaults.standard.set($0, forKey: "PUSH")
                return $0
            }
            .bind(to: self.output.bindSwitch)
            .disposed(by: bag)
        
    }
}
