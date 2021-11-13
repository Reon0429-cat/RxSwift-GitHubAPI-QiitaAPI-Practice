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
    
    private let fetchQiitaDataTrigger = PublishRelay<Void>()
    private let fetchGitHubDataTrigger = PublishRelay<Void>()
    private let qiitasRelay = BehaviorRelay<Single<[Qiita]>>(value: .just([]))
    private let gitHubsRelay = BehaviorRelay<Single<[GitHub]>>(value: .just([]))
    private let disposeBag = DisposeBag()
    
    var qiitas: Driver<Single<[Qiita]>> {
        qiitasRelay.asDriver()
    }
    
    var gitHubs: Driver<Single<[GitHub]>> {
        gitHubsRelay.asDriver()
    }
    
    init() {
        fetchQiitaDataTrigger
            .flatMap { APIClient().fetchQiitaData() }
            .subscribe(onNext: { self.qiitasRelay.accept(.just($0)) })
            .disposed(by: disposeBag)
        
        fetchGitHubDataTrigger
            .flatMap { APIClient().fetchGitHubData() }
            .subscribe(onNext: { self.gitHubsRelay.accept(.just($0)) })
            .disposed(by: disposeBag)
    }
    
    func fetchQiitaData() {
        fetchQiitaDataTrigger.accept(())
    }
    
    func fetchGitHubData() {
        fetchGitHubDataTrigger.accept(())
    }
    
}
