////класс типа Синглтон - обеспечивает повсеместную доступность текущих координат
//  Location.swift
//  rainyShinyCloudy3
//
//  Created by Алик Базин on 06.07.17.
//  Copyright © 2017 Shenshin. All rights reserved.
//

import CoreLocation


class Location {
    static var sharedInstance = Location()
    private init(){}
    
    
    var latitude: Double!
    var longitude: Double!

}
