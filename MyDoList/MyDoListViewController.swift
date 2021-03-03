//
//  ViewController.swift
//  MyDoList
//
//  Created by leejungchul on 2021/02/26.
//

import UIKit

class MyDoListViewController: UIViewController {

    // viewModel 만들기
    let mydoListViewModel  = MydoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 키보드 디텍션
        
        // 데이터 블러오기
        mydoListViewModel.loadTasks()
        
        let mydo = MydoManager.shared.createMydo(detail: "이게 무슨일이야", isToday: true)
        Storage.saveMydo(mydo, fileName: "test.json")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let mydo = Storage.restoreMydo("test.json")
        print("restore from disk : \(mydo)")
    }


}

extension MyDoListViewController: UICollectionViewDataSource {
    //섹션별 아이템의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return mydoListViewModel.todayMydos.count
        } else {
            return mydoListViewModel.upcomingMydos.count
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //커스텀 셀을 deque시켜 가져오기
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyDoListCell", for: indexPath) as? MyDoListCell else { return UICollectionViewCell() }
        
        var mydo: Mydo
        if indexPath.section == 0 {
            mydo = mydoListViewModel.todayMydos[indexPath.item]
        } else {
            mydo = mydoListViewModel.upcomingMydos[indexPath.item]
        }
        cell.updateUI(mydo: mydo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyDoListHeaderView", for: indexPath) as? MyDoListHeaderView else { return UICollectionReusableView() }

            guard let section = MydoViewModel.Section(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }

            header.sectionTitleLabel.text = section.title
            return header
        default:
            return UICollectionReusableView()
        }
    }
    //섹션의 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mydoListViewModel.numOfSection
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
    @IBOutlet weak var strikeThroughView: UIView!
    
    @IBOutlet weak var strikeThroughWidth: NSLayoutConstraint!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func updateUI(mydo: Mydo) {
        // 셀 업데이트
        checkButton.isSelected = mydo.isDone
        descriptionLabel.text = mydo.detail
        descriptionLabel.alpha = mydo.isDone ? 0.2 : 1
        deleteButton.isHidden = mydo.isDone == false
        showStrikeThrough(mydo.isDone)
    }
    
    private func showStrikeThrough(_ show: Bool) {
        if show {
            strikeThroughWidth.constant = descriptionLabel.bounds.width
        } else {
            strikeThroughWidth.constant = 0
        }
    }
    
    func reset(){
        // reset 구현
        descriptionLabel.alpha = 1
        deleteButton.isHidden = true
        showStrikeThrough(false)
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        // 체크버튼 탭 처리
        checkButton.isSelected = !checkButton.isSelected
        let isDone = checkButton.isSelected
        showStrikeThrough(isDone)
        descriptionLabel.alpha = isDone ? 0.2 : 1
        deleteButton.isHidden = !isDone
        doneButtonTapHandler?(isDone)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        // 딜리트 버튼 탭 처리
        deleteButtonTapHandler?()
    }
}

class MyDoListHeaderView: UICollectionReusableView {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
