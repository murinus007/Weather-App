//
//  ViewController.swift
//  Weather App
//
//  Created by Alexey Sergeev on 26.10.2021.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, MainViewControllerDelegate {
    func didTapPlace(with location: CLLocation) {
        weatherService.getCurrentLocationWeather(location: location, completion: { [weak self] weather in
            self?.configureUI(with: weather)
        })
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    let weatherService = WeatherServiceImpl()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    
    @IBAction func selectLocation(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let selectLocationViewController = storyBoard.instantiateViewController(withIdentifier: "selectLocation") as! SelectLocationsViewController
        selectLocationViewController.delegate = self
        
       let navigationController = UINavigationController(rootViewController: selectLocationViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func configureUI(with weather: Weather) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm"
        
        cityLabel.text = weather.name
        tempLabel.text = String(Int(weather.main.temp.rounded())) + " °C"
        descriptionLabel.text = weather.weather.first?.weatherDescription
        minTempLabel.text = "min: " + String(Int(weather.main.tempMin.rounded())) + " °C"
        maxTempLabel.text = "max: " + String(Int(weather.main.tempMax.rounded())) + " °C"
        humidityLabel.text = "humidity: " + String(weather.main.humidity) + "%"
        pressureLabel.text = "pressure: " + String(weather.main.pressure) + " mbar"
        sunriseLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: weather.sys?.sunrise ?? 0))
        sunsetLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: weather.sys?.sunset ?? 0))
        changeBackgroundImage(weather: weather)
    }
    
    func changeBackgroundImage(weather: Weather) {
        let date = Date()
        if date.timeIntervalSince1970 > weather.sys?.sunset ?? 0 {
            backgroundImageView.image = UIImage(named: "night_img")
        } else {
            backgroundImageView.image = UIImage(named: "day_img")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        weatherService.getCurrentLocationWeather(location: locations.first,
                                                 completion: { [weak self] weather in
            self?.configureUI(with: weather)
        })
    }

}

