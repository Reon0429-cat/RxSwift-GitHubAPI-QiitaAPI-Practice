//
//  APIClient.swift
//  RxSwift-GitHubAPI-QiitaAPI-Practice
//
//  Created by 大西玲音 on 2021/11/12.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case unknownError
}

final class APIClient {
    
    func fetchQiitaData() -> Single<[Qiita]> {
        fetchData(urlString: "https://qiita.com/api/v2/items?page=1&per_page=5")
    }
    
    func fetchGitHubData() -> Single<[GitHub]> {
        fetchData(urlString: "https://api.github.com/users/Reon0429-cat/repos?per_page=5")
    }
    
    private func fetchData<T: Decodable>(urlString: String) -> Single<T> {
        return Single<T>.create { observer in
            guard let url = URL(string: urlString) else {
                observer(.failure(APIError.invalidURL))
                return Disposables.create()
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    return observer(.failure(APIError.invalidData))
                }
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try! jsonDecoder.decode(T.self, from: data)
                observer(.success(decodedData))
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
