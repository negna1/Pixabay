//
//  PictureDetails.ViewCOntroller.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 09.11.23.
//

import Combine
import UIKit
import Components
import SnapKit
import Resolver
import NetworkLayer

final class PictureDetailsViewController: UIViewController {
    private var cancellables: [AnyCancellable] = []
    private lazy var viewModel: PictureDetailsViewModelType = Resolver.resolve(args: hit)
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private var hit: Hit
    
    public init(hit: Hit) {
        self.hit = hit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        [CenterTitleTableCell.self,
         ImageWithTitleTableCell.self,
         IconAndInfoWidgetTableCell.self]
    }
    
    private func registerCells() {
        classes.forEach({ tableView.register($0.self,
                                             forCellReuseIdentifier: String(describing: $0.self)
        )})
        
    }
    
    private func bind(to viewModel: PictureDetailsViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = PictureDetailsViewModelInput()
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: PictureDetailsState) {
        switch state {
        case .idle(let cells):
            update(with: cells, animate: false)
        case .navigationToAuth:
            let vc: RegistrationViewController = Resolver.resolve()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: - Data source and reload
extension PictureDetailsViewController {
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

extension PictureDetailsViewController{
    var getTableView: UITableView {
        tableView
    }
    
    var getDataSource: UITableViewDiffableDataSource<RegistrationViewController.Section,  RegistrationViewController.CellModelType> {
        dataSource
    }
}
