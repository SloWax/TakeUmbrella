//
//  Extension+UIViewController.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/07/29.
//  Copyright © 2022 SloWax. All rights reserved.
//

import UIKit

extension UIViewController {
    // 기본 push
    func pushVC(_ vc: UIViewController, animated: Bool = true, title: String? = nil) {
        if self is BaseMainVC {
            vc.hidesBottomBarWhenPushed = true
        }
        
        vc.title = title
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    // 기본 present
    func presentVC(_ vc: UIViewController, _ animated: Bool = true, modal: UIModalPresentationStyle = .fullScreen, title: String = "", completion: (() -> Void)? = nil) {
        switch vc {
        case is BaseModalVC:
            vc.modalPresentationStyle = .overFullScreen
        default:
            vc.modalPresentationStyle = modal
        }
        
        if let navi = vc as? BaseNC {
            navi.rootViewController?.title = title
        }
        
        self.present(vc, animated: animated) {
            completion?()
        }
    }
    
    func popVC(_ animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    // 키보드 높이 가져오기
    func getKeyBoardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo! as NSDictionary
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else { return 0 }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        return keyboardHeight
    }
    
    // 키보드 애니메이션 속도
    func getKeyBoardDuration(_ notification: Notification) -> Double {
        let userInfo = notification.userInfo! as NSDictionary
        guard let duration = userInfo.value(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as? Double else { return 0 }
        
        return duration
    }
}
