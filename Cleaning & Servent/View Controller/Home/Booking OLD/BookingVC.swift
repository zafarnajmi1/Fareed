//
//  BookingVC.swift
//  Servent
//
//  Created by Jawad ali on 2/12/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import AAPickerView



class BookingVC: BaseViewController , UITextViewDelegate{
    var SelectedCompany = CompanyModel()
    var SelectedServices = [Services]()
    
    var DateStart = Date()
    var DateEnd = Date()
    
    var startDateChoose = ""
    var endDateChoose = ""
    
    var ChooseImage = UIImage()
    var isImageChoose = false
    var urlvideo = ""
    var timechoose = [TimeChooseModel]()
    
    var indexAddress = 0
    var chooseaddress = AddressModel()
    
    @IBOutlet weak var tabel_view: UITableView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isArabic() {
            self.btnBack.setImage(#imageLiteral(resourceName: "backArabic"), for: .normal)
        }
        self.tabel_view.register(UINib(nibName: "DateChooseCell", bundle: nil), forCellReuseIdentifier: "DateChooseCell")
        
        self.tabel_view.register(UINib(nibName: "HeadingCell", bundle: nil), forCellReuseIdentifier: "HeadingCell")

        self.tabel_view.register(UINib(nibName: "TextFeildCell", bundle: nil), forCellReuseIdentifier: "TextFeildCell")
        
        self.tabel_view.register(UINib(nibName: "HistoryCancelBookingCell", bundle: nil), forCellReuseIdentifier: "HistoryCancelBookingCell")
        self.tabel_view.register(UINib(nibName: "ShowServicesCell", bundle: nil), forCellReuseIdentifier: "ShowServicesCell")
        self.tabel_view.register(UINib(nibName: "TimeChooseCell", bundle: nil), forCellReuseIdentifier: "TimeChooseCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.indexAddress > 0  && self.chooseaddress.addressID != "0" {
            let cellMain = self.tabel_view.cellForRow(at: IndexPath.init(row: indexAddress, section: 0)) as! TextFeildCell
            cellMain.txtFieldMain.text = self.chooseaddress.address
        }
        
        self.indexAddress = 0
    }
    
    @IBAction func Back(_ sender: Any) {
        self.Back()
    }
    override func selectedImage(image: UIImage) {
        self.ChooseImage = image//info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.isImageChoose = true
    }
}
extension BookingVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (7 + SelectedServices.count + self.timechoose.count)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var count =  self.timechoose.count
        
        if count == 0 {
            count = 1
        }else {
            count = 1 + count
        }
        
        if count + 6 > indexPath.row {
            switch indexPath.row {
            case 0:
                return DateChooseCell(tableView:tableView, cellForRowAt:indexPath)
            case 1, (count + 3), (count + 5):
                return HeadingCell(tableView:tableView, cellForRowAt:indexPath)
                
            case  (count + 4):
                return SelectImageCell(tableView:tableView, cellForRowAt:indexPath)
                
            case (count + 1),(count + 2):
                return TextFeildCell(tableView:tableView, cellForRowAt:indexPath)
            default:
                return TimeChooseCell(tableView:tableView, cellForRowAt:indexPath)
            }
        }else {
            return HistroySelectServiceCell(tableView:tableView, cellForRowAt:indexPath)
        }
    }
    
    
    func TextFeildCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TextFeildCell") as! TextFeildCell
        
        var count =  self.timechoose.count
        
        if count == 0 {
            count = 1
        }else {
            count = 1 + count
        }
        
        if indexPath.row == (count + 1) {
            self.indexAddress = indexPath.row
            cell.lblHeading.text = "Address"
            cell.txtFieldMain.placeholder = "Tap to Select Address"
            cell.txtFieldMain.tag = -1000
            cell.txtFieldMain.text = self.chooseaddress.address
            cell.txtFieldMain.delegate = self
        }else {
            cell.lblHeading.text = "Special Instructions (Optional)"
            cell.txtFieldMain.placeholder = "Write instrructions here..."
            cell.txtFieldMain.tag = -2000
            cell.txtFieldMain.delegate = self
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func HeadingCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "HeadingCell") as! HeadingCell
        var count = self.timechoose.count
        if count == 0 {
            count = 1
        }
        if indexPath.row == 1 {
            cell.lblViewHeading.text = "Select Service's Days"
        }else if (count + 3) == indexPath.row {
            cell.lblViewHeading.text = "Upload Media (Optional)"
        }else if (count + 5) == indexPath.row {
            cell.lblViewHeading.text = "Selected Servants"
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func DateChooseCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell  = tableView.dequeueReusableCell(withIdentifier: "DateChooseCell") as! DateChooseCell
        cell.txtFieldEndDAte.pickerType = .date
        cell.txtFieldStartDAte.pickerType = .date
        
        cell.txtFieldEndDAte.datePicker?.datePickerMode = .date
        cell.txtFieldStartDAte.datePicker?.datePickerMode = .date
        cell.txtFieldStartDAte.datePicker?.minimumDate = Date()
        cell.txtFieldEndDAte.datePicker?.minimumDate = Date()
        
        cell.txtFieldStartDAte.valueDidChange = { date in
            print("selectedDate ", date )
            self.startDateChoose = "1"
            self.DateStart = date as! Date
            self.CallDate()
        }
        
        cell.txtFieldEndDAte.valueDidChange = { date in
            print("selectedDate ", date )
            self.DateEnd = date as! Date
            self.endDateChoose = "1"
            
            self.CallDate()
        }
            
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func TimeChooseCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TimeChooseCell") as! TimeChooseCell
        cell.txtEndTime.pickerType = .date
        cell.txtStartTime.pickerType = .date
        
        cell.txtEndTime.datePicker?.datePickerMode = .time
        cell.txtStartTime.datePicker?.datePickerMode = .time
        
        cell.txtEndTime.tag = indexPath.row * -1
        cell.txtStartTime.tag = indexPath.row
        
        cell.txtEndTime.delegate = self
        cell.txtStartTime.delegate = self
        
        cell.btnClose.tag = indexPath.row - 2
        cell.btnClose.addTarget(self, action: #selector(self.DeleteAction), for: .touchUpInside)
        cell.lblDate.text = self.timechoose[indexPath.row - 2].kdate
        
        let fmt = DateFormatter()
        fmt.dateFormat = "hh:mm a"
        
        cell.txtEndTime.dateFormatter = fmt
        cell.txtStartTime.dateFormatter = fmt

        cell.txtStartTime.valueDidChange = { date in
            print("selectedDate ", date )
            
            
            let indexObj = self.timechoose[indexPath.row - 2]
            indexObj.kStartTime = fmt.string(from: date as! Date)
            self.timechoose[indexPath.row - 2] = indexObj
            
        }
        
        cell.txtEndTime.valueDidChange = { date in
            print("selectedDate ", date )
            let indexObj = self.timechoose[indexPath.row - 2]
            indexObj.kEndTime = fmt.string(from: date as! Date)
            self.timechoose[indexPath.row - 2] = indexObj
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    @objc func DeleteAction(sender : UIButton){
        self.timechoose.remove(at: sender.tag)
        self.tabel_view.reloadData()
    }
    
    func CallDate(){
        
        
        // Formatter for printing the date, adjust it according to your needs:
        let fmt = DateFormatter()
        fmt.dateFormat = "dd MMM yyyy"
        self.timechoose.removeAll()
        var dateMew = self.DateStart
        while dateMew < DateEnd {
            let newModel = TimeChooseModel()
            newModel.kdate = fmt.string(from: dateMew)
            newModel.kStartTime = ""
            newModel.kEndTime = ""
            self.timechoose.append(newModel)
            print(fmt.string(from: self.DateStart))
            dateMew = Calendar.current.date(byAdding: .day, value: 1, to: dateMew)!
        }
        
        print(self.timechoose.count)
        self.tabel_view.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    func HistroySelectServiceCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ShowServicesCell")
        return cell!
    }
    
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField.tag == -1000 {
//
////            let storyboard = UIStoryboard(name: "AddressBook", bundle: nil)
////            let viewPush = storyboard.instantiateViewController(withIdentifier: "BookingListViewController") as! BookingListViewController
////            viewPush.delegate = self
////            viewPush.isChoose = true
////            self.navigationController?.pushViewController(viewPush, animated: true)
//
//            return false
//        }
//        return true
//    }
    
    func SelectedAddress(address: AddressModel) {
        self.chooseaddress = address
        
    }
    func SelectImageCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "HistoryCancelBookingCell")
        return cell!
    }
    
    func AddImage(sender : UIButton){
        self.showMediaChoosingOptions()
    }
    
    func AddVideo(sender : UIButton){
        
    }
    
//    override func selectedImage(image: UIImage) {
//        self.ChooseImage = image//info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        self.isImageChoose = true
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        self.ChooseImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        self.isImageChoose = true
//        picker.dismiss(animated: true) {
//
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true) {
//
//        }
//    }
    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(textField.tag)
//        print("Call ")
//
//
//        if textField.tag > -1000 {
//
//            var indexMain  = textField.tag
//            if textField.tag < 0 {
//                indexMain = textField.tag * -1
//            }
//
//            let cellMain = self.tabel_view.cellForRow(at: IndexPath.init(row: indexMain, section: 0)) as! TimeChooseCell
//
//            let startDate = ""
//            let endDate = ""
//
//            print(cellMain.txtEndTime.text)
//            print(cellMain.txtStartTime.text)
//
//
//            let fmt = DateFormatter()
//            fmt.dateFormat = "hh:mm a"
//
//            if cellMain.txtEndTime.text!.count > 0 && cellMain.txtEndTime.text!.count > 0 {
//
//                let dateStart = fmt.date(from: cellMain.txtStartTime.text!)
//                let dateEnd = fmt.date(from: cellMain.txtEndTime.text!)
//
//                if dateEnd! < dateStart! {
//                    self.ShowErrorAlert(message: "End date must be greater")
//
//                    cellMain.txtEndTime.text = ""
//                }
//            }
//        }
//    }
    
    
    
    @IBAction func Submit(sender : UIButton){
//
        
        
        var startDate = ""
        var endDate = ""
        var instruction = ""
        
        if self.timechoose.count == 0 {
            self.ShowErrorAlert(message: "Please select date and time")
            return
        }
        
        
        if self.chooseaddress.addressID == "0" || self.chooseaddress.addressID.count == 0{
            self.ShowErrorAlert(message: "Please select Address")
            return
        }
        
        
        
        
//        "company_id:7
//        address_id:2
//        instruction:Testing Testing
//        items[0][date]:1511308800
//        items[0][start_time]:1511334000
//        items[0][end_time]:1511359200
//        items[1][date]:1511395200
//        items[1][start_time]:1511438400
//        items[1][end_time]:1511452800
//        services[]:2
//        services[]:3
//        start_date:1511308800
//        end_date:1511395200
//        image
//        video"

        
        var newparam = [String : AnyObject]()
        newparam["company_id"] = self.SelectedCompany.companyID as AnyObject
        newparam["address_id"] = self.chooseaddress.addressID as AnyObject
        
        var indexCount = 0
        for index in 0..<(7 + self.timechoose.count) {
           let cell = tabel_view.cellForRow(at: IndexPath.init(row: index, section: 0))
            
            if cell is DateChooseCell {
                let TableFCell = cell as! DateChooseCell
                
                if TableFCell.txtFieldStartDAte.text!.count == 0 {
                    self.ShowErrorAlert(message: "Start date missing.")
                    return
                }else {
                    startDate = TableFCell.txtFieldStartDAte.text!
                }
                
                
                if TableFCell.txtFieldEndDAte.text!.count == 0 {
                    self.ShowErrorAlert(message: "End date missing.")
                    return
                }else {
                    endDate = TableFCell.txtFieldEndDAte.text!
                }
                
            }
            
            
            if cell is TimeChooseCell {
                let TableFCell = cell as! TimeChooseCell
                if TableFCell.txtStartTime.text?.count == 0 {
                    self.ShowErrorAlert(message:"Start time missing")
                    return
                }
                
                if TableFCell.txtEndTime.text?.count == 0 {
                    self.ShowErrorAlert(message:"End time missing")
                    return
                }
                
                print(TableFCell.txtStartTime.text)
                print(TableFCell.txtEndTime.text)
                print(TableFCell.lblDate.text)
                newparam[String.init(format:"items[%d][start_time]",indexCount)] = String(Int(self.getTimeInt(mainString:TableFCell.txtStartTime.text! , Withformate: "hh:mm a"))) as AnyObject
                newparam[String.init(format:"items[%d][end_time]",indexCount)] = String(Int(self.getTimeInt(mainString:TableFCell.txtEndTime.text! , Withformate: "hh:mm a"))) as AnyObject
                newparam[String.init(format:"items[%d][date]",indexCount)] = String(Int(self.getTimeInt(mainString:TableFCell.lblDate.text! , Withformate: "dd MMM yyyy"))) as AnyObject

                indexCount = indexCount + 1
            }else if  cell is TextFeildCell{
                let TableFCell = cell as! TextFeildCell
                
                if TableFCell.lblHeading.text == "Special Instructions (Optional)" {
                    instruction = TableFCell.txtFieldMain.text!
                }
            }
        }
        
        
        newparam["start_date"] = String(Int(self.getTimeInt(mainString:startDate , Withformate: "MM/dd/yyyy"))) as AnyObject
        newparam["end_date"] = String(Int(self.getTimeInt(mainString:endDate , Withformate: "MM/dd/yyyy"))) as AnyObject

        
        newparam["instruction"] = instruction as AnyObject
        
        var indexService = 0
        for indexObj in self.SelectedServices {
            newparam[String.init(format:"services[%d]",indexService)] = indexObj.ID as AnyObject
        }
        
        
        print(newparam)
        
        
        if isImageChoose {
            self.showLoading()
            NetworkManager.UploadFiles("user/bookings/store", image: self.ChooseImage,withParams: newparam, onView: self, completion: { (mainResponse) in
                self.hideLoading()
                print(mainResponse)
                
                if(mainResponse?["status_code"] as! Int == 200 ){
                    self.ShowSuccessAlert(message: (mainResponse?["message"] as? String)!)
                    
                }else{
                    self.hideLoading()
                    self.ShowErrorAlert(message:  mainResponse?["message"] as! String)
                }
                
                
            })
        }else {
            self.showLoading()
            NetworkManager.post("user/bookings/store", isLoading: true , withParams: newparam, onView: self, hnadler: { (mainResponse) in
                self.hideLoading()
                if(mainResponse?["status_code"] as! Int == 200 ){
                    self.ShowSuccessAlert(message: (mainResponse?["message"] as? String)!)
                    
                }else{
                    self.hideLoading()
                    self.ShowErrorAlert(message:  mainResponse?["message"] as! String)
                }
            })
        }
        
       
    }
}
extension BookingVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == -1000 {
            
            //            let storyboard = UIStoryboard(name: "AddressBook", bundle: nil)
            //            let viewPush = storyboard.instantiateViewController(withIdentifier: "BookingListViewController") as! BookingListViewController
            //            viewPush.delegate = self
            //            viewPush.isChoose = true
            //            self.navigationController?.pushViewController(viewPush, animated: true)
            
            return false
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.tag)
        print("Call ")
        
        
        if textField.tag > -1000 {
            
            var indexMain  = textField.tag
            if textField.tag < 0 {
                indexMain = textField.tag * -1
            }
            
            let cellMain = self.tabel_view.cellForRow(at: IndexPath.init(row: indexMain, section: 0)) as! TimeChooseCell
            
//            let startDate = ""
//            let endDate = ""
            
//            print(cellMain.txtEndTime.text)
//            print(cellMain.txtStartTime.text)
            
            
            let fmt = DateFormatter()
            fmt.dateFormat = "hh:mm a"
            
            if cellMain.txtEndTime.text!.count > 0 && cellMain.txtEndTime.text!.count > 0 {
                
                let dateStart = fmt.date(from: cellMain.txtStartTime.text!)
                let dateEnd = fmt.date(from: cellMain.txtEndTime.text!)
                
                if dateEnd! < dateStart! {
                    self.ShowErrorAlert(message: "End date must be greater")
                    
                    cellMain.txtEndTime.text = ""
                }
            }
        }
    }
}

class DateChooseCell : UITableViewCell{
    @IBOutlet var txtFieldStartDAte : AAPickerView!
    @IBOutlet var txtFieldEndDAte : AAPickerView!
}

class TextFeildCell : UITableViewCell{
    @IBOutlet var lblHeading : UILabel!
    @IBOutlet var txtFieldMain : UITextField!
}


class TimeChooseCell : UITableViewCell {
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var txtStartTime : AAPickerView!
    @IBOutlet var txtEndTime : AAPickerView!
    @IBOutlet var btnClose : UIButton!
}


class TimeChooseModel : NSObject {
    var kdate = kEmptyString
    var kStartTime = kEmptyString
    var kEndTime = kEmptyString
    var kStartDate = Date()
    var kEndDate = Date()
    
}

class HeadingCell : UITableViewCell {
    @IBOutlet var lblViewHeading : UILabel!
    @IBOutlet var viewSepreator : UIView!
}


class HistoryBookingButtonCell : UITableViewCell {
    
}

class HistoryCancelBookingCell : UITableViewCell{
    @IBOutlet var btnFirstBtn : UIButton!
    @IBOutlet var btnSecondBtn : UIButton!
}

class ShowServicesCell : UITableViewCell {
    @IBOutlet var lblName : UILabel!
    
    @IBOutlet var imgViweMain : UIImageView!
}

