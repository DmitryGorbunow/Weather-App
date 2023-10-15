//
//  DailyWeatherCollectionViewCell.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/2/23.
//

import UIKit

// MARK: - Constants
private extension CGFloat {
    static let borderWidth = 2.0
}

final class DailyWeatherCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
    
    var viewModel: IDailyWeatherCollectionViewCellViewModel? {
        didSet {
            self.temperatureLabel.text = viewModel?.temperature
            self.dateLabel.text = viewModel?.date
        }
    }
    
    // MARK: - UI Components
    private let temperatureLabel = CustomLabel(titleSize: .littleFontSize)
    private let dateLabel = CustomLabel(titleSize: .littleFontSize)

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
        contentView.layer.borderWidth = .borderWidth
        contentView.layer.borderColor = UIColor.systemGray6.cgColor
        contentView.addSubview(dateLabel)
        contentView.addSubview(temperatureLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .offset32),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.offset32),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        temperatureLabel.text = nil
    }
}
