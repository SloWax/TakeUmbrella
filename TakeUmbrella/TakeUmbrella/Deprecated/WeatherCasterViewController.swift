//
//  ViewController.swift
//  WeatherForecast
//
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import CoreLocation

final class WeatherCasterViewController: UIViewController {
    
    private let bag = DisposeBag()
    private var weatherVM: WeatherViewModel!
    
    private lazy var weatherView: WeatherCasterView = {
        let view  = WeatherCasterView(frame: view.frame)
        view.scrollView.delegate = self
        view.scrollView.weatherTable.dataSource = self
        view.scrollView.weatherTable.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.Identifier)
        
        return view
    }()
    
    private var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setLocation()
        loadData()
    }
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    private func setView() {
        weatherView.refreshButton.addTarget(self, action: #selector(beforerefresh(_:)), for: .touchDown)
        view.addSubview(weatherView)
        
        weatherView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func setLocation() {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    private func loadData() {
        let coor = locationManager.location?.coordinate
        let lat = String(coor?.latitude ?? CLLocationDegrees())
        let lon = String(coor?.longitude ?? CLLocationDegrees())
        
        let todayUrl = "\(UrlBase.urlToday)lat=\(lat)&lon=\(lon)&appid=\(UrlBase.appid)&lang=\(UrlBase.lang)"
        let daysUrl = "\(UrlBase.urlDays)lat=\(lat)&lon=\(lon)&appid=\(UrlBase.appid)&lang=\(UrlBase.lang)"
        
        Observable.zip(WebService.loadWeather(url: todayUrl, method: .get), WebService.loadWeather(url: daysUrl, method: .get)) { [weak self] (todayData, daysData) in
            guard let self = self else { return }
            let todayResult = try JSONDecoder().decode(TodayWeatherData.self, from: todayData)
            let daysResult = try JSONDecoder().decode(DaysWeatherData.self, from: daysData)
            
            self.weatherVM = WeatherViewModel(todayResult, daysResult)
            self.update()
        }.subscribe().disposed(by: bag)
    }
    private func update() {
        weatherView.setToday(data: weatherVM)
        weatherView.scrollView.weatherTable.reloadData()
    }
    
    @objc func beforerefresh(_ sender: UIBarButtonItem) {
        
        weatherView.beforeRefresh()
        loadData()
    }
}

extension WeatherCasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weatherVM == nil ? 0 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.Identifier, for: indexPath) as? CustomTableViewCell else { fatalError() }
        cell.setValue(data: weatherVM.daysVM, indexPath: indexPath.row)
        
        return cell
    }
}

extension WeatherCasterViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.contentOffset.y < view.frame.height else { return }
        weatherView.backgroundImageView.center.x = view.center.x - (scrollView.contentOffset.y / 20)
        weatherView.blurEffectView.alpha = scrollView.contentOffset.y / view.frame.height
    }
}
