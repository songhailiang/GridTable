//
//  GridTable.swift
//  GridTableDemo
//
//  Created by songhailiang on 2018/6/12.
//

import Foundation
import UIKit
import SnapKit

enum GridTableRowDataType {
    case text(String)
    case image(UIImage)
    case remoteImage(URL, UIImage) // url + placeholder image
}

protocol GridTableRowData {

    func data(for column: GridTableColumnId) -> GridTableRowDataType?
}

protocol GridTableDelegate: class {
    func numberOfRows(in gridTable: GridTable) -> Int
    func gridTable(_ gridTable: GridTable, dataFor row: Int) -> GridTableRowData?
    func gridTable(_ gridTable: GridTable, didScroll scrollView: UIScrollView)
    func gridTable(_ gridTable: GridTable, didSelectRowAt indexPath: IndexPath)
}

class GridTable: NSObject, UITableViewDataSource, UITableViewDelegate {

    public var rowHeight: CGFloat = 45.0
    public var headerHeight: CGFloat = 45.0
    public var separatorColor: UIColor? {
        didSet {
            headerView?.separatorLine.backgroundColor = separatorColor
            table.separatorColor = separatorColor
        }
    }
    public var rowContentInset: UIEdgeInsets = .zero
    public var rowBackgroundColor: UIColor?
    public weak var delegate: GridTableDelegate?

    public var view: UIView {
        return containerView
    }

    public let table: UITableView
    public let headerView: GridTableHeaderView?

    private var headers: [GridTableColumnHeader]
    private let containerView: UIView
    private let cellIdentifier = "gridTableCell"
    private var allColumns: [GridTableColumn] {
        return headers.flatMap({
            return $0.columns
        })
    }

    init(headers: [GridTableColumnHeader]) {
        self.headers = headers
        containerView = UIView()
        table = UITableView(frame: .zero, style: .plain)
        headerView = GridTableHeaderView(headers: headers)
        super.init()
        setupTableHeader()
        setupTableUI()
    }

    public func reloadData() {
        table.reloadData()
    }

    private func setupTableHeader() {
        containerView.addSubview(headerView!)
        headerView?.snp.makeConstraints({ (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerHeight)
        })
    }

    private func setupTableUI() {
        table.separatorInset = .zero
        table.separatorColor = separatorColor
        table.separatorStyle = .singleLine
        table.tableFooterView = UIView()
        table.tableFooterView?.backgroundColor = .clear
        table.register(GridTableRow.self, forCellReuseIdentifier: cellIdentifier)
        table.delegate = self
        table.dataSource = self

        containerView.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            if let header = headerView {
                make.top.equalTo(header.snp.bottom)
            } else {
                make.top.equalToSuperview()
            }
        }
    }

    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.numberOfRows(in: self) ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GridTableRow
        cell.columns = allColumns
        cell.contentInset = rowContentInset
        cell.setupColumnsfNotReused()
        cell.backgroundColor = rowBackgroundColor
        if let data = delegate?.gridTable(self, dataFor: indexPath.row) {
            cell.updateUI(data: data)
        }
        cell.layoutMargins = .zero
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.gridTable(self, didSelectRowAt: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == table else {
            return
        }
        delegate?.gridTable(self, didScroll: scrollView)
    }
}
