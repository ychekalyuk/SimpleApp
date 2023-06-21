//
//  SearchService.swift
//  SimpleApp
//
//  Created by Юрий Альт on 21.06.2023.
//

import Moya

protocol SearchServiceProtocol {
    func search(completion: @escaping (Result<Response, MoyaError>) -> Void)
}

class SearchService: SearchServiceProtocol {
    let provider = MoyaProvider<SearchAPI>()
    
    func search(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.search(), completion: completion)
    }
}
