//
//  LanguageManager.swift
//  Netflix Clone
//
//  Created by Le Viet Tung on 12/8/24.
//

import Foundation

final class LanguageManager {
    static let shared = LanguageManager()
    
    var isVietnamese: Bool {
        guard let lang = UserDefaults.standard.string(forKey: "lang") else { return false }
        return lang == "vi"
    }
}
