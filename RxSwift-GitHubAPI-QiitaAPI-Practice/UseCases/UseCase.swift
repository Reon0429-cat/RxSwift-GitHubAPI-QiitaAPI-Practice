//
//  UseCase.swift
//  RxSwift-GitHubAPI-QiitaAPI-Practice
//
//  Created by 大西玲音 on 2021/11/12.
//

import Foundation
import RxSwift
import RxCocoa

final class UseCase {
    
    private let disposeBag = DisposeBag()
    
    func fetchQiitaData() -> Single<[Qiita]> {
        APIClient().fetchQiitaData()
    }
    
    func fetchGitHubData() -> Single<[GitHub]> {
        APIClient().fetchGitHubData()
    }
    
}
