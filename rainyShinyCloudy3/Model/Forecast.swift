//  Прогноз погоды на 16 дней
//  Forecast.swift
//  rainyShinyCloudy3
//
//  Created by Алик Базин on 04.07.17.
//  Copyright © 2017 Shenshin. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    private var _date: String!
    private var _weatherType: String!
    private var _lowTemp: Double!
    private var _highTemp: Double!
    private var _icon: String!
    
    var icon: String {
        get {
            if _icon == nil {
                _icon = ""
            }
        return _icon
        }
    }
    
    var date: String {
    get {
        if _date == nil {
            _date = ""
        }
        return _date
        }
    }
    
    var weatherType: String {
        get {
            if _weatherType == nil {
               _weatherType = ""
            }
            return _weatherType
        }
    }
    
    var lowTemp: Double {
        get {
            if _lowTemp == nil {
               _lowTemp = 0.0
            }
            return _lowTemp
        }
    }
    
    var highTemp: Double {
        get {
            if _highTemp == nil {
               _highTemp = 0.0
            }
            return _highTemp
        }
    }
    
    init(weatherDict: Dictionary<String,AnyObject>){
        
        if let temp = weatherDict["temp"] as? Dictionary<String,AnyObject> {
            if let min = temp["min"] as? Double {
                self._lowTemp = min
            }
            if let max = temp["max"] as? Double {
                self._highTemp = max
            }
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String,AnyObject>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
            if let ico = weather[0]["icon"] as? String {
                self._icon = ico
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            self._date = dateFormatter.string(from: unixConvertedDate).capitalized
        }
        
    }
    
}


