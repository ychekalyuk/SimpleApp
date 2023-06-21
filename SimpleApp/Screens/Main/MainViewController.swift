//
//  MainViewController.swift
//  SimpleApp
//
//  Created by Юрий Альт on 20.06.2023.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func showScreen(_ viewController: UIViewController)
    func reloadTableView()
    func hideActivityIndicator()
    func showErrorAlert()
}

final class MainViewController: UIViewController {
    //MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .SimpleApp.Main.tableViewBackground
        tableView.register(ArtistTableViewCell.self, forCellReuseIdentifier: ArtistTableViewCell.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            indicator.style = .gray
        }
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    //MARK: - Public Properties
    var presenter: MainViewPresenterProtocol!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.didLoad()
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCellsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter.getCell(in: tableView, at: indexPath)
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.goToDetailsScreen(at: indexPath)
    }
}

//MARK: - MainViewControllerProtocol
extension MainViewController: MainViewControllerProtocol {
    func showScreen(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showErrorAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Network Error", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}

//MARK: - SetupUI & Layout
private extension MainViewController {
    func setupUI() {
        view.backgroundColor = .SimpleApp.Main.background
        view.addAutolayoutSubviews(tableView, activityIndicator)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
