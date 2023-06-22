//
//  MainViewPresenter.swift
//  SimpleApp
//
//  Created by Юрий Альт on 20.06.2023.
//

import UIKit
import Alamofire
import Kingfisher

protocol MainViewPresenterProtocol {
    func didLoad()
    func getCellsCount() -> Int
    func getCell(in tableView: UITableView, at index: IndexPath) -> UITableViewCell
    func goToDetailsScreen(at indexPath: IndexPath)
    func checkInternetConnection() -> Bool
}

final class MainViewPresenter {
    weak var view: MainViewControllerProtocol?
    
    private let searchService: SearchServiceProtocol
    private let networkReachabilityService = NetworkReachabilityManager()
    private var items: [Media] = []
    private var savedItems: [SavedMedia] = []
    
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
        checkInternetConnection() ? items.count : savedItems.count
    }
    
    func getCell(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        if !checkInternetConnection() {
            let savedItem = savedItems[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistTableViewCell.cellIdentifier,
                                                           for: indexPath) as? ArtistTableViewCell else { return UITableViewCell() }
            cell.configure(savedItem: savedItem)
            return cell
        } else {
            let item = items[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistTableViewCell.cellIdentifier,
                                                           for: indexPath) as? ArtistTableViewCell else { return UITableViewCell() }
            cell.configure(item: item)
            return cell
        }
    }
    
    func goToDetailsScreen(at indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        let detailsViewPresenter = DetailsViewPresenter(view: detailsViewController, isOnline: checkInternetConnection())
        if checkInternetConnection() {
            let item = items[indexPath.row]
            detailsViewPresenter.model = item
        } else {
            let savedItem = savedItems[indexPath.row]
            detailsViewPresenter.savedModel = savedItem
        }
        
        detailsViewController.presenter = detailsViewPresenter
        view?.showScreen(detailsViewController)
    }
    
    func checkInternetConnection() -> Bool {
        networkReachabilityService?.isReachable ?? false
    }
}

private extension MainViewPresenter {
    func fetchData() {
        guard checkInternetConnection() else {
            view?.showErrorAlert()
            StorageService.shared.fetchData { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let savedItems):
                    self.savedItems = savedItems
                    self.view?.reloadTableView()
                    self.view?.hideActivityIndicator()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            return
        }
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
                    StorageService.shared.clearDataBase()
                    self.items.forEach { item in
                        self.getData(from: item.artworkUrl100 ?? "") { data in
                            StorageService.shared.save(artistName: item.artistName ?? "",
                                                       trackName: item.trackName ?? "",
                                                       artworkUrl100: data ?? Data())
                        }
                    }
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
    
    func getData(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        KingfisherManager.shared.downloader.downloadImage(with: url, options: [], progressBlock: nil) { result in
            switch result {
            case .success(let value):
                completion(value.originalData)
            case .failure(let error):
                print("Failed to download image: \(error)")
                completion(nil)
            }
        }
    }
    
}
