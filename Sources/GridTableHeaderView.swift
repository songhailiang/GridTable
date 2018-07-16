//
//  GridTableHeaderView.swift
//  GridTableDemo
//
//  Created by songhailiang on 2018/6/12.
//

import UIKit
import Foundation
import SnapKit

class GridTableHeaderView: UIView {

    public var headers: [GridTableColumnHeader]
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    private var contentView: UIView
    internal let separatorLine: UIView

    init(headers: [GridTableColumnHeader]) {
        self.headers = headers
        contentView = UIView()
        separatorLine = UIView()
        super.init(frame: .zero)

        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(contentInset)
        }

        addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            reloadHeader()
        }
    }

    override func updateConstraints() {
        contentView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(contentInset)
        }
        super.updateConstraints()
    }

    public func reloadHeader() {
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }

        headers.forEach { [weak self] (header) in
            let lbl = UILabel(frame: .zero)
            lbl.font = header.font
            lbl.textColor = header.color
            lbl.textAlignment = header.align
            lbl.text = header.title
            self?.contentView.addSubview(lbl)
        }

        var previous: UIView?
        for i in 0 ..< contentView.subviews.count {
            contentView.subviews[i].snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                if let previous = previous {
                    make.leading.equalTo(previous.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }
                switch headers[i].width {
                case .fixed(let width):
                    make.width.equalTo(width)
                case .flexible:
                    break
                }
            }
            previous = contentView.subviews[i]
        }

        // last subview
        previous?.snp.makeConstraints({ (make) in
            make.trailing.equalToSuperview()
        })
    }
}
