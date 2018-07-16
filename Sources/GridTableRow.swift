//
//  GridTableRow.swift
//  GridTableDemo
//
//  Created by songhailiang on 2018/6/12.
//

import Foundation
import UIKit
import SnapKit

class GridTableRow: UITableViewCell {

    var columns: [GridTableColumn] = []
    var contentInset: UIEdgeInsets = .zero

    private var isReused: Bool = false
    private var dataContentView: UIView

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        dataContentView = UIView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dataContentView)
        dataContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(contentInset)
        }
        contentView.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        isReused = true
    }

    func setupColumnsfNotReused() {
        guard !isReused else {
            return
        }
        dataContentView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(contentInset)
        }
        dataContentView.subviews.forEach({
            $0.removeFromSuperview()
        })

        createColumnViews()

        var previous: UIView?
        var trailing: CGFloat = 0
        for i in 0 ..< dataContentView.subviews.count {
            dataContentView.subviews[i].snp.makeConstraints { (make) in
                let width = columns[i].width.width
                switch columns[i].type {
                case .text:
                    make.top.bottom.equalToSuperview()
                    if let previous = previous {
                        make.leading.equalTo(previous.snp.trailing).offset(trailing)
                    } else {
                        make.leading.equalToSuperview()
                    }
                    if width > 0 {
                        make.width.equalTo(width)
                    }
                    trailing = 0
                case .image(let size):
                    make.centerY.equalToSuperview()
                    make.width.equalTo(size.width)
                    make.height.equalTo(size.height)
                    let offset = abs((width - size.width) / 2)
                    if let previous = previous {
                        make.leading.equalTo(previous.snp.trailing).offset(offset)
                    } else {
                        make.leading.equalToSuperview().offset(offset)
                    }
                    trailing = offset
                }
            }
            previous = dataContentView.subviews[i]
        }

        // last subview
        previous?.snp.makeConstraints({ (make) in
            make.trailing.equalToSuperview()
        })
    }

    private func createColumnViews() {
        columns.forEach { [weak self] (column) in
            switch column.type {
            case .text:
                let lbl = UILabel(frame: .zero)
                lbl.font = column.font
                lbl.textColor = column.color
                lbl.textAlignment = column.align
                self?.dataContentView.addSubview(lbl)
            case .image(let size):
                let image = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                image.contentMode = .scaleAspectFit
                self?.dataContentView.addSubview(image)
            }
        }
    }

    func updateUI(data: GridTableRowData) {
        for i in 0 ..< columns.count {
            let view = dataContentView.subviews[i]
            if let d = data.data(for: columns[i].id) {
                view.isHidden = false
                switch d {
                case .text(let title):
                    (view as? UILabel)?.text = title
                case .image(let image):
                    (view as? UIImageView)?.image = image
                case .remoteImage(let url, let image):
                    // FIXME: update this using your web image library, like Kingfisher, sdwebimage
//                    (view as? UIImageView)?.setImageWith(url, placeholderImage: image)
                    break
                }
            } else {
                view.isHidden = true
            }
        }
    }
}
