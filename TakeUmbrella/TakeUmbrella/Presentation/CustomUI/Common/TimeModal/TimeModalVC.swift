//
//  TimeModalVC.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/08/02.
//  Copyright © 2022 SloWax. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxOptional
import RxDataSources


class TimeModalVC: BaseModalVC {
    
    private let textTitle: String
    private let textSubTitle: String?
    private let confirmTitle: String
    
    private var onTime: OnTime?
    
    private let timeModalView = TimeModalView()
    private let vm: TimeModalVM
    
    private let stringPickerAdapter = RxPickerViewAttributedStringAdapter<[[Int]]>(
        components: [],
        numberOfComponents: { _, _, components in components.count },
        numberOfRowsInComponent: {  _, _, items, row -> Int in
            return items[row].count
        },
        attributedTitleForRow: { _, _, items, row, component -> NSAttributedString? in
            var value = "\(items[component][row])"
            component == 0 ? (value += " 시간") : (value += " 분")
            
            let attributed = NSAttributedString(
                string: value,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.setCustomColor(.black)]
            )
            
            return attributed
        }
    )
    
    
    init(title: String, subTitle: String? = nil,
         confirmTitle: String = "확인",
         defaultTime: Time,
         onWorkTime: OnTime? = nil) {
        
        self.textTitle = title
        self.textSubTitle = subTitle
        self.confirmTitle = confirmTitle
        self.vm = TimeModalVM(defaultTime: defaultTime)
        self.onTime = onWorkTime
        
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
        view = timeModalView
        
        timeModalView.setValue(
            title: textTitle,
            subTitle: textSubTitle,
            confirmTitle: confirmTitle
        )
    }
    
    private func bind() {
        self.rx
            .viewWillAppear
            .bind(to: vm.input.viewWillAppear)
            .disposed(by: bag)
        
        timeModalView.viewDismiss // 빈 공간 tap dismiss
            .rx
            .tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                self.vm.clearBag()
                self.dismiss(animated: false)
            }.disposed(by: bag)
        
        timeModalView.pvPicker // Picker value bind vm
            .rx
            .itemSelected
            .map { ($0.component, $0.row) }
            .bind(to: vm.input.index)
            .disposed(by: bag)
        
        timeModalView.btnConfirm // 확인
            .rx
            .tap
            .bind(to: vm.input.bindConfirm)
            .disposed(by: bag)
        
        vm.output
            .times // 근무시간
            .bind(to: timeModalView.pvPicker
                    .rx
                    .items(adapter: stringPickerAdapter)
            ).disposed(by: bag)
        
        vm.output
            .bindDefaultRow // 기본설정 row
            .bind { [weak self] defaultRow in
                guard let self = self else { return }
                
                self.timeModalView.setDefaultRow(defaultRow)
            }.disposed(by: bag)
        
        vm.output
            .bindConfirm // 근무시간 넘기기
            .bind { [weak self] time in
                guard let self = self else { return }
                
                if let callBack = self.onTime {
                    callBack(time)
                }

                self.vm.clearBag()
                self.dismiss(animated: false)
            }.disposed(by: bag)
    }
}
