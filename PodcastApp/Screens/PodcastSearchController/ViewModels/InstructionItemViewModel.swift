//
//  PlaceholderSectionViewModel.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import UIKit

class InstructionItemViewModel {
    
    let id = UUID()
    let title: String
    let description: String
    var image: UIImage? {
        UIImage(named: imagePath)
    }
    private let imagePath: String
    
    init(title: String, description: String, imagePath: String) {
        self.title = title
        self.description = description
        self.imagePath = imagePath
    }
    
}

extension InstructionItemViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: InstructionItemViewModel, rhs: InstructionItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
