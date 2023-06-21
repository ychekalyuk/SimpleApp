//
//  SearchAPI.swift
//  SimpleApp
//
//  Created by Юрий Альт on 21.06.2023.
//

import Moya

enum SearchAPI {
    case search(term: String = "LP")
}

extension SearchAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://itunes.apple.com")!
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .search(let term):
            return .requestParameters(
                parameters: ["term" : term], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        [:]
    }
}

