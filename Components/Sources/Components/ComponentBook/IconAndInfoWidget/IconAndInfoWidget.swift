//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import UIKit
import SnapKit
import SDWebImage

public class IconAndInfoWidget: UIView {
    
    private lazy var  stack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(titleStack)
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(120)
        }
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var  titleStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 2
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    public override func layoutSubviews() {
        imageView.layer.cornerRadius = imageView.frame.height/2
    }
    
    public func configure(with model: Model) {
        configureTitleStack(titles: model.titles)
        guard let url = URL(string: model.imageURLString) else { return }
        imageView.sd_setImage(with: url)
    }
    
    private func configureTitleStack(titles: [String]) {
        titleStack.subviews.forEach({$0.removeFromSuperview()})
        titles.forEach { title in
            var t = UILabel()
            t.translatesAutoresizingMaskIntoConstraints = false
            t.text = title
            styleLabel(titleLabel: &t)
            titleStack.addArrangedSubview(t)
        }
    }
}

// MARK: - Constraint and Style setup
extension IconAndInfoWidget {
    private func setUp() {
        constrain()
        styleView()
    }
    
    private func constrain() {
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview().inset(10)
        }
    }
    
    private func styleLabel(titleLabel: inout UILabel) {
        titleLabel.font = .systemFont(ofSize: 10, weight: .bold)
        titleLabel.shadowColor = .lightGray
        titleLabel.shadowOffset = .init(width: 1, height: 1)
    }
 
    private func styleView() {
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 1
//        layer.shadowOffset = .zero
//        layer.shadowRadius = 10
//        
        backgroundColor = .white

        layer.cornerRadius = 10.0

        layer.shadowColor = UIColor.gray.cgColor

        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)

        layer.shadowRadius = 6.0

        layer.shadowOpacity = 0.7
    }
}
