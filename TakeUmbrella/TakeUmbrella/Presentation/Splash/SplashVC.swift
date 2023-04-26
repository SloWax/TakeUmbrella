//
//  SplashVC.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/26.
//


import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Then


class SplashVC: BaseVC {
    
    private let ivImage = UIImageView().then {
        let image = UIImage(named: "rainy")
        $0.image = image
//        $0.backgroundColor = .setCustomColor(.primaryRubys)
        $0.contentMode = .scaleAspectFill
    }
    
    private let vm = SplashVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        bind()
    }
    
    private func initialize() {
        view = ivImage
        
    }
    
    private func bind() {
        NotificationCenter.default // 다른 앱에서 되돌아왔을때
            .rx
            .notification(UIApplication.willEnterForegroundNotification)
            .map { _ in Void() }
            .bind(to: vm.input.bindAuth)
            .disposed(by: vm.bag)
        
        self.rx
            .viewWillAppear // 화면이 뜰 때
            .bind(to: vm.input.bindAuth)
            .disposed(by: vm.bag)
        
        vm.output
            .bindAuth
            .bind { [weak self] data in
                guard let self = self else { return }
                
                if let data = data {
                    WindowManager.change(.weather(nowWeather: data.now, daysWeather: data.days))
                } else {
                    self.openSettingAlert(
                        title: "위치권한을 허용해 주세요.",
                        message: "앱을 사용하기 위해서 꼭 필요해요!"
                    )
                }
            }.disposed(by: vm.bag)
    }
}
