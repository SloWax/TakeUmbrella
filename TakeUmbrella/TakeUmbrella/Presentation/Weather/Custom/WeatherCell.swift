//
//  WeatherCell.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/21.
//


import UIKit
import SnapKit
import Then

class WeatherCell: UITableViewCell {
    
    static let id: String = "WeatherCell"
    
    private let svDate = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let lblDay = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .light, size: 16)
    }
    
    private let lblTime = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .regular, size: 24)
    }
    
    private let ivIcon = UIImageView()
    private let viewBorder = UIView().then {
        $0.backgroundColor = .setCustomColor(.white)
        $0.cornerRadius = 1
        $0.alpha = 0.3
    }
    
    private let lblTemp = UILabel().then {
        $0.textColor = .setCustomColor(.white)
        $0.font = .setCustomFont(font: .light, size: 50)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUP()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP() {
        self.backgroundColor = .clear
        
        svDate.addArrangedSubviews([lblDay, lblTime])
        
        let views = [svDate, ivIcon, viewBorder, lblTemp]
        self.contentView.addSubviews(views)
    }
    
    private func setLayout() {
        svDate.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.left.equalTo(contentView).inset(10)
        }
        
        ivIcon.snp.makeConstraints {
            $0.centerX.centerY.equalTo(contentView)
            $0.width.height.equalTo(contentView.snp.width).multipliedBy(0.125)
        }
        
        viewBorder.snp.makeConstraints {
            $0.left.right.equalTo(ivIcon)
            $0.height.equalTo(1.5)
            $0.bottom.equalTo(contentView)
        }
        
        lblTemp.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.right.equalTo(contentView).inset(10)
        }
    }
    
    func setValue(_ value: DayWeatherModel) {
        lblDay.text = value.day
        lblTime.text = value.time
        
        ivIcon.image = UIImage(named: value.icon)
        lblTemp.text = value.temp.toString("%.1f°")
    }
}
