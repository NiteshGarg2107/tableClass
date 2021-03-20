//
//  viewModel.swift
//  testtableview
//
//  Created by Nitesh Garg on 20/03/21.
//

import Foundation

protocol ViewModelDelegate {
    func getSuccessData(resp: Response)
    func getSuccessDataFromJason(resp: [Dictionary<String, AnyObject>])
    func getFailure()
}

class ViewModel {
    var useCase: ServiceNetworkType!
    var delegate: ViewModelDelegate?
    
    init(_ usecase : ServiceNetworkType) {
        self.useCase = usecase
    }
    
    func getDataFromJasonFile() {
        useCase.readDataFromJasonFile { (result) in
            switch result {
            case .success(let resp):
                self.delegate?.getSuccessDataFromJason(resp: resp)
                print("asa")
            case .failure( _):
                self.delegate?.getFailure()
                print("err")
            }
        }
    }
    
    func getData(req: Request) {
        useCase.getdata(req: req) { (result) in
            switch result {
            case .success(let resp):
                self.delegate?.getSuccessData(resp: resp)
            break
            case .failure(let _):
                self.delegate?.getFailure()
                break
            }
        }
    }
}
