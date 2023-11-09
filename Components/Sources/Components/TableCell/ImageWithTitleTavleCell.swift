//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import UIKit
import SnapKit

public class ImageWithTitleTableCell: UITableViewCell,  ConfigurableTableCell {

    private var imageWithTitle: ImageWithTitle = {
        let component = ImageWithTitle()
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
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
        self.addSubview(imageWithTitle)
        
        imageWithTitle.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    public func configure(with model: TableCellModel) {
        if let model = model as? CellModel {
            imageWithTitle.configure(with: model.model)
        }
    }
}

extension ImageWithTitleTableCell {
    public struct CellModel: TableCellModel, Hashable {
        public var nibIdentifier: String = "ImageWithTitleTableCell"
        public var height: Double = UITableView.automaticDimension
        public var id: UUID = UUID()
        public init( model: ImageWithTitle.Model) {
            self.model = model
        }
        let model: ImageWithTitle.Model
    }
}


