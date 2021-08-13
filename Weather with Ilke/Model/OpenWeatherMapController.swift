//
//  OpenWeatherMapController.swift
//  Weather with Ilke
//
//  Created by Ilke Yucel on 13.08.2021.
//

import Foundation

private enum API {
    static let key = "dcdac3c54428b2eed1c7cf28b28d6695"
}

class OpenWeatherMapController: APIServicesController {
    
    let fallbackService: APIServicesController?
    
    required init(fallBackService: APIServicesController? = nil) {
        self.fallbackService = fallBackService
    }
    
    func fetchWeatherData(for city: String, completionHandler: @escaping (String?, APIServiceError?) -> Void) {
        let endpoint = "https://api.openweathermap.org/data/2.5/find?q=\(city)&units=imperial&appid=\(API.key)"
        
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
                let weatherList = try decoder.decode(OpenWeatherMapContainer.self, from: responseData)
                guard let weatherInfo = weatherList.list?.first,
                      let weather = weatherInfo.weather.first?.main,
                      let temperature = weatherInfo.main.temp else {
                    completionHandler(nil, APIServiceError.invalidPayload(endPointUrl))
                    return
                }
            
                let weatherDescription = "\(weather) \(temperature) 'F"
                completionHandler(weatherDescription, nil)
            
            } catch let error {
                completionHandler(nil, APIServiceError.error(error))
            }
        }
        
        dataTask.resume()
        
    }
    
    
}
