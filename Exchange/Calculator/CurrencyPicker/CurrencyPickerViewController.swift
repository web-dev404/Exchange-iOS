//
//  CurrencyPickerViewController.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 04/03/26.
//

import UIKit

final class CurrencyPickerViewController: UIViewController {
    private lazy var titleLabel = TextFactory(text: "Choose currency", color: .text, fontWeight: .semibold, fontSize: 24).createText()
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
    
    private var viewModel: CurrencyPickerViewModelProtocol! {
        didSet {
            viewModel.getCurrencies { [weak self] in
                self?.customTableView.reloadData()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CurrencyPickerViewModel()
        
        view.backgroundColor = UIColor(named: "Background")
        
        view.addSubview(titleLabel)
        view.addSubview(customTableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            customTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            customTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            customTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
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
        cell.viewModel = viewModel.getCurrencyCellViewModel(at: indexPath.row)
        return cell
    }
}

extension CurrencyPickerViewController: UITableViewDelegate {
    
}
