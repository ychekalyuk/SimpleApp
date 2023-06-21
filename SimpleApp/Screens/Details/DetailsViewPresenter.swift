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
    private let model: Media
    
    init(view: DetailsViewControllerProtocol, model: Media) {
        self.view = view
        self.model = model
    }
}

//MARK: - DetailsViewPresenterProtocol
extension DetailsViewPresenter: DetailsViewPresenterProtocol {
    func didLoad() {
        view?.loadUI(with: model)
    }
}
