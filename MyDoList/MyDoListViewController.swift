//
//  ViewController.swift
//  MyDoList
//
//  Created by leejungchul on 2021/02/26.
//

import UIKit

class MyDoListViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension MyDoListViewController: UICollectionViewDataSource {
    //섹션별 아이템의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //커스텀 셀을 deque시켜 가져오기
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyDoListCell", for: indexPath) as? MyDoListCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyDoListHeaderView", for: indexPath) as? MyDoListHeaderView else { return UICollectionReusableView() }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    //섹션의 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

// 컬렉션 뷰의 사이즈 계산
extension MyDoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width:CGFloat = collectionView.bounds.width
        let height: CGFloat = 50
        
        return CGSize(width: width, height: height)
        
    }
}

class MyDoListCell: UICollectionViewCell {
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class MyDoListHeaderView: UICollectionReusableView {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
