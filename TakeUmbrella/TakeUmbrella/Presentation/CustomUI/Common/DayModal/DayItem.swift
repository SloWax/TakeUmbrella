//
//  DayItem.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/06/01.
//

import UIKit
import Then
import SnapKit


class DayItem: UICollectionViewCell {
    
    static let id: String = "DayItem"
    
    private let lblText = UILabel().then {
        $0.textColor = .setCustomColor(.black)
        $0.font = .setCustomUIFont(font: .regular, size: 14)
    }
    
    override var isSelected: Bool {
        didSet {
            self.borderColor = isSelected ?
                .setCustomColor(.primaryBlue) : .clear
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cornerRadius = self.frame.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUP()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP() {
        self.backgroundColor = .setCustomColor(.gray1)
        self.borderWidth = 1
        self.borderColor = .clear
        self.clipsToBounds = true
        
        let views = [lblText]
        
        self.addSubviews(views)
    }
    
    private func setLayout() {
        lblText.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
    
    func setValue(_ value: String) {
        lblText.text = value
    }
}
