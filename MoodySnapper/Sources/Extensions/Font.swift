//
//  Font.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 25/05/23.
//

import Foundation
import SwiftUI

extension Font {
    static func sfMonoRegular(fontSize: Double) -> Font {
        Font.custom("SFMono-Regular", size: fontSize)
    }
    
    static func sfMonoSemibold(fontSize: Double) -> Font {
        Font.custom("SFMono-Semibold", size: fontSize)
    }
    
    static func sfMonoBold(fontSize: Double) -> Font {
        Font.custom("SFMono-Bold", size: fontSize)
    }
}
