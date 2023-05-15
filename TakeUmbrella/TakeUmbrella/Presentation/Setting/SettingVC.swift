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
        vm.output
            .bindMyList // 
            .bind(to: settingView.tvMy
                .rx
                .items(cellIdentifier: MyCityCell.id,
                       cellType: MyCityCell.self)
            ) { (row, data, cell) in
                
//                cell.setValue(data)
            }.disposed(by: vm.bag)
    }
}
