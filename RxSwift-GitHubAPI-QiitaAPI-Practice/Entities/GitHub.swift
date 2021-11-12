//
//  GitHub.swift
//  RxSwift-GitHubAPI-QiitaAPI-Practice
//
//  Created by 大西玲音 on 2021/11/13.
//

import Foundation

struct GitHub: Decodable {
    var name: String
    init(name: String) {
        self.name = name
    }
}
