//
//  NumberOfLines.swift
//  Nin0chat
//
//  Created by tiramisu on 10/22/24.
//

extension String {
    var numberOfLines: Int {
        return self.components(separatedBy: "\n").count
    }

}
