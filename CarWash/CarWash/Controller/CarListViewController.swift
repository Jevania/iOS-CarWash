//
//  CarListViewController.swift
//  CarWash
//
//  Created by jevania on 07/01/23.
//

import UIKit

class CarListViewController: UIViewController {
    
    var carQueue = FIFOQueue()
    var nCar = 0
    
    var timer: Timer!
    
    private let dropCarButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Drop your car!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        button.backgroundColor = .systemOrange
        button.tintColor = .white
        
        button.layer.masksToBounds = false
        button.frame.size  = CGSize(width: 100, height: 50)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(didTapDropCarButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapDropCarButton(){
        
        print("carQueue.getQueue() ->", carQueue.getQueue())
        
        let newCar = CarModel(id: UUID(), name: "Car \(nCar + 1)", status: .unwashed, isCollect: false)
        
        carQueue.enqueue(value: newCar)
        
        showAlert(alertTitle: "Success!", alertMessage: "Your ticket id: \(newCar.id)", alertActionTitle: "Ok")
        
        DispatchQueue.main.async {
            self.unwashedCarListTableView.reloadData()
            self.washingCarListTableView.reloadData()
            self.washedCarListTableView.reloadData()
        }
        
        nCar += 1
    }
    
    private let collectCarButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Collect your car!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        button.backgroundColor = .systemCyan
        button.tintColor = .white
        
        button.layer.masksToBounds = false
        button.frame.size  = CGSize(width: 100, height: 50)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(didTapCollectCarButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapCollectCarButton(){
        
        let alertController = UIAlertController(title: "Collect Car", message: "Enter your ticket number", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Ticket number"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let textField = alertController.textFields![0]
            let text = textField.text
            print(text)
            
            for car in self.carQueue.queue{
                if car.id?.uuidString == text{
                    switch car.status {
                    case .unwashed:
                        self.showAlert(alertTitle: "Message", alertMessage: "Car is still in the queue", alertActionTitle: "Ok")
                    case .washing:
                        self.showAlert(alertTitle: "Message", alertMessage: "Car is being washed", alertActionTitle: "Ok")
                    case .washed:
                        
                        self.showAlert(alertTitle: "Message", alertMessage: "Car is washed. Thank you", alertActionTitle: "Ok")
                        
                        self.carQueue.dequeue()
                        
                        DispatchQueue.main.async {
                            self.unwashedCarListTableView.reloadData()
                            self.washingCarListTableView.reloadData()
                            self.washedCarListTableView.reloadData()
                        }
                    case .none:
                        print("")
                    }
                }else{
                    self.showAlert(alertTitle: "Message", alertMessage: "Car is not found", alertActionTitle: "Ok")
                }
            }
            
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private let unwashedCarListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(CarTableViewCell.self, forCellReuseIdentifier: CarTableViewCell.identifier)
        
        return tableView
    }()
    
    private let washingCarListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(CarTableViewCell.self, forCellReuseIdentifier: CarTableViewCell.identifier)
        
        return tableView
    }()
    
    private let washedCarListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(CarTableViewCell.self, forCellReuseIdentifier: CarTableViewCell.identifier)
        
        return tableView
    }()
    
    private var mainSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Unwashed", "Washing", "Washed"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemOrange], for: UIControl.State.selected)
        
        segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        
        return segmentedControl
    }()
    
    @objc private func indexChanged(){
        switch mainSegmentedControl.selectedSegmentIndex{
        case 0:
            unwashedCarListTableView.isHidden = false
            washingCarListTableView.isHidden = true
            washedCarListTableView.isHidden = true
        case 1:
            unwashedCarListTableView.isHidden = true
            washingCarListTableView.isHidden = false
            washedCarListTableView.isHidden = true
        case 2:
            unwashedCarListTableView.isHidden = true
            washingCarListTableView.isHidden = true
            washedCarListTableView.isHidden = false
        default:
            unwashedCarListTableView.isHidden = true
            washingCarListTableView.isHidden = true
            washedCarListTableView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(dropCarButton)
        view.addSubview(collectCarButton)
        
        view.addSubview(unwashedCarListTableView)
        unwashedCarListTableView.delegate = self
        unwashedCarListTableView.dataSource = self
        
        view.addSubview(washingCarListTableView)
        washingCarListTableView.delegate = self
        washingCarListTableView.dataSource = self
        
        view.addSubview(washedCarListTableView)
        washedCarListTableView.delegate = self
        washedCarListTableView.dataSource = self
        
        view.addSubview(mainSegmentedControl)
        
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(runWashingCarProcess), userInfo: nil, repeats: true)
        
        setUpSegmentedView()
        configureConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            
            self.setUpSegmentedView()
            self.unwashedCarListTableView.reloadData()
            self.washingCarListTableView.reloadData()
            self.washedCarListTableView.reloadData()
            
        }
    }
    
    @objc private func runWashingCarProcess() {
        washingCarProcess(queue: carQueue)
    }
    
    private func washingCarProcess(queue: FIFOQueue) {
        
        if let index = queue.queue.firstIndex(where: { $0.status == .unwashed }) {
            queue.queue[index].status = .washing
            
            DispatchQueue.main.async {
                self.unwashedCarListTableView.reloadData()
                self.washingCarListTableView.reloadData()
                self.washedCarListTableView.reloadData()
            }
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 10) {
                queue.queue[index].status = .washed
                
                DispatchQueue.main.async {
                    self.unwashedCarListTableView.reloadData()
                    self.washingCarListTableView.reloadData()
                    self.washedCarListTableView.reloadData()
                }
            }
            
        }
    }
    
    private func setUpSegmentedView(){
        mainSegmentedControl.selectedSegmentIndex = 0
        
        unwashedCarListTableView.isHidden = false
        washingCarListTableView.isHidden = true
        washedCarListTableView.isHidden = true
    }
    
    private func configureConstraints(){
        let dropCarButtonConstraints = [
            dropCarButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            dropCarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dropCarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dropCarButton.heightAnchor.constraint(equalToConstant: 50),
            dropCarButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let collectCarButtonContraints = [
            collectCarButton.topAnchor.constraint(equalTo: dropCarButton.bottomAnchor, constant: 20),
            collectCarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectCarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectCarButton.heightAnchor.constraint(equalToConstant: 50),
            collectCarButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let mainSegmentedControlConstraints = [
            mainSegmentedControl.topAnchor.constraint(equalTo: collectCarButton.bottomAnchor, constant: 30),
            mainSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainSegmentedControl.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let unwashedCarListTableViewConstraints = [
            unwashedCarListTableView.topAnchor.constraint(equalTo: mainSegmentedControl.bottomAnchor, constant: 10),
            unwashedCarListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            unwashedCarListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            unwashedCarListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
        
        let washingCarListTableViewConstraints = [
            washingCarListTableView.topAnchor.constraint(equalTo: mainSegmentedControl.bottomAnchor, constant: 10),
            washingCarListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            washingCarListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            washingCarListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
        
        let washedCarListTableViewConstraints = [
            washedCarListTableView.topAnchor.constraint(equalTo: mainSegmentedControl.bottomAnchor, constant: 10),
            washedCarListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            washedCarListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            washedCarListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(dropCarButtonConstraints)
        NSLayoutConstraint.activate(collectCarButtonContraints)
        NSLayoutConstraint.activate(mainSegmentedControlConstraints)
        
        NSLayoutConstraint.activate(unwashedCarListTableViewConstraints)
        NSLayoutConstraint.activate(washingCarListTableViewConstraints)
        NSLayoutConstraint.activate(washedCarListTableViewConstraints)
    }
    
    private func showAlert(alertTitle: String, alertMessage: String, alertActionTitle: String) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension CarListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let unwashedCar = carQueue.getQueue().filter { $0.status == .unwashed }
        let washingCar = carQueue.getQueue().filter { $0.status == .washing }
        let washedCar = carQueue.getQueue().filter { $0.status == .washed }
        
        if tableView == unwashedCarListTableView{
            return unwashedCar.count
        }else if tableView == washingCarListTableView{
            return washingCar.count
        }else{
            return washedCar.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.identifier, for: indexPath) as? CarTableViewCell else {
            return UITableViewCell()
        }
        
        let unwashedCar = carQueue.getQueue().filter { $0.status == .unwashed }
        let washingCar = carQueue.getQueue().filter { $0.status == .washing }
        let washedCar = carQueue.getQueue().filter { $0.status == .washed }
        
        if tableView == unwashedCarListTableView{
            cell.carNameLabel.text = unwashedCar[indexPath.row].name
            cell.carIdLabel.text = unwashedCar[indexPath.row].id?.uuidString
            cell.carStatusLabel.text = unwashedCar[indexPath.row].status?.rawValue
            
            return cell
            
        }else if tableView == washingCarListTableView{
            cell.carNameLabel.text = washingCar[indexPath.row].name
            cell.carIdLabel.text = washingCar[indexPath.row].id?.uuidString
            cell.carStatusLabel.text = washingCar[indexPath.row].status?.rawValue
            
            return cell
            
        }else if tableView == washedCarListTableView{
            cell.carNameLabel.text = washedCar[indexPath.row].name
            cell.carIdLabel.text = washedCar[indexPath.row].id?.uuidString
            cell.carStatusLabel.text = washedCar[indexPath.row].status?.rawValue
            
            return cell
        }
        return UITableViewCell()
    }
}
