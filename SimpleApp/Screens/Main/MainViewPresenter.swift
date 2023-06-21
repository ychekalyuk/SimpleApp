//
//  MainViewPresenter.swift
//  SimpleApp
//
//  Created by Юрий Альт on 20.06.2023.
//

import UIKit

protocol MainViewPresenterProtocol {
    func didLoad()
    func getCellsCount() -> Int
    func getCell(in tableView: UITableView, at index: IndexPath) -> UITableViewCell
    func goToDetailsScreen(at indexPath: IndexPath)
}

final class MainViewPresenter {
    weak var view: MainViewControllerProtocol?
    
    private let searchService: SearchServiceProtocol
    private var items: [Media] = []
    
    init(view: MainViewControllerProtocol, searchService: SearchServiceProtocol) {
        self.view = view
        self.searchService = searchService
    }
}

//MARK: - MainViewPresenterProtocol
extension MainViewPresenter: MainViewPresenterProtocol {
    func didLoad() {
        fetchData()
    }
    
    func getCellsCount() -> Int {
        items.count
    }
    
    func getCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistTableViewCell.cellIdentifier,
                                                       for: indexPath) as? ArtistTableViewCell else { return UITableViewCell() }
        cell.configure(with: item)
        return cell
    }
    
    func goToDetailsScreen(at indexPath: IndexPath) {
        let item = items[indexPath.row]
        let detailsViewController = DetailsViewController()
        let detailsViewPresenter = DetailsViewPresenter(view: detailsViewController, model: item)
        detailsViewController.presenter = detailsViewPresenter
        view?.showScreen(detailsViewController)
    }
}

private extension MainViewPresenter {
    func fetchData() {
        searchService.search { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let responseData = try JSONDecoder().decode(Results.self, from: response.data)
                    self.items = responseData.results
                    self.view?.reloadTableView()
                    self.view?.hideActivityIndicator()
                    print(responseData)
                } catch(let error) {
                    print("Error decoding response data from search Response - \(error)")
                }
            case .failure(let error):
                self.view?.hideActivityIndicator()
                self.view?.showErrorAlert()
                print(error.localizedDescription)
            }
        }
    }
}





//https://itunes.apple.com/search?term=LP
