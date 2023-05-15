//
//  MyCityCell.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/05/17.
//


import UIKit
import SnapKit
import Then

class MyCityCell: UITableViewCell {
    static let id: String = "MyCityCell"
    
    private let viewMother = UIView().then {
        $0.backgroundColor = .setCustomColor(.white)
    }
    
    private let lblTitle = UILabel().then {
        $0.text = "test"
        $0.textColor = .setCustomColor(.black)
        $0.font = .setCustomFont(font: .medium, size: 16)
    }
    
    let swPush = UISwitch().then {
        $0.onTintColor = .setCustomColor(.primaryBlue)
    }
    
    let btnDelete = UIButton().then {
        let image = UIImage(systemName: "trash.fill")
        $0.setImage(image, for: .normal)
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
        backgroundColor = .clear
        
        let views = [lblTitle, swPush, btnDelete]
        
        viewMother.addSubviews(views)
        
        contentView.addSubview(viewMother)
    }
    
    private func setLayout() {
        viewMother.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(5)
            make.left.right.equalTo(contentView).inset(15)
        }
        
        lblTitle.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(viewMother).inset(15)
        }
        
        swPush.snp.makeConstraints { make in
            make.centerY.equalTo(btnDelete)
            make.right.equalTo(btnDelete.snp.left).offset(-15)
        }
        
        btnDelete.snp.makeConstraints { make in
            make.centerY.equalTo(lblTitle)
            make.right.equalTo(viewMother).inset(15)
            make.width.height.equalTo(30)
        }
    }
    
//    func setValue(_ value: <#Model#>) {
//
//    }
    
}
