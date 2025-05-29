//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Даниил Павленко on 29.05.2025.
//

import Foundation
import PromiseKit

final class WeatherService {
    private let apiKey = "517c84005e2c4552a7164414232809"
    private let baseURL = "https://api.weatherapi.com/v1/forecast.json"

    func fetchWeather(for city: String) -> Promise<[ForecastDay]> {
        let urlString = "\(baseURL)?q=\(city)&days=4&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return .init(error: URLError(.badURL))
        }
        print(url)
        return Promise { seal in
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    seal.reject(error)
                    return
                }

                guard let data = data else {
                    seal.reject(URLError(.badServerResponse))
                    
                    return
                }

                do {
                    let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    seal.fulfill(response.forecast.forecastday)
                } catch {
                    seal.reject(error)
                }
            }.resume()
        }
    }
}
