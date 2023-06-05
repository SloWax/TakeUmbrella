//
//  DayModalVM.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/06/01.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional


class DayModalVM: BaseVM {
    
    struct Input {
        // Void
        let viewWillAppear = PublishRelay<Void>()
        let selectIndex = PublishRelay<(isSelect: Bool, index:Int)>()
        let bindConfirm = PublishRelay<Void>()
    }
    
    struct Output {
        // Void
        let bindDefaultRow = PublishRelay<[Int]>()
        let bindConfirm = PublishRelay<[String]>()
        
        // Data
        let days = BehaviorRelay<[String]>(value: ["일", "월", "화", "수", "목", "금", "토"])
        let selectedDays = BehaviorRelay<[String]>(value: [])
    }
    
    let input: Input
    let output: Output
    
    init(input: Input = Input(), output: Output = Output(),
         defaultDays: [String]) {
        
        self.input = input
        self.output = output
        
        super.init()
        
        self.input
            .viewWillAppear
            .bind { [weak self] in
                guard let self = self else { return }
                
                let allDays = self.output.days.value
                let rows = defaultDays.compactMap { allDays.firstIndex(of: $0) }
                
                self.output.bindDefaultRow.accept(rows)
                self.output.selectedDays.accept(defaultDays)
            }.disposed(by: bag)
        
        self.input
            .selectIndex
            .bind { [weak self] event in
                guard let self = self else { return }
                
                let selectValue = self.output.days.value[event.index]
                var nextDays = self.output.selectedDays.value
                
                switch event.isSelect {
                case true:
                    nextDays.append(selectValue)
                case false:
                    guard let index = nextDays.firstIndex(of: selectValue) else { return }
                    nextDays.remove(at: index)
                }
                
                self.output.selectedDays.accept(nextDays)
            }.disposed(by: bag)
        
        self.input
            .bindConfirm
            .bind { [weak self] in
                guard let self = self else { return }
                
                let selectedDays = self.output.selectedDays.value
                self.output.bindConfirm.accept(selectedDays)
            }.disposed(by: bag)
    }
}
