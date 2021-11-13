//
//  ViewModel.swift
//  RxSwift-GitHubAPI-QiitaAPI-Practice
//
//  Created by 大西玲音 on 2021/11/12.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelInput {
    
}

protocol ViewModelOutput: AnyObject {
    var qiitas: Driver<[Qiita]> { get }
    var gitHubs: Driver<[GitHub]> { get }
    var isCombineButtonEnabled: Driver<Bool> { get }
    var combineTexts: Driver<[String]> { get }
}

protocol ViewModelType {
    var inputs: ViewModelInput { get }
    var outputs: ViewModelOutput { get }
}

final class ViewModel {
    
    private let disposeBag = DisposeBag()
    private let qiitasRelay = BehaviorRelay<[Qiita]>(value: [])
    private let gitHubsRelay = BehaviorRelay<[GitHub]>(value: [])
    private let combineTextsRelay = BehaviorRelay<[String]>(value: [])
    private let isCombineButtonEnabledRelay = BehaviorRelay<Bool>(value: false)
    
    init(
        useCase: UseCase,
        fetchQiitaButton: Signal<Void>,
        fetchGitHubButton: Signal<Void>,
        combineButton: Signal<Void>
    ) {
        fetchQiitaButton.asObservable()
            .subscribe(onNext: {
                useCase.fetchQiitaData()
                    .map { $0.map { Qiita(title: $0.title.prefix(5).description) } }
                    .subscribe(
                        onSuccess: { self.qiitasRelay.accept($0) },
                        onFailure: { print($0.localizedDescription) }
                    )
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        fetchGitHubButton.asObservable()
            .subscribe(onNext: {
                useCase.fetchGitHubData()
                    .map { $0.map { GitHub(name: $0.name.prefix(5).description) } }
                    .subscribe(
                        onSuccess: { self.gitHubsRelay.accept($0) },
                        onFailure: { print($0.localizedDescription) }
                    )
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        combineButton.asObservable()
            .map {
                zip(self.qiitasRelay.value, self.gitHubsRelay.value)
                    .map { $0.title.prefix(5).description + $1.name.prefix(5).description }
            }
            .bind(to: combineTextsRelay)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Input
extension ViewModel: ViewModelInput {
    
}

// MARK: - Output
extension ViewModel: ViewModelOutput {
    
    var qiitas: Driver<[Qiita]> {
        qiitasRelay.asDriver()
    }
    
    var gitHubs: Driver<[GitHub]> {
        gitHubsRelay.asDriver()
    }
    
    var combineTexts: Driver<[String]> {
        combineTextsRelay.asDriver()
    }
    
    var isCombineButtonEnabled: Driver<Bool> {
        Observable.combineLatest(
            qiitasRelay.asObservable(),
            gitHubsRelay.asObservable()
        ).map { !$0.isEmpty && !$1.isEmpty }
        .asDriver(onErrorDriveWith: .empty())
    }
    
}

extension ViewModel: ViewModelType {
    
    var inputs: ViewModelInput {
        return self
    }
    
    var outputs: ViewModelOutput {
        return self
    }
    
}
