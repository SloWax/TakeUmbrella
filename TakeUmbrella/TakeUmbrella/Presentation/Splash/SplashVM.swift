//
//  SplashVM.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/26.
//

import Foundation
import RxSwift
import RxCocoa

enum LocationAuth {
    case auth
    case notDetermined
    case denied
}

class SplashVM: BaseVM {
    struct Input {
        let bindAuth = PublishRelay<Void>()
    }
    
    struct Output {
        let bindAuth = PublishRelay<(NowWeatherModel, [DayWeatherModel])?>()
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
                case .auth:
                    let coor = LocationManager.shared.loadLocation()
                    
                    self.getWeather(lat: coor.lat, lon: coor.lon)
                case .notDetermined:
                    
                    break
                case .denied:
                    
                    self.output.bindAuth.accept(nil)
                }
            }.disposed(by: bag)
    }
    
    private func getWeather(lat: String, lon: String) {
        let appID = "35bc6c3ea0807b59455f3bfb5e237c97"
        let lang = "kr"
        
        let daysQuery = WeatherDto.Request(
            lat: lat,
            lon: lon,
            appid: appID,
            lang: lang
        )
        
        let todayQuery = WeatherDto.Request(
            lat: lat,
            lon: lon,
            appid: appID,
            lang: lang
        )
        
        guard let daysQuery = daysQuery.toDictionary,
              let nowQuery = todayQuery.toDictionary else { return }
        
        let daysService = WeatherService.shared
            .request(.days(query: daysQuery), WeatherDto.Response.Days.self)
            .asObservable()
        
        let nowService = WeatherService.shared
            .request(.today(query: nowQuery), WeatherDto.Response.Today.self)
            .asObservable()
        
        Observable.zip(daysService, nowService)
            .subscribe { daysData, nowData in
                
                let days = daysData.list
                    .splitRange(23)
                    .map {
                        let date = Date(timeIntervalSince1970: $0.dt)
                        
                        let newDay = DayWeatherModel(
                            day: date.toString(dateFormat: "M.d (E)"),
                            time: date.toString(dateFormat: "HH:mm"),
                            icon: $0.weather.first?.icon ?? "",
                            temp: $0.main.temp.toCelsius
                        )
                        
                        return newDay
                    }
                
                let description = nowData.weather.first?.description
                    .replacingOccurrences(of: "연무", with: "안개")
                    .replacingOccurrences(of: "박무", with: "안개")
                    .replacingOccurrences(of: "보통", with: "")
                    .replacingOccurrences(of: "온", with: "")
                    .replacingOccurrences(of: "실 ", with: "")
                    .replacingOccurrences(of: "튼", with: "") ?? ""
                
                let list = daysData.list.count > 8 ?
                daysData.list.splitRange(7) : daysData.list
                
                let minTemp = list
                    .compactMap { $0.main.temp_min }
                    .sorted()
                    .first ?? 0
                
                let maxTemp = list
                    .compactMap { $0.main.temp_max }
                    .sorted()
                    .last ?? 0
                
                let nowWeather = NowWeatherModel(
                    icon: nowData.weather.first?.icon ?? "",
                    description: description,
                    minTemp: minTemp.toCelsius,
                    maxTemp: maxTemp.toCelsius,
                    feelTemp: nowData.main.feels_like.toCelsius,
                    temp: nowData.main.temp.toCelsius
                )
                
                print(days, nowWeather)
            } onError: { [weak self] error in
                guard let self = self else { return }
                
                self.error.accept(error)
            }.disposed(by: bag)
    }
}
