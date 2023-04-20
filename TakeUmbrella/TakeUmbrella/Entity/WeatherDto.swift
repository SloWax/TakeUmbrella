//
//  WeatherDto.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/19.
//

import Foundation

struct WeatherDto: Codable {
    struct Request: Codable {
        let lat: String
        let lon: String
        let appid: String
        let lang: String
    }
    
    struct Response: Codable {
        struct Today: Codable {
            let coord: Coordinate
            let weather: [Weather]
            let base: String
            let main: Main
            let sys: System
            let timezone: Int
            let name: String
            let cod: Int
            
            struct Coordinate: Codable {
                let lon: Double
                let lat: Double
            }
            
            struct Weather: Codable {
                let id: Int
                let main: String
                let description: String
                let icon: String
            }

            struct Main: Codable {
                let temp: Double
                let feels_like: Double
                let temp_min: Double
                let temp_max: Double
                let pressure: Int
                let humidity: Int
            }
            
            struct System: Codable {
                let type: Int
                let id: Int
                let country: String
                let sunrise: Int
                let sunset: Int
            }
        }

        struct Days: Codable {
            let cod: String
            let cnt: Int
            let list: [List]

            struct List: Codable {
                let dt: Int
                let main: Main
                let weather: [Weather]
                let dt_txt: String
            }
        }
    }
}
