//
//  ViewController.swift
//  CompositionalLayout
//
//  Created by Rahul on 28/06/22.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

class ViewController: UIViewController {

    // Item -> Group -> Section -> Layout
    private lazy var layout: UICollectionViewLayout = {

        // Layout
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var columns = 1

            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

            // Group
            var groupHeight = NSCollectionLayoutDimension.absolute(44)

            var groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)


            // Section
            var section = NSCollectionLayoutSection(group: NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item]))
            switch sectionIndex{
            case 1:
                columns = 3
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.4))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: columns)
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
            case 2:
                columns = 5
                groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.6)
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

            case 3:
                columns = 4
                groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.5)
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous

            default:
                columns = 1
                groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.6)
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: groupHeight)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging

            }

            return section
        }

        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

private extension ViewController {
    func setup() {
        self.view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { 5 }

    func numberOfSections(in collectionView: UICollectionView) -> Int { 8 }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .random()
        return cell
    }
}
