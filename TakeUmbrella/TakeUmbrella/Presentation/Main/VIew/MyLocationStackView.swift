//
//  MyLocationStackView.swift
//  WeatherForecast
//
//  Created by 표건욱 on 2021/03/24.
//  Copyright © 2021 Giftbot. All rights reserved.
//

import UIKit

class MyLocationStackView: UIStackView {

    let cityLabel: UILabel = {
    let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alignment = .center
        self.axis = .vertical
        self.spacing = 5
        self.addArrangedSubview(cityLabel)
        self.addArrangedSubview(timeLabel)
    }
    
    required init(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
