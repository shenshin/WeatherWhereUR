//
//  ViewController.swift
//  Pogoda
//
//  Created by Алик Базин on 04.07.17.
//  Copyright © 2017 Shenshin. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import GooglePlaces
import MapKit


/// Это кошмарный класс, который против всех правил делает всё
class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var currentWeatherImage: UIImageView!
    
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    
    var forecasts: [Forecast] = Array()
    
    var myPlacesClient: GMSPlacesClient! //GooglePlaces
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        currentWeather = CurrentWeather()
        
        myPlacesClient = GMSPlacesClient.shared() //создает экземпляр GooglePlaces
    }
    
    //Запускает самую важную функцию locationAuthStatus, которая делает всё
    //и это не правильно!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        locationAuthStatus()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //количество строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    //заполняет строки таблицы содержимым прогноза погоды на 16 дней
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell
        {
            let forecast = self.forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
        
        
    }
    
    ///Устанавливает разрешение на чтение местоположения -1, а также:
    ///Загружает сведения о текущей погоде -2
    ///Загружает сведения о прогнозе погоды на 16 дней -3
    ///Загружает текущее местоположение locationLabel.text -4
    ///Заполняет сведения о текущей погоде -5
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            self.currentWeather.downloadWeatherDetails { //2
                self.downloadForecastData { //3
                    self.updateMainUI() //5
                    self.getPlace() //4
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization() //1
            locationAuthStatus() //рекурсия
        }
    }
    
    //установка параметров погоды на текущую дату (кроме местоположения) (5)
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)℃"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
    //загрузка прогноза погоды на 16 дней (3)
    func downloadForecastData(completed: @escaping DownloadComplete) {
        
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String,AnyObject>] {
                    
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)  
                    }
                    //удаляю первый элемент, т.к. он уже отображается в шапке страницы
                    self.forecasts.removeFirst()
                    self.tableView.reloadData()//без этой функции не грузит прогноз (загадочно)
                }
            }
            completed()
        }
    }
    
    
    //это гугловская функция, разобранная на вызывающую и вызываемую (callback)
    ///Эти две функции вместе заполняют реальное текущее местоположение locationLabel (4)
    func getPlace(){
        myPlacesClient.currentPlace(callback: cb)
    }
    func cb (mesta: GMSPlaceLikelihoodList!, error: Error!){
        if let oshibka = error {
            print("Pick Place error: \(oshibka.localizedDescription)")
            return
        }
        
        if let places = mesta {
            let place = places.likelihoods.first?.place
            if let firstPlace = place {
                self.locationLabel.text = firstPlace.formattedAddress?.components(separatedBy: ", ")
                    .joined(separator: "\n")
            }
        }
    }
    
}


