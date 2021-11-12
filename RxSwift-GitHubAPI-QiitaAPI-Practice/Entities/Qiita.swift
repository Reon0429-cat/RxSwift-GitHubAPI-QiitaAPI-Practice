//
//  Qiita.swift
//  RxSwift-GitHubAPI-QiitaAPI-Practice
//
//  Created by 大西玲音 on 2021/11/13.
//

import Foundation

struct Qiita: Decodable {
    var title: String
    init(title: String) {
        self.title = title
    }
}
