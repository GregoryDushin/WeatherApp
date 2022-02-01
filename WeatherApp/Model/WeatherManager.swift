//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Григорий Душин on 22.01.2022.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather( _ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=a40b0664fbaf7371a76ca3be548eda20"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print (urlString)
       performRequest(urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print (urlString)
        performRequest(urlString)
    }
    func performRequest(_ urlString: String) {
        //1.Create a URL
        if let url = URL(string: urlString) {
            //2.Create a URLSession
            
            let session = URLSession(configuration: .default)
            //3.Give the session the task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safedata = data {
                    if let weather =  self.parsJSON(weatherData: safedata) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4.Start the task
            
            task.resume()
        }
        
    }
    
    func parsJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
       let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
}

}
