//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 09.11.23.
//


import UIKit
import SnapKit
import SDWebImage

public class ImageWithTitle: UIView {
    
    private lazy var  stack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(titleLabel)
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
        }
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public init(with model: Model? = nil) {
        super.init(frame: .zero)
        setUp()
        guard let model = model else { return }
        configure(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Model) {
        titleLabel.text = model.title
        guard let url = URL(string: model.imageURLString) else { return }
        imageView.sd_setImage(with: url)
    }
}

// MARK: - Constraint and Style setup
extension ImageWithTitle {
    private func setUp() {
        constrain()
        styleImageView()
        styleLabel()
    }
    
    private func constrain() {
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview().inset(10)
        }
    }
    
    private func styleLabel() {
        titleLabel.font = .systemFont(ofSize: 10, weight: .bold)
        titleLabel.shadowColor = .lightGray
        titleLabel.shadowOffset = .init(width: 1, height: 1)
    }
 
    private func styleImageView() {
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.shadowRadius = 1
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }
}
