//
//  DayWeatherModel.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/22.
//

import Foundation
import WidgetKit

struct DayWeatherModel {
    let day: String
    let time: String
    let location: String
    let icon: String
    let description: String
    let isRain: Bool
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    
    var toEntry: SimpleEntry {
        return SimpleEntry(
            date: Date(),
            day: day,
            time: time,
            location: "동도옫ㅇ",
            icon: icon,
            description: description,
            temp: temp,
            tempMin: tempMin,
            tempMax: tempMax
        )
    }
}

struct WeatherEntry: TimelineEntry {
    let date: Date
    
    let day: String
    let time: String
    let icon: String
    let description: String
    let isRain: Bool
    let temp: Double
    let tempMin: Double
    let tempMax: Double
}
