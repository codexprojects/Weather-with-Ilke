//
//  APIServicesController.swift
//  Weather with Ilke
//
//  Created by Ilke Yucel on 13.08.2021.
//

import Foundation

public enum APIServiceError: Error {
    case invalidURL(String)
    case invalidPayload(URL)
    case error(Error)
}

public protocol APIServicesController {
    init(fallBackService: APIServicesController?)
    
    var fallbackService: APIServicesController? { get }
    
    func fetchWeatherData(for city:String,
                          completionHandler: @escaping (String?, APIServiceError?) -> Void)
}
