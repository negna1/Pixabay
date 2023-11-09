//
//  PictureList.ViewController.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import Combine
import UIKit
import Components
import SnapKit
import Resolver


final class PictureListViewController: UIViewController {
    private var cancellables: [AnyCancellable] = []
    private var viewModel: PictureListViewModelType = Resolver.resolve()
    private let selection = PassthroughSubject<RegistrationViewController.CellModelType, Never>(
    )
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.delegate = self
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
        [CenterTitleTableCell.self, ImageWithTitleTableCell.self]
    }
    
    private func registerCells() {
        classes.forEach({ tableView.register($0.self,
                                             forCellReuseIdentifier: String(describing: $0.self)
        )})
        
    }
    
    private func bindViewModel(viewModel: PictureListViewModelType) {
        self.viewModel = viewModel
    }
    
    private func bind(to viewModel: PictureListViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = PictureListViewModelInput(selection: selection.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: PictureListState) {
        switch state {
        case .idle(let cells):
            update(with: cells, animate: false)
        case .navigateToDetails(let hit):
            let vc: PictureDetailsViewController = Resolver.resolve(args: hit)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: - Data source and reload
extension PictureListViewController {
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

//MARK: - Table View cell selection
extension PictureListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        
        selection.send(snapshot.itemIdentifiers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


