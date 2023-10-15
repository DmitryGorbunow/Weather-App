//
//  HourlyWeatherCollectionViewCell.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/2/23.
//

import UIKit

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    static var identifier: String {
        return String(describing: self)
    }
    
    var viewModel: IHourlyWeatherCollectionViewCellViewModel? {
        didSet {
            self.temperatureLabel.text = viewModel?.temperature
            self.timeLabel.text = viewModel?.time
            self.weatherIconImageView.loadImageWithUrl(URL(string: viewModel?.imageUrlString ?? ""))
        }
    }
    
    // MARK: - UI Components
    private let temperatureLabel = CustomLabel(titleSize: .littleFontSize)
    private let timeLabel = CustomLabel(titleSize: .minFontSize)
    
    private let weatherIconImageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherIconImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -(contentView.frame.height / .mainDivider)),
            
            weatherIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: (contentView.frame.height / .mainDivider)),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        temperatureLabel.text = nil
        timeLabel.text = nil
        weatherIconImageView.image = nil
    }
}
