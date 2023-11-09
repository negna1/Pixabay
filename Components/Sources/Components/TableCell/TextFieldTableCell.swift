//
//  TextFieldTableCell.swift
//  
//
//  Created by Nato Egnatashvili on 11.11.22.
//

import UIKit
import SnapKit

public class TextFieldTableCell: UITableViewCell,  ConfigurableTableCell {
    
    private lazy var textField: BorderedTextField = {
        let txt = BorderedTextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
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
        self.contentView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(2)
        }
    }
    
    public func configure(with model: TableCellModel) {
        if let model = model as? CellModel {
            self.textField.configure(with: model.borderModel)
        }
    }
}

extension TextFieldTableCell {
    public struct CellModel: TableCellModel, Hashable {
        public var nibIdentifier: String = "TextFieldTableCell"
        
        public var height: Double = UITableView.automaticDimension
        public var borderModel: BorderedTextField.Model
        
        public init(borderModel: BorderedTextField.Model) {
            self.borderModel = borderModel
        }
    }
}
