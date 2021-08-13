//
//  WeatherStackController.swift
//  Weather with Ilke
//
//  Created by Ilke Yucel on 13.08.2021.
//

import Foundation

private enum API {
    static let key = "1881ec5d8d25a1510f90dc2b5c1f0259"
}

class WeatherStackController: APIServicesController {
    
    let fallbackService: APIServicesController?
    
    required init(fallBackService: APIServicesController? = nil) {
        self.fallbackService = fallBackService
    }
    
    func fetchWeatherData(for city: String, completionHandler: @escaping (String?, APIServiceError?) -> Void) {
        
        
        let endpoint = "http://api.weatherstack.com/current?access_key=\(API.key)&query=\(city)"
        
        guard let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let endPointUrl = URL(string: safeURLString) else {
            completionHandler(nil, APIServiceError.invalidURL(endpoint))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: endPointUrl) { data, response, error in
            
            guard error == nil else {
                if let fallback = self.fallbackService {
                    fallback.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, APIServiceError.error(error!))
                }
                return
            }
            
            guard let responseData = data else {
                if let fallback = self.fallbackService {
                    fallback.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, APIServiceError.invalidPayload(endPointUrl))
                }
                return
            }
            
            
            //decode json
            let decoder = JSONDecoder()
            do {
                let weatherList = try decoder.decode(WeatherStackContainer.self, from: responseData)
                guard let weatherInfo = weatherList.current,
                      let temperature = weatherInfo.temperature,
                      let weatherDescription = weatherInfo.weather_descriptions else {
                    completionHandler(nil, APIServiceError.invalidPayload(endPointUrl))
                    return
                }
            
                let weatherDescriptionText = "\(weatherDescription.first ?? "-") \(temperature) 'F"
                completionHandler(weatherDescriptionText, nil)
            
            } catch let error {
                completionHandler(nil, APIServiceError.error(error))
            }
        }
        
        dataTask.resume()
    }
    
    
}
