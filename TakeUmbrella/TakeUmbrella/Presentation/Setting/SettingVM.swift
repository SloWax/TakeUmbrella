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
        let bindTime = PublishRelay<(hour: Int, min: Int)>()
    }
    
    struct Output {
        let setData = PublishRelay<(isOn: Bool, time: Int)>()
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
            .map {
                let isOn = UserInfoManager.shared.getUserDefault(key: .push, type: Bool.self)
                let time = UserInfoManager.shared.getUserDefault(key: .time, type: Int.self)
                
                return (isOn, time)
            }
            .bind(to: self.output.setData)
            .disposed(by: bag)
        
        self.input
            .bindSwitch
            .map { [weak self] isOn in
                guard let self = self else { return isOn }
                
                UserInfoManager.shared.setUserDefault(isOn, key: .push)
                
                isOn ? self.addPushRainy() : UserInfoManager.shared.removeAllNotification(.pending)
                
                return isOn
            }
            .bind(to: self.output.bindSwitch)
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
