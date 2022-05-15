//
//  WeatherModel.swift
//  Clima
//
//  Created by Yahya Emad on 12/03/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

//just testing extension concept
extension Double{
    func round(to decimalPlaces:Int)-> Double{
        let precisionVal = pow(10, Double(decimalPlaces))
        var roundedVal = self * precisionVal
        roundedVal.round()
        return roundedVal / precisionVal
    }
}


struct WeatherModel{
    //stores properties
    let temp: Double
    let cityName: String
    let conditionID: Int
    
    // computed property
    var tempString: String {
        let roundedTemp = temp.round(to: 1)
        return String(roundedTemp)
    }
    var conditionName: String {
        switch conditionID{
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "sun.haze"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "sun.max"
        }
    }
}
