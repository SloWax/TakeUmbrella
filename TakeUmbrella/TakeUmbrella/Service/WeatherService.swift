//
//  WeatherService.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/19.
//

import Foundation
import Moya
import RxSwift

final class WeatherService: BaseService<WeatherAPI> {
    
    static let shared = WeatherService()
    
    func request<T:Codable>(_ api: WeatherAPI, _ dto: T.Type) -> Single<T> {
        return provider
            .rx
            .request(api)
            .filterSuccessfulStatusCodes()
            .retry(3)
            .map(T.self)
    }
}

enum WeatherAPI {
    case today(query: [String: Any])
    case days(query: [String: Any])
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        let url = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as! String
        return URL(string: url)!
    }
    
    var path: String {
        switch self {
        case .today : return "/weather"
        case .days  : return "/forecast"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .today(let query):
            return .requestParameters(parameters: query, encoding: URLEncoding.default)
        case .days(let query):
            return .requestParameters(parameters: query, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return [:]
        }
    }
}
