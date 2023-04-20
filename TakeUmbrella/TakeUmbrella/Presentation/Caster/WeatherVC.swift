//
//  WeatherVC.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/19.
//


import UIKit
import RxSwift
import RxCocoa
import RxOptional


class WeatherVC: BaseVC {
    private let weatherView = WeatherView()
    private let vm = WeatherVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        bind()
    }
    
    private func initialize() {
        view = weatherView
    }
    
    private func bind() {
        
    }
}
