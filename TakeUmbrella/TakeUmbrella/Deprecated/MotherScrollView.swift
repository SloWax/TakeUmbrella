//
//  MotherScrollView.swift
//  WeatherForecast
//
//  Created by 표건욱 on 2021/03/24.
//  Copyright © 2021 Giftbot. All rights reserved.
//

import UIKit

class MotherScrollView: UIScrollView {
    
    let tempLabel = UILabel()
    
    let tempStack = UIStackView()
    let minTemp = UILabel()
    let maxTemp = UILabel()
    
    let dayInfoStack = UIStackView()
    let dayImage = UIImageView()
    let dayLabel = UILabel()
    
    let weatherTable = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tempLabel.textColor = .white
        self.addSubview(tempLabel)
        
        minTemp.textColor = .white
        maxTemp.textColor = .white
        
        tempStack.alignment = .leading
        tempStack.axis = .horizontal
        tempStack.distribution = .fillEqually
        tempStack.spacing = 5
        tempStack.addArrangedSubview(minTemp)
        tempStack.addArrangedSubview(maxTemp)
        self.addSubview(tempStack)
        
        dayImage.contentMode = .scaleAspectFit
        dayLabel.textColor = .white
        
        dayInfoStack.alignment = .bottom
        dayInfoStack.axis = .horizontal
        dayInfoStack.distribution = .equalSpacing
        dayInfoStack.spacing = 5
        dayInfoStack.addArrangedSubview(dayImage)
        dayInfoStack.addArrangedSubview(dayLabel)
        self.addSubview(dayInfoStack)
        
        weatherTable.separatorStyle = .none
        weatherTable.backgroundColor = .clear
        weatherTable.allowsSelection = false
        self.addSubview(weatherTable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
