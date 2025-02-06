//
//  PocketSelectionViewController.swift
//  zzimtory
//
//  Created by 김하민 on 1/31/25.
//

import UIKit
import SnapKit

final class PocketSelectionViewController: UIViewController {
    
    let selectedItems: [Item]
    private var pockets: [Pocket] = []
    var onComplete: (() -> Void)?
    
    // MARK: - UI Components
    private let informLabel = PocketSelectionInformLabel()
    private let addNewPocketButton = AddNewPocketButton()
    private let verticalLine = UIView()
    private let pocketColletionView = PocketCollectionView()

    private lazy var horizontalStackView: UIStackView = {
        let subViews = [
            addNewPocketButton,
            verticalLine,
            pocketColletionView
        ]
        
        verticalLine.backgroundColor = .gray300Zt
        
        let stackView = UIStackView(arrangedSubviews: subViews)
        
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    
    // MARK: - Initializers
    init(selectedItems: [Item]) {
        self.selectedItems = selectedItems
        super.init(nibName: nil, bundle: nil)
        
        DatabaseManager.shared.readPocket { pockets in
            self.pockets = pockets
            self.pocketColletionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white100Zt

        // 화면 높이가 작은 기기(SE 등)인 경우 더 큰 detent 값 사용
        let screenHeight = UIScreen.main.bounds.height
        let modalHeight = screenHeight < 700 ? 0.3 : 0.2
        
        sheetPresentationController?.detents = [.custom { context in
            modalHeight * context.maximumDetentValue
        }]
        
        addNewPocketButton.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        
        setCollectionView()
        addSubviews()
        setConstraints()
    }
    
    // MARK: - Functions
    @objc private func onTap() {
        print("AddPocket button tapped")
        let alert = UIAlertController(title: "주머니 이름 임력",
                                      message: "새로 추가할 주머니의 이름을 입력해주세요.",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "주머니 이름"
        }
        
        alert.addAction(UIAlertAction(title: "저장",
                                      style: .default,
                                      handler: { [unowned self] _ in
            if let name = alert.textFields?.first?.text {
                let newPocket = Pocket(title: name, items: self.selectedItems)
                
                DatabaseManager.shared.createPocket(title: name) {
                    self.selectedItems.forEach { item in
                        DatabaseManager.shared.updatePocketItem(newItem: item, pocketTitle: name)
                    }
                    
                    self.pocketColletionView.reloadData()
                    self.informLabel.userDidPutItem(in: newPocket) { [weak self] in
                        self?.onComplete?()  // 완료 콜백 호출
                        self?.dismiss(animated: true)
                    }
                    
                }

            }
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
        
    }
    
    private func setCollectionView() {
        pocketColletionView.delegate = self
        pocketColletionView.dataSource = self
        pocketColletionView.register(PocketCollectionViewCell.self,
                                     forCellWithReuseIdentifier: PocketCollectionViewCell.id)
        pocketColletionView.isScrollEnabled = true
    }
    
    private func addSubviews() {
        view.addSubview(informLabel)
        view.addSubview(horizontalStackView)
    }
    
    private func setConstraints() {
        informLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(informLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(104)
        }
        
        verticalLine.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.verticalEdges.equalToSuperview().inset(12)
        }
        
        pocketColletionView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
        }
    }
}

extension PocketSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return pockets.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PocketCollectionViewCell.id,
                                                            for: indexPath)
                as? PocketCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setCell(with: pockets[indexPath.item])
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedItems.forEach { item in
            DatabaseManager.shared.updatePocketItem(newItem: item, pocketTitle: pockets[indexPath.item].title)
        }
        
        informLabel.userDidPutItem(in: pockets[indexPath.item]) { [weak self] in
            self?.onComplete?()  // 완료 콜백 호출
            self?.dismiss(animated: true)
        }
    }
}

extension PocketSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow: CGFloat = 3
        let spacing: CGFloat = 8
        let totalSpacing = spacing * (numberOfCellsInRow - 1)

        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = availableWidth / numberOfCellsInRow

        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
    
}
