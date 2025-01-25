//
//  DummyViewModel.swift
//  zzimtory
//
//  Created by 김하민 on 1/26/25.
//

protocol ViewModel {
    
}

protocol ViewModelBindable {
    func bind(to viewModel: some ViewModel)
}

class DummyViewModel: ViewModel {
    
}
