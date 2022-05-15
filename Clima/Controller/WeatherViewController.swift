//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    //Outlets
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //properties
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var lat:CLLocationDegrees = 0.0
    var long:CLLocationDegrees = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //you need to set the delegate before calling the functions
        locationManager.delegate = self
        
        //permission request
        locationManager.requestWhenInUseAuthorization()
        
        //request location once
        locationManager.requestLocation()
        
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //normally it dismisses the keyboard
        searchTextField.endEditing(true)
    }
    
    //Handles if the return key is pressed to do some functionality
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
    
    
    //make sure if you actually should be considered to have ended editing before calling the didEndEditing method
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else{
            textField.placeholder = "Type Something!"
            return false
        }
    }
    
    
    //Handles the moment when editing has been actually confirmed to be ended
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(textField.text!)
        //TODO: Here we will be passing our cityName to parse back its weather
        weatherManager.fetchWeather(for: textField.text!)
        textField.text = ""
        textField.placeholder = "Search"
    }
    
    
}


//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.cityName
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            print("latitude: \(lat)")
            print("longitude: \(long)")
            weatherManager.fetchWeather(lat, long)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
