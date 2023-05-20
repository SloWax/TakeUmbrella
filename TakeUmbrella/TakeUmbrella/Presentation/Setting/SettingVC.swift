//
//  SettingVC.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/05/16.
//


import UIKit
import RxSwift
import RxCocoa
import RxOptional


class SettingVC: BaseSceneVC {
    private let settingView = SettingView()
    private let vm = SettingVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        bind()
    }
    
    private func initialize() {
        view = settingView
    }
    
    private func bind() {
        settingView.viewPush.swOnOff
            .rx
            .value
            .changed
            .bind { [weak self] value in
                guard let self = self else { return }
                
                
            }.disposed(by: vm.bag)
            
        settingView.btnTime
            .rx
            .tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                
            }.disposed(by: vm.bag)
    }
}
