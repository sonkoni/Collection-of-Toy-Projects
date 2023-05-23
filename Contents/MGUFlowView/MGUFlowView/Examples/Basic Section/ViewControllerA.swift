//
//  ViewControllerA.swift
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import BaseKit
import IosKit

final class ViewControllerA: UIViewController {
    
    // MARK: - Property
    var itemSize: CGSize?
    var flowView: MGUFlowView?
    var diffableDataSource: MGUFlowDiffableDataSource<NSNumber, NSString>?
    private var items: [String]?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = view.bounds.width - (20.0 * 2)
        itemSize = CGSize(width: width, height: 65.0)
        guard let itemSize = itemSize, let flowViewItemSize = flowView?.itemSize else {
            return
        }
        if CGSizeEqualToSize(itemSize, flowViewItemSize) == false {
            flowView?.itemSize = itemSize
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Folding Style"
        let items = ["faceid",
                     "calendar.badge.clock",
                     "teletype.answer.circle.fill",
                     "coloncurrencysign.circle",
                     "photo.on.rectangle.angled",
                     "square.grid.3x3",
                     "note.text.badge.plus",
                     "person.crop.circle.badge.plus",
                     "globe.badge.chevron.backward",
                     "circle.hexagongrid.fill",
                     "trash.circle",
                     "folder.badge.plus",
                     "paperplane",
                     "tray.full",
                     "mic.slash.circle.fill",
                     "sun.dust.fill"]
        self.items = items
        let width = UIScreen.main.bounds.width - (2 * 20.0)
        let itemSize = CGSize(width: width, height: 65.0)
        let flowView = MGUFlowView()
        self.itemSize = itemSize
        self.flowView = flowView
        flowView.register(MGUFlowFoldCell.self, forCellWithReuseIdentifier: NSStringFromClass(MGUFlowFoldCell.self))
        flowView.register(MGUFlowIndicatorSupplementaryView.self,
                           forSupplementaryViewOfKind: MGUFlowElementKindFold.leading.rawValue,
                           withReuseIdentifier: MGUFlowElementKindFold.leading.rawValue)
        
        flowView.itemSize = itemSize
        flowView.leadingSpacing = 20.0
        flowView.interitemSpacing = 0.0
        flowView.scrollDirection = .vertical
        flowView.decelerationDistance = MGUFlowView.automaticDistance
        flowView.transformer = nil
        flowView.delegate = self
        flowView.bounces = true
        flowView.alwaysBounceVertical = true
        flowView.clipsToBounds = true
        let transformer = MGUFlowFoldTransformer()
        flowView.transformer = transformer
        view.addSubview(flowView)
        flowView.mgrPinEdgesToSuperviewSafeAreaLayoutGuide()

        let diffableDataSource =
        MGUFlowDiffableDataSource<NSNumber, NSString>(flowView: flowView,
                                                      cellProvider: { (collectionView: UICollectionView,
                                                                       indexPath: IndexPath,
                                                                       str: Any) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MGUFlowFoldCell.self),
                                                                for: indexPath) as? MGUFlowFoldCell else {
                return MGUFlowFoldCell()
            }
            let symbolConfiguration = UIImage.SymbolConfiguration.init(pointSize: 22.0, weight: .medium, scale: .medium)
            let colorConfig = UIImage.SymbolConfiguration.preferringMulticolor()
            let config = colorConfig.applying(symbolConfiguration)
            
            cell.tintColor = UIColor(red: CGFloat(arc4random() % 256) / 255.0,
                                     green: CGFloat(arc4random() % 256) / 255.0,
                                     blue: CGFloat(arc4random() % 256) / 255.0,
                                     alpha: 1.0)
            
            var contentConfiguration = UIListContentConfiguration.cell()
            guard let str = str as? String else {
                return cell
            }
            contentConfiguration.text = str.components(separatedBy: ".").first?.capitalized
            contentConfiguration.secondaryText = str
            contentConfiguration.secondaryTextProperties.color = .darkGray
            contentConfiguration.image = UIImage(systemName: str, withConfiguration: config)
            
            let fontDescriptor = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight(10.0)).fontDescriptor
            let designFontDescriptor = fontDescriptor.withDesign(.default)
            let italicFontDescriptor = designFontDescriptor?.withSymbolicTraits(.traitItalic)
            if let italicFontDescriptor = italicFontDescriptor {
                contentConfiguration.secondaryTextProperties.font = UIFont(descriptor: italicFontDescriptor, size: 0.0)
            } else if let designFontDescriptor = designFontDescriptor {
                contentConfiguration.secondaryTextProperties.font = UIFont(descriptor: designFontDescriptor, size: 0.0)
            } else {
                contentConfiguration.secondaryTextProperties.font = UIFont(descriptor: fontDescriptor, size: 0.0)
            }
            cell.contentConfiguration = contentConfiguration
            
            var backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
            backgroundConfiguration.backgroundColor = .white
            backgroundConfiguration.strokeWidth = (1.0 / UIScreen.main.scale) * 2.0
            backgroundConfiguration.strokeOutset = (1.0 / UIScreen.main.scale)
            backgroundConfiguration.strokeColor = .black
            cell.backgroundConfiguration = backgroundConfiguration
            cell.layer.masksToBounds = false
            cell.layer.shouldRasterize = true // http://wiki.mulgrim.net/page/Api:Core_Animation/CALayer/shouldRasterize
            cell.layer.rasterizationScale = UIScreen.main.scale
            return cell
        })
        
        self.diffableDataSource = diffableDataSource;
        diffableDataSource.elementOfKinds = [MGUFlowElementKindFold.leading.rawValue]
        diffableDataSource.supplementaryViewProvider = { (collectionView: UICollectionView,
                                                          elementKind: String,
                                                          indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                                             withReuseIdentifier: elementKind,
                                                                             for: indexPath) as? MGUFlowIndicatorSupplementaryView else {
                return MGUFlowIndicatorSupplementaryView()
            }
            
            if elementKind == MGUFlowElementKindFold.leading.rawValue {
                cell.indicatorColor = .systemTeal
            } else {
                fatalError("뭔가 잘못들어왔다.")
            }
            return cell
        }
        
        diffableDataSource.volumeType = .finite  // 디폴트
        
        let snapshot = NSDiffableDataSourceSnapshotReference()
        snapshot.appendSections(withIdentifiers: [NSNumber(value: 0)])
        snapshot.appendItems(withIdentifiers: items, intoSectionWithIdentifier: NSNumber(value: 0))
        diffableDataSource.applySnapshot(snapshot, animatingDifferences: true)
    }
}

extension ViewControllerA : MGUFlowViewDelegate {}
