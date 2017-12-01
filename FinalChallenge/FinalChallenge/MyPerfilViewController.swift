//
//  MyPerfilViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 12/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class MyPerfilViewController: UIViewController, UINavigationControllerDelegate {
    
    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var perfilUserImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var containerTableView: UIView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var selectionLbl: UILabel!
    
    
    let presenter = PerfilPresenter()
    let ref = FIRDatabase.database().reference()
    let services = Services()
    var requests = [Post]()
    var testimonies = [Testimony]()
    var user: User!
    var uid: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .plain, target: nil, action: nil)
        
        (self.segmentControl.subviews[0] as UIView).tintColor = UIColor(colorLiteralRed: 244/255, green: 103/255, blue: 40/255, alpha: 1)

        
        let nibTetimony = UINib(nibName: "TestimonyTableViewCell", bundle: Bundle.main)
        self.tableView.register(nibTetimony, forCellReuseIdentifier: "testimonyCell")
        
        let nibRequest = UINib(nibName: "RequestTableViewCell", bundle: Bundle.main)
        self.tableView.register(nibRequest, forCellReuseIdentifier: "requestCell")
        
        
        //self.uid = (FIRAuth.auth()?.currentUser?.uid)!
        if let user = FIRAuth.auth()?.currentUser {
            self.uid = user.uid
        }else {
            print("PERFIL: user not connected")
        }
        
        
        services.loadUserImage(uid: uid) { (data) in
            if data == nil {
                self.perfilUserImage.image = #imageLiteral(resourceName: "profile")
            }else {
                let image = UIImage(data: data!)
                self.perfilUserImage.image = image
            }
        }
        
        presenter.attachView(view: self)
        presenter.loadUserRequest(uid: uid)
        
        print(self.perfilUserImage.frame.width)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        self.perfilUserImage.isUserInteractionEnabled = true
        self.perfilUserImage.addGestureRecognizer(tap)

        
        //view
        view.backgroundColor = UIColor(colorLiteralRed: 254/255, green: 248/255, blue: 228/255, alpha: 1)
        self.headerView.backgroundColor = UIColor.clear
        self.containerTableView.backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear

        
        //name Label
        self.usernameLbl.font = UIFont(name: "OstrichSans-Heavy", size: 25)
        self.usernameLbl.textColor = UIColor(colorLiteralRed: 23/255, green: 178/255, blue: 138/255, alpha: 1)
        
        //location label
        self.locationLbl.font = UIFont(name: "Lato-Medium", size: 13)
        self.locationLbl.textColor = UIColor(colorLiteralRed: 213/255, green: 13/255, blue: 76/255, alpha: 1)
        
        //Cosmos view
        self.cosmosView.settings.updateOnTouch = false
        self.cosmosView.settings.fillMode = .precise
        self.cosmosView.backgroundColor = UIColor.clear
        
        self.selectionLbl.text = NSLocalizedString("Depoimentos", comment: "String for label testimony")

        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.loadTestimony(uid: uid)
        presenter.loadUserRequests(uid: uid)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        if self.perfilUserImage.image == nil {
            self.perfilUserImage.image = #imageLiteral(resourceName: "profile")
        }
        (self.segmentControl.subviews[0] as UIView).tintColor = UIColor(colorLiteralRed: 244/255, green: 103/255, blue: 40/255, alpha: 1)

        
    }
    
    
    //MARK: - segmented control actions
    
    @IBAction func segmentValueChange(_ sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectionLbl.text = NSLocalizedString("Depoimentos", comment: "String for label testimony")

            (self.segmentControl.subviews[0] as UIView).tintColor = UIColor(colorLiteralRed: 244/255, green: 103/255, blue: 40/255, alpha: 1)
            self.tableView.reloadData()
            self.tableView.reloadInputViews()
        case 1:
            self.selectionLbl.text = NSLocalizedString("Meus Pedidos", comment: "String for label my requests")

            (self.segmentControl.subviews[1] as UIView).tintColor = UIColor(colorLiteralRed: 244/255, green: 103/255, blue: 40/255, alpha: 1)

            self.tableView.reloadData()
            self.tableView.reloadInputViews()
            
        default:
            print("PERFIL- SEGMENT CONTROL: error during value changing")
            break
        }
    }
    
    @IBAction func giveAnOpinionButton(_ sender: AnyObject) {
        
    }
    
    func selectImage () {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func loadRequestInfo(requests:[Post]) {
        self.requests.removeAll()
        self.requests = requests
    }
    
    func loadTestimonyInfo(testimonies:[Testimony]) {
        self.testimonies.removeAll()
        self.testimonies = testimonies
        self.tableView.reloadData()
    }
    
    func formateDate(date: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat  = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let postDate = dateFormater.date(from: date)
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
        
        var componentes = NSCalendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: postDate!, to: NSDate() as Date)
        
        
        if componentes.year != 0 {
            return "\(componentes.year!) ano(s) atrás"
            
        }else if componentes.month != 0 {
            return "\(componentes.month) mes(es) atrás"
            
        }else if componentes.day != 0 {
            return "\(componentes.day!) dia(s) atrás"
            
        }else if componentes.hour != 0 {
            return "\(componentes.hour!) hora(s) atrás"
            
        }else if componentes.minute != 0 {
            return "\(componentes.minute!) minuto(s) atrás"
            
        }else if componentes.second != 0 {
            return "\(componentes.second!) segundo(s) atrás"
            
        }else {
            return "Tempo indentermindado"
        }
        
        
    }
    
    
    
}

extension MyPerfilViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        let data = UIImageJPEGRepresentation(info["UIImagePickerControllerEditedImage"] as! UIImage, 0.1)
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        services.saveUserImage(uid: uid , data: data)
        
        
        self.perfilUserImage.image = info["UIImagePickerControllerEditedImage"] as! UIImage?
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setUserInformation (user: User) {
        if user.username.isEmpty {
            self.usernameLbl.text = "Não identificado"
        }else {
            self.usernameLbl.text = user.username

        }
        
        if (user.location?.isEmpty)! {
            
            self.locationLbl.text = "Não localizado"
            
        }else {
            
            self.locationLbl.text = user.location
        }
        
        if (user.userReputation != nil) {
            let rep = user.userReputation?.doubleValue
            
            if !(rep?.isNaN)! {
                self.cosmosView.rating = rep!
            }else {
                self.cosmosView.rating = 0.0
            }
            
        }
    }
    
//    func formateDate(date: String) -> String {
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat  = "yyyy-MM-dd HH:mm:ss zzz"
//        let postDate = dateFormater.date(from: date)
//        let dateComponentsFormatter = DateComponentsFormatter()
//        dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
//        //let interval = NSDate().timeIntervalSince(postDate!)
//        let interval = NSDate().timeIntervalSince(postDate!)
//        
//
//        return dateComponentsFormatter.string(from: interval)!
//        
//    }
    
}




extension MyPerfilViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.segmentControl.selectedSegmentIndex == 0 {
            return UITableViewAutomaticDimension
        }else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let postDetailNVc = sb.instantiateViewController(withIdentifier: "postDetailNav") as! UINavigationController
        let postDetailVc = postDetailNVc.topViewController as! PostDetailViewController
        
        if self.segmentControl.selectedSegmentIndex == 1 {
            postDetailVc.post = self.requests[indexPath.row]
            self.present(postDetailNVc, animated: true, completion: nil)
        }
    }
    
  
}

extension MyPerfilViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        if self.segmentControl.selectedSegmentIndex == 0 {
            
            //return 1
            if testimonies.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.backgroundView = nil
                return 1
            }else {
                let rect = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
                let label = UILabel(frame: rect)
                label.text = "Você ainda não possui depoimentos"
                label.textColor = Color().vlackColor
                label.numberOfLines = 0
                label.textAlignment = NSTextAlignment.center
                label.font = FontLato().blackFont(size: 20)
                label.sizeToFit()
                self.tableView.backgroundView = label
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }

        }else {
            if requests.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.backgroundView = nil
                return 1
            }else {
                let rect = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
                let label = UILabel(frame: rect)
                label.text = "Você ainda não realizou pedidos. Experimente!"
                label.textColor = Color().vlackColor
                label.numberOfLines = 0
                label.textAlignment = NSTextAlignment.center
                label.font = FontLato().blackFont(size: 20)
                label.sizeToFit()
                self.tableView.backgroundView = label
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }

            
            //return 1
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        
        if self.segmentControl.selectedSegmentIndex == 0 {
            return testimonies.count
            
        } else {
            
            return self.requests.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if segmentControl.selectedSegmentIndex == 0 {
            
         
            //let mycell = Bundle.main.loadNibNamed("TestimonyTableViewCell", owner: self, options: nil)?.first as! TestimonyTableViewCell
            let mycell = tableView.dequeueReusableCell(withIdentifier: "testimonyCell", for: indexPath) as! TestimonyTableViewCell
            
            mycell.backgroundColor = UIColor.clear
            
            let rating = (self.testimonies[indexPath.row].testimonyEvaluation as NSString).doubleValue
            mycell.testemonyTitle.font = FontOstrich().heavyFont(size: 17)
            mycell.testemonyTitle.textColor = Color().greenCustomColor
            mycell.testemonyTitle.text = testimonies[indexPath.row].testimonyTitle
            
            mycell.cosmosView.settings.updateOnTouch = false
            mycell.cosmosView.settings.fillMode = .precise
            mycell.cosmosView.rating = rating
            
            mycell.testemonyMessage.font = FontLato().mediumFont(size: 13)
            mycell.testemonyMessage.numberOfLines = 10
            mycell.testemonyMessage.lineBreakMode = NSLineBreakMode.byWordWrapping
            mycell.testemonyMessage.sizeToFit()
            mycell.testemonyMessage.text = testimonies[indexPath.row].testimonyMessage
            
            mycell.testemonyUserName.font = FontLato().blackFont(size: 10)
            mycell.testemonyUserName.textColor = Color().redCustomColor
            mycell.testemonyUserName.text = testimonies[indexPath.row].testimonyAuthor
            
            mycell.userTestemonyImage.image = #imageLiteral(resourceName: "profile")
            services.loadUserImage(uid: testimonies[indexPath.row].testimonyAuthorUid, completion: { (data) in
                if data != nil {
                    let image = UIImage(data: data!)
                    mycell.userTestemonyImage.image = image
                }else {
                    mycell.userTestemonyImage.image = #imageLiteral(resourceName: "profile")
                }
            })
        
            mycell.contentView.setNeedsLayout()
            mycell.contentView.layoutIfNeeded()

            return mycell
            
            
        }else {
            
            if !requests.isEmpty {
               // let myRequestCell = Bundle.main.loadNibNamed("RequestTableViewCell", owner: self, options: nil)?.first as! RequestTableViewCell
                let myRequestCell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestTableViewCell
                myRequestCell.backgroundColor = UIColor.clear
                myRequestCell.decriptionLabel.font = FontLato().mediumFont(size: 13)
                myRequestCell.decriptionLabel.text = requests[indexPath.row].body
                myRequestCell.decriptionLabel.numberOfLines = 10
                myRequestCell.decriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                myRequestCell.decriptionLabel.sizeToFit()
                
                myRequestCell.titleLabel.font = FontOstrich().heavyFont(size: 18)
                    //FontLato().mediumFont(size: 15)
                myRequestCell.titleLabel.textColor = Color().greenCustomColor
                myRequestCell.titleLabel.text = (requests[indexPath.row].title).uppercased()
                
                myRequestCell.timeLabel.font = FontLato().italicFont(size: 10)
                myRequestCell.timeLabel.text = self.formateDate(date: requests[indexPath.row].timestamp!)
                
                myRequestCell.categoryImage.tintColor = Color().redCustomColor
                myRequestCell.categoryImage.image = UIImage(named: requests[indexPath.row].tags)
            
                
                myRequestCell.contentView.setNeedsLayout()
                myRequestCell.contentView.layoutIfNeeded()
                return myRequestCell
                
            }else {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                cell?.textLabel?.text = "Nome"
                cell.backgroundColor = UIColor.clear
                
                
                return cell
            }
            
            
            
            
        }
        
    }
}




