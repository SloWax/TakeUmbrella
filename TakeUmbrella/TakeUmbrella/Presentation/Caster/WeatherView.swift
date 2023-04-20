//
//  WeatherView.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/19.
//

import UIKit
import SnapKit
import Then


class WeatherView: BaseView {
    
    private let ivBack = UIImageView().then {
        let backImage = ["sunny", "cloudy", "lightning", "rainy"]
        let image = UIImage(named: backImage.randomElement() ?? "")
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    private let viewBlur: UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blur = UIVisualEffectView(effect: effect)
        
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.alpha = 0
        
        return blur
    }()
    
    let btnCity = UIButton(type: .system).then {
        $0.setTitleColor(.setCustomColor(.white), for: .normal)
        $0.titleLabel?.font = .setCustomFont(font: .bold, size: 20)
        $0.setTitle("test", for: .normal)
    }
    
    let btnSetting = UIButton(type: .system).then {
        let image = UIImage(systemName: "gear")
        $0.setImage(image, for: .normal)
        $0.tintColor = .setCustomColor(.white)
    }
    
    private let svMother = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.refreshControl = UIRefreshControl()
    }
    
    private let svDayInfo = UIStackView().then {
        $0.alignment = .bottom
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 5
    }
    
    private let ivDay = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let lblDay = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .regular, size: 14)
        $0.text = "lblDay"
    }
    
    private let svTemp = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 5
    }
    
    private let lblMinTemp = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .regular, size: 14)
        $0.text = "lblMinTemp"
    }
    
    private let lblMaxTemp = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .regular, size: 14)
        $0.text = "lblMaxTemp"
    }
    
    private let lblFeelTemp = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .regular, size: 14)
        $0.text = "lblFeelTemp"
    }
    
    private let lblTemp = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.text = "lblTemp"
    }
    
    let tvList = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.allowsSelection = false
    }
    
    
    private var effectViewAlpha: CGFloat = 0
    private var tempConstraint: Constraint?
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUP()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        lblTemp.font = .systemFont(ofSize: self.frame.width / 3, weight: .ultraLight)
        lblTemp.font = .setCustomFont(font: .light, size: self.frame.width / 3)
    }
    
    private func setUP() {
        let dayArrangedSubviews = [ivDay, lblDay]
        svDayInfo.addArrangedSubviews(dayArrangedSubviews)
        
        let tempArrangedSubviews = [lblMinTemp, lblMaxTemp, lblFeelTemp]
        svTemp.addArrangedSubviews(tempArrangedSubviews)
        
        let subViews = [svDayInfo, svTemp, lblTemp, tvList]
        svMother.addSubviews(subViews)
        
        let views = [
            ivBack, viewBlur,
            btnCity, btnSetting,
            svMother
        ]
        
        self.addSubviews(views)
    }
    
    private func setLayout() {
        ivBack.snp.makeConstraints {
            $0.top.left.bottom.equalTo(self)
            $0.width.equalTo(self).multipliedBy(1.1)
        }
        
        viewBlur.snp.makeConstraints {
//            $0.top.leading.bottom.equalTo(self)
//            $0.width.equalTo(self.snp.width).multipliedBy(1.2)
            $0.edges.equalTo(ivBack)
        }
        
        btnCity.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)//.offset(<#T##amount: ConstraintOffsetTarget##ConstraintOffsetTarget#>)
            make.centerX.equalTo(self)
        }
        
        btnSetting.snp.makeConstraints { make in
            make.centerY.equalTo(btnCity)
            make.right.equalTo(self).inset(5)
            make.width.height.equalTo(45)
        }
        
        svMother.snp.makeConstraints {
            $0.top.equalTo(btnSetting.snp.bottom)//.offset(<#T##amount: ConstraintOffsetTarget##ConstraintOffsetTarget#>)
            $0.left.right.bottom.equalTo(self)
        }
        
        lblTemp.snp.makeConstraints {
            $0.top.equalTo(svMother.snp.bottom).multipliedBy(0.7)
            tempConstraint = $0.left.equalTo(self).inset(10).constraint
        }
        
        svTemp.snp.makeConstraints {
            $0.top.left.equalTo(lblTemp)
        }
        
        ivDay.snp.makeConstraints {
            $0.width.height.equalTo(45)
        }
        
        svDayInfo.snp.makeConstraints {
            $0.left.equalTo(svTemp)
            $0.bottom.equalTo(svTemp.snp.top).offset(-5)
        }
        
        tvList.snp.makeConstraints {
            $0.top.equalTo(lblTemp.snp.bottom)
            $0.left.right.equalTo(self)
            $0.height.equalTo(0)
            $0.bottom.equalTo(svMother)
        }
    }
    
//    func setToday(data: WeatherViewModel) {
//        let weather = data.todayWeather
//        let main = data.todayMain
//        let name = data.todayName
//
//        let dayLabelText = weather.description
//                            .replacingOccurrences(of: "온", with: "")
//                            .replacingOccurrences(of: "실 ", with: "")
//                            .replacingOccurrences(of: "튼", with: "")
//
//        scrollView.dayLabel.text = dayLabelText
//        scrollView.dayImage.image = UIImage(named: weather.icon)
//        scrollView.minTemp.text = String(format: "⤓ %.1f°", main.temp_min - 273.15)
//        scrollView.maxTemp.text = String(format: "⤒ %.1f°", main.temp_max - 273.15)
//        scrollView.tempLabel.text = String(format: "%.1f°", main.temp - 273.15)
//        cityLabel.text = name
//    }
    
//    func beforeRefresh() {
//
//        effectViewAlpha = viewBlur.alpha
//        viewBlur.alpha = 1
//        locationStack.alpha = 0
//        tempConstraint?.update(inset: self.frame.width)
//    }
    
//    @objc private func timeShow() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "a h:mm"
//
//        locationStack.timeLabel.text = formatter.string(from: Date())
//    }
    
//    @objc private func refreshToggle(_ sender: UIBarButtonItem) {
//
//        UIView.animate(withDuration: 0.75) { [weak self] in
//            guard let self = self else { return }
//
//            self.refreshButton.transform = CGAffineTransform(rotationAngle: .pi)
//            self.refreshButton.transform = CGAffineTransform(rotationAngle: 0)
//            self.viewBlur.alpha = self.effectViewAlpha
//            self.locationStack.alpha = 1
//            self.tempConstraint?.update(inset: 10)
//
//            self.layoutIfNeeded()
//        }
//
//        ivBack.image = UIImage(named: backImage.randomElement() ?? "")
//    }
}
