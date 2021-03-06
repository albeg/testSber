//
//  NewsViewController.swift
//  TestSber
//
//  Created by Viacheslav Loie on 25.04.2020.
//  Copyright © 2020 SberTestViper. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, NewsViewInConnection {
	
	// MARK: - presenter
	var presenter: NewsViewOutConnection?
	
	// MARK: - collectionView
	var collectionView: UICollectionView! = nil
	
	// MARK: - isCollections
	var isCollections: Bool = false
	
	// MARK: - Loader
	private lazy var loader = Loader(view: collectionView)
	
	// MARK: - refreshControl
	private var refreshControl: UIRefreshControl = UIRefreshControl()
	
	// MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionView()
		presenter?.viewDidLoad()
		view.backgroundColor = .white
		refreshControll()
	}
	
	// MARK: - viewWillAppear
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter?.viewWillAppear()
		setupNavBar()
		addRightBarButtonItem()
		refreshControll()
	}
	
	// MARK: fileprivate func refreshControll()
	fileprivate func refreshControll() {
		refreshControl.addTarget(self, action: #selector(NewsViewController.reloadData), for: UIControl.Event.valueChanged)
		collectionView.addSubview(refreshControl)
		refreshControl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		refreshControl.tintColor = UIColor.sberGreen
		reloadData()
	}
	
	func updateUrl()  {
		if presenter?.isAllSelected == true {
			presenter?.finamFetch() // finam
		} else {
			presenter?.bankiRUFetch() // banki
		}
	}
	
	// MARK: - reloadData
	@objc func reloadData()  {
		updateUrl()
		self.collectionView.reloadData()
		self.refreshControl.endRefreshing()
	}
	
	// MARK: - collectionButtonClickeds
	@objc  func collectionButtonClickeds() {
		updateUrl()
		self.collectionView.reloadData()
		scrollToTop(animated: true)
	}
	
	// MARK: - hideLoader
	func hideLoader() {
		loader.hide()
	}
	
	// MARK: - showLoader
	func showLoader() {
		loader.show()
	}
	
	// MARK:  updateSearchBar()
	func scrollToTop(animated: Bool) {
		collectionView?.scrollToItem(at:  IndexPath.init(row: 0, section: 0), at: .top, animated: true)
	}

	// MARK: - addRightBarButtonItem(Nav)
	private func addRightBarButtonItem() {
		let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"),
											style: .plain, target: self, action: #selector(updateButtonClicked))
		let barButtonItems = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.2x2"),
											 style: .plain, target: self, action: #selector(collectionButtonClickeds))
		barButtonItem.tintColor = #colorLiteral(red: 0.09803921569, green: 0.6274509804, blue: 0.1568627451, alpha: 1)
		barButtonItems.tintColor = #colorLiteral(red: 0.09803921569, green: 0.6274509804, blue: 0.1568627451, alpha: 1)
		navigationItem.rightBarButtonItems = [barButtonItem, barButtonItems]
	}
	
	// MARK: - backButtonClicked(Nav)
	@objc func updateButtonClicked() {
		reloadData()
		scrollToTop(animated: true)
	}
	
	// MARK: - init
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 0)
		tabBarItem.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal).withTintColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
		tabBarItem.selectedImage = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal).withTintColor(#colorLiteral(red: 0.09803921569, green: 0.6274509804, blue: 0.1568627451, alpha: 1))
		// make unselected icons white
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - setupNavBar()
extension NewsViewController {
	private func setupNavBar() {
		navigationController?.setNavigationBarHidden(false, animated: true)
		title = NSLocalizedString("title.navBarHome", comment: "Главная")
		navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.sberGreen]
	}
}

// MARK: - setupCollectionView()
extension NewsViewController {
	private func setupCollectionView() {
		if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
			flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
		}
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
		collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView?.backgroundColor = .white
		registerCells()
		view.addSubview(collectionView)
	}
}

// MARK: - Setup Layout
extension NewsViewController {
	// Работает только с IOS 13 (new fitcha)
	private func createLayout() -> UICollectionViewLayout {
		// section -> groups -> items -> size
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											  heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: .fractionalWidth(0.75))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
		let spacing = CGFloat(15)
		group.interItemSpacing = .fixed(spacing)
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = spacing
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}
}

// MARK: - registerCells()
extension NewsViewController {
	private func registerCells()  {
		collectionView?.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.reuseId)
	}
}



