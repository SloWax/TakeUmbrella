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


class WeatherVC: BaseMainVC {
    private let weatherView = WeatherView()
    private let vm = WeatherVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        bind()
    }
    
    private func initialize() {
        view = weatherView
        
        if let nowWeather = UserInfoManager.shared.now.value {
            weatherView.setValue(nowWeather)
        }
        
        let userNotiCenter = UNUserNotificationCenter.current()
        let notiAuthOptions = UNAuthorizationOptions(arrayLiteral: [.criticalAlert, .badge, .sound])
        
        userNotiCenter.requestAuthorization(options: notiAuthOptions) { (success, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    private func bind() {
        NotificationCenter.default // 다른 앱에서 되돌아왔을때
            .rx
            .notification(UIApplication.willEnterForegroundNotification)
            .map { _ in Void() }
            .bind(to: vm.input.bindRefresh)
            .disposed(by: vm.bag)
        
        weatherView.btnSetting // 설정
            .rx
            .tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                let vc = SettingVC()
                self.pushVC(vc, title: "설정")
            }.disposed(by: vm.bag)
        
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
            }.disposed(by: vm.bag)
    }
}
