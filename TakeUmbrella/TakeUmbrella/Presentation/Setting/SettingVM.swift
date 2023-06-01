//
//  SettingVM.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/05/16.
//


import Foundation
import RxSwift
import RxCocoa


class SettingVM: BaseVM, WeatherProtocol {
    struct Input {
        let loadData = PublishRelay<Void>()
        let bindSwitch = PublishRelay<Bool>()
        let bindDays = PublishRelay<[String]>()
        let bindTime = PublishRelay<(hour: Int, min: Int)>()
    }
    
    struct Output {
        let setData = PublishRelay<(isOn: Bool, days: [String], time: Int)>()
    }
    
    let input: Input
    let output: Output
    
    init(input: Input = Input(), output: Output = Output()) {
        self.input = input
        self.output = output
        super.init()
        
        self.input
            .loadData
            .map {
                self.addPushRainy()
                
                let isOn = UserInfoManager.shared.getUserDefault(key: .push, type: Bool.self)
                let days = UserInfoManager.shared.getUserDefault(key: .days, type: [String].self)
                let time = UserInfoManager.shared.getUserDefault(key: .time, type: Int.self)
                
                return (isOn, days, time)
            }
            .bind(to: self.output.setData)
            .disposed(by: bag)
        
        self.input
            .bindSwitch
            .map { UserInfoManager.shared.setUserDefault($0, key: .push) }
            .bind(to: self.input.loadData)
            .disposed(by: bag)
        
        self.input
            .bindDays
            .map { UserInfoManager.shared.setUserDefault($0, key: .days) }
            .bind(to: self.input.loadData)
            .disposed(by: bag)
        
        self.input
            .bindTime
            .map { time in
                let convertTime = (time.hour * 60) + time.min
                UserInfoManager.shared.setUserDefault(convertTime, key: .time)
                
                return Void()
            }
            .bind(to: self.input.loadData)
            .disposed(by: bag)
    }
}
