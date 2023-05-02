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
        let bindAuth = PublishRelay<(now: NowWeatherModel, days: [DayWeatherModel])?>()
    }
    
    let input: Input
    let output: Output
    
    init(input: Input = Input(), output: Output = Output()) {
        self.input = input
        self.output = output
        super.init()
        
        self.input
            .bindAuth
            .bind { LocationManager.shared.request() }
            .disposed(by: bag)
        
        LocationManager.shared
            .bindAuth
            .bind { [weak self] status in
                guard let self = self else { return }
                
                switch status {
                case .auth          : self.requestWeather()
                case .notDetermined : break
                case .denied        : self.output.bindAuth.accept(nil)
                }
            }.disposed(by: bag)
    }
    
    private func requestWeather() {
        getWeather { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.output.bindAuth.accept(data)
            case .failure(let error):
                self.error.accept(error)
            }
        }
    }
}
