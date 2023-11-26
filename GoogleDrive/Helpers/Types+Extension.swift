//
//  Types+Extension.swift
//  GoogleDrive
//
//  Created by Шахова Анастасия on 25.11.2023.
//

import Foundation

extension Double {
    
    func getSize() -> Double {
           var fileSize = self/1048576 //Convert in to MB
           fileSize = (fileSize*100).rounded()/100
           return fileSize
    }

    public var toString: String { return String(self) }

}

extension Date {
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "format.rawValue"
        return formatter.string(from: self)
    }
}
