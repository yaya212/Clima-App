//
//  WeatherManager.swift
//  Clima
//
//  Created by Yahya Emad on 10/03/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager {
    let requestURL = "https://api.openweathermap.org/data/2.5/weather?appid=b36c74cfbe53c647e42a4fd233021a30&units=metric"
    var delegate:WeatherManagerDelegate?
    
    func fetchWeather(for cityName: String){
        let URLString = "\(requestURL)&q=\(cityName)"
        performRequest(for:URLString)
    }
    
    func performRequest(for url:String){
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                // Where $0 refers to data return from the task if exists, $1 refers to urlResponse if exists & $2 refers to error if exists
                if error != nil{
                    //It is better to hand the error back to the controller and manage it there.
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = parseJSON(for: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(for data:Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            let id = weatherData.weather[0].id
            let name = weatherData.name
            let temperature = weatherData.main.temp
            
            let weatherModel = WeatherModel(temp: temperature, cityName: name, conditionID: id)
            return weatherModel
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}


//MARK: - extending the WeatherManager to fetchWeather using GPS
extension WeatherManager{
    func fetchWeather(_ Latitude:CLLocationDegrees, _ Logitude:CLLocationDegrees){
        let URLString = "\(requestURL)&lat=\(Latitude)&lon=\(Logitude)"
        performRequest(for:URLString)
    }
}
