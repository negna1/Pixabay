//  
//  RegistrationView.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 06.11.23.
//

import Combine
import UIKit
import Components
import SnapKit
import Resolver


final class RegistrationViewController: UIViewController {
    private var cancellables: [AnyCancellable] = []
    private var viewModel: RegistrationViewModelType = Resolver.resolve()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        configureUI()
        bind(to: viewModel)
        
    }
    
    private func configureUI() {
        constrain()
        registerCells()
        tableView.dataSource = dataSource
    }
    
    private func constrain() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
    
    private var classes: [ConfigurableTableCell.Type] {
        [CenterTitleTableCell.self, TextFieldTableCell.self, DatePickerTableCell.self, PrimaryButtonTableCell.self]
    }
    
    private func registerCells() {
        classes.forEach({ tableView.register($0.self,
                                             forCellReuseIdentifier: String(describing: $0.self)
        )})
        
    }
    
    private func bindViewModel(viewModel: RegistrationViewModelType) {
        self.viewModel = viewModel
    }
    
    private func bind(to viewModel: RegistrationViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = RegistrationViewModelInput()
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: RegistrationState) {
        switch state {
        case .idle(let cells):
            update(with: cells, animate: false)
        }
    }
    
}

//MARK: - Data source and reload
extension RegistrationViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section,  CellModelType> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, type in
                let cell = tableView.dequeueReusableCell(withIdentifier: type.tableCellModel.nibIdentifier) as? ConfigurableTableCell
                cell?.configure(with: type.tableCellModel)
                return cell ?? UITableViewCell()
            }
        )
    }
    
    func update(with models: [CellModelType], animate: Bool) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section,  CellModelType>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(models, toSection: .initial)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension RegistrationViewController{
    var getTableView: UITableView {
        tableView
    }
    
    var getDataSource: UITableViewDiffableDataSource<Section,  CellModelType> {
        dataSource
    }
}
