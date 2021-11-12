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

struct Qiita: Codable {
    let title: String
}

struct GitHub: Codable {
    let name: String
}

final class APIClient {
    
    func fetchQiitaData() -> Single<[Qiita]> {
        return Single<[Qiita]>.create { observer in
            let urlString = "https://qiita.com/api/v2/items?page=1&per_page=5"
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
                let qiitas = try! jsonDecoder.decode([Qiita].self, from: data)
                observer(.success(qiitas))
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func fetchGitHubData() -> Single<[GitHub]> {
        return Single<[GitHub]>.create { observer in
            let urlString = "https://api.github.com/users/Reon0429-cat/repos?per_page=5"
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
                let gitHubs = try! jsonDecoder.decode([GitHub].self, from: data)
                observer(.success(gitHubs))
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
