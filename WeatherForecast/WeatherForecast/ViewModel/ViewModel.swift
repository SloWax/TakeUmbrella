//
//  ViewModel.swift
//  WeatherForecast
//
//  Created by 표건욱 on 2021/03/24.
//  Copyright © 2021 Giftbot. All rights reserved.
//

import Foundation

struct WeatherViewModel {
    let todayVM: TodayWeatherData
    let daysVM: DaysWeatherData
    
    var todayWeather: Weather {
        return self.todayVM.weather[0]
    }
    var todayMain: Main {
        return self.todayVM.main
    }
    var todayName: String {
        return self.todayVM.name
    }
    
    init(_ today: TodayWeatherData, _ days: DaysWeatherData) {
        self.todayVM = today
        self.daysVM = days
    }
}
