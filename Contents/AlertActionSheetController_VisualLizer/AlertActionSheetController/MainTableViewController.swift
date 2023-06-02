//
//  ViewController.swift
//  Alert & Action Sheet
//
//  Created by Kwan Hyun Son on 2022/10/08.
//

import UIKit
import MapKit
import IosKit
import AudioKit

final class TableViewDiffableDataSource: UITableViewDiffableDataSource<String, Item> {
    // MARK: header/footer titles support
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let allItems = ItemsForTableView.shared.allItems
        return allItems[section].sectionTitle
    }
}

final class MainTableViewController: UIViewController {
    
    var dataSource : TableViewDiffableDataSource?
    var currentSnapshot : NSDiffableDataSourceSnapshot<String, Item>?
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let pickerSound = MGOSoundPicker.pickerSound
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alert & Action Sheet"
        configureTableView()
        configureDataSource()
        updateUI(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //! 현재 컨트롤러가 UITableViewController 가 아니므로, clearsSelectionOnViewWillAppear가 없다.
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at:indexPath, animated:true)  // 원래 뷰로 돌아 올때, 셀렉션을 해제시킨다. 이게 더 멋지다.
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension MainTableViewController {
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:NSStringFromClass(UITableViewCell.self))
        tableView.delegate = self
    }
    
    func configureDataSource() {
        
        dataSource =
        TableViewDiffableDataSource (tableView: tableView) {
             (tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier:NSStringFromClass(UITableViewCell.self),
                for: indexPath)
            
            // cell.accessoryType = .disclosureIndicator
            var content = cell.defaultContentConfiguration()
            // content.text = item.title
            // content.secondaryText = item.detailText
            let attributedText = NSMutableAttributedString(string: item.title)
            attributedText.addAttributes([NSAttributedString.Key.backgroundColor : UIColor.systemPink,
                                          NSAttributedString.Key.foregroundColor : UIColor.white,
                                          NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17.0)],
                                         range: (item.title as NSString).range(of: "IV-Drop에서 이용"))
            content.attributedText = attributedText
            if let detailText = item.detailText {
                let secondaryAttributedText = NSMutableAttributedString(string: detailText)
                secondaryAttributedText.addAttributes([NSAttributedString.Key.backgroundColor : UIColor.systemYellow,
                                                       NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 12.0)],
                                                      range: (detailText as NSString).range(of: "Alert"))
                secondaryAttributedText.addAttributes([NSAttributedString.Key.backgroundColor : UIColor.systemBlue,
                                                       NSAttributedString.Key.foregroundColor : UIColor.white,
                                                       NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 12.0)],
                                                      range: (detailText as NSString).range(of: "ActionSheet"))
                content.secondaryAttributedText = secondaryAttributedText
            }
            
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top:8.0, leading:8.0, bottom:8.0, trailing:8.0)
            content.textToSecondaryTextVerticalPadding = 5.0
            cell.contentConfiguration = content
            return cell
        }

        dataSource?.defaultRowAnimation = .fade
    }
    
    func updateUI(animated: Bool = true) {
        currentSnapshot = NSDiffableDataSourceSnapshot<String, Item>()
        let allItems = ItemsForTableView.shared.allItems
        for i in 0..<allItems.count {
            let section = allItems[i]
            let sectionTitle = section.sectionTitle
            let items = section.items
            
            currentSnapshot?.appendSections([sectionTitle])
            currentSnapshot?.appendItems(items, toSection:sectionTitle)
        }
        
        dataSource?.apply(currentSnapshot!, animatingDifferences: animated)
    }
}


// MARK: - UITableViewDelegate
extension MainTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var alertViewController: MGUAlertViewController?
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 0 {
            if indexPath.row <= 3 {
                alertViewController = createCustomAlertView(buttonCount: indexPath.row)
            } else if indexPath.row == 4 {
                alertViewController = createTextFieldAlertView()
            } else if indexPath.row == 5 {
                alertViewController = createCustomFontAlertView()
            } else if indexPath.row == 6 {
                alertViewController = createLongMessageAlertView()
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                alertViewController = createCustomContentViewAlertView1()
            } else if indexPath.row == 1 {
                alertViewController = createCustomContentViewAlertView2()
            } else if indexPath.row == 2 {
                alertViewController = createCustomContentViewAlertView3()
            } else if indexPath.row == 3 {
                alertViewController = createCustomContentViewAlertView4()
            } else if indexPath.row == 4 {
                alertViewController = createCustomContentViewAlertView5()
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                alertViewController = createActionSheet1(cell)
            } else if indexPath.row == 1 {
                alertViewController = createActionSheet2(cell)
            } else if indexPath.row == 2 {
                alertViewController = createActionSheet3(cell)
            } else if indexPath.row == 3 {
                alertViewController = createActionSheet4(cell)
            } else if indexPath.row == 4 {
                alertViewController = createActionSheet5(cell)
            } else if indexPath.row == 5 {
                alertViewController = createActionSheet6(cell)
            } else if indexPath.row == 6 {
                alertViewController = createActionSheet7(cell)
            }
        }
        if let alertViewController = alertViewController {
            present(alertViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - Create Alert Basic
private extension MainTableViewController {
    func createCustomAlertView(buttonCount: Int) -> MGUAlertViewController {
        
        var mutableActions = [MGUAlertAction]()
        
        for i in 0..<buttonCount {
            var buttonTitle : String
            var actionStyle : UIAlertAction.Style
            var handler : (MGUAlertAction) -> Void
            if i != buttonCount - 1 {
                buttonTitle = String(format: "Button %ld", i + 1)
                actionStyle = UIAlertAction.Style.default
                handler = { (action: MGUAlertAction) -> Void in
                    print("버튼 \(i+1) 눌렀음.")
                }
            } else {
                buttonTitle = "Cancel"
                actionStyle = UIAlertAction.Style.cancel
                handler = { (action: MGUAlertAction) -> Void in
                    print("Cancel 버튼 눌렀음.")
                }
                // cancel button에 해당하는 마지막 버튼 set up
            }
            let alertAction = MGUAlertAction.init(title: buttonTitle, style: actionStyle, handler: handler, configuration: nil)
            mutableActions.append(alertAction)
        }
        
        let configuration = MGUAlertViewConfiguration()
        configuration.transitionStyle = [.fgFade, .bgScale]
        
        configuration.backgroundTapDismissalGestureEnabled = true
        configuration.swipeDismissalGestureEnabled = true
        configuration.alwaysArrangesActionButtonsVertically = true
        
        let title = "This is Title"
        let message = "MGUAlertViewController is presented. transitionStyle == [.fgFade, .bgScale]. To dismiss, tap the background, swipe the alert view, or press the button."
        return MGUAlertViewController.init(configuration: configuration,
                                           title: title,
                                           message: message,
                                           actions: mutableActions)
        //
        // 0, 1, 2, 3 : 총 4가지
    }
    
    func createTextFieldAlertView() -> MGUAlertViewController {
        let title = "Login"
        let message = "The submit action is disabled until text is entered in both text fields"
        let configuration = MGUAlertViewConfiguration()
        configuration.transitionStyle = [.fgFade]
        
        let alertViewController = MGUAlertViewController.init(configuration: configuration,
                                                              title: title,
                                                              message: message,
                                                              actions: nil)
        alertViewController.addTextField { (textField: UITextField) in
            textField.placeholder = NSLocalizedString("Username", comment: "")
        }
        
        alertViewController.addTextField { (textField: UITextField) in
            textField.placeholder = NSLocalizedString("Password", comment: "")
            textField.isSecureTextEntry = true
        }
        
        let submitActionHandler = { [weak alertViewController] (action: MGUAlertAction?) -> Void in
            print("submitAction 버튼 눌렀음.")
            print("userName value: \(String(describing: alertViewController?.textFields.first?.text))")
            print("Password value: \(String(describing: alertViewController?.textFields.last?.text))")
        }
        
        let submitAction = MGUAlertAction.init(title: "Submit", style: .default, handler: submitActionHandler, configuration: nil)
        submitAction.enabled = false
        let cancelHandler = { (action: MGUAlertAction?) -> Void in
            print("취소버튼 눌렀음.")
        }
            
        let cancelAction = MGUAlertAction.init(title: "Cancel", style: .cancel, handler: cancelHandler, configuration: nil)
        
        alertViewController.actions = [submitAction, cancelAction]
        // 사용자가 두 개의 텍스트 필드 모두를 채울 때까지 submit action 버튼을 disable한다.
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                               object: nil,
                                               queue: .main) { [weak alertViewController] (note: Notification) in
            let usernameTextField = alertViewController?.textFields.first
            let passwordTextField = alertViewController?.textFields.last
            if let count1 = usernameTextField?.text?.count, let count2 = passwordTextField?.text?.count, count1 > 0, count2 > 0 {
                submitAction.enabled = true
            } else {
                submitAction.enabled = false
            }
        }
        return alertViewController
    }
    
    func createCustomFontAlertView() -> MGUAlertViewController {
        let buttonConfiguration = MGUAlertActionConfiguration()
        buttonConfiguration.titleColor = .init(red: 0.42, green: 0.78, blue: 0.32, alpha: 1.0)
        if let font = UIFont.init(name: "AvenirNext-Medium", size: 19.0) {
            buttonConfiguration.titleFont = font
        }
        
        let cancelButtonConfiguration = MGUAlertActionConfiguration()
        cancelButtonConfiguration.titleColor = .lightGray
        if let font = UIFont.init(name: "AvenirNext-Regular", size: 17.0) {
            cancelButtonConfiguration.titleFont = font
        }

        let configuration = MGUAlertViewConfiguration()
        configuration.buttonConfiguration = buttonConfiguration
        configuration.cancelButtonConfiguration = cancelButtonConfiguration
        configuration.alertContainerViewBackgroundColor = .init(white: 0.19, alpha: 1.0)
        configuration.showsSeparators = false
        if let font = UIFont.init(name: "AvenirNext-Bold", size: 18.0) {
            configuration.titleFont = font
        }
        if let font = UIFont.init(name: "AvenirNext-Medium", size: 16.0) {
            configuration.messageFont = font
        }
        configuration.alertViewCornerRadius = 10.0
        configuration.backgroundTapDismissalGestureEnabled = true
        configuration.swipeDismissalGestureEnabled = true
        configuration.alwaysArrangesActionButtonsVertically = true
        configuration.titleTextColor = .init(red: 0.42, green: 0.78, blue: 0.32, alpha: 1.0)
        configuration.messageTextColor = .init(white: 0.92, alpha: 1.0)

        let title = "Custom Fonts"
        let message = "You take the blue pill, the story ends, you wake up in your bed and believe whatever you want to believe. You take the red pill, you stay in Wonderland, and I show you how deep the rabbit hole goes."
        
        let okActionHandler = { (action: MGUAlertAction?) -> Void in
            print("Subscribe 버튼 눌렀음.")
        }
        let okAction = MGUAlertAction.init(title: "Take the red pill", style: .default, handler: okActionHandler, configuration: nil)
        
        let cancelActionHandler = { (action: MGUAlertAction?) -> Void in
            print("Cancel 버튼 눌렀음.")
        }
        let cancelAction = MGUAlertAction.init(title: "Cancel", style: .cancel, handler: cancelActionHandler, configuration: nil)
        
        return MGUAlertViewController.init(configuration: configuration,
                                           title: title,
                                           message: message,
                                           actions: [okAction, cancelAction])
    }
    
    func createLongMessageAlertView() -> MGUAlertViewController {
        let configuration = MGUAlertViewConfiguration()
        configuration.transitionStyle = [.fgSlideFromBottom, .bgScale]
        
        let title = "TERMS AND CONDITIONS"
        let message = "THIS PURCHASE AGREEMENT (the \"Agreement\") sets forth the terms and conditions that apply to all purchases of goods and services by Apple from Seller by means of a purchase order (a \"PO\") issued by Apple to Seller. As used in this Agreement, \"Seller\" means the entity identified on the face of a PO as \"Seller\" and its subsidiaries and affiliates, and \"Apple\" means Apple Inc. and its subsidiaries and affiliates. Seller and Apple hereby agree as follows: 1. SERVICES & DELIVERABLES. Seller agrees to perform the services (\"Services\") and/or provide the goods or deliverables described in a PO (collectively referred to as \"Goods\"), in accordance with the terms and conditions in this Agreement and the terms and conditions on the face of the PO, which terms are incorporated herein by reference. Upon acceptance of a PO, shipment of Goods or commencement of Services, Seller shall be bound by the provisions of this Agreement, whether Seller acknowledges or otherwise signs this Agreement or the PO, unless Seller objects to such terms in writing prior to shipping Goods or commencing Services. A PO does not constitute a firm offer and may be revoked at any time prior to acceptance. This Agreement may not be added to, modified, superseded, or otherwise altered, except in writing signed by an authorized Apple representative. Any terms or conditions contained in any acknowledgment, invoice, or other communication of Seller which are inconsistent with the terms and conditions of this Agreement, are hereby rejected. To the extent that a PO might be treated as an acceptance of Seller's prior offer, such acceptance is expressly made on condition of assent by Seller to the terms hereof, and shipment of the Goods or beginning performance of any Services by Seller shall constitute such assent. Apple hereby reserves the right to reschedule any delivery or cancel any PO issued at any time prior to shipment of the Goods or prior to commencement of any Services. Apple shall not be subject to any charges or other fees as a result of such cancellation."
        
        let acceptActionHandler = { (action: MGUAlertAction?) -> Void in
            print("Accept 버튼 눌렀음.")
        }
        let acceptAction = MGUAlertAction.init(title: "Accept", style: .default, handler: acceptActionHandler, configuration: nil)
        
        let declineActionHandler = { (action: MGUAlertAction?) -> Void in
            print("Decline 버튼 눌렀음.")
        }
        let declineAction = MGUAlertAction.init(title: "Decline", style: .default, handler: declineActionHandler, configuration: nil)
        
        return MGUAlertViewController.init(configuration: configuration,
                                           title: title,
                                           message: message,
                                           actions: [acceptAction, declineAction])
    }
}


// MARK: - Create Alert Advanced
private extension MainTableViewController {
    func createCustomContentViewAlertView1() -> MGUAlertViewController {
        let title = "Content View"
        let message = "To add a custom view to the alert view, set the contentView property."
        
        let deleteActionHandler = { (action: MGUAlertAction?) -> Void in
            print("Delete 버튼 눌렀음.")
        }
        let deleteAction = MGUAlertAction.init(title: "Delete", style: .destructive, handler: deleteActionHandler, configuration: nil)
        
        let cancelHandler = { (action: MGUAlertAction?) -> Void in
            print("Cancel 버튼 눌렀음.")
        }
        let cancelAction = MGUAlertAction.init(title: "Cancel", style: .cancel, handler: cancelHandler, configuration: nil)
        
        let alertViewController = MGUAlertViewController.init(configuration: nil,
                                                              title: title,
                                                              message: message,
                                                              actions: [deleteAction, cancelAction])
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.heightAnchor.constraint(equalToConstant: 160.0).isActive = true
        let houseCoordinate = CLLocationCoordinate2DMake(37.535313, 126.944688)
        mapView.region = MKCoordinateRegion(center: houseCoordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
        alertViewController.contentView = mapView
        return alertViewController
    }

    func createCustomContentViewAlertView2() -> MGUAlertViewController {
        let title = "Content View"
        let message = "To add a custom view to the alert view, set the contentView property."
        let cancelHandler = { (action: MGUAlertAction?) -> Void in
            print("Later버튼 눌렀음.")
        }
        let cancelAction = MGUAlertAction.init(title: "Later", style: .default, handler: cancelHandler, configuration: nil)
        
        
        let okActionHandler = { (action: MGUAlertAction?) -> Void in
            print("OK 버튼 눌렀음.")
        }
        let okAction = MGUAlertAction.init(title: "Ok", style: .cancel, handler: okActionHandler, configuration: nil)

        let configuration = MGUAlertViewConfiguration()
        configuration.transitionStyle = [.fgSlideFromTop]
        let alertViewController = MGUAlertViewController.init(configuration: configuration,
                                                              title: title,
                                                              message: message,
                                                              actions: [cancelAction, okAction])
        
        // 이미지 제작자 : John Alberton
        // https://www.istockphoto.com/kr/portfolio/JohnAlberton?mediatype=illustration
        // https://www.istockphoto.com/kr/벡터/화려한-하늘과-바위가있는-아름다운-해변의-일몰-gm1408146499-459099221
        let imageView = UIImageView(image: UIImage(named: "BannerImage"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        alertViewController.contentView = imageView
        return alertViewController
    }
    
    func createCustomContentViewAlertView3() -> MGUAlertViewController {
        let dosePickerTitles = ["Mg", "Mcg", "Grams", "None"] as NSMutableArray
        let weightPickerTitles = ["Kg", "None"] as NSMutableArray
        let timePickerTitles = ["Hr", "Min", "None"] as NSMutableArray
        let initialTitles = ["Grams", "None", "Hr"] as NSMutableArray
        
        let dosePickerViewController = MGUDosePickerViewController(doseTitles: dosePickerTitles,
                                                                   weightTitles: weightPickerTitles,
                                                                   timeTitles: timePickerTitles,
                                                                   initialTitles: initialTitles)
        dosePickerViewController.normalSoundPlayBlock = self.pickerSound.playSoundTick
            
        let title = "Dose Unit"
        let message = "hello world haha hoho selection!"

        let configuration = MGUAlertViewConfiguration.dosePicker()
        
        let cancelActionHandler = { (action: MGUAlertAction?) -> Void in
            print("Cancel 버튼 눌렀음.")
        }
        let cancelAction = MGUAlertAction.init(title: "Cancel", style: .cancel, handler: cancelActionHandler, configuration: nil)

        let doneActionHandler = { [weak dosePickerViewController] (action: MGUAlertAction?) -> Void in  // 순환참조는 발생 안함.
            print("Done 버튼 눌렀음.")
            print(dosePickerViewController?.selectedDosePickerTitle as Any,
                  dosePickerViewController?.selectedWeightPickerTitle as Any,
                  dosePickerViewController?.selectedTimePickerTitle as Any)
        }
        let doneAction = MGUAlertAction.init(title: "Done", style: .default, handler: doneActionHandler, configuration: nil)
        
        let alertViewController = MGUAlertViewController.init(configuration: configuration,
                                                              title: title,
                                                              message: message,
                                                              actions: [cancelAction, doneAction])
        alertViewController.secondContentViewController = dosePickerViewController
        alertViewController.addChild(dosePickerViewController)
        dosePickerViewController.didMove(toParent: alertViewController)
        dosePickerViewController.view.heightAnchor.constraint(equalTo: dosePickerViewController.view.widthAnchor, multiplier: 0.6).isActive = true
        alertViewController.secondContentView = dosePickerViewController.view
        return alertViewController
    }
    
    func createCustomContentViewAlertView4() -> MGUAlertViewController {
        let title = "Save & Alarm"
        let message = "A message should be a short, complete sentence."
        let saveAlarm = SaveAlarm()
        
        
        let configuration = MGUAlertViewConfiguration.forgeSaveAlarm()
        
        let cancelActionHandler = { (action: MGUAlertAction?) -> Void in
            print("Cancel 버튼 눌렀음.")
        }
        let cancelAction = MGUAlertAction.init(title: "Cancel", style: .cancel, handler: cancelActionHandler, configuration: nil)
        
        let doneActionHandler = { (action: MGUAlertAction?) -> Void in  // 순환참조는 발생 안함.
            
        }
        let doneAction = MGUAlertAction.init(title: "Action", style: .default, handler: doneActionHandler, configuration: nil)
        doneAction.enabled = false
        
        let alertViewController = MGUAlertViewController.init(configuration: configuration,
                                                              title: title,
                                                              message: message,
                                                              actions: [cancelAction, doneAction])
        
        saveAlarm.translatesAutoresizingMaskIntoConstraints = false
        saveAlarm.heightAnchor.constraint(equalTo: saveAlarm.widthAnchor, multiplier: 0.3).isActive = true
        alertViewController.thirdContentView = saveAlarm
        
        // 사용자가 두 개의 텍스트 필드 모두를 채울 때까지 submit action 버튼을 disable한다.
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                               object: nil,
                                               queue: .main) { [weak alertViewController] (note: Notification) in
            if let count = alertViewController?.textFields.first?.text?.count, count > 0 {
                doneAction.enabled = true
            } else {
                doneAction.enabled = false
            }
        }
        alertViewController.addTextField { (textField: UITextField) in
            textField.placeholder = NSLocalizedString("60 drops/min, 20.5...", comment: "")
        }
        return alertViewController
    }
    
    func createCustomContentViewAlertView5() -> MGUAlertViewController {
     
        let onboardingViewController = ForgeOnboardingViewController(verginLoad: false)
        
        let configuration = MGUAlertViewConfiguration.onboarding()
        let visualEffectView = UIVisualEffectView.mgrBlurView(with: .light)
        configuration.alternativeBackgroundView = visualEffectView
        let alertViewController = MGUAlertViewController(configuration: configuration, title: nil, message: nil, actions: nil)
        
        alertViewController.contentViewController = onboardingViewController
        alertViewController.addChild(onboardingViewController)
        onboardingViewController.didMove(toParent: alertViewController)
        
        let mainScreenBoundsSize = UIScreen.main.bounds.size
        let shortLength = min(mainScreenBoundsSize.width, mainScreenBoundsSize.height)
        
        guard let view = onboardingViewController.view else {
            return alertViewController
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            var resultWidth = 320.0
            if shortLength >= 1024.0 { // iPad Pro : 제일 큼.
                resultWidth = 375.0;
            }
            alertViewController.maximumWidth = resultWidth * 0.95 // priority가 UILayoutPriorityRequired - 1.0
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 393.0/852.0).isActive = true
        } else {
            alertViewController.maximumWidth = 1000.0 // priority가 UILayoutPriorityRequired - 1.0
            let layoutConstraint = view.heightAnchor.constraint(equalToConstant: 1000.0)
            layoutConstraint.priority = .defaultHigh
            layoutConstraint.isActive = true
        }
        alertViewController.contentView = view
        return alertViewController
    }
}


// MARK: - Create MGUActionSheetController
private extension MainTableViewController {
    func createActionSheet1(_ sender: AnyObject?) -> MGUActionSheetController {
        let dosePickerTitles = ["Mg", "Mcg", "Grams", "None"] as NSMutableArray
        let weightPickerTitles = ["Kg", "None"] as NSMutableArray
        let timePickerTitles = ["Hr", "Min", "None"] as NSMutableArray
        let initialTitles = ["Grams", "None", "Hr"] as NSMutableArray
        
        let dosePickerViewController = MGUDosePickerViewController(doseTitles: dosePickerTitles,
                                                                   weightTitles: weightPickerTitles,
                                                                   timeTitles: timePickerTitles,
                                                                   initialTitles: initialTitles)
        
        dosePickerViewController.normalSoundPlayBlock = self.pickerSound.playSoundTick
        let title = "Dose Unit"
        let message = "hello world haha hoho selection!"
        
        let configuration = MGUActionSheetConfiguration.dosePicker()
        
        let cancelActionHandler = { (action: MGUAlertAction?) -> Void in
            print("Cancel 버튼 눌렀음.")
        }
        let cancelAction = MGUAlertAction.init(title: "Cancel", style: .cancel, handler: cancelActionHandler, configuration: nil)
        
        let doneActionHandler = { [weak dosePickerViewController] (action: MGUAlertAction?) -> Void in  // 순환참조는 발생 안함.
            print("Done 버튼 눌렀음.")
            print(dosePickerViewController?.selectedDosePickerTitle as Any,
                  dosePickerViewController?.selectedWeightPickerTitle as Any,
                  dosePickerViewController?.selectedTimePickerTitle as Any)
        }
        let doneAction = MGUAlertAction.init(title: "Done", style: .default, handler: doneActionHandler, configuration: nil)
        
        var alertViewController: MGUActionSheetController
        if UIDevice.current.userInterfaceIdiom == .pad {
            var barButtonItem: UIBarButtonItem?
            var sourceView: UIView?
            
            if let sender = sender as? UIBarButtonItem {
                barButtonItem = sender
            } else if let sender = sender as? UIView {
                sourceView = sender
            }

            alertViewController = MGUActionSheetController(configuration: configuration,
                                                           title: title,
                                                           message: message,
                                                           actions: [cancelAction, doneAction],
                                                           barButtonItem: barButtonItem,
                                                           sourceView: sourceView,
                                                           sourceRect: sourceView?.bounds ?? .zero)
        } else {
            alertViewController = MGUActionSheetController(configuration: configuration,
                                                           title: title,
                                                           message: message,
                                                           actions: [cancelAction, doneAction])
        }
        
        alertViewController.secondContentViewController = dosePickerViewController
        alertViewController.addChild(dosePickerViewController)
        dosePickerViewController.didMove(toParent: alertViewController)
        
        let constraint = dosePickerViewController.view.heightAnchor.constraint(equalTo: dosePickerViewController.view.widthAnchor, multiplier: 0.6)
        constraint.priority = .defaultHigh
        constraint.isActive = true
        alertViewController.secondContentView = dosePickerViewController.view
        return alertViewController
    }
    
    func createActionSheet2(_ sender: AnyObject?) -> MGUActionSheetController {
        
        let title = "Save & Alarm"
        let message = "A message should be a short, complete sentence."
        let saveAlarm = SaveAlarm()
        
        let configuration = MGUActionSheetConfiguration.forgeSaveAlarm()
        
        let cancelActionHandler = { (action: MGUAlertAction?) -> Void in
            print("Cancel 버튼 눌렀음.")
        }
        let cancelAction = MGUAlertAction.init(title: "Cancel", style: .cancel, handler: cancelActionHandler, configuration: nil)
        
        let doneActionHandler = { (action: MGUAlertAction?) -> Void in  // 순환참조는 발생 안함.
        }
        let doneAction = MGUAlertAction.init(title: "Action", style: .default, handler: doneActionHandler, configuration: nil)
        doneAction.enabled = false
        
        
        var alertViewController: MGUActionSheetController
        if UIDevice.current.userInterfaceIdiom == .pad {
            var barButtonItem: UIBarButtonItem?
            var sourceView: UIView?
            
            if let sender = sender as? UIBarButtonItem {
                barButtonItem = sender
            } else if let sender = sender as? UIView {
                sourceView = sender
            }

            alertViewController = MGUActionSheetController(configuration: configuration,
                                                           title: title,
                                                           message: message,
                                                           actions: [cancelAction, doneAction],
                                                           barButtonItem: barButtonItem,
                                                           sourceView: sourceView,
                                                           sourceRect: sourceView?.bounds ?? .zero)
        } else {
            alertViewController = MGUActionSheetController(configuration: configuration,
                                                           title: title,
                                                           message: message,
                                                           actions: [cancelAction, doneAction])
        }
        saveAlarm.translatesAutoresizingMaskIntoConstraints = false
        saveAlarm.heightAnchor.constraint(equalTo: saveAlarm.widthAnchor, multiplier: 0.3).isActive = true
        alertViewController.secondContentView = saveAlarm
        return alertViewController
    }
    
    func createActionSheet3(_ sender: AnyObject?) -> MGUActionSheetController {
        let title = "Content View"
        let message = "To add a custom view to the alert view, set the contentView property."
        
        let cancelHandler = { (action: MGUAlertAction?) -> Void in
            print("Later버튼 눌렀음.")
        }
        let cancelAction = MGUAlertAction.init(title: "Later", style: .default, handler: cancelHandler, configuration: nil)
        
        
        let okActionHandler = { (action: MGUAlertAction?) -> Void in
            print("OK 버튼 눌렀음.")
        }
        let okAction = MGUAlertAction.init(title: "Ok", style: .cancel, handler: okActionHandler, configuration: nil)
        
        let configuration = MGUActionSheetConfiguration()
//        configuration.isFullAppearance = true
        configuration.transitionStyle = .fgFade
//        configuration.transitionStyle = [.fgSlideFromBottom]
        configuration.contentViewInset = .init(top: 12.0, left: 8.0, bottom: 8.0, right: 8.0)

        var alertViewController: MGUActionSheetController
        if UIDevice.current.userInterfaceIdiom == .pad {
            var barButtonItem: UIBarButtonItem?
            var sourceView: UIView?
            
            if let sender = sender as? UIBarButtonItem {
                barButtonItem = sender
            } else if let sender = sender as? UIView {
                sourceView = sender
            }

            alertViewController = MGUActionSheetController(configuration: configuration,
                                                           title: title,
                                                           message: message,
                                                           actions: [cancelAction, okAction],
                                                           barButtonItem: barButtonItem,
                                                           sourceView: sourceView,
                                                           sourceRect: sourceView?.bounds ?? .zero)
        } else {
            alertViewController = MGUActionSheetController(configuration: configuration,
                                                           title: title,
                                                           message: message,
                                                           actions: [cancelAction, okAction])
        }
        
        let symbolConfiguration = UIImage.SymbolConfiguration.init(pointSize: 22.0, weight: .medium, scale: .medium)
        let colorConfig = UIImage.SymbolConfiguration.preferringMulticolor()
        let config = colorConfig.applying(symbolConfiguration)
        let image = UIImage(systemName: "circle.hexagongrid.fill", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        alertViewController.contentView = imageView
        return alertViewController
    }
    
    func createActionSheet4(_ sender: AnyObject?) -> MGUActionSheetController {
        let model = IVDropQuickModel(quickType: .weight, value: 49.0, maxValue: 200.0, title: "Weight", unitName: "kg")
        return createActionSheet(sender, model: model)
    }
    func createActionSheet5(_ sender: AnyObject?) -> MGUActionSheetController {
        let model = IVDropQuickModel(quickType: .chamber, value: 60.0, maxValue: 60.0, title: "Chamber", unitName: "gtt/mL")
        return createActionSheet(sender, model: model)
    }
    func createActionSheet6(_ sender: AnyObject?) -> MGUActionSheetController {
        let model = IVDropQuickModel(quickType: .dose, value: 50.0, maxValue: 10000.0, title: "Dose", unitName: "mcg/kg/min")
        return createActionSheet(sender, model: model)
    }
    func createActionSheet7(_ sender: AnyObject?) -> MGUActionSheetController {
        let model = IVDropQuickModel(quickType: .time, value: 150.0, maxValue: 1440.0, title: "Duration", unitName: "hr min")
        return createActionSheet(sender, model: model)
    }
    
    func createActionSheet(_ sender: AnyObject?, model: IVDropQuickModel) -> MGUActionSheetController {
        let qv = IVDropQuickView(frame: .zero, quickModel: model)
        let configuration = MGUActionSheetConfiguration.forgeSaveAlarm()
        configuration.onlyOneContentView = true
        
        let cancelActionHandler = { (action: MGUAlertAction?) -> Void in
            print("Cancel버튼 눌렀음.")
        }
        let cancelAction = MGUAlertAction.init(title: "Cancel", style: .cancel, handler: cancelActionHandler, configuration: nil)
        
        let doneActionHandler = { (action: MGUAlertAction?) -> Void in
        }
        let doneAction = MGUAlertAction.init(title: "Quick Edit", style: .default, handler: doneActionHandler, configuration: nil)
        
        var alertViewController: MGUActionSheetController
         
        if UIDevice.current.userInterfaceIdiom == .pad {
            var barButtonItem: UIBarButtonItem?
            var sourceView: UIView?
            
            if let sender = sender as? UIBarButtonItem {
                barButtonItem = sender
            } else if let sender = sender as? UIView {
                sourceView = sender
            }

            alertViewController = MGUActionSheetController(configuration: configuration,
                                                           title: nil,
                                                           message: nil,
                                                           actions: [cancelAction, doneAction],
                                                           barButtonItem: barButtonItem,
                                                           sourceView: sourceView,
                                                           sourceRect: sourceView?.bounds ?? .zero)
        } else {
            alertViewController = MGUActionSheetController(configuration: configuration,
                                                           title: nil,
                                                           message: nil,
                                                           actions: [cancelAction, doneAction])
        }
        alertViewController.contentView  = qv
        return alertViewController
    }
}
