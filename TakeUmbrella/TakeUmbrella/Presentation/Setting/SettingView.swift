//
//  SettingView.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/05/16.
//


import UIKit
import SnapKit
import Then


class SettingView: BaseView {
    
    private let viewMother = UIView().then {
        $0.backgroundColor = .setCustomColor(.gray1)
    }
    
    private let svMenu = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let viewPush = PushMenu()
    
    let btnTime = TimeMenu()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUP()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP() {
        let arrangedSubviews = [viewPush, btnTime]
        svMenu.addArrangedSubviews(arrangedSubviews)
        
        viewMother.addSubview(svMenu)
        
        self.addSubview(viewMother)
    }
    
    private func setLayout() {
        viewMother.snp.makeConstraints { make in
            let manager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
            let height = manager?.statusBarFrame.height ?? 0
            
            make.top.equalTo(self).inset(height)
            make.left.right.bottom.equalTo(self)
        }
        
        svMenu.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.left.right.equalTo(self).inset(15)
        }
    }
}


final class PushMenu: UIView {
    
    private let lblTitle = UILabel().then {
        $0.text = "비 소식 알림"
        $0.textColor = .setCustomColor(.black)
        $0.font = .setCustomFont(font: .medium, size: 16)
    }
    
    let swOnOff = UISwitch().then {
        $0.onTintColor = .setCustomColor(.primaryBlue)
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
        self.backgroundColor = .setCustomColor(.white)
        self.cornerRadius = 15
        
        let views = [lblTitle, swOnOff]
        
        self.addSubviews(views)
    }
    
    private func setLayout() {
        lblTitle.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(self).inset(15)
        }
        
        swOnOff.snp.makeConstraints { make in
            make.centerY.equalTo(lblTitle)
            make.right.equalTo(self).inset(15)
        }
    }
}

final class TimeMenu: UIButton {
    
    private let lblTitle = UILabel().then {
        $0.text = "알림 시간"
        $0.font = .setCustomFont(font: .medium, size: 16)
    }
    
    private let lblValue = UILabel().then {
        $0.text = "미설정"
        $0.font = .setCustomFont(font: .regular, size: 16)
        $0.textAlignment = .right
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
        self.backgroundColor = .setCustomColor(.white)
        self.cornerRadius = 15
        
        let views = [lblTitle, lblValue]
        
        self.addSubviews(views)
    }
    
    private func setLayout() {
        lblTitle.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(self).inset(15)
        }
        
        lblValue.snp.makeConstraints { make in
            make.right.equalTo(self).inset(15)
            make.centerY.equalTo(self)
        }
    }
    
    func setValue(_ isOn: Bool, value: String) {
        self.isEnabled = isOn
        
        let textColor: UIColor = isOn ? .setCustomColor(.black) : .setCustomColor(.gray2)
        lblTitle.textColor = textColor
        lblValue.textColor = textColor
        
        lblValue.text = value
    }
}
