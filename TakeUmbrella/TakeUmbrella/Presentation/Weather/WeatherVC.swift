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
    private let vm: WeatherVM
    
    init(nowWeather: NowWeatherModel, daysWeather: [DayWeatherModel]) {
        
        self.weatherView.setValue(nowWeather)
        self.vm = WeatherVM(daysWeather: daysWeather)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        bind()
    }
    
    private func initialize() {
        view = weatherView
        
        let userNotiCenter = UNUserNotificationCenter.current()
        let notiAuthOptions = UNAuthorizationOptions(arrayLiteral: [.criticalAlert, .badge, .sound])
        
        userNotiCenter.requestAuthorization(options: notiAuthOptions) { (success, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    private func bind() {
//        self.rx
//            .viewWillAppear
//            .bind(to: vm.input.bindRefresh)
//            .disposed(by: vm.bag)
        
        weatherView.btnCity // 위치 설정
            .rx
            .tap
            .bind(to: vm.input.bindLocation)
            .disposed(by: vm.bag)
        
//        weatherView.btnSetting // 설정
//            .rx
//            .tap
//            .bind(to: <#T##Void...##Void#>)
//            .disposed(by: vm.bag)
        
        weatherView.svMother // 배경 블러처리
            .rx
            .didScroll
            .bind { [weak self] in
                guard let self = self else { return }
                
                let offset = self.weatherView.svMother.contentOffset
                guard offset.y < self.weatherView.frame.height else { return }
                
                self.weatherView.setOffset(offset)
            }.disposed(by: vm.bag)
        
        weatherView.svMother.refreshControl? // 새로고침
            .rx
            .controlEvent(.valueChanged)
            .bind(to: vm.input.bindRefresh)
            .disposed(by: vm.bag)
            
        
        vm.output
            .bindNow // 현재 날씨
            .bind { [weak self] nowWeather in
                guard let self = self else { return }
                
                self.weatherView.setValue(nowWeather)
            }.disposed(by: vm.bag)
        
        vm.output
            .bindList // 일기예보 리스트
            .bind(to: weatherView.tvList
                .rx
                .items(cellIdentifier: WeatherCell.id,
                       cellType: WeatherCell.self)
            ) { (row, data, cell) in
                
                cell.setValue(data)
            }.disposed(by: vm.bag)
        
        vm.output
            .bindList // 일기예보 리스트 높이, refresh indicator 중지
            .bind { [weak self] list in
                guard let self = self else { return }
                
                self.weatherView.setWeatherCast(list.count)
                
                guard list.contains(where: { $0.rain }) else { return }
                
                self.addPush()
            }.disposed(by: vm.bag)
    }
    
    private func addPush() {
        let push =  UNMutableNotificationContent()

        push.title = "엄마가우산챙기래"
        push.subtitle = "일기예보를 다시 확인해볼까요?"
        push.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "rain", content: push, trigger: trigger)
        
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
