//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 06.11.23.
//

import UIKit
import SnapKit

public class DatePickerTableCell: UITableViewCell, ConfigurableTableCell {

    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(ageLabel)
        stack.addArrangedSubview(datePicker)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private var dateChanged: ((Date) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let selectedDate = sender.date
        self.dateChanged?(selectedDate)
    }
    
    private func setup() {
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        self.contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
    }
    
    public func configure(with model: TableCellModel) {
        if let model = model as? CellModel {
            self.dateChanged = model.dateChanged
            ageLabel.text = "please select you birth date"
            ageLabel.textColor = model.hasError ? .red : .black
            datePicker.ageValidation(minAge: model.minAge, maxAge: model.maxAge)
        }
    }
}

extension DatePickerTableCell {
    public struct CellModel: TableCellModel {
        public var nibIdentifier: String = "DatePickerTableCell"
        public var height: Double = UITableView.automaticDimension
        public var id: UUID = UUID()
        public init( minAge: Int,
                     maxAge: Int,
                     hasError: Bool = false,
                     dateChanged: @escaping ((Date) -> ())) {
            self.maxAge = maxAge
            self.minAge = minAge
            self.hasError = hasError
            self.dateChanged = dateChanged
        }
        let hasError: Bool
        let maxAge: Int
        let minAge: Int
        var dateChanged: ((Date) -> ())
    }
}

extension DatePickerTableCell.CellModel: Hashable {
    public static func == (lhs: DatePickerTableCell.CellModel, rhs: DatePickerTableCell.CellModel) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
       hasher.combine(id)
     }
    
}

extension UIDatePicker {
    func ageValidation(minAge: Int, maxAge: Int) {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -(minAge)
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -(maxAge)
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
   
}
