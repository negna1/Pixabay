//
//  LogIn.ViewController.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 08.11.23.
//

import Combine
import UIKit
import Components
import SnapKit
import Resolver

final class LogInViewController: UIViewController {
    private var cancellables: [AnyCancellable] = []
    private lazy var viewModel: LogInViewModelType = Resolver.resolve(args: navigationController)
    private lazy var dataSource = makeDataSource()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
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
    
    private func bindViewModel(viewModel: LogInViewModelType) {
        self.viewModel = viewModel
    }
    
    private func bind(to viewModel: LogInViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = LogInViewModelInput()
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: LogInState) {
        switch state {
        case .idle(let cells):
            update(with: cells, animate: false)
        }
    }
    
}

//MARK: - Data source and reload
extension LogInViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<RegistrationViewController.Section,  RegistrationViewController.CellModelType> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, type in
                let cell = tableView.dequeueReusableCell(withIdentifier: type.tableCellModel.nibIdentifier) as? ConfigurableTableCell
                cell?.configure(with: type.tableCellModel)
                return cell ?? UITableViewCell()
            }
        )
    }
    
    func update(with models: [RegistrationViewController.CellModelType], animate: Bool) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<RegistrationViewController.Section,  RegistrationViewController.CellModelType>()
            snapshot.appendSections(RegistrationViewController.Section.allCases)
            snapshot.appendItems(models, toSection: .initial)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension LogInViewController{
    var getTableView: UITableView {
        tableView
    }
    
    var getDataSource: UITableViewDiffableDataSource<RegistrationViewController.Section,  RegistrationViewController.CellModelType> {
        dataSource
    }
}
