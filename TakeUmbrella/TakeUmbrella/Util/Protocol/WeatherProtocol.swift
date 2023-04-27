//
//  WeatherProtocol.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/26.
//

import Foundation
import RxSwift

protocol WeatherProtocol { }

extension WeatherProtocol where Self: BaseVM {
    
    // GET 날씨 가져오기
    func getWeather(completion: @escaping (Result<(now: NowWeatherModel, days: [DayWeatherModel]), Error>) -> Void) {
        let coor = LocationManager.shared.loadLocation()
        let lat = String(coor.lat)
        let lon = String(coor.lon)
        let appID = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherID") as! String
        
        let daysQuery = WeatherDto.Request(
            lat: lat,
            lon: lon,
            appid: appID,
            lang: "kr"
        )
        
        let todayQuery = WeatherDto.Request(
            lat: lat,
            lon: lon,
            appid: appID,
            lang: "kr"
        )
        
        guard let daysQuery = daysQuery.toDictionary,
              let nowQuery = todayQuery.toDictionary else { return }
        
        let addressService = LocationManager.shared
            .loadAddress(coor: coor)
        
        let daysService = WeatherService.shared
            .request(.days(query: daysQuery), WeatherDto.Response.Days.self)
            .asObservable()
        
        let nowService = WeatherService.shared
            .request(.today(query: nowQuery), WeatherDto.Response.Today.self)
            .asObservable()
        
        Observable.zip(addressService, daysService, nowService)
            .subscribe { address, daysData, nowData in
                
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
                
                let now = NowWeatherModel(
                    address: address,
                    icon: nowData.weather.first?.icon ?? "",
                    description: description,
                    minTemp: minTemp.toCelsius,
                    maxTemp: maxTemp.toCelsius,
                    feelTemp: nowData.main.feels_like.toCelsius,
                    temp: nowData.main.temp.toCelsius
                )
                
                completion(.success((now, days)))
            } onError: { error in
                completion(.failure(error))
            }.disposed(by: bag)
    }
}
