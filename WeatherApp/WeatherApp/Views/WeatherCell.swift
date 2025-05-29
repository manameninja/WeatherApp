//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Даниил Павленко on 29.05.2025.
//


import UIKit

final class WeatherCell: UITableViewCell {
    private let iconView = UIImageView()
    private let dayLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let tempLabel = UILabel()
    private let windLabel = UILabel()
    private let humidityLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with forecast: ForecastDay) {
        dayLabel.text = forecast.date
        descriptionLabel.text = forecast.day.condition.text
        tempLabel.text = "Temp: \(forecast.day.avgtemp_c)°C"
        windLabel.text = "Wind: \(forecast.day.maxwind_kph) km/h"
        humidityLabel.text = "Humidity: \(forecast.day.avghumidity)%"

        if let iconURL = URL(string: "https:\(forecast.day.condition.icon)") {
            loadImage(from: iconURL)
        }
    }

    private func setupUI() {
        [iconView, dayLabel, descriptionLabel, tempLabel, windLabel, humidityLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        iconView.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 64),
            iconView.heightAnchor.constraint(equalToConstant: 64),
            
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dayLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),

            descriptionLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: dayLabel.leadingAnchor),

            tempLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            tempLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),

            windLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 4),
            windLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),

            humidityLabel.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 4),
            humidityLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            humidityLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.iconView.image = image
                }
            }
        }
    }
}
