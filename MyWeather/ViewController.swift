//
//  ViewController.swift
//  MyWeather
//
//  Created by daanff on 2021-08-13.
//https://www.youtube.com/watch?v=Xc6q_JltHSI
// 22:34

import UIKit
import MapKit
import CoreLocation
//Location: CoreLocation
// table view
// custom cell: collection view
//API / Request to get the data

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{

    @IBOutlet var table: UITableView!
    
    var models = [Weather]()
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register 2 cells
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
    
        table.delegate = self
        table.dataSource = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }

    //Location
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = "http://api.weatherapi.com/v1/forecast.json?key=ef3f3c79ddab4ca4aa3232755210702&q=\(long),\(lat)&days=7"
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, responds, error in
            // Validation
            
            guard let data = data,
                  error == nil,
                  let result = try? JSONDecoder().decode(Weather.self, from: data)
                    else {
                print("something went wrong")
                return
            }
            print(result)
//            print(data)
            // Convert data to models / some object
            
            // Update user interface
            
        
        }).resume()
        print("\(long) | \(lat)")
    }
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

struct Weather: Codable{
    var current: CurrentWeather
    var forecast: Forecast
    enum CodingKeys: String, CodingKey {
        case current, forecast
    }
}

struct CurrentWeather: Codable{
    var lastUpdated: String
    var tempC: Double
    var windMph: Double
    var windDir: String
    var humidity: Double
    var cloud: Int
    var feelslikeC: Double
    var uv: Double
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated", tempC = "temp_c", windMph = "wind_mph",
             windDir = "wind_dir", humidity, cloud, feelslikeC = "feelslike_c", uv
    }
}

struct Forecast: Codable{
    var forecastday: [Forecastday]
    enum CodingKeys: String, CodingKey {
        case forecastday
    }
}

struct Forecastday: Codable{
    var date: String
    var day: Day
    enum CodingKeys: String, CodingKey {
        case date, day
    }
}

struct Day: Codable{
    var maxtempC: Double
    var mintempC: Double
    var dailyWillItRain: Double
    var dailyChanceOfRain: Double
    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c", mintempC = "mintemp_c", dailyWillItRain = "daily_will_it_rain", dailyChanceOfRain = "daily_chance_of_rain"
    }
}

