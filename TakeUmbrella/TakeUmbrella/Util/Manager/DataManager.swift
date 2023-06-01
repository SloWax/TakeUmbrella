//
//  DataManager.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/05/26.
//

import RealmSwift


protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object

    init(managedObject: ManagedObject)

    func managedObject() -> ManagedObject
}


class DataManager {
    static let shared = DataManager()
    
    private var realm: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.SloWax.TakeUmbrella")
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        return try! Realm(configuration: config)
    }
    
    func create(_ data: DayWeatherModel) {
        let weather = data.managedObject()
        
        try! realm.write {
            realm.add(weather)
        }
    }
    
    func retrieve() -> [DayWeatherModel] {
        let objects = realm.objects(RealmItemModel.self)
        var weather = [DayWeatherModel]()
        
        objects.forEach { item in
            let convertItem = DayWeatherModel(managedObject: item)
            weather.append(convertItem)
        }
        
        return weather
    }
    
    func delete() {
        let objects = realm.objects(RealmItemModel.self)
        
        try! realm.write {
            realm.delete(objects)
        }
    }
}


class RealmItemModel: Object {
    @objc dynamic var day = ""
    @objc dynamic var time = ""
    @objc dynamic var location = ""
    @objc dynamic var icon = ""
    @objc dynamic var desc = ""
    @objc dynamic var isRain = false
    @objc dynamic var temp = 0.0
    @objc dynamic var tempMin = 0.0
    @objc dynamic var tempMax = 0.0
}


extension DayWeatherModel: Persistable {

    init(managedObject: RealmItemModel) {
        self.day = managedObject.day
        self.time = managedObject.time
        self.location = managedObject.location
        self.icon = managedObject.icon
        self.description = managedObject.desc
        self.isRain = managedObject.isRain
        self.temp = managedObject.temp
        self.tempMin = managedObject.tempMin
        self.tempMax = managedObject.tempMax
    }

    func managedObject() -> RealmItemModel {
        let module = RealmItemModel()
        
        module.day = self.day
        module.time = self.time
        module.location = self.location
        module.icon = self.icon
        module.desc = self.description
        module.isRain = self.isRain
        module.temp = self.temp
        module.tempMin = self.tempMin
        module.tempMax = self.tempMax
        
        return module
    }
}
