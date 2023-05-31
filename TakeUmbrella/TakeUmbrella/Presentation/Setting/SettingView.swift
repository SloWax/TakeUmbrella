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
    
    let btnDays = TimeMenu(title: "요일")
    
    let btnTime = TimeMenu(title: "시간")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUP()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP() {
        let arrangedSubviews = [viewPush, btnDays, btnTime]
        svMenu.addArrangedSubviews(arrangedSubviews)
        
        viewMother.addSubview(svMenu)
        
        self.addSubview(viewMother)
    }
    
    private func setLayout() {
        viewMother.snp.makeConstraints { make in
            let manager = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first?
                .windowScene?
                .statusBarManager
            
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
        $0.font = .setCustomUIFont(font: .medium, size: 16)
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
        $0.font = .setCustomUIFont(font: .medium, size: 16)
    }
    
    private let lblValue = UILabel().then {
        $0.text = "미설정"
        $0.font = .setCustomUIFont(font: .regular, size: 16)
        $0.textAlignment = .right
    }
    
    init(title: String) {
        
        self.lblTitle.text = title
        
        super.init(frame: .zero)
        
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
    
    func setValue(_ isOn: Bool, days: [String] = [], time: Int? = nil) {
        self.isEnabled = isOn
        
        let textColor: UIColor = isOn ? .setCustomColor(.black) : .setCustomColor(.gray2)
        lblTitle.textColor = textColor
        lblValue.textColor = textColor
        
        if !days.isEmpty {
            switch days {
            case let days where days.count == 7:
                lblValue.text = "매일"
            case let days where days.count == 5
                && days.contains("월")
                && days.contains("화")
                && days.contains("수")
                && days.contains("목")
                && days.contains("금"):
                
                lblValue.text = "평일"
            case let days where days.count == 2
                && days.contains("토")
                && days.contains("일"):
                
                lblValue.text = "주말"
            default:
                let sortedDays = days.sorted { (a, b) -> Bool in
                    let days = ["일", "월", "화", "수", "목", "금", "토"]
                    return days.firstIndex(of: a)! < days.firstIndex(of: b)!
                }
                
                lblValue.text = sortedDays.joined(separator: ",")
            }
        }
        
        if let time = time?.splitTime {
            let hour = time.hour
            let min = time.min
            let value = min == 0 ? "\(hour)시" : "\(hour)시 \(min)분"
            lblValue.text = value
        }
    }
}
