//  Текущая погода в текущей локации GPS
//  CurrentWeather.swift
//  Pogoda
//
//  Created by Алик Базин on 04.07.17.
//  Copyright © 2017 Shenshin. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    
    var cityName: String {
        get{
            if _cityName == nil {
                _cityName = ""
            }
            return _cityName
        }
    }
    
    
    var date: String {
        get {
            if _date == nil {
                _date = ""
            }
            //день недели
            let dateFormatterWeekday = DateFormatter()
            dateFormatterWeekday.dateFormat = "EEEE"
            let weekDay = dateFormatterWeekday.string(from: Date()).capitalized
            
            //текущая дата (без времени)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            let currentDate = dateFormatter.string(from: Date())
            
            self._date = "\(weekDay), \(currentDate)"
            return self._date
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
    
    
    var currentTemp: Double {
        get {
            if _currentTemp == nil {
                _currentTemp = 0.0
            }
            return _currentTemp
        }
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //загрузка текущей погоды (текущее местоположение - см. Constants.swift)
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    
                    if let currentTemperature = main["temp"] as? Double {
                        self._currentTemp = currentTemperature
                    }
                }
            }
            completed()
        }
    }
    
}

