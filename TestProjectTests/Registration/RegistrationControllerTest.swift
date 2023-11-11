//
//  RegistrationControllerTest.swift
//  TestProjectTests
//
//  Created by Nato Egnatashvili on 10.11.23.
//

import XCTest
@testable import TestProject
import Resolver


final class RegistrationControllerTest: XCTestCase {
    
    var vc: RegistrationViewController?
    override func setUpWithError() throws {
        Resolver.register { _, args in
            RegistrationViewModelMock(navigation: args()) as RegistrationViewModelType }
        Resolver.register { RegistrationViewController() }
        vc = RegistrationViewController()
    }
    
    func testTable() {
        XCTAssert(vc?.getTableView.numberOfRows(inSection: 0) == 0)
        
    }
    
    func testAfterViewDidLoad() {
        vc?.viewDidLoad()
        XCTAssertEqual(vc!.getDataSource.snapshot().numberOfItems, mockDataSource.snapshot().numberOfItems)
        
    }
    
    var mockDataSource: UITableViewDiffableDataSource<RegistrationViewController.Section,  RegistrationViewController.CellModelType> {
        let dt = UITableViewDiffableDataSource<RegistrationViewController.Section,  RegistrationViewController.CellModelType>.init(tableView: UITableView()) { tableView, indexPath, itemIdentifier in
            return UITableViewCell()
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<RegistrationViewController.Section,  RegistrationViewController.CellModelType>()
        snapshot.appendSections(RegistrationViewController.Section.allCases)
        snapshot.appendItems([RegistrationViewController.CellModelType.title("ola")], toSection: .initial)
        dt.apply(snapshot, animatingDifferences: false)
        return dt
    }
}
