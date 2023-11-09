//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 03.11.23.
//

import UIKit
import SnapKit

public class BorderedTextField: UIView {
    private lazy var errorLabel: UILabel = {
        let txt = UILabel()
        txt.isHidden = true
        txt.font = .boldSystemFont(ofSize: 9)
        txt.textColor = .clear
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.addArrangedSubview(view)
        stack.addArrangedSubview(errorLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var textField: UITextField = {
        let txt = UITextField()
        txt.delegate = self
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private lazy var view: UIView = {
        let txt = UIView()
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private lazy var lbl: UILabel = {
        let txt = UILabel()
        txt.backgroundColor = .white
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private var didChangeText: ((ActionType) -> ())?
    private var textType: BorderedTextField.TextType = .name
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        constrain()
        styleUI()
    }
    
    public init(with model: Model? = nil) {
        super.init(frame: .zero)
        guard let model = model else {
            constrain()
            styleUI()
            return
        }
        configure(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Model) {
        textField.text = model.textToWrite
        didChangeText = model.didChangeText
        textType = model.textType
        updateErrorTextIfNeeded(with: model.errorText)
        textField.placeholder = textType.rawValue
    }
    
    public func updateErrorTextIfNeeded(with text: String?) {
        errorLabel.text = text
        errorLabel.isHidden = text == nil
        errorLabel.textColor = .red
    }
    
    private func constrain() {
        self.addSubview(stack)
        self.addSubview(lbl)
        view.addSubview(textField)
        
        stack.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview().inset(10)
            make.height.equalTo(60)
        }
        
        textField.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview().inset(8)
        }
        
        lbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(40)
        }
    }
    
    private func styleUI() {
        styleView()
        styleTextField()
    }
    
    private func styleTextField() {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    private func styleView() {
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 10
    }
}


extension BorderedTextField: UITextFieldDelegate {
    @objc func valueChanged(_ textField: UITextField){
        self.lbl.text = (textField.text?.isEmpty ?? true) ? nil : textType.rawValue
        self.didChangeText?(.init(textType: self.textType,
                                  text: textField.text ?? "",
                                  hasEndedEdit: false,
                                  textfield: self))
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.didChangeText?(.init(textType: self.textType,
                                  text: textField.text ?? "",
                                  hasEndedEdit: true,
                                  textfield: self))
    }
}
