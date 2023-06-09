//
//  WeatherVM.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/19.
//


import Foundation
import RxSwift
import RxCocoa


class WeatherVM: BaseVM, WeatherProtocol {
    struct Input {
        let bindRefresh = PublishRelay<Void>()
    }
    
    struct Output {
        let bindNow = PublishRelay<NowWeatherModel>()
        let bindList = BehaviorRelay<[DayWeatherModel]>(value: [])
    }
    
    let input: Input
    let output: Output
    
    init(input: Input = Input(), output: Output = Output()) {
        
        self.input = input
        self.output = output
        
        let daysWeather = UserInfoManager.shared.days.value
        output.bindList.accept(daysWeather)
        
        super.init()
        
        self.input
            .bindRefresh
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.requestWeather()
            }.disposed(by: bag)
    }
    
    private func requestWeather() {
        getWeather { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.output.bindNow.accept(data.now)
                self.output.bindList.accept(data.days)
                
                self.addPushRainy()
            case .failure(let error):
                self.error.accept(error)
            }
        }
    }
}
