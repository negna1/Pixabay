//  
//  RegistrationPresenter.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 06.11.23.
//

import Components
import UIKit
import NetworkLayer

extension RegistrationViewController.CellModelType {
    
    var tableCellModel: TableCellModel {
        switch self {
        case .title(let title):
            return CenterTitleTableCell.CellModel(title: title)
        case .textField(let textfieldModel):
            return TextFieldTableCell.CellModel(borderModel: textfieldModel)
        case .datePicker(let model):
            return model
        case .button(let model):
            return model
        case .imageWithTitle(let imageAndUser):
            let imageModel = ImageWithTitle.Model(title: imageAndUser.author,
                                                  imageURLString: imageAndUser.iconURL)
            return ImageWithTitleTableCell.CellModel(model: imageModel)
        case .iconWithDescription(let viewModel):
            return IconAndInfoWidgetTableCell.CellModel(model: viewModel)
        }
    }
}
 
extension RegistrationViewController {
    enum Section: CaseIterable {
        case initial
    }
    
    enum CellModelType: Hashable {
        case title(String)
        case textField(BorderedTextField.Model)
        case datePicker(DatePickerTableCell.CellModel)
        case button(PrimaryButtonTableCell.CellModel)
        case imageWithTitle(PicResponse.ImageAndUser)
        case iconWithDescription(IconAndInfoWidget.Model)
    }
}

extension RegistrationViewController.CellModelType: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.tableCellModel.id == rhs.tableCellModel.id
    }
}

