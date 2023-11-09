//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 09.11.23.
//


import UIKit
import SnapKit

public class IconAndInfoWidgetTableCell: UITableViewCell,  ConfigurableTableCell {

    private var imageWithTitle: IconAndInfoWidget = {
        let component = IconAndInfoWidget()
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
            make.top.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    public func configure(with model: TableCellModel) {
        if let model = model as? CellModel {
            imageWithTitle.configure(with: model.model)
        }
    }
}

extension IconAndInfoWidgetTableCell {
    public struct CellModel: TableCellModel, Hashable {
        public var nibIdentifier: String = "IconAndInfoWidgetTableCell"
        public var height: Double = UITableView.automaticDimension
        public var id: UUID = UUID()
        public init( model: IconAndInfoWidget.Model) {
            self.model = model
        }
        let model: IconAndInfoWidget.Model
    }
}


