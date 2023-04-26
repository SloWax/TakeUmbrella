//
//  LottieIndicator.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/26.
//

import UIKit
import Lottie

class LottieIndicator {
    static let shared = LottieIndicator()
    
    private let animationView = AnimationView(name: "UmbrellaIndicator")
    
    func show() {
        if let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?
            .windows
            .filter({ $0.isKeyWindow })
            .first {

            //메인 뷰에 삽입
            keyWindow.addSubview(animationView)
            
            animationView.frame.size = CGSize(width: 500, height: 500)
            animationView.center = animationView.superview!.center
            animationView.center.x = animationView.center.x - 20
            animationView.contentMode = .scaleAspectFit
            
            //애니메이션 재생모드( .loop = 애니메이션 무한재생)
            animationView.loopMode = .loop
            
            //애니메이션 재생(애니메이션 재생모드 미 설정시 1회)
            animationView.play()
        }
    }
    
    func dismiss() {
        animationView.stop()
        animationView.removeFromSuperview()
    }
}
