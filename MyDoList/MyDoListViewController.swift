//
//  ViewController.swift
//  MyDoList
//
//  Created by leejungchul on 2021/02/26.
//

import UIKit

class MyDoListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputTextfield: UITextField!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var isTodayButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // viewModel 만들기
    let mydoListViewModel  = MydoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // 키보드 디텍션
        // 키보드 노출 감지
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드 숨김 감지
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 데이터 블러오기
        mydoListViewModel.loadTasks()
        
//        let mydo = MydoManager.shared.createMydo(detail: "이게 무슨일이야", isToday: true)
//        Storage.saveMydo(mydo, fileName: "test.json")
//        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//
//        let mydo = Storage.restoreMydo("test.json")
//        print("restore from dist : \(mydo)")
    }
    @IBAction func isTodayButtonTapped(_ sender: Any) {
        //today 버튼 토글 작업
        isTodayButton.isSelected = !isTodayButton.isSelected
    }
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        //mydo 에 작업들 추가
        // 글자가 있는지 확인
        guard let detail = inputTextfield.text, detail.isEmpty == false else { return }
        
        let mydo = MydoManager.shared.createMydo(detail: detail, isToday: isTodayButton.isSelected)
        mydoListViewModel.addMydo(mydo)
        collectionView.reloadData()
        inputTextfield.text = ""
        isTodayButton.isSelected = false
    }
    
    // background tap 햇을때 키보드 내려가게 하기
    @IBAction func tapBackground(_ sender: Any) {
        inputTextfield.resignFirstResponder()
    }
    

}

extension MyDoListViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        //키보드 위치에 따른 인풋 뷰 위치변경
        guard let  keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
        print("\(keyboardFrame)")
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
        
        // Mydo done button Handler 작성
        cell.doneButtonTapHandler = { isDone in
            mydo.isDone = isDone
            self.mydoListViewModel.updateMydo(mydo)
            self.collectionView.reloadData()
        }
        // Mydo delete button Handler 작성
        cell.deleteButtonTapHandler = {
            self.mydoListViewModel.deleteMydo(mydo)
            self.collectionView.reloadData()
        }
        
        
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
