//
//  DetaisViewPresenter.swift
//  SimpleApp
//
//  Created by Юрий Альт on 20.06.2023.
//


protocol DetailsViewPresenterProtocol {
    func didLoad()
}

final class DetailsViewPresenter {
    
    weak var view: DetailsViewControllerProtocol?
    var model: Media = Media(artistName: "", trackName: "", artworkUrl100: "")
    var savedModel: SavedMedia = SavedMedia()
    private var isOnline: Bool
    
    init(view: DetailsViewControllerProtocol, isOnline: Bool) {
        self.view = view
        self.isOnline = isOnline
    }
}

//MARK: - DetailsViewPresenterProtocol
extension DetailsViewPresenter: DetailsViewPresenterProtocol {
    func didLoad() {
        isOnline ? view?.loadUI(with: model) : view?.loadUI(savedMedia: savedModel)
    }
}
