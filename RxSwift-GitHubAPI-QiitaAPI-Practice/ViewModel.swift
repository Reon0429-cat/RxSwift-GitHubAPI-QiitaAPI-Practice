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
}

protocol ViewModelType {
    var inputs: ViewModelInput { get }
    var outputs: ViewModelOutput { get }
}

final class ViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase = UseCase()
    private let qiitasRelay = BehaviorRelay<[Qiita]>(value: [])
    
    init(fetchQiitaButton: Signal<Void>) {
        // Input
        fetchQiitaButton.asObservable()
            .subscribe(onNext: useCase.fetchQiitaData)
            .disposed(by: disposeBag)
        
        // Output
        useCase.qiitas
            .drive(qiitasRelay)
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
    
}

extension ViewModel: ViewModelType {
    
    var inputs: ViewModelInput {
        return self
    }
    
    var outputs: ViewModelOutput {
        return self
    }
    
}
