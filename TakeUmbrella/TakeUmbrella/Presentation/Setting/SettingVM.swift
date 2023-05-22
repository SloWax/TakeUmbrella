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
        let bindTime = PublishRelay<(hour: Int, min: Int)>()
    }
    
    struct Output {
        let setData = PublishRelay<(isOn: Bool, time: Int?)>()
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
                let isOn = DeviceManager.shared.getValue(key: .push, type: Bool.self)
                let time = DeviceManager.shared.getValue(key: .time, type: Int.self)
                let sumTime = (time > 0) ? time : nil
                
                return (isOn, sumTime)
            }
            .bind(to: self.output.setData)
            .disposed(by: bag)
        
        self.input
            .bindSwitch
            .map { isOn in
                if !isOn { DeviceManager.shared.removeAllNotification(.Pending) }
                DeviceManager.shared.setValue(isOn, key: .push)
                
                return isOn
            }
            .bind(to: self.output.bindSwitch)
            .disposed(by: bag)
        
        self.input
            .bindTime
            .map { time in
                let convertTime = (time.hour * 60) + time.min
                DeviceManager.shared.setValue(convertTime, key: .time)
                
                return Void()
            }
            .bind(to: self.input.loadData)
            .disposed(by: bag)
    }
}
