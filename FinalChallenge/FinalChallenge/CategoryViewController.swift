//
//  CategoryViewController.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 26/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    //properties
    @IBOutlet weak var collectionView: UICollectionView!
    let categories = ["Ferramentas", "Alimento", "Roupas", "Material Escolar", "Outros"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let nib = UINib(nibName: "FilterCollectionViewCell", bundle: Bundle.main)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "filterCell")
        
        self.view.backgroundColor = Color().backgroundViewStandard
        self.collectionView.backgroundColor = Color().backgroundViewStandard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedSegue" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let tabControl = sb.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
            let navFeedVc = tabControl.viewControllers?[0] as! UINavigationController
            let vc = navFeedVc.viewControllers[0] as! MainViewController
            vc.category = categories[(collectionView.indexPathsForSelectedItems?[0].row)!]
    
            self.present(tabControl, animated: true, completion: nil)
        }
    }
}


extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "feedSegue", sender: self)
    }
    
}

extension CategoryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
        
        cell.backgroundColor = Color().greenCustomColor
        cell.layer.cornerRadius = 5.0
        
        cell.categoryNameLbl.text = categories[indexPath.row]
        cell.categoryFilterImage.image = #imageLiteral(resourceName: "profile")
        
        return cell
    }
    
}
