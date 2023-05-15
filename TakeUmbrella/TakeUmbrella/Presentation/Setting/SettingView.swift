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
    
    let tfSearch = UITextField().then {
        $0.backgroundColor = .setCustomColor(.gray6)
    }
    
    let tvMy = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorColor = .clear
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(MyCityCell.self, forCellReuseIdentifier: MyCityCell.id)
    }
    
//    private let tvSearch = UITableView().then {
//        $0.backgroundColor = .clear
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUP()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP() {
        self.backgroundColor = .setCustomColor(.gray1)
        
        let views = [tfSearch, tvMy]
        
        self.addSubviews(views)
    }
    
    private func setLayout() {
        tfSearch.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(45)
        }
        
        tvMy.snp.makeConstraints { make in
            make.top.equalTo(tfSearch.snp.bottom).offset(15)
            make.left.right.bottom.equalTo(self)
        }
    }
}
