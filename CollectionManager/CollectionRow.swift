//
//  CollectionRow.swift
//  CollectionManager
//
//  Created by Pedro Wagner on 22/04/19.
//  Copyright © 2019 Poatek. All rights reserved.
//

import UIKit

open class CollectionRow: Equatable {
    
    var id = NSObject()
    
    /// The cell identifier
    open var identifier: String?
    
    /// Defines if it need be rendered or not when reload the table.
    open var visible = true
    
    var movable = false
    var deleteConfirmation: String?
    
    /// Read only property that indicate if the row is movable.
    open var canMove: Bool {
        return movable
    }
    
    /// The object that can be used in the closure's impementation.
    open var object: AnyObject?
    
    /// The closure that will be called when the table request the cell.
    open var configuration: Configuration?
    
    /// The closure that will be called when the cell was selected.
    open var didSelect: DidSelect?
    
    /// The closure that will be called when the cell is going to be displayed.
    open var willDisplay: WillDisplay?
    
    /// The closure that will be called when the table request the row's height.
    var heightForRow: Double!
    var widthForRow: Double!
    
    weak var collectionViewReference: UICollectionView?
    
    var indexPathReference: IndexPath?
    
    open weak var cell: UICollectionViewCell?
    
    /// Initializes a new Row. All parameters are optionals.
    public required init(identifier: String? = nil, visible: Bool = true, object: AnyObject? = nil) {
        self.identifier = identifier
        self.visible = visible
        self.object = object
    }
    
    // MARK: Methods
    
    /// Set row visibility
    @discardableResult
    open func setVisible(_ visible: Bool) -> CollectionRow {
        self.visible = visible
        return self
    }
    
    /// Set a identifier to use a custom cell
    @discardableResult
    open func setIdentifier(_ identifier: String) -> CollectionRow {
        self.identifier = identifier
        return self
    }
    
    /// Set object that can be used in the closure's impementation.
    @discardableResult
    open func setObject(_ object: AnyObject) -> CollectionRow {
        self.object = object
        return self
    }
    
    /// Define if the row can be moved
    @discardableResult
    open func setCanMove(_ movable: Bool) -> CollectionRow {
        self.movable = movable
        return self
    }
    
    /// Set closure that will be called when the table request the cell.
    @discardableResult
    open func setConfiguration(_ block: @escaping Configuration) -> CollectionRow {
        self.configuration = block
        return self
    }
    
    /// Set closure that will be called when the cell was selected.
    @discardableResult
    open func setDidSelect(_ block: @escaping DidSelect) -> CollectionRow {
        self.didSelect = block
        return self
    }
    
    /// Set closure that will be called when the cell is going to be displayed.
    @discardableResult
    open func setWillDisplay(_ block: @escaping WillDisplay) -> CollectionRow {
        self.willDisplay = block
        return self
    }
    
    /// Set the row's height using a closure that will be called when the table request the a height
    @discardableResult
    open func setHeight(_ height: Double) -> CollectionRow {
        heightForRow = height
        return self
    }
    
    @discardableResult
    open func setWidth(_ width: Double) -> CollectionRow {
        widthForRow = width
        return self
    }
    
    /// Get the row's height after it has been appeared in the screen
    /// Return`s zero if the visibility is false
    open func getHeight() -> Double {
        if !visible {
            return 0
        }
        
        guard let heightForRow = heightForRow else {
            return defaultCellHeight
        }
        
        guard collectionViewReference != nil else {
            return defaultCellHeight
        }
        
        guard indexPathReference != nil else {
            return defaultCellHeight
        }
        
        if heightForRow > Double(UITableView.automaticDimension) {
            return heightForRow
        }
        
        guard let contentHeight = self.cell?.contentView.frame.height else {
            return defaultCellHeight
        }
        
        return Double(contentHeight)
    }
    
    public typealias HeightForRow = (_ row: CollectionRow, _ collectionView: UICollectionView, _ indexPath: IndexPath) -> Double
    public typealias WidthForRow = (_ row: CollectionRow, _ collectionView: UICollectionView, _ indexPath: IndexPath) -> Double
    public typealias Configuration = (_ row: CollectionRow, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void
    public typealias DidSelect = (_ row: CollectionRow, _ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void
    public typealias WillDisplay = (_ row: CollectionRow, _ collectionView: UICollectionView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> Void
}

public func == (lhs: CollectionRow, rhs: CollectionRow) -> Bool {
    return lhs.id == rhs.id
}

