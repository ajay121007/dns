//
//  DnsLeakListVC.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import UIKit

class DnsLeakListVC: UIViewController {

    @IBOutlet weak var vwDropdown: UIView!{
        didSet{
            vwDropdown.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnOption: UIButton!
    @IBOutlet weak var tblVw: UITableView!{
        didSet{
            tblVw.delegate = self
            tblVw.dataSource = self
            tblVw.registerNib(cell: DNSDetailTblCell.self)
            tblVw.registerNib(cell: DnsNotLeakTblCell.self)
            tblVw.isUserInteractionEnabled = true
        }
    }
    
    private enum headerTitle : String,CaseIterable{
        case header = ""
        case ip = "Your IP:"
        case dns = "Detected DNS:"
        case conclusion = "Conclusion"
    }
    
    private enum loadingMsg : String{
        case noDisplay = "There is no test result to display now."
        case loading = "The test is running, please wait..."
    }
    
    private enum dnsUrls : String {
        case PrivacyPolicy = "https://bash.ws/privacy"
        case About = "https://bash.ws/about"
        case DnsLeak = "https://bash.ws/dnsleak"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnOptionAction(_ sender: Any) {
        vwDropdown.isHidden = vwDropdown.isHidden == true ? false : true
    }
    
    @IBAction func btnPrivacyPolicyAction(_ sender: Any) {
        vwDropdown.isHidden = true
        guard let url = URL(string: dnsUrls.PrivacyPolicy.rawValue)else{
            Logger.log("invalid url")
            return
        }
        self.openInSafari(url: url)
    }
    
    @IBAction func btnAboutAction(_ sender: Any) {
        vwDropdown.isHidden = true
        guard let url = URL(string: dnsUrls.About.rawValue)else{
            Logger.log("invalid url")
            return
        }
        self.openInSafari(url: url)
    }
    
}

//MARK: TABLEVIEW DELEGATE AND DATASOURCE
extension DnsLeakListVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DNSViewModel.shared().getIpListCount() == 0 && DNSViewModel.shared().getDnsListCount() == 0 ? 1 : headerTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return section == 0 ? 0 : 4
        switch headerTitle.allCases[section]{
        case .conclusion:
            return 1
        case .ip:
            return DNSViewModel.shared().getIpListCount()
        case .dns:
            return DNSViewModel.shared().getDnsListCount()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch headerTitle.allCases[indexPath.section]{
        case .ip:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DNSDetailTblCell", for: indexPath) as! DNSDetailTblCell
            let obj = DNSViewModel.shared().getIPListDetail(indexPath: indexPath)
            cell.lblIP.text = obj.ip ?? ""
            cell.lblFlag.text = obj.country?.countryFlag() ?? ""
            cell.lblCountry.text = obj.country_name ?? ""
            cell.lblIpAddress.text = obj.asn ?? ""
            cell.vwTouchClick = {[weak self] ( _ ) in
                self?.vwDropdown.isHidden = true
            }
            return cell
            
        case .dns:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DNSDetailTblCell", for: indexPath) as! DNSDetailTblCell
            let obj = DNSViewModel.shared().getDnsListDetail(indexPath: indexPath)
            cell.lblIP.text = obj.ip ?? ""
            cell.lblFlag.text = obj.country?.countryFlag() ?? ""
            cell.lblCountry.text = obj.country_name ?? ""
            cell.lblIpAddress.text = obj.asn ?? ""
            cell.vwTouchClick = {[weak self] ( _ ) in
                self?.vwDropdown.isHidden = true
            }
            return cell
            
        case .conclusion:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DnsNotLeakTblCell", for: indexPath) as! DnsNotLeakTblCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vwDropdown.isHidden = true
        switch headerTitle.allCases[indexPath.section]{
        case .conclusion:
            guard let url = URL(string: dnsUrls.DnsLeak.rawValue)else{
                Logger.log("invalid url")
                return
            }
            self.openInSafari(url: url)
            break
        default:
            Logger.log("default")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch headerTitle.allCases[section]{
            
        case .header:
            let vw = DNSHeaderView.instance
            vw.btnStartClick = { [weak self] ( _ ) in
                self?.vwDropdown.isHidden = true
                vw.constraintWidthBtnStart.constant = 50
                vw.btnStart.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .black) { [weak self] in
                    vw.lblProcessing.text = loadingMsg.loading.rawValue
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){ [weak self] in
                        self?.getIP {
                            //vw.constraintWidthBtnStart.constant = 150
                            vw.btnStart.stopAnimate {
                                vw.lblProcessing.text = loadingMsg.noDisplay.rawValue
                                vw.constraintWidthBtnStart.constant = 120
                                vw.constraintBottomStackVw.constant = DNSViewModel.shared().getIpListCount() == 0 && DNSViewModel.shared().getDnsListCount() == 0 ? 0 : 20
                                vw.vwProcessing.isHidden = DNSViewModel.shared().getIpListCount() == 0 && DNSViewModel.shared().getDnsListCount() == 0 ? false : true
                                self?.tblVw.backgroundColor = DNSViewModel.shared().getIpListCount() == 0 && DNSViewModel.shared().getDnsListCount() == 0 ? .white : UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
                                self?.tblVw.reloadData()
                            }
                        }
                    }
                }
            }
            vw.vwTouchClick = { [weak self] ( _ ) in
                self?.vwDropdown.isHidden = true
            }
            return vw
            
        default:
            let vw = DNSTitleHeaderView.instance
            vw.lblTitle.text = headerTitle.allCases[section].rawValue
            vw.lblLine.isHidden = headerTitle.allCases[section].rawValue == headerTitle.conclusion.rawValue ? false : true
            return vw
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


//MARK: SAFARI OPEN
extension DnsLeakListVC{
    
    func openInSafari(url:URL){
        UIApplication.shared.open(url)
    }
    
}

//MARK: API
extension DnsLeakListVC{
    
    func getIP(completion:@escaping()->Void){
        DNSViewModel.shared().pinServer { [weak self] (subDomainId) in
            // DNSViewModel.shared().getIPList(subDomainId: subDomainId)
            DNSViewModel.shared().getIPList(subDomainId: subDomainId) { [weak self] (success,msg) in
                if success{
                    
                }else{
                    self?.showAlert(title: "", msg: msg)
                }
                completion()
            }
        }
    }
    
}
