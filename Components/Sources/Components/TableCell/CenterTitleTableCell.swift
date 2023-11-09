//
//  CenterTitleTableCell.swift
//  
//
//  Created by Nato Egnatashvili on 04.11.22.
//

import UIKit
import SnapKit

public class CenterTitleTableCell: UITableViewCell,  ConfigurableTableCell {

    private var label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
    }
    
    public func configure(with model: TableCellModel) {
        if let model = model as? CellModel {
            label.text = model.title
        }
    }
}

extension CenterTitleTableCell {
    public struct CellModel: TableCellModel, Hashable {
        public var nibIdentifier: String = "CenterTitleTableCell"
        public var height: Double = UITableView.automaticDimension
        public var id: UUID = UUID()
        public init( title: String) {
            self.title = title
        }
        let title: String
    }
}

