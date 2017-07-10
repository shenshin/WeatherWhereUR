//
//  Constants.swift
//  Pogoda
//
//  Created by Алик Базин on 04.07.17.
//  Copyright © 2017 Shenshin. All rights reserved.
//

import Foundation

let units = "metric"
let language = "ru"
let API_KEY = "39ed13c579ea7a1447e1b92059983746"
let latitude = Location.sharedInstance.latitude!
let longitude = Location.sharedInstance.longitude!

let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=\(units)&lang=\(language)&appid=\(API_KEY)"

let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&units=\(units)&lang=\(language)&cnt=16&appid=\(API_KEY)"

typealias DownloadComplete = () -> ()



