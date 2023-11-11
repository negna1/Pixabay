//
//  PictureDetailsViewControllerTest.swift
//  TestProjectTests
//
//  Created by Nato Egnatashvili on 11.11.23.
//

import XCTest
@testable import TestProject
import Resolver
import NetworkLayer

final class PictureDetailsViewControllerTest: XCTestCase {
    
    var vc: PictureDetailsViewController?
    var hit = Hit()
    override func setUpWithError() throws {
        Resolver.register { _, args in
            PictureListViewModelMock(navigation: args()) as PictureListViewModelType }
        Resolver.register { LogInViewController() }
        vc = PictureDetailsViewController.init(hit: hit)
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

