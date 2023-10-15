//
//  CurrentWeatherCollectionViewCell.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/2/23.
//

import UIKit

final class CurrentWeatherCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
    
    var viewModel: ICurrentWeatherCollectionViewCellViewModel? {
        didSet {
            self.temperatureLabel.text = viewModel?.temperature
            self.descriptionLabel.text = viewModel?.description
            self.cityNameLabel.text = viewModel?.cityName
        }
    }
    
    // MARK: - UI Components
    private let cityNameLabel = CustomLabel(titleSize: .largerFontSize)
    private let temperatureLabel = CustomLabel(titleSize: .maxFontSize)
    private let descriptionLabel = CustomLabel(titleSize: .littleFontSize, weight: .regular)
    
    private let weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        contentView.addSubview(weatherStackView)
        weatherStackView.addArrangedSubview(cityNameLabel)
        weatherStackView.addArrangedSubview(temperatureLabel)
        weatherStackView.addArrangedSubview(descriptionLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            weatherStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .offset32),
            weatherStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weatherStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weatherStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.offset32),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        temperatureLabel.text = nil
        descriptionLabel.text = nil
        cityNameLabel.text = nil
    }
}
