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
                        
                        let description = $0
                            .weather
                            .first?
                            .description
                            .replacingOccurrences(of: "연무", with: "안개")
                            .replacingOccurrences(of: "박무", with: "안개")
                            .replacingOccurrences(of: "보통", with: "")
                            .replacingOccurrences(of: "온", with: "")
                            .replacingOccurrences(of: "실 ", with: "")
                            .replacingOccurrences(of: "튼", with: "") ?? ""
                        
                        let isRain = description.contains { String($0).contains("비") || String($0).contains("눈") }
                        
                        let newDay = DayWeatherModel(
                            day: date.toString(dateFormat: "M.d (E)"),
                            time: date.toString(dateFormat: "HH:mm"),
                            location: address.subLocal,
                            icon: $0.weather.first?.icon ?? "",
                            description: description,
                            isRain: isRain,
                            temp: $0.main.temp.toCelsius,
                            tempMin: $0.main.temp_min.toCelsius,
                            tempMax: $0.main.temp_max.toCelsius
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
                    address: "\(address.area) \(address.local) \(address.subLocal)",
                    icon: nowData.weather.first?.icon ?? "",
                    description: description,
                    minTemp: minTemp.toCelsius,
                    maxTemp: maxTemp.toCelsius,
                    feelTemp: nowData.main.feels_like.toCelsius,
                    temp: nowData.main.temp.toCelsius
                )
                
                UserInfoManager.shared.accept(now, days)
                
                completion(.success((now, days)))
            } onError: { error in
                completion(.failure(error))
            }.disposed(by: bag)
    }
    
    func addPushRainy() {
        UserInfoManager.shared.removeAllNotification(.pending)
        
        guard UserInfoManager.shared.getUserDefault(key: .push, type: Bool.self),
              UserInfoManager.shared.days.value.contains(where: { $0.isRain }) else { return }

        let time = UserInfoManager.shared
            .getUserDefault(key: .time, type: Int.self)
            .splitTime

        let components = DateComponents(hour: time.hour, minute: time.min)
        let nextTime = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime) ?? Date()
        
        let nextTimeWeekday = nextTime.toString(dateFormat: "E")
        let days = UserInfoManager.shared.getUserDefault(key: .days, type: [String].self)
        
        guard (days.contains { $0 == nextTimeWeekday }) else { return }
        
        let interval = DateInterval(start: Date(), end: nextTime)
        let duration = interval.duration

        UserInfoManager.shared.addNotification(
            identifier: "rain",
            title: "엄마가우산챙기래",
            subtitle: "일기예보를 다시 확인해볼까요?",
            timeInterval: duration
        )
    }
}
