//
//  WeatherViewModel.swift
//  Weather with Ilke
//
//  Created by Ilke Yucel on 13.08.2021.
//

import Foundation

class WeatherViewModel: ObservableObject {
 
    private let weatherService = OpenWeatherMapController(fallBackService: WeatherStackController())
    
    @Published var weatherInfo = ""
    
    func fetch(city: String) {
        weatherService.fetchWeatherData(for: city) { info, error in
            guard error == nil,
                  let weatherInfo = info else {
                //For update UI on main thread
                DispatchQueue.main.async {
                    self.weatherInfo = "Could not retrieve weather information for \(city)"
                }
                return
            }
            DispatchQueue.main.async {
                self.weatherInfo = weatherInfo
            }
        }
    }
}
