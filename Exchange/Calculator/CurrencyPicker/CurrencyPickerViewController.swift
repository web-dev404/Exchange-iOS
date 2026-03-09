//
//  CurrencyPickerViewController.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 04/03/26.
//

import UIKit

final class CurrencyPickerViewController: UIViewController {
    private lazy var customTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "currencyCell")
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular) // adjust pointSize
        button.setImage(UIImage(systemName: "xmark.circle", withConfiguration: config), for: .normal)
        button.tintColor = .text
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction {[weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
        return button
    }()
    
    weak var delegate: CurrencyPickerDelegate?
    private let viewModel: CurrencyPickerViewModelProtocol = CurrencyPickerViewModel()
    private var activeCurrencyIndex: Int
    
    init(activeCurrencyIndex: Int) {
        self.activeCurrencyIndex = activeCurrencyIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        viewModel.getCurrencies { [weak self] in
            self?.customTableView.reloadData()
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor(named: "Background")
        
        let titleLabel = TextFactory(text: "Choose currency", color: .text, fontWeight: .semibold, fontSize: 24).createText()
        view.addSubview(titleLabel)
        view.addSubview(customTableView)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            customTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            customTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            customTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
        ])
    }
}

extension CurrencyPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
        guard let cell = cell as? CurrencyCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getCurrencyCellViewModel(at: indexPath.row, activeIndex: activeCurrencyIndex)
        return cell
    }
}

extension CurrencyPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCurrency(viewModel.getCurrency(by: indexPath.row))
        dismiss(animated: true)
    }
}
