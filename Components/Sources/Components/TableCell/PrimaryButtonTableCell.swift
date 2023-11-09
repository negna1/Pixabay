//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 06.11.23.
//

import UIKit
import SnapKit

public class PrimaryButtonTableCell: UITableViewCell,  ConfigurableTableCell {

    private lazy var button: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        v.backgroundColor = .gray
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .clear
        self.contentView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    var tap: ((PrimaryButtonTableCell) -> ())?
    
    public func configure(with model: TableCellModel) {
        if let model = model as? CellModel {
            self.tap = model.tap
            button.layer.cornerRadius = 10
            button.setTitle(model.title, for: .normal)
            button.backgroundColor = .blue
            button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        }
    }
    
    @objc func didTap() {
        tap?(self)
    }
}

extension PrimaryButtonTableCell {
    public struct CellModel: TableCellModel, Hashable {
        public static func == (lhs: PrimaryButtonTableCell.CellModel, rhs: PrimaryButtonTableCell.CellModel) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
           hasher.combine(id)
         }
        
        public var id: UUID = UUID()
        public var nibIdentifier: String = "PrimaryButtonTableCell"
        public var height: Double = UITableView.automaticDimension
        public var title: String
        public var tap: ((PrimaryButtonTableCell) -> ())?
        
        public init(title: String, tap: ((PrimaryButtonTableCell) -> ())? = nil) {
            self.title = title
            self.tap = tap
        }
        
    }
}
