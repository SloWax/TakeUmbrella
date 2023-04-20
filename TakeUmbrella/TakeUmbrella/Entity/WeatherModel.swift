//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by 표건욱 on 2020/07/23.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

struct TodayWeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let timezone: Int
    let name: String
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct DaysWeatherData: Codable {
    let city: City
    let list: [List]
}

struct City: Codable {
  let name: String
}

struct List: Codable {
    let dt: Double
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}

struct UrlBase {
    static let urlToday = "https://api.openweathermap.org/data/2.5/weather?"
    static let urlDays = "https://api.openweathermap.org/data/2.5/forecast?"
    static let appid = "35bc6c3ea0807b59455f3bfb5e237c97"
    static let lang = "kr"
}
