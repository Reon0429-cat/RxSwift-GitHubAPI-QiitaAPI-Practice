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
    private let qiitasRelay = BehaviorRelay<[Qiita]>(value: [])
    private let qiitaErrorRelay = PublishRelay<Error>()
    private let disposeBag = DisposeBag()
    
    var qiitas: Driver<[Qiita]> {
        qiitasRelay.asDriver()
    }
    
    var qiitaError: Driver<Error> {
        qiitaErrorRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    init() {
        fetchQiitaDataTrigger
            .subscribe(onNext: {
                APIClient().fetchQiitaData()
                    .subscribe { qiitas in
                        self.qiitasRelay.accept(qiitas)
                    } onFailure: { error in
                        self.qiitaErrorRelay.accept(error)
                    }
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchQiitaData() {
        fetchQiitaDataTrigger.accept(())
    }
    
}
