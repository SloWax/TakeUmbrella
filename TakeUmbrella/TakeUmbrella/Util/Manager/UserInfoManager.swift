//
//  UserInfoManager.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/05/22.
//


import Foundation
import RxSwift
import RxCocoa
import RxOptional
import WidgetKit


class UserInfoManager: NSObject {
    
    enum UserDefaultKeys: String {
        case push     = "PUSH"
        case days     = "DAYS"
        case time     = "TIME"
        case launched = "LAUNCHED"
    }
    
    enum NotificationKeys {
        case pending
        case delivered
    }
    
    static let shared = UserInfoManager()
    
    private let bag = DisposeBag()
    private var nowData: NowWeatherModel?
    private var daysData: [DayWeatherModel] = []
    
    let now = BehaviorRelay<NowWeatherModel?>(value: nil)
    let days = BehaviorRelay<[DayWeatherModel]>(value: [])
    
    override init() {
        super.init()
        
//        self.now
//            .bind { now in }
//            .disposed(by: bag)
        
        self.days
            .bind { days in
                DataManager.shared.delete()
                
                days.forEach {
                    DataManager.shared.create($0)
                }
                
                WidgetCenter.shared.reloadAllTimelines()
            }.disposed(by: bag)
    }
    
    func accept(_ now: NowWeatherModel, _ days: [DayWeatherModel]) {
        self.now.accept(now)
        self.days.accept(days)
    }
    
    func setUserDefault(_ value: Any?, key: UserDefaultKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getUserDefault<T>(key: UserDefaultKeys, type: T.Type) -> T {
        switch key {
        case .push, .launched:
            return UserDefaults.standard.bool(forKey: key.rawValue) as! T
        case .days:
            return UserDefaults.standard.array(forKey: key.rawValue) as! T
        case .time:
            return UserDefaults.standard.integer(forKey: key.rawValue) as! T
        }
    }
    
    func addNotification(identifier: String, title: String, subtitle: String = "", badge: NSNumber = 1, timeInterval: TimeInterval, repeats: Bool = false) {
        let push =  UNMutableNotificationContent()
        
        push.title = title
        push.subtitle = subtitle
        push.badge = badge
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier, content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func removeAllNotification(_ key: NotificationKeys) {
        switch key {
        case .pending   : UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        case .delivered : UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
    }
}
