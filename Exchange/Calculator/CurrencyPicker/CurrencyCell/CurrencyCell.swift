//
//  CurrencyCell.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 05/03/26.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    private lazy var currencyIconView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .secondaryBackground
        image.layer.cornerRadius = 10
        image.contentMode = .center
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return image
    }()
        
    private lazy var currencyRadio: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 24).isActive = true
        image.heightAnchor.constraint(equalToConstant: 24).isActive = true
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 12
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.borderSecondary.cgColor
        return image
    }()
    
    private let currencyLabel = TextFactory(text: "", color: .text, fontWeight: .semibold, fontSize: 16).createText()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var viewModel: CurrencyCellViewModelProtocol! {
        didSet {
            currencyLabel.text = viewModel.currencyName
            currencyIconView.image = UIImage(named: viewModel.currencyIcon)
            setSelected(viewModel.isSelected)
        }
    }
    
    private func setupLayout() {
        contentView.heightAnchor.constraint(equalToConstant: 62).isActive = true
        
        contentView.addSubview(currencyIconView)
        contentView.addSubview(currencyLabel)
        contentView.addSubview(currencyRadio)
        
        NSLayoutConstraint.activate([
            currencyIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currencyLabel.leadingAnchor.constraint(equalTo: currencyIconView.trailingAnchor, constant: 8),
            currencyRadio.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            currencyIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currencyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currencyRadio.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            currencyRadio.image = UIImage(systemName: "checkmark.circle.fill")
            currencyRadio.tintColor = .contentBrand
        } else {
            currencyRadio.image = nil
            currencyRadio.layer.borderWidth = 2
        }
    }
}
