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
    private let useCase = UseCase()
    private let qiitasRelay = BehaviorRelay<[Qiita]>(value: [])
    private let gitHubsRelay = BehaviorRelay<[GitHub]>(value: [])
    private let combineTextsRelay = BehaviorRelay<[String]>(value: [])
    private let isCombineButtonEnabledRelay = BehaviorRelay<Bool>(value: false)
    
    init(
        fetchQiitaButton: Signal<Void>,
        fetchGitHubButton: Signal<Void>,
        combineButton: Signal<Void>
    ) {
        // Input from VC
        fetchQiitaButton.asObservable()
            .subscribe(onNext: useCase.fetchQiitaData)
            .disposed(by: disposeBag)
        
        fetchGitHubButton.asObservable()
            .subscribe(onNext: useCase.fetchGitHubData)
            .disposed(by: disposeBag)
        
        combineButton.asObservable()
            .subscribe(onNext: {
                let text = zip(
                    self.qiitasRelay.value,
                    self.gitHubsRelay.value
                ).map {
                    $0.title.prefix(5).description
                    + $1.name.prefix(5).description
                }
                self.combineTextsRelay.accept(text)
            })
            .disposed(by: disposeBag)
        
        // Output from UseCase
        useCase.qiitas
            .map { $0.map { Qiita(title: $0.title.prefix(5).description) } }
            .drive(qiitasRelay)
            .disposed(by: disposeBag)
        
        useCase.qiitaError
            .drive(onNext: { print($0.localizedDescription) })
            .disposed(by: disposeBag)
        
        useCase.gitHubs
            .map { $0.map { GitHub(name: $0.name.prefix(5).description) } }
            .drive(gitHubsRelay)
            .disposed(by: disposeBag)
        
        useCase.gitHubError
            .drive(onNext: { print($0.localizedDescription) })
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
