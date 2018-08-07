//
//  TypeAlias.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

typealias UtilisateurCompletion = (_ utilisateur: Utilisateur?) -> (Void)
typealias PostCompletion = (_ post: Post?) -> (Void)
typealias HashtagCompletion = (_ hashtag: Hashtag?) -> (Void)
typealias CommentaireCompletion = (_ commentaire: Commentaire?) -> (Void)
typealias SuccesCompletion = (_ succes: Bool?, _ string: String?) -> (Void)
