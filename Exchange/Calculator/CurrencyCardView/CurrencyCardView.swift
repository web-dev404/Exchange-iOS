//
//  CurrencyCardView.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 05/03/26.
//

import UIKit

final class CurrencyCardView: UIView {
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var currencyIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.heightAnchor.constraint(equalToConstant: 16).isActive = true
        image.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return image
    }()
        
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var currencyTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 16, weight: .bold)
        textField.placeholder = "0"
        return textField
    }()
    
    private lazy var chevronDown: UIImageView = {
        let chevron = UIImageView()
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.image = UIImage(systemName: "chevron.down")
        chevron.tintColor = .black
        return chevron
    }()
    
    private var tapGesture: UITapGestureRecognizer?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    var viewModel: CurrencyCardViewModelProtocol! {
        didSet {
            currencyIcon.image = UIImage(named: viewModel.currencyIcon)
            currencyLabel.text = viewModel.currencyName
            currencyTextField.text = viewModel.amount
            chevronDown.isHidden = !viewModel.isChangeable
            
            if viewModel.isChangeable {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(selectTapped))
                leftStackView.addGestureRecognizer(gesture)
                leftStackView.isUserInteractionEnabled = true
                tapGesture = gesture
            } else {
                if let gesture = tapGesture {
                    leftStackView.removeGestureRecognizer(gesture)
                    tapGesture = nil
                }
                leftStackView.isUserInteractionEnabled = false
            }
        }
    }
    
    private func setupLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.heightAnchor.constraint(equalToConstant: 66).isActive = true
        
        addSubview(currencyTextField)
        addSubview(leftStackView)
        leftStackView.addArrangedSubview(currencyIcon)
        leftStackView.addArrangedSubview(currencyLabel)
        leftStackView.addArrangedSubview(chevronDown)
        
        currencyTextField.delegate = self
                
        NSLayoutConstraint.activate([
            leftStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            currencyTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            leftStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            currencyTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    // Отправляем знак родителю, что нажали на открытие bottom sheet
    @objc private func selectTapped() { onSelectTapped?() }
    var onSelectTapped: (() -> Void)?
    
    // Отправляем то, что ввели в инпут родителю
    var onAmountChanged: ((String) -> Void)?
    
    // Обновить значение инпута
    func updateAmount(_ amount: String) {
        currencyTextField.text = amount
    }
}

// MARK: - UITextFieldDelegate
extension CurrencyCardView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        onAmountChanged?(newText)
        return true
    }
}
