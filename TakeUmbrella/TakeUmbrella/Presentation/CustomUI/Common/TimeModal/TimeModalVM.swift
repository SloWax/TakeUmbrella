//
//  TimeModalVM.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/08/02.
//  Copyright © 2022 SloWax. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional


class TimeModalVM: BaseVM {
    
    struct Input {
        // Void
        let viewWillAppear = PublishRelay<Void>()
        let index = PublishRelay<(component: Int, row: Int)>()
        let bindConfirm = PublishRelay<Void>()
    }
    
    struct Output {
        // Void
        let bindDefaultRow = PublishRelay<[(component: Int, row: Int)]>()
        let bindConfirm = PublishRelay<Time>()
        
        // Data
        let times = BehaviorRelay<[[Int]]>(value: [Array(0...23), Array(0...59)])
    }
    
    let input: Input
    let output: Output
    
    private var selectedTime: Time = (0, 0)
    
    init(input: Input = Input(), output: Output = Output(),
         defaultTime: Time) {
        
        self.input = input
        self.output = output
        
        super.init()
        
        self.input
            .viewWillAppear
            .bind { [weak self] in
                guard let self = self else { return }
                
                let times = self.output.times.value
                let hour = defaultTime.hour
                let min = defaultTime.min
                
                var rows: [(component: Int, row: Int)] = []
                
                if let row = times.first?.firstIndex(of: hour), hour > 0 {
                    rows.append((0, row))
                }
                
                if let row = times.last?.firstIndex(of: min), min > 0 {
                    rows.append((1, row))
                }
                
                guard rows.isNotEmpty else { return }
                
                self.selectedTime = (hour, min)
                self.output.bindDefaultRow.accept(rows)
            }.disposed(by: bag)
        
        self.input
            .index
            .bind { [weak self] index in
                guard let self = self else { return }
                
                let times = self.output.times.value
                let selectValue = times[index.component][index.row]
                
                let isHour = index.component == 0
                isHour ? (self.selectedTime.hour = selectValue) : (self.selectedTime.min = selectValue)
            }.disposed(by: bag)
        
        self.input
            .bindConfirm
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.output.bindConfirm.accept(self.selectedTime)
            }.disposed(by: bag)
    }
}
