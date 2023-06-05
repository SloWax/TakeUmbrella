//
//  DayModalVC.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/06/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import RxOptional
import RxDataSources


class DayModalVC: BaseModalVC {
    
    private let textTitle: String
    private let textSubTitle: String?
    private let confirmTitle: String
    
    private var onDays: OnDays?
    
    private let dayModalView = DayModalView()
    private let vm: DayModalVM
    
    
    init(title: String, subTitle: String? = nil,
         confirmTitle: String = "확인",
         defaultDays: [String],
         onDays: OnDays? = nil) {
        
        self.textTitle = title
        self.textSubTitle = subTitle
        self.confirmTitle = confirmTitle
        self.vm = DayModalVM(defaultDays: defaultDays)
        self.onDays = onDays
        
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
        view = dayModalView
        
        dayModalView.setValue(
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
        
        dayModalView.viewDismiss // 빈 공간 tap dismiss
            .rx
            .tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                self.vm.clearBag()
                self.dismiss(animated: false)
            }.disposed(by: bag)
        
        dayModalView.cvDays // day value bind vm
            .rx
            .itemSelected
            .map { (true, $0.row) }
            .bind(to: vm.input.selectIndex)
            .disposed(by: bag)
        
        dayModalView.cvDays // day value bind vm
            .rx
            .itemDeselected
            .map { (false, $0.row) }
            .bind(to: vm.input.selectIndex)
            .disposed(by: bag)
        
        dayModalView.btnConfirm // 확인
            .rx
            .tap
            .bind(to: vm.input.bindConfirm)
            .disposed(by: bag)
        
        vm.output // 요일 리스트
            .days
            .bind(to: dayModalView.cvDays
                    .rx
                    .items(cellIdentifier: DayItem.id,
                           cellType: DayItem.self)
            ) { row, data, cell in
                
                cell.setValue(data)
            }.disposed(by: bag)
        
        vm.output
            .bindDefaultRow // 기본설정 row
            .bind { [weak self] defaultRow in
                guard let self = self else { return }

                self.dayModalView.setDefaultRow(defaultRow)
            }.disposed(by: bag)
        
        vm.output
            .bindConfirm // 요일 넘기기
            .bind { [weak self] days in
                guard let self = self else { return }

                if let callBack = self.onDays {
                    callBack(days)
                }

                self.vm.clearBag()
                self.dismiss(animated: false)
            }.disposed(by: bag)
        
        vm.output
            .selectedDays // 설정 버튼 활성화 여부
            .bind { [weak self] selectedDays in
                guard let self = self else { return }
                
                self.dayModalView.isEnabledConfirm(selectedDays)
            }.disposed(by: bag)
    }
}
