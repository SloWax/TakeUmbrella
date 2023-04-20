//
//  WeatherVM.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/19.
//


import Foundation
import RxSwift
import RxCocoa


class WeatherVM: BaseVM {
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
        
        getWeather()
    }
    
    private func getWeather() {
        let todayQuery = WeatherDto.Request(
            lat: "37",
            lon: "127",
            appid: "35bc6c3ea0807b59455f3bfb5e237c97",
            lang: "kr"
        )
        
        let daysQuery = WeatherDto.Request(
            lat: "37",
            lon: "127",
            appid: "35bc6c3ea0807b59455f3bfb5e237c97",
            lang: "kr"
        )
        
        guard let todayQuery = todayQuery.toDictionary,
              let daysQuery = daysQuery.toDictionary else { return }
        
        let todayService = WeatherService.shared
            .request(.today(query: todayQuery), WeatherDto.Response.Today.self)
            .asObservable()
        
        let daysService = WeatherService.shared
            .request(.days(query: daysQuery), WeatherDto.Response.Days.self)
            .asObservable()
        
        Observable.zip(todayService, daysService)
            .subscribe { today, days in
                print(today, days)
            } onError: { [weak self] error in
                guard let self = self else { return }
                
                self.error.accept(error)
            }.disposed(by: bag)
    }
}
