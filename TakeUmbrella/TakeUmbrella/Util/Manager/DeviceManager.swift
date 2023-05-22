//
//  DeviceManager.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/05/22.
//


import Foundation
import RxSwift
import RxCocoa
import RxOptional


class DeviceManager: NSObject {
    
    enum UserDefaultKeys: String {
        case push = "PUSH"
        case time = "TIME"
    }
    
    enum NotificationKeys {
        case Pending
        case Delivered
    }
    
    static let shared = DeviceManager()
    
    func setValue(_ value: Any?, key: UserDefaultKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getValue<T>(key: UserDefaultKeys, type: T.Type) -> T {
        switch key {
        case .push: return UserDefaults.standard.bool(forKey: key.rawValue) as! T
        case .time: return UserDefaults.standard.integer(forKey: key.rawValue) as! T
        }
    }
    
    func addNotification(title: String, subtitle: String = "", badge: NSNumber = 1, timeInterval: TimeInterval, repeats: Bool = false) {
        let push =  UNMutableNotificationContent()
        
        push.title = title
        push.subtitle = subtitle
        push.badge = badge
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        let request = UNNotificationRequest(identifier: "rain", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func removeAllNotification(_ key: NotificationKeys) {
        switch key {
        case .Pending   : UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        case .Delivered : UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
    }
}
