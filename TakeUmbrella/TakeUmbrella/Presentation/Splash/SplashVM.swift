//
//  SplashVM.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/26.
//

import Foundation
import RxSwift
import RxCocoa


class SplashVM: BaseVM, WeatherProtocol {
    struct Input {
        let bindAuth = PublishRelay<Void>()
    }
    
    struct Output {
        let bindAuth = PublishRelay<Bool>()
    }
    
    let input: Input
    let output: Output
    
    init(input: Input = Input(), output: Output = Output()) {
        self.input = input
        self.output = output
        super.init()
        
        self.input
            .bindAuth
            .bind {
                LocationManager.shared.request()
                
                UserInfoManager.shared.removeAllNotification(.delivered)
                
                if !UserInfoManager.shared.getUserDefault(key: .launched, type: Bool.self) {
                    UserInfoManager.shared.setUserDefault(true, key: .launched)
                    UserInfoManager.shared.setUserDefault(true, key: .push)
                    UserInfoManager.shared.setUserDefault(480, key: .time)
                }
            }.disposed(by: bag)
        
        LocationManager.shared
            .bindAuth
            .bind { [weak self] status in
                guard let self = self else { return }
                
                switch status {
                case .auth          : self.requestWeather()
                case .notDetermined : break
                case .denied        : self.output.bindAuth.accept(false)
                }
            }.disposed(by: bag)
    }
    
    private func requestWeather() {
        getWeather { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.output.bindAuth.accept(true)
                
                self.addPushRainy()
            case .failure(let error):
                self.error.accept(error)
            }
        }
    }
}
