//
//  ViewController.swift
//  GridTableExample
//
//  Created by songhailiang on 2018/7/16.
//  Copyright © 2018 songhailiang. All rights reserved.
//

import UIKit
import SnapKit

extension GridTableColumnId {
    static let Pos = GridTableColumnId(rawValue: "Pos")
    static let Arrow = GridTableColumnId(rawValue: "Arrow")
    static let Name = GridTableColumnId(rawValue: "Name")
    static let P = GridTableColumnId(rawValue: "P")
    static let W = GridTableColumnId(rawValue: "W")
    static let D = GridTableColumnId(rawValue: "D")
    static let L = GridTableColumnId(rawValue: "L")
    static let Pts = GridTableColumnId(rawValue: "Pts")
}

struct Team {
    var pos: String = ""
    var name: String = ""
    var p: String = ""
    var w: String = ""
    var d: String = ""
    var l: String = ""
    var pts: String = ""
}

extension Team: GridTableRowData {
    func data(for column: GridTableColumnId) -> GridTableRowDataType? {
        switch column {
        case .Pos: return .text(pos)
        case .Name: return .text(name)
        case .P: return .text(p)
        case .W: return .text(w)
        case .D: return .text(d)
        case .L: return .text(l)
        case .Pts: return .text(pts)
        case .Arrow:
            if pos == "1" {
                return .image(UIImage(named: "table_arrow_up")!)
            } else if pos == "2" {
                return .image(UIImage(named: "table_arrow_down")!)
            }
            return nil
        default:
            return nil
        }
    }
}

class ViewController: UIViewController, GridTableDelegate {
    var gridTable: GridTable!

    var teams: [Team] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Grid Table"

        prepareData()
        // Grid Table Columns
        let column1 = GridTableColumn(id: .Pos, type: .text, width: .fixed(30), align: .left)
        let column11 = GridTableColumn(id: .Arrow, type: .image(CGSize(width: 10, height: 10)), width: .fixed(20))
        let column2 = GridTableColumn(id: .Name, type: .text, width: .flexible, align: .left)
        let column3 = GridTableColumn(id: .P, type: .text, width: .fixed(30))
        let column4 = GridTableColumn(id: .W, type: .text, width: .fixed(30))
        let column5 = GridTableColumn(id: .D, type: .text, width: .fixed(30))
        let column6 = GridTableColumn(id: .L, type: .text, width: .fixed(30))
        let column7 = GridTableColumn(id: .Pts, type: .text, width: .fixed(30))

        // Grid Table Header
        let header1 = GridTableColumnHeader(width: .flexible, title: "Pos.", columns: [column1, column11, column2], align: .left)
        let header2 = GridTableColumnHeader(width: .fixed(30), title: "P", columns: [column3])
        let header3 = GridTableColumnHeader(width: .fixed(30), title: "W", columns: [column4])
        let header4 = GridTableColumnHeader(width: .fixed(30), title: "D", columns: [column5])
        let header5 = GridTableColumnHeader(width: .fixed(30), title: "L", columns: [column6])
        let header6 = GridTableColumnHeader(width: .fixed(30), title: "Pts", columns: [column7])

        gridTable = GridTable(headers: [header1, header2, header3, header4, header5, header6])
        gridTable.rowContentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        //        gridTable.view.backgroundColor = .white
        gridTable.headerView?.backgroundColor = UIColor.lightGray
        gridTable.headerView?.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        gridTable.delegate = self
        self.view.addSubview(gridTable.view)
        gridTable.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfRows(in gridTable: GridTable) -> Int {
        return teams.count
    }

    func gridTable(_ gridTable: GridTable, dataFor row: Int) -> GridTableRowData? {
        return teams[row]
    }

    func prepareData() {
        for i in 0 ..< 50 {
            let team = Team(pos: "\(i)", name: "Name\(i)", p: "\(i)", w: "\(i)", d:
                "\(i)", l: "\(i)", pts: "\(i)")
            teams.append(team)
        }
    }

    func gridTable(_ gridTable: GridTable, didScroll scrollView: UIScrollView) {
        // grid table did scroll
    }

    func gridTable(_ gridTable: GridTable, didSelectRowAt indexPath: IndexPath) {
        print("\(#function) \(indexPath)")
    }
}
