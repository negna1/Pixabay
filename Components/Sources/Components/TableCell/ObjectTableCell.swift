//
//  ObjectTableCell.swift
//  ARKitInteraction
//
//  Created by Nato Egnatashvili on 24.10.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import SnapKit

public class ObjectTableCell: UITableViewCell,  ConfigurableTableCell {
    
    private var image: UIImageView = {
        let img = UIImageView()
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.borderWidth = 1
        img.widthAnchor.constraint(equalToConstant: 40).isActive = true
        img.heightAnchor.constraint(equalToConstant: 40).isActive = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
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
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(label)
    }
    
    public func configure(with model: TableCellModel) {
        if let model = model as? CellModel {
            label.text = model.title
            image.image = model.icon
            image.contentMode = .scaleAspectFit
        }
    }
}

extension ObjectTableCell {
    public struct CellModel: TableCellModel, Hashable {
        public var nibIdentifier: String = "ObjectTableCell"
        public var height: Double = UITableView.automaticDimension
        
        public init( title: String, icon: UIImage? = nil) {
            self.title = title
            self.icon = icon
        }
        let title: String
        let icon: UIImage?
    }
}
