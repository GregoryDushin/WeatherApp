//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Григорий Душин on 26.01.2022.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp : Double
    
}
struct Weather: Codable {
    let id: Int
}
