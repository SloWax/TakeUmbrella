//
//  CustomTableViewCell.swift
//  WeatherForecast
//
//  Created by 표건욱 on 2020/07/23.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let Identifier = "CustomTableViewCell"
    
    let dayLabel = UILabel()
    let timeLabel = UILabel()
    let leftStack = UIStackView()
    
    let dayImage = UIImageView()
    let dayboder = UIView()
    
    let tempLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        dayLabel.font = .systemFont(ofSize: contentView.frame.height * 0.4, weight: .light)
        dayLabel.textColor = .white
        
        timeLabel.font = .systemFont(ofSize: contentView.frame.height * 0.55, weight: .medium)
        timeLabel.textColor = .white
        
        leftStack.axis = .vertical
        leftStack.alignment = .leading
        leftStack.distribution = .fillEqually
        leftStack.addArrangedSubview(dayLabel)
        leftStack.addArrangedSubview(timeLabel)
        contentView.addSubview(leftStack)
        
        dayboder.backgroundColor = .white
        dayboder.layer.cornerRadius = 1
        dayboder.alpha = 0.3
        dayImage.addSubview(dayboder)
        contentView.addSubview(dayImage)
        
        tempLabel.font = .systemFont(ofSize: contentView.frame.height, weight: .thin)
        tempLabel.textColor = .white
        contentView.addSubview(tempLabel)
        
        setLayout()
    }
    
    func setLayout() {
        
        leftStack.snp.makeConstraints {
            
            $0.top.bottom.equalTo(contentView)
            $0.leading.equalTo(contentView).offset(10)
        }
        
        dayImage.snp.makeConstraints {
            
            $0.centerX.equalTo(contentView.snp.leading).offset(contentView.frame.width * 0.7)
            $0.centerY.equalTo(contentView)
            $0.width.height.equalTo(contentView.frame.width * 0.125)
        }
        
        dayboder.snp.makeConstraints {
            
            $0.centerX.width.equalTo(dayImage)
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(1.5)
        }
        
        tempLabel.snp.makeConstraints {
            
            $0.trailing.equalTo(contentView).inset(10)
            $0.centerY.equalTo(contentView)
        }
        
    }
    
    func setValue(data: DaysWeatherData, indexPath: Int) {
        
        let dataWithIndex = data.list[indexPath]
        let dateText = (Date(timeIntervalSince1970: dataWithIndex.dt))
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "M.d (E)"
        dayLabel.text = dateFormatter.string(from: dateText)
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: dateText)
        
        dayImage.image = UIImage(named: dataWithIndex.weather[0].icon)
        tempLabel.text = String(format: "%.1f°", dataWithIndex.main.temp - 273.15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
