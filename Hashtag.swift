//
//  Hashtag.swift
//  Wettly
//
//  Created by Nathan Levy on 06/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import Foundation

class Hashtag {
    
    private var _nom: String!
    private var _posts: [String: String]!
    
    var nom: String { return _nom }
    var posts: [String: String] { return _posts}
    
    init(nom: String, posts: [String: String]) {
        self._nom = nom
        self._posts = posts
    }
}
