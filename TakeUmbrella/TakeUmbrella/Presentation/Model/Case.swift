//
//  Case.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/26.
//

import Foundation

typealias Time = (hour: Int, min: Int)
typealias OnTime = (Time) -> Void
typealias CallBack = () -> Void

enum LocationAuth {
    case auth
    case notDetermined
    case denied
}
