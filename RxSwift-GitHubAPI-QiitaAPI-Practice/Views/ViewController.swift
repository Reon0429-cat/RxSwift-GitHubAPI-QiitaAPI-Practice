//
//  ViewController.swift
//  RxSwift-GitHubAPI-QiitaAPI-Practice
//
//  Created by 大西玲音 on 2021/11/12.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    @IBOutlet private weak var fetchQiitaButton: UIButton!
    @IBOutlet private weak var fetchGitHubButton: UIButton!
    @IBOutlet private weak var combineButton: UIButton!
    @IBOutlet private weak var qiitaTableView: UITableView!
    @IBOutlet private weak var gitHubTableView: UITableView!
    @IBOutlet private weak var combineTableView: UITableView!
    
    private let useCase = UseCase()
    private lazy var viewModel: ViewModelType = ViewModel(
        useCase: useCase,
        fetchQiitaButton: fetchQiitaButton.rx.tap.asSignal(),
        fetchGitHubButton: fetchGitHubButton.rx.tap.asSignal(),
        combineButton: combineButton.rx.tap.asSignal()
    )
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupBindings()
        
    }
    
    private func setupBindings() {
        // Output
        viewModel.outputs.qiitas
            .drive(
                qiitaTableView.rx.items(
                    cellIdentifier: CustomTableViewCell.identifier,
                    cellType: CustomTableViewCell.self
                )
            ) { row, element, cell in
                cell.configure(text: element.title)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.gitHubs
            .drive(
                gitHubTableView.rx.items(
                    cellIdentifier: CustomTableViewCell.identifier,
                    cellType: CustomTableViewCell.self
                )
            ) { row, element, cell in
                cell.configure(text: element.name)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.combineTexts
            .drive(
                combineTableView.rx.items(
                    cellIdentifier: CustomTableViewCell.identifier,
                    cellType: CustomTableViewCell.self
                )
            ) { row, element, cell in
                cell.configure(text: element)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.isCombineButtonEnabled
            .drive(combineButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
    
    private func setupTableView() {
        qiitaTableView.register(CustomTableViewCell.nib,
                                forCellReuseIdentifier: CustomTableViewCell.identifier)
        gitHubTableView.register(CustomTableViewCell.nib,
                                 forCellReuseIdentifier: CustomTableViewCell.identifier)
        combineTableView.register(CustomTableViewCell.nib,
                                  forCellReuseIdentifier: CustomTableViewCell.identifier)
        qiitaTableView.rowHeight = 60
        gitHubTableView.rowHeight = 60
        combineTableView.rowHeight = 60
    }
    
}

