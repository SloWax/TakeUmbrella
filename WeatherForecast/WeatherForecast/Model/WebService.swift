//
//  WebService.swift
//  WeatherForecast
//
//  Created by 표건욱 on 2021/03/24.
//  Copyright © 2021 Giftbot. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

struct WebService {
    static func loadWeather(url: String, method: HTTPMethod) -> Observable<Data> {
        return Observable<Data>.create { observer -> Disposable in
            let af = AF.request(url, method: method).validate(statusCode: 200 ..< 400)
            af.responseJSON { (response) in
                switch response.result {
                case .success(_):
                    
                    if let data = response.data {
                        observer.onNext(data)
                    }
                case .failure(_):
                    
                    print("통신실패")
                }
            }

            return Disposables.create()
        }
    }
}
