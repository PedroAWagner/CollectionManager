//
//  CollectionManager.swift
//  CollectionManager
//
//  Created by Pedro Wagner on 22/04/19.
//  Copyright © 2019 Poatek. All rights reserved.
//

import UIKit

internal let defaultCellIdentifier = "DefaultCellIdentifier"
internal let defaultCellHeight = 44.0

class CollectionManager: NSObject {
    weak var collectionView: UICollectionView?
    
    /// The sections added to this table
    open var sections = [CollectionSection]()
    
    /// The sections added to this table and with `visible=true`
    open var sectionsToRender: [CollectionSection] {
        return sections.filter {
            $0.visible
        }
    }
    
    var minimumLineSpacing: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0
    
    // A redirection for all the scroll events
    open weak var scrollViewDelegate: UIScrollViewDelegate?
    
    required init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        super.init()
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    }
    
    //MARK:- Methods
    func reloadData() {
        collectionView?.reloadData()
    }
    
    /// Returns the Row by indexPath, includeAll parameter means it will include rows with visible=false too
    open func row(atIndexPath indexPath: IndexPath, includeAll: Bool = false) -> CollectionRow {
        let section = self.section(atIndex: indexPath.section, includeAll: includeAll)
        return section.row(atIndex: indexPath.row, includeAll: includeAll)
    }
    
    func index(forSection section: CollectionSection, includeAll: Bool = false) -> Int? {
        let objects = includeAll ? sections : sectionsToRender
        
        return objects.index {
            $0 == section
        }
    }
    
    /// Returns the indexPath for the row if exist
    open func indexPath(forRow row: CollectionRow, includeAll: Bool = false) -> IndexPath? {
        let sectionObjects = includeAll ? sections : sectionsToRender
        
        var indexPath: IndexPath?
        
        sectionObjects.enumerated().forEach { indexSection, section in
            if let indexRow = section.index(forCollectionRow: row, includeAll: includeAll) {
                indexPath = IndexPath(row: indexRow, section: indexSection)
            }
        }
        
        return indexPath
    }
    
    /// Returns the Section by indexPath, includeAll parameter means it will include sections with visible=false too
    open func section(atIndex index: Int, includeAll: Bool = false) -> CollectionSection {
        let objects = includeAll ? sections : sectionsToRender
        
        if objects.count > index {
            return objects[index]
        } else {
            return CollectionSection()
        }
    }
    
    @discardableResult
    func addSection(_ section: CollectionSection? = nil) -> CollectionSection {
        let newSection = section ?? CollectionSection()
        if index(forSection: newSection, includeAll: true) == nil {
            sections.append(newSection)
        }
        return newSection
    }
    
    /// Add a new row in the table. A new section will be added if don't exist yet. If any row is passed as parameter, a new empty row will be allocated, added in the first section and returned.
    @discardableResult
    open func addRow(_ row: CollectionRow? = nil) -> CollectionRow {
        let firstSection: CollectionSection
        if sections.count > 0 {
            firstSection = section(atIndex: 0)
        } else {
            firstSection = addSection()
        }
        
        return firstSection.addCollectionRow(row)
    }
    
    /// Initializes a new row with identifier, add it in the table and returns it. A new section will be added if don't exist yet.
    @discardableResult
    open func addRow(_ identifier: String) -> CollectionRow {
        return addRow(CollectionRow(identifier: identifier))
    }
    
    /// Remove all sections
    open func clearSections() {
        sections.removeAll()
    }
    
    /// Remove all rows from the first section
    open func clearRows() {
        if sections.count > 0 {
            sections[0].clearCollectionRows()
        }
    }
    
    /// Convert an indexPath for row with visible: true to an indexPath including all rows
    func convertToIncludeAllIndexPath(withToRenderIndexPath indexPath: IndexPath) -> IndexPath? {
        let row = self.row(atIndexPath: indexPath)
        return self.indexPath(forRow: row, includeAll: true)
    }
}

extension CollectionManager: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsToRender.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section(atIndex: section).rowsToRender.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.row(atIndexPath: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.identifier ?? defaultCellIdentifier, for: indexPath)
        
        row.cell = cell
        row.configuration?(row, cell, indexPath)
        
        return cell
    }
}

extension CollectionManager: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = self.row(atIndexPath: indexPath)
        row.didSelect?(row, collectionView, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = self.row(atIndexPath: indexPath)
        return CGSize(width: row.widthForRow, height: row.heightForRow)
    }
}

