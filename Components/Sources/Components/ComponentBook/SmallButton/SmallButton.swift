//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 06.11.23.
//

import UIKit
import SnapKit

public class SmallButton: UIView {
    
    private lazy var  button: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var tap: ((SmallButton) -> ())?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        constrain()
    }
    
    public init(with model: Model? = nil) {
        super.init(frame: .zero)
        guard let model = model else {
            constrain()
            return
        }
        configure(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Model) {
        button.setTitle(model.title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        self.tap = model.didTap
    }
    
    @objc func didTapButton() {
        self.tap?(self)
    }
    
    private func constrain() {
        self.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview().inset(10)
        }
        button.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
 
}
