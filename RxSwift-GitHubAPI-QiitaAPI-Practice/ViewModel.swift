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

    init(fetchQiitaButton: Signal<Void>,
         fetchGitHubButton: Signal<Void>) {
        // Input from VC
        fetchQiitaButton.asObservable()
            .subscribe(onNext: useCase.fetchQiitaData)
            .disposed(by: disposeBag)
        
        fetchGitHubButton.asObservable()
            .subscribe(onNext: useCase.fetchGitHubData)
            .disposed(by: disposeBag)
        
        // Output from UseCase
        useCase.qiitas
            .drive(qiitasRelay)
            .disposed(by: disposeBag)
        
        useCase.qiitaError
            .drive(onNext: { print($0.localizedDescription) })
            .disposed(by: disposeBag)
        
        useCase.gitHubs
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
    
}

extension ViewModel: ViewModelType {
    
    var inputs: ViewModelInput {
        return self
    }
    
    var outputs: ViewModelOutput {
        return self
    }
    
}
