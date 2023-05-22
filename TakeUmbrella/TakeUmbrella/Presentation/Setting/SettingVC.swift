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
        self.rx
            .viewWillAppear
            .bind(to: vm.input.loadData)
            .disposed(by: vm.bag)
        
        settingView.viewPush.swOnOff // 푸시 알림 on/off
            .rx
            .value
            .changed
            .bind(to: vm.input.bindSwitch)
            .disposed(by: vm.bag)
            
        settingView.btnTime
            .rx
            .tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                let defaultTime = UserInfoManager.shared
                    .getUserDefault(key: .time, type: Int.self)
                    .splitTime
                
                let modal = TimeModalVC(
                    title: "알림 시간 설정",
                    subTitle: "비 소식이 있다면 몇시에 알려드릴까요?",
                    confirmTitle: "설정",
                    defaultTime: defaultTime,
                    onWorkTime: { self.vm.input.bindTime.accept($0) }
                )
                
                self.presentVC(modal)
            }.disposed(by: vm.bag)
        
        vm.output
            .setData
            .bind { [weak self] data in
                guard let self = self else { return }

                self.settingView.viewPush.swOnOff.setOn(data.isOn, animated: false)
                self.settingView.btnTime.setValue(data.isOn, value: data.time)
            }.disposed(by: vm.bag)
        
        vm.output
            .bindSwitch
            .bind { [weak self] isOn in
                guard let self = self else { return }
                
                self.settingView.btnTime.setValue(isOn)
            }.disposed(by: vm.bag)
    }
}
