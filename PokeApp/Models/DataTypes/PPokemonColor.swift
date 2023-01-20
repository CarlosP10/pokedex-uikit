//
//  PPokemonColor.swift
//  PokeApp
//
//  Created by Carlos Paredes on 1/19/23.
//

import UIKit

enum PPokemonColor: Codable {
    case black, blue, brown, gray, green, pink, purple, red, white, yellow
    
    var color: UIColor {
        switch self {
        case .black:
            return UIColor.black
        case .blue:
            return UIColor.blue
        case .brown:
            return UIColor.brown
        case .gray:
            return UIColor.gray
        case .green:
            return UIColor.green
        case .pink:
            return UIColor.systemPink
        case .purple:
            return UIColor.purple
        case .red:
            return UIColor.red
        case .white:
            return UIColor.white
        case .yellow:
            return UIColor.yellow
        }
    }
}
