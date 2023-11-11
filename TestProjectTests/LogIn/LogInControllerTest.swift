//
//  LogInControllerTest.swift
//  TestProjectTests
//
//  Created by Nato Egnatashvili on 11.11.23.
//

import XCTest
@testable import TestProject
import Resolver


final class LogInControllerTest: XCTestCase {
    
    var vc: LogInViewController?
    override func setUpWithError() throws {
        Resolver.register { _, args in
            LogInViewModelMock(navigation: args()) as LogInViewModelType }
        Resolver.register { LogInViewController() }
        vc = LogInViewController()
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

