//
//  UserViewController.swift
//  TestSber
//
//  Created by Viacheslav Loie on 25.04.2020.
//  Copyright © 2020 SberTestViper. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UserViewInConnection {
	
	// MARK: - presenter
	var presenter: UserViewOutConnection?
	
	// MARK: - private
	private var openButton: UIButton = UIButton()
	
	// MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter?.viewDidLoad()
		view.backgroundColor = .white
		addButton()
		addTarget()
	}

	// MARK: - viewDidLoad
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavBar()
		openButton.pulsate()
	}
	
	// MARK: - viewDidLoad
	private func addTarget() {
		openButton.addTarget(self, action: #selector(openButtonAction), for: .touchUpInside)
	}
	
	@objc private func openButtonAction() {
		showHomeVC()
	}
	
	// MARK: - init
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
	  super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	  tabBarItem = UITabBarItem(title: "Аккаунт", image: UIImage(named: "User"), tag: 2)
	  tabBarItem.image = UIImage(named: "User")?.withRenderingMode(.alwaysOriginal)
	  tabBarItem.selectedImage = UIImage(named: "User")?.withRenderingMode(.alwaysOriginal)
	}
	
	required init?(coder aDecoder: NSCoder) {
	  fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - setupNavBar()
extension UserViewController {
	private func setupNavBar() {
		navigationController?.setNavigationBarHidden(false, animated: true)
		title = "Аккаунт"
		navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.semibold20, NSAttributedString.Key.foregroundColor: UIColor.sberGreen]
	}
}

// MARK: - addButton
extension UserViewController {
	private func addButton() {
		view.addSubview(openButton)
		openButton.translatesAutoresizingMaskIntoConstraints = false
		openButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		openButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		openButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
		openButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
		openButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
		openButton.roundedButtonYellow(cornerRadius: 10)
		openButton.backgroundColor = .white
		openButton.setTitleColor(UIColor.sberGreen, for: .normal)
		openButton.setTitle(NSLocalizedString("button.newsUser", comment: "Почитай новости"), for: .normal)
		openButton.titleLabel?.font = UIFont.semibold15
		
	}
}

extension UserViewController {
	
	// MARK: Router (tabBarController)
	func showHomeVC() {
		self.tabBarController?.selectNews()
	}
}


