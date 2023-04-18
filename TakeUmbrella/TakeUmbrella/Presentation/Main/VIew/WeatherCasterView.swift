//
//  WeatherCasterView.swift
//  WeatherForecast
//
//  Created by Envy on 2021/06/14.
//  Copyright © 2021 Giftbot. All rights reserved.
//

import UIKit
import SnapKit

class WeatherCasterView: UIView {
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    private let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    private lazy var backImage = ["sunny", "cloudy", "lightning", "rainy"]
    
    private let locationStack = MyLocationStackView()
    private var timer: Timer?
    
    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        let symbol = UIImage(systemName: "arrow.clockwise")
        button.setImage(symbol, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    lazy var scrollView: MotherScrollView = {
        let view = MotherScrollView()
        view.alwaysBounceVertical = true
        
        return view
    }()
    var effectViewAlpha: CGFloat = 0
    
    private var tempConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
        setLayout()
    }
    
    private func setView() {
        backgroundImageView.image = UIImage(named: backImage.randomElement() ?? "")
        self.addSubview(backgroundImageView)
        
        blurEffectView.alpha = 0
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timeShow),
                                         userInfo: nil,
                                         repeats: true)
        self.addSubview(locationStack)
        
        refreshButton.addTarget(self, action: #selector(refreshToggle(_:)), for: .touchUpInside)
        self.addSubview(refreshButton)
        
        scrollView.tempLabel.font = .systemFont(ofSize: self.frame.width / 3, weight: .ultraLight)
        self.addSubview(scrollView)
    }
    private func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(self).multipliedBy(1.1)
        }
        
        blurEffectView.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(self)
            $0.width.equalTo(self.snp.width).multipliedBy(1.2)
        }
        
        locationStack.snp.makeConstraints {
            
            $0.top.equalToSuperview().offset(self.frame.height * 0.01)
                $0.centerX.equalToSuperview()
        }
        
        refreshButton.snp.makeConstraints {
            $0.width.height.equalTo(self.frame.width * 0.1)
            $0.top.equalTo(locationStack)
            $0.trailing.equalTo(self.snp.leading).offset(self.frame.width * 0.95)
        }
        
        scrollView.snp.makeConstraints {
            
            $0.top.equalTo(locationStack.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.tempLabel.snp.makeConstraints {
            
            $0.top.equalTo(scrollView.snp.top).offset(self.frame.height * 0.72)
            tempConstraint = $0.leading.equalTo(scrollView).inset(10).constraint
        }
        scrollView.tempStack.snp.makeConstraints {
            
            $0.leading.equalTo(scrollView.tempLabel)
            $0.bottom.equalTo(scrollView.tempLabel.snp.top).offset(-5)
        }
        scrollView.dayImage.snp.makeConstraints {
            
            $0.width.height.equalTo(scrollView.snp.width).multipliedBy(0.1)
        }
        scrollView.dayInfoStack.snp.makeConstraints {
            
            $0.leading.equalTo(scrollView.tempLabel)
            $0.bottom.equalTo(scrollView.tempStack.snp.top).offset(-5)
        }
        scrollView.weatherTable.snp.makeConstraints {
            
            $0.top.equalTo(scrollView.tempLabel.snp.bottom)
            $0.leading.trailing.equalTo(self)
            $0.height.equalTo(10 * 60)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setToday(data: WeatherViewModel) {
        let weather = data.todayWeather
        let main = data.todayMain
        let name = data.todayName
        
        let dayLabelText = weather.description
                            .replacingOccurrences(of: "온", with: "")
                            .replacingOccurrences(of: "실 ", with: "")
                            .replacingOccurrences(of: "튼", with: "")
        
        scrollView.dayLabel.text = dayLabelText
        scrollView.dayImage.image = UIImage(named: weather.icon)
        scrollView.minTemp.text = String(format: "⤓ %.1f°", main.temp_min - 273.15)
        scrollView.maxTemp.text = String(format: "⤒ %.1f°", main.temp_max - 273.15)
        scrollView.tempLabel.text = String(format: "%.1f°", main.temp - 273.15)
        locationStack.cityLabel.text = name
    }
    func beforeRefresh() {
        
        effectViewAlpha = blurEffectView.alpha
        blurEffectView.alpha = 1
        locationStack.alpha = 0
        tempConstraint?.update(inset: self.frame.width)
    }
    
    @objc private func timeShow() {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        
        locationStack.timeLabel.text = formatter.string(from: Date())
    }
    @objc private func refreshToggle(_ sender: UIBarButtonItem) {
        
        UIView.animate(withDuration: 0.75) { [weak self] in
            guard let self = self else { return }
            
            self.refreshButton.transform = CGAffineTransform(rotationAngle: .pi)
            self.refreshButton.transform = CGAffineTransform(rotationAngle: 0)
            self.blurEffectView.alpha = self.effectViewAlpha
            self.locationStack.alpha = 1
            self.tempConstraint?.update(inset: 10)
            
            self.layoutIfNeeded()
        }
        
        backgroundImageView.image = UIImage(named: backImage.randomElement() ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
