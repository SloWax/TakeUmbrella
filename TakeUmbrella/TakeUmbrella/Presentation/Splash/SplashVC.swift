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
    
    private let viewBack = UIView().then {
        $0.backgroundColor = .setCustomColor(.black)
    }
    
    private let vm = SplashVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        bind()
    }
    
    private func initialize() {
        view = viewBack
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
        
        self.rx
            .viewDidAppear
            .bind { LottieIndicator.shared.show() }
            .disposed(by: vm.bag)
        
        vm.output
            .bindAuth
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .bind { [weak self] data in
                guard let self = self else { return }
                
                LottieIndicator.shared.dismiss()
                
                if let data = data {
                    WindowManager.change(.weather)
                } else {
                    self.openSettingAlert(
                        title: "위치권한을 허용해 주세요.",
                        message: "앱을 사용하기 위해서 꼭 필요해요!"
                    )
                }
            }.disposed(by: vm.bag)
    }
}
