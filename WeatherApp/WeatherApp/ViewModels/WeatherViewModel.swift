//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Даниил Павленко on 29.05.2025.
//

import Foundation
import PromiseKit

final class WeatherViewModel {
    private let service = WeatherService()
    private(set) var forecasts: [ForecastDay] = []

    var onDataLoaded: (() -> Void)?
    var onError: ((Error) -> Void)?

    func loadWeather(for city: String) {
        service.fetchWeather(for: city)
            .done { [weak self] days in
                self?.forecasts = days
                self?.onDataLoaded?()
            }
            .catch { [weak self] error in
                self?.onError?(error)
            }
    }
}
