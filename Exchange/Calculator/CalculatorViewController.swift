//
//  ViewController.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 27/02/26.
//

import UIKit

final class CalculatorViewController: UIViewController {
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
    
    private lazy var fromCardView = CurrencyCardView()
    private lazy var toCardView = CurrencyCardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Background")
        view.addSubview(fromCardView)
        view.addSubview(toCardView)
        
        fromCardView.viewModel = CurrencyCardViewModel(currency: Currency(name: "USDc", icon: "us"), amount: "9999", isChangeable: false)
        toCardView.viewModel = CurrencyCardViewModel(currency: Currency(name: "MXN", icon: "mxn"), amount: "9299", isChangeable: true)
        
        toCardView.onSelectTapped = { [weak self] in
            self?.openBottomSheet()
        }
        
        setText()
    }
    
    private func setText() {
        view.addSubview(textStack)
        view.addSubview(swapButton)
        
        let calcTitle = TextFactory(text: "Exchange calculator", color: .text, fontWeight: .bold, fontSize: 30).createText()
        let exchangeRateText = TextFactory(text: "1 USDc = 18.4097 MXN", color: .contentBrand, fontWeight: .semibold, fontSize: 16).createText()
        
        textStack.addArrangedSubview(calcTitle)
        textStack.addArrangedSubview(exchangeRateText)
                
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
