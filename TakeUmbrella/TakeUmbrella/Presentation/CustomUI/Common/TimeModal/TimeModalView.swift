//
//  TimeModalView.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/08/02.
//  Copyright © 2022 SloWax. All rights reserved.
//

import UIKit
import SnapKit
import Then


class TimeModalView: BaseView {
    
    let viewDismiss = UIView()
    
    private let viewMother = UIView().then {
        $0.addShadow(offset: .top)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    private let lblTitle = UILabel().then {
        $0.textColor = .setCustomColor(.gray10)
        $0.font = .setCustomUIFont(font: .bold, size: 18)
        $0.textAlignment = .center
    }
    
    private let lblSubTitle = UILabel().then {
        $0.textColor = .setCustomColor(.gray10)
        $0.font = .setCustomUIFont(font: .medium, size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let vevPicker = UIVisualEffectView()
    let pvPicker = UIPickerView()
    
    let btnConfirm = PyoButton(type: .system).then {
        $0.titleLabel?.font = .setCustomUIFont(font: .medium, size: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUP()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP() {
        self.backgroundColor = .clear
        
        vevPicker.contentView.addSubview(pvPicker)
        
        let views = [lblTitle, lblSubTitle, vevPicker, btnConfirm]
        viewMother.addSubviews(views)
        
        self.addSubviews([viewDismiss, viewMother])
    }
    
    private func setLayout() {
        viewDismiss.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        viewMother.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
        }
        
        lblTitle.snp.makeConstraints { make in
            make.top.equalTo(viewMother).inset(28)
            make.left.right.equalTo(self)
        }
        
        lblSubTitle.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom)
            make.left.right.equalTo(self)
        }
        
        vevPicker.snp.makeConstraints { make in
            make.top.equalTo(lblSubTitle.snp.bottom)
            make.left.right.equalTo(self).inset(20)
            make.height.equalTo(120)
        }
        
        pvPicker.snp.makeConstraints { make in
            make.edges.equalTo(vevPicker)
        }
        
        btnConfirm.snp.makeConstraints { make in
            make.top.equalTo(vevPicker.snp.bottom)
            make.left.right.equalTo(viewMother).inset(20)
            make.bottom.equalTo(viewMother).inset(28)
            make.height.equalTo(48)
        }
    }
    
    func setValue(title: String?, subTitle: String?, confirmTitle: String?) {
        lblTitle.text = title
        lblSubTitle.text = subTitle
        
        btnConfirm.setTitle(confirmTitle, for: .normal)
    }
    
    func setDefaultRow(_ rows: [(component: Int, row: Int)]) {
        rows.forEach {
            pvPicker.selectRow($0.row, inComponent: $0.component, animated: false)
        }
    }
}
