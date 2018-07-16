//
//  GridTableColumn.swift
//  GridTableDemo
//
//  Created by songhailiang on 2018/6/13.
//

import Foundation
import UIKit
import SnapKit

enum GridTableColumnType {
    case text
    case image(CGSize)
}

enum GridTableColumnWidth {
    case fixed(CGFloat)
    case flexible

    var width: CGFloat {
        switch self {
        case .fixed(let width): return width
        case .flexible: return 0
        }
    }
}

struct GridTableColumnId: Equatable {
    var rawValue: String
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

struct GridTableColumn {
    var id: GridTableColumnId
    var type: GridTableColumnType
    var width: GridTableColumnWidth
    var font: UIFont
    var color: UIColor
    var align: NSTextAlignment

    init(id: GridTableColumnId, type: GridTableColumnType, width: GridTableColumnWidth, font: UIFont? = nil, color: UIColor? = nil, align: NSTextAlignment = .center) {
        self.id = id
        self.type = type
        self.width = width
        self.font = font ?? UIFont.systemFont(ofSize: 14)
        self.color = color ?? UIColor.black
        self.align = align
    }
}

struct GridTableColumnHeader {
    var width: GridTableColumnWidth
    var title: String
    var font: UIFont
    var color: UIColor
    var align: NSTextAlignment
    var columns: [GridTableColumn]

    init(width: GridTableColumnWidth, title: String, columns: [GridTableColumn], font: UIFont? = nil, color: UIColor? = nil, align: NSTextAlignment = .center) {
        self.width = width
        self.title = title
        self.columns = columns
        self.font = font ?? UIFont.systemFont(ofSize: 16)
        self.color = color ?? UIColor.black
        self.align = align
    }
}
