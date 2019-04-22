//
//  CollectionExtension.swift
//  CollectionManager
//
//  Created by Pedro Wagner on 22/04/19.
//  Copyright © 2019 Poatek. All rights reserved.
//

import UIKit

internal let instanceKey = "CollectionManagerInstance"

extension UICollectionView {
    
    var minimumLineSpacing: CGFloat {
        set {
            collectionManagerInstance().minimumLineSpacing = newValue
        }
        get {
            return collectionManagerInstance().minimumLineSpacing
        }
    }
    var minimumInteritemSpacing: CGFloat {
        set {
            collectionManagerInstance().minimumInteritemSpacing = newValue
        }
        get {
            return collectionManagerInstance().minimumInteritemSpacing
        }
    }
    
    /// The instance of CollectionManager. A new one will be created if not exist.
    func collectionManagerInstance() -> CollectionManager {
        guard let tableManager = self.layer.value(forKey: instanceKey) as? CollectionManager else {
            let tableManager = CollectionManager(with: self)
            self.layer.setValue(tableManager, forKey: instanceKey)
            return tableManager
        }
        return tableManager
    }
    
    /// Sections with `visible=true`
    public var sectionsToRender: [CollectionSection] {
        return self.collectionManagerInstance().sectionsToRender
    }
    
    public weak var scrollViewDelegate: UIScrollViewDelegate? {
        set {
            self.collectionManagerInstance().scrollViewDelegate = newValue
        }
        get {
            return self.collectionManagerInstance().scrollViewDelegate
        }
    }
    
    // MARK: Methods
    
    /// Get the Row by indexPath, includeAll parameter means it will include rows with visible=false too
    public func row(atIndexPath indexPath: IndexPath, includeAll: Bool = false) -> CollectionRow {
        return self.collectionManagerInstance().row(atIndexPath: indexPath)
    }
    
    /// Get the Section by indexPath, includeAll parameter means it will include sections with visible=false too
    public func section(atIndex index: Int, includeAll: Bool = false) -> CollectionSection {
        return self.collectionManagerInstance().section(atIndex: index)
    }
    
    /// Returns the indexPath for the row if exist
    public func indexPath(forRow row: CollectionRow, includeAll: Bool = false) -> IndexPath? {
        return self.collectionManagerInstance().indexPath(forRow: row, includeAll: includeAll) as IndexPath?
    }
    
    /// Returns the index of the Section if exist
    public func index(forSection section: CollectionSection, includeAll: Bool = false) -> Int? {
        return self.collectionManagerInstance().index(forSection: section, includeAll: includeAll)
    }
    
    //    /// If exist, return the Row that correspond the selected cell
    //    public func selectedRow() -> CollectionRow? {
    //        return self.collectionManagerInstance().selectedRow()
    //    }
    //
    //    /// If exist, return the Rows that are appearing to the user in the table
    //    public func visibleRows() -> [CollectionRow]? {
    //        return self.collectionManagerInstance().visibleRows()
    //    }
    
    /// Add a new section in the table. If no section is passed as parameter, a new empty section will be allocated and added in the table.
    @discardableResult
    public func addSection(_ section: CollectionSection? = nil) -> CollectionSection {
        return self.collectionManagerInstance().addSection(section)
    }
    
    /// Add a new row in the table. A new section will be added if don't exist yet. If any row is passed as parameter, a new empty row will be allocated, added in the first section and returned.
    @discardableResult
    public func addRow(_ row: CollectionRow? = nil) -> CollectionRow {
        return self.collectionManagerInstance().addRow(row)
    }
    
    /// Initializes a new row with identifier, add it in the table and returns it. A new section will be added if don't exist yet.
    @discardableResult
    public func addRow(_ identifier: String) -> CollectionRow {
        return self.collectionManagerInstance().addRow(identifier)
    }
    
    /// Remove all sections
    public func clearSections() {
        self.collectionManagerInstance().clearSections()
    }
    
    /// Remove all rows from the first section
    public func clearRows() {
        self.collectionManagerInstance().clearRows()
    }
}

