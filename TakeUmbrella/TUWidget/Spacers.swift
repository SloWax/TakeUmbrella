//
//  Spacers.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/05/23.
//

import SwiftUI


struct Spacers: View {
    var w: CGFloat = 0.0
    var h: CGFloat = 0.0
    
    var body: some View {
        ZStack{
            Spacer().frame(width: w, height: h)
        }
    }
}
