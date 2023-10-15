//
//  ViewController.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/1/23.
//

import UIKit

// MARK: - Constants
private extension CGFloat {
    static let mainFractionalSize = 1.0
    static let additionalFractionalSize = 0.75
    static let minFractionalSize = 0.22
    static let mainAbsoluteSize = 150.0
    static let additionalAbsoluteSize = 100.0
    static let mainOffset = 3.0
}

private enum Constants {
    static let numberOfSections: Int = 3
    static let itemsInCurrentWeatherSection: Int = 1
    static let itemsInDailyWeatherSection: Int = 4
}

final class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: IWeatherViewModel = WeatherViewModel()
    
    // MARK: - UI Components
    private var weatherCollectionView: UICollectionView?
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(pointSize: .bigFontSize, weight: .regular)), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.clearData()
        viewModel.getWeather()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        createCollectionView()
        view.addSubview(settingButton)
        setupLoadingIndicator()
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .offset8),
            settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset8),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.color = .lightGray
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViewModelObserver() {
        viewModel.currentWeather.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.weatherCollectionView?.reloadData()
            }
        }
        
        viewModel.threeHourWeather.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.weatherCollectionView?.reloadData()
            }
        }
        
        viewModel.isSearching.bind { [weak self] (isSearching) in
            guard let isSearching = isSearching else { return }
            DispatchQueue.main.async {
                isSearching ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.startAnimating()
                self?.loadingIndicator.isHidden = !isSearching
            }
        }
    }
    
    private func createCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.layout(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(CurrentWeatherCollectionViewCell.self, forCellWithReuseIdentifier: CurrentWeatherCollectionViewCell.identifier)
        collectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.identifier)
        collectionView.register(HourlyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.identifier)
        self.weatherCollectionView = collectionView
    
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .offset16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func layout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let section = WeatherSection.allCases[sectionIndex]
        
        switch section {
        case .current:
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(.mainFractionalSize),
                heightDimension: .fractionalHeight(.mainFractionalSize)
            ))
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(.mainFractionalSize), heightDimension: .fractionalWidth(.additionalFractionalSize)),
                subitems: [item]
            )
            
            return NSCollectionLayoutSection(group: group)
        case .hourly:
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(.mainFractionalSize),
                heightDimension: .fractionalHeight(.mainFractionalSize)
            ))
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(.minFractionalSize),
                                  heightDimension: .absolute(.mainAbsoluteSize)),
                subitems: [item]
            )
            
            let section =  NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .daily:
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(.mainFractionalSize),
                heightDimension: .fractionalHeight(.mainFractionalSize)
            ))
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: .fractionalWidth(.mainFractionalSize),
                                  heightDimension: .absolute(.additionalAbsoluteSize)),
                subitems: [item]
            )
            group.contentInsets = .init(top: .mainOffset, leading: 0, bottom: .mainOffset, trailing: 0)
            
            return NSCollectionLayoutSection(group: group)
        }
    }
    
    // MARK: - @objc Methods
    @objc private func settingButtonTapped() {
        let vc = SettingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Constants.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Constants.itemsInCurrentWeatherSection
        case 1:
            return viewModel.threeHourWeather.value?.list.count ?? 0
        case 2:
            return Constants.itemsInDailyWeatherSection
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = weatherCollectionView?.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCollectionViewCell.identifier, for: indexPath) as? CurrentWeatherCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.currentWeatherCellViewModel()
            return cell
        case 1:
            guard let cell = weatherCollectionView?.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier, for: indexPath) as? HourlyWeatherCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.hourlyWeatherCellViewModel(at: indexPath)
           
            return cell
        case 2:
            guard let cell = weatherCollectionView?.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.identifier, for: indexPath) as? DailyWeatherCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel.dailyWeatherCellViewModel(at: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}


