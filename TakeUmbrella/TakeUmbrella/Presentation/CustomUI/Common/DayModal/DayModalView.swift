//
//  DayModalView.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/06/01.
//

import UIKit
import SnapKit
import Then


class DayModalView: BaseView {
    
    let viewDismiss = UIView()
    
    private let viewMother = UIView().then {
        $0.addShadow(offset: .top)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    private let lblTitle = UILabel().then {
        $0.textColor = .setCustomColor(.gray10)
        $0.font = .setCustomUIFont(font: .bold, size: 18)
        $0.textAlignment = .center
    }
    
    private let lblSubTitle = UILabel().then {
        $0.textColor = .setCustomColor(.gray10)
        $0.font = .setCustomUIFont(font: .medium, size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let cvDays: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.register(DayItem.self, forCellWithReuseIdentifier: DayItem.id)
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.allowsMultipleSelection = true
        }
    }()
    
    let btnConfirm = PyoButton(type: .system).then {
        $0.titleLabel?.font = .setCustomUIFont(font: .medium, size: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUP()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP() {
        self.backgroundColor = .clear
        
        cvDays.delegate = self
        
        let views = [lblTitle, lblSubTitle, cvDays, btnConfirm]
        viewMother.addSubviews(views)
        
        self.addSubviews([viewDismiss, viewMother])
    }
    
    private func setLayout() {
        viewDismiss.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        viewMother.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
        }
        
        lblTitle.snp.makeConstraints { make in
            make.top.equalTo(viewMother).inset(28)
            make.left.right.equalTo(self)
        }
        
        lblSubTitle.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom)
            make.left.right.equalTo(self)
        }
        
        cvDays.snp.makeConstraints { make in
            make.top.equalTo(lblSubTitle.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(100)
        }
        
        btnConfirm.snp.makeConstraints { make in
            make.top.equalTo(cvDays.snp.bottom)
            make.left.right.equalTo(viewMother).inset(20)
            make.bottom.equalTo(viewMother).inset(28)
            make.height.equalTo(48)
        }
    }
    
    func setValue(title: String?, subTitle: String?, confirmTitle: String?) {
        lblTitle.text = title
        lblSubTitle.text = subTitle
        
        btnConfirm.setTitle(confirmTitle, for: .normal)
    }
    
    func setDefaultRow(_ rows: [Int]) {
        rows.forEach {
            let indexPath = IndexPath(item: $0, section: 0)
            cvDays.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }
    }
}


extension DayModalView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let allSpacing: CGFloat = 20 + 60
        let size = floor((collectionView.frame.width - allSpacing) / 7)
        
        return CGSize(width: size, height: size)
    }
}
