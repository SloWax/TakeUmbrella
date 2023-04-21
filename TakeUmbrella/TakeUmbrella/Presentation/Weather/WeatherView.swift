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
        $0.titleLabel?.font = .setCustomFont(font: .bold, size: 24)
        $0.setTitle("test", for: .normal)
    }
    
    let btnSetting = UIButton(type: .system).then {
        let image = UIImage(systemName: "gear")
        $0.setImage(image, for: .normal)
        $0.tintColor = .setCustomColor(.white)
    }
    
    let svMother = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.refreshControl = UIRefreshControl()
    }
    
    private let svNowInfo = UIStackView().then {
        $0.alignment = .bottom
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 5
    }
    
    private let ivNow = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let lblNow = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .regular, size: 18)
    }
    
    private let svTemp = UIStackView().then {
        $0.alignment = .leading
        $0.axis = .horizontal
        $0.spacing = 5
    }
    
    private let lblMinTemp = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .regular, size: 18)
    }
    
    private let lblMaxTemp = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .regular, size: 18)
    }
    
    private let lblFeelTemp = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .regular, size: 18)
    }
    
    private let lblTemp = UILabel().then {
        $0.textColor = .setCustomColor(.white)
    }
    
    let tvList = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.id)
    }
    
    private var effectViewAlpha: CGFloat = 0
    
    
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
        
        lblTemp.font = .setCustomFont(font: .light, size: self.frame.width / 3)
    }
    
    private func setUP() {
        let nowArrangedSubviews = [ivNow, lblNow]
        svNowInfo.addArrangedSubviews(nowArrangedSubviews)
        
        let tempArrangedSubviews = [lblMinTemp, lblMaxTemp, lblFeelTemp]
        svTemp.addArrangedSubviews(tempArrangedSubviews)
        
        let subViews = [svNowInfo, svTemp, lblTemp, tvList]
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
            $0.edges.equalTo(ivBack)
        }
        
        btnCity.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalTo(self).inset(15)
        }
        
        btnSetting.snp.makeConstraints { make in
            make.centerY.equalTo(btnCity)
            make.right.equalTo(self).inset(5)
            make.width.height.equalTo(45)
        }
        
        svMother.snp.makeConstraints {
            $0.top.equalTo(btnSetting.snp.bottom)
            $0.left.right.bottom.equalTo(self)
        }
        
        lblTemp.snp.makeConstraints {
            $0.top.equalTo(svMother.snp.bottom).multipliedBy(0.23)
            $0.left.equalTo(self).inset(10)
        }
        
        svTemp.snp.makeConstraints {
            $0.top.left.equalTo(lblTemp)
        }
        
        ivNow.snp.makeConstraints {
            $0.width.height.equalTo(45)
        }
        
        svNowInfo.snp.makeConstraints {
            $0.left.equalTo(svTemp)
            $0.bottom.equalTo(svTemp.snp.top)
        }
        
        tvList.snp.makeConstraints {
            $0.top.equalTo(lblTemp.snp.bottom)
            $0.left.right.equalTo(self)
            $0.height.equalTo(0)
            $0.bottom.equalTo(svMother)
        }
    }
    
    func setValue(_ data: NowWeatherModel) {
//        ivBack.image = UIImage(named: backImage.randomElement() ?? "")
//        cityLabel.text = name

        ivNow.image = UIImage(named: data.icon)
        lblNow.text = data.description
        lblMinTemp.text = data.minTemp.toString("⤓ %.1f°")
        lblMaxTemp.text = data.maxTemp.toString("⤒ %.1f°")
        lblFeelTemp.text = data.feelTemp.toString("👤 %.1f°")
        
        lblTemp.text = data.temp.toString("%.1f°")
    }
    
    func setOffset(_ offset: CGPoint) {
        ivBack.center.x = self.center.x - (offset.y / 20)
        viewBlur.alpha = offset.y / self.frame.height
    }
    
    func setWeatherCast(_ count: Int) {
        svMother.refreshControl?.endRefreshing()
        
        // 셀 높이 가져오기
        let tvVisibleCells = tvList.visibleCells
        guard tvVisibleCells.count > 0 else { return }
        
        if let cell = tvVisibleCells.first as? WeatherCell {
            let height = CGFloat(count) * cell.frame.height
            tvList.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
        }
    }
}
