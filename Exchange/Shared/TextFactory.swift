//
//  TextFactory.swift
//  Exchange
//
//  Created by Imron Mirzarasulov on 05/03/26.
//

import UIKit

protocol TextFactoryProtocol {
    func createText() -> UILabel
}

final class TextFactory: TextFactoryProtocol {
    let text: String
    let color: UIColor
    let fontWeight: UIFont.Weight
    let fontSize: CGFloat
    
    init(text: String, color: UIColor, fontWeight: UIFont.Weight, fontSize: CGFloat) {
        self.text = text
        self.color = color
        self.fontWeight = fontWeight
        self.fontSize = fontSize
    }
    
    func createText() -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
