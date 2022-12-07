//
//  StringExtensions.swift
//  DaffyTypeaheadProject
//
//  Created by Jon Evans on 12/3/22.
//

import Foundation

extension String {
    
    func isolateYearFromReleaseDate() -> String {
        guard self != "" else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return "" }
        if let year = Calendar.current.dateComponents([.year], from: date).year {
            return "-\(year)"
        }
        return ""
    }
}
