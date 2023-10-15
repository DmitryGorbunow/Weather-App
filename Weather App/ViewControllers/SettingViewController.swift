//
//  SettingViewController.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/10/23.
//

import UIKit

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: ISettingViewModel = SettingViewModel()
    
    // MARK: - UI Components
    private let cityTextField = CustomTextField()
    private let okButton = CustomButton(title: .ok, size: .normal)
    private let locationSwitchLabel = CustomLabel(title: "Определение по геолокации", titleSize: .minFontSize)
    
    private lazy var locationSwitch: UISwitch = {
        let locationSwitch = UISwitch()
        locationSwitch.onTintColor = UIColor.systemIndigo
        locationSwitch.isOn = true
        locationSwitch.addTarget(self, action: #selector(locationSwitchSwitched), for: .touchUpInside)
        locationSwitch.translatesAutoresizingMaskIntoConstraints = false
        return locationSwitch
    }()
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        cityTextField.delegate = self
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        activateKeyboardRemoval()
        setLocationSwitch()
        view.addSubview(okButton)
        view.addSubview(cityTextField)
        view.addSubview(locationSwitch)
        view.addSubview(locationSwitchLabel)
        setupConstraints()
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .offset64),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset32),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset32),
            cityTextField.heightAnchor.constraint(equalToConstant: .mainSize),
            
            locationSwitch.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: .offset32),
            locationSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset32),
            
            locationSwitchLabel.centerYAnchor.constraint(equalTo: locationSwitch.centerYAnchor),
            locationSwitchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset32),
            
            okButton.heightAnchor.constraint(equalToConstant: .mainSize),
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .offset32),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.offset32),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.mainSize),
        ])
    }
    
    private func setLocationSwitch() {
        let city = DataManager.shared.getCity(key: .cityKey)
        
        if let city = city {
            locationSwitch.isOn = false
            cityTextField.text = city
        } else {
            locationSwitch.isOn = true
        }
    }
    
    private func activateKeyboardRemoval() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - @objc Methods
    @objc private func okButtonTapped() {
        viewModel.okButtonTapped()
        if viewModel.canDismiss {
            dismiss(animated: true)
        } else {
            AlertManager.showInvalidCityAlert(on: self)
        }
    }
    
    @objc private func locationSwitchSwitched() {
        cityTextField.text = ""
        viewModel.changeDetectionMethod(value: locationSwitch.isOn)
        viewModel.setCity(name: cityTextField.text)
    }
}

// MARK: - UITextFieldDelegate
extension SettingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.setCity(name: textField.text)
        locationSwitch.isOn = false
        viewModel.changeDetectionMethod(value: locationSwitch.isOn)
    }
}
