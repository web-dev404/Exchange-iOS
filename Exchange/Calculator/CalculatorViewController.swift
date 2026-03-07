//
//  CalculatorViewController.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 27/02/26.
//

import UIKit

final class CalculatorViewController: UIViewController {
    private let exchangeRateLabel = TextFactory(text: "--", color: .contentBrand, fontWeight: .semibold, fontSize: 16).createText()

    private lazy var textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var swapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.backgroundColor = .contentBrand
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let fromCardView = CurrencyCardView()
    private let toCardView = CurrencyCardView()
    
    private var viewModel: CalculatorViewModelProtocol = CalculatorViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        fromCardView.viewModel = CurrencyCardViewModel(
            currency: viewModel.state.fromCurrency,
            amount: viewModel.state.fromAmount.formatted(),
            isChangeable: false
        )
        
        toCardView.viewModel = CurrencyCardViewModel(
            currency: viewModel.state.toCurrency,
            amount: viewModel.state.toAmount.formatted(),
            isChangeable: true
        )
        
        toCardView.onSelectTapped = { [weak self] in
            self?.openBottomSheet()
        }
        
        Task {
            await viewModel.fetchExchangeRate()
            
            self.exchangeRateLabel.text = "1 USDc = \(self.viewModel.state.exchangeRate?.ask.formatted() ?? "--") \(self.viewModel.state.toCurrency.name)"
        }
        
        viewModel.onError = { [weak self] in
            let alert = UIAlertController(
                title: "Ошибка",
                message: "Не удалось загрузить текущий курс",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
        
    private func setupLayout() {
        view.backgroundColor = UIColor(named: "Background")
        let calcTitle = TextFactory(
            text: "Exchange calculator",
            color: .text,
            fontWeight: .bold,
            fontSize: 30
        ).createText()

        view.addSubview(fromCardView)
        view.addSubview(toCardView)
        view.addSubview(textStack)
        view.addSubview(swapButton)
        textStack.addArrangedSubview(calcTitle)
        textStack.addArrangedSubview(exchangeRateLabel)
                
        NSLayoutConstraint.activate([
            textStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            textStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            fromCardView.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 24),
            fromCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fromCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            toCardView.topAnchor.constraint(equalTo: fromCardView.bottomAnchor, constant: 16),
            toCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            toCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            swapButton.topAnchor.constraint(equalTo: fromCardView.bottomAnchor, constant: -4),
            swapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func openBottomSheet() {
        let pickerVC = CurrencyPickerViewController()
        
        if let sheet = pickerVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 32
        }
        
        present(pickerVC, animated: true)
    }
}
