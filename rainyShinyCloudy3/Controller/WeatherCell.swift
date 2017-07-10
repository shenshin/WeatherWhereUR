//  Заполняет строки таблицы с прогнозом погоды
//  WeatherCell.swift
//  rainyShinyCloudy3
//
//  Created by Алик Базин on 05.07.17.
//  Copyright © 2017 Shenshin. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    func configureCell (forecast: Forecast){
        lowTemp.text = "\(forecast.lowTemp)"
        highTemp.text = "\(forecast.highTemp)"
        weatherType.text = forecast.weatherType
        dayLabel.text = forecast.date
        weatherIcon.image = UIImage(named: "\(forecast.weatherType) Mini")
    }



}
