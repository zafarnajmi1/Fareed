 
 import UIKit
 import Alamofire
 
 typealias LoadingProgress = (_ counter: String) -> ()
 
 
 
 class NetworkManager: NSObject {
    //MARK: Activity Functions
    //Show loading view when a service is called
    class func showLoadingView(_ parentView: UIView) {
        var view = parentView.viewWithTag(-100)
        if view == nil {
            view = UIView(frame: UIScreen.main.bounds)
            view!.backgroundColor = UIColor.clear
            view!.tag = -100
            let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicator.center = view!.center
            activityIndicator.color = UIColor.black
            activityIndicator.startAnimating()
            view!.addSubview(activityIndicator)
        }
        parentView.addSubview(view!)
    }
    
    //Hide loading view when a service is called
    class func hideLoadingView(_ parentView: UIView) {
        if let view = parentView.viewWithTag(-100) {
            view.removeFromSuperview()
        }
    }
    
    
    //Failure handler if response give error from server
    
    class func handleFailureResponse(Error error: NSError?, parentView: UIViewController) {
        print(error?.code ?? "Servent")
        print(error?.description ?? "Servent")
        print(error?.debugDescription ?? "Servent")
//        self.hideLoadingView(parentView.view)
        self.ShowAlert(message: error!.localizedDescription, title: "Error".localized, parentView: parentView)
        self.hideLoadingView(parentView.view)
    }
    
    
    class func ShowAlert(message : String , title : String , parentView : UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler: nil))
        parentView.present(alert, animated: true, completion: nil)
    }
    
    //Sending get request to server
    //MARK: Get Request
    class  func get(_ URL: String, isLoading : Bool ,handleFailure : Bool = true,onView parentView: UIViewController, hnadler completion: @escaping ([AnyHashable: Any]?) -> Void) {
        var URLString  = String()
        if(isLoading){
            
        }
        
        URLString = APIConstants.kServerURL + URL
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                URLString = APIConstants.kServerArabicURL + URL
            }
        }
        
        
        
        var headers = [String : String]()
        headers = [
//            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        if let userSession = DataManager.sharedInstance.user?.session_token {
            headers["Authorization"] =  "bearer \(userSession)"
        }
        print("Get Request Headers: \(headers)")
        print("Get Request URL: \(URLString)")
        Alamofire.request(URLString ,  headers : headers)
            .validate()
            .responseJSON { response in
                self.hideLoadingView(parentView.view)
                switch response.result {
                case .success( _):
                    var completionVarible = [NSObject : AnyObject]()
                    print(response.result.value ?? "Servent")
                    if ((response.result.value as? NSDictionary) != nil) {
                        completionVarible = response.result.value as! [NSObject : AnyObject]
                    }else {
                        completionVarible = ["data" : response.result.value!] as [NSObject : AnyObject]
                    }
                    completion(completionVarible)
                case .failure(let error):
                    if handleFailure{
                        self.handleFailureResponse(Error: error as NSError?, parentView: parentView)
                    }
                    
                }
        }
    }
    
    //Sending get request to server
    //MARK: Get Request
    class  func getWithPArams(_ URL: String, isLoading : Bool , withParams params: [String : AnyObject], onView parentView: UIViewController, hnadler completion: @escaping ([AnyHashable: Any]?) -> Void) {
        var URLString  = String()
        if(isLoading){
            
        }
        URLString = APIConstants.kServerURL + URL
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                URLString = APIConstants.kServerArabicURL + URL
            }
        }
        
        var headers = [String : String]()
        
        headers = [
//            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        if let userSession = DataManager.sharedInstance.user?.session_token {
            headers["Authorization"] =  "bearer \(userSession)"
        }
        print("Request Headers: \(headers)")
        print("Request URL: \(URLString)")
        Alamofire.request(URLString , parameters: params, headers : headers)
            .validate()
            .responseJSON { response in
                self.hideLoadingView(parentView.view)
                switch response.result {
                case .success( _):
                    var completionVarible = [NSObject : AnyObject]()
                    print(response.result.value ?? "Servent")
                    if ((response.result.value as? NSDictionary) != nil) {
                        completionVarible = response.result.value as! [AnyHashable: Any]? as! [NSObject : AnyObject]
                    }else {
                        completionVarible = ["data" : response.result.value!] as [AnyHashable: Any]? as! [NSObject : AnyObject]
                    }
                    completion(completionVarible)
                case .failure(let error):
                    self.handleFailureResponse(Error: error as NSError?, parentView: parentView)
                }
        }
    }
    //Sending get request to server
    //MARK: Get Request
    
    class  func Delete(_ URL: String,isLoading : Bool, onView parentView: UIViewController, hnadler completion: @escaping ([AnyHashable: Any]?) -> Void) {
        if(isLoading){
            
        }
        var URLString  = String()
        URLString = APIConstants.kServerURL + URL
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                URLString = APIConstants.kServerArabicURL + URL
            }
        }
        
        var headers = [String : String]()
        headers = [
//            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        if let userSession = DataManager.sharedInstance.user?.session_token {
            headers["Authorization"] =  "bearer \(userSession)"
        }
        print("Request Headers: \(headers)")
        print("Request URL: \(URLString)")
        Alamofire.request(URLString ,method: .delete,  headers : headers)
            .validate(statusCode: 0..<600)
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    let completionVarible = [NSObject : AnyObject]()
                    completion(completionVarible)
                case .failure(let error):
                    self.handleFailureResponse(Error: error as NSError?, parentView: parentView)
                }
        }
    }
    
    //Sending Post request to server
    //MARK: POST Request
    
    class  func post(_ URL: String, isLoading : Bool, withParams params: [String : AnyObject], withToken: Bool = true, onView parentView: UIViewController, hnadler completion: @escaping ([AnyHashable: Any]?) -> Void) {
        var URLString  = String()
        URLString = APIConstants.kServerURL + URL
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                URLString = APIConstants.kServerArabicURL + URL
            }
        }
        var headers = [String: String]()
        if(isLoading){
            
        }
        
        headers = [
//            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
//        headers["Accept"] =  "¸application/json"
        if withToken {
            if let userSession = DataManager.sharedInstance.user?.session_token {
                headers["Authorization"] =  "bearer \(userSession)"
        }
        
        
            
            
        }
        print("Request Params: \(params)")
        print("Request Headers: \(headers)")
        print("Request URL: \(URLString)")
        Alamofire.request(URLString,method: .post, parameters: params , headers : headers)
            .responseJSON { response in
                
                self.hideLoadingView(parentView.view)
                switch response.result {
                case .success( _):
                    var completionVarible = [NSObject : AnyObject]()
                    var response_result : [AnyHashable: Any]  = (response.result.value as! [AnyHashable: Any]?)!
                    if response.response?.allHeaderFields != nil {
                        if  let Token : String = response.response?.allHeaderFields["Authorization"] as? String {
                            if(Token.count != 0){
                                response_result["token"] = Token as Any
                            }
                        }
                    }
                    completionVarible = response_result  as [NSObject : AnyObject]
                    completion(completionVarible)
                case .failure(let error):
                    self.handleFailureResponse(Error: error as NSError?, parentView: parentView)
                }
        }
    }
    
    //Sending put request to server
    //MARK: PUT Request
    
    class  func put(_ URL: String, withParams params: [String : AnyObject], onView parentView: UIViewController, hnadler completion: @escaping ([AnyHashable: Any]?) -> Void) {
        var URLString  = String()
        URLString = APIConstants.kServerURL + URL
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                URLString = APIConstants.kServerArabicURL + URL
            }
        }
        
        var headers = [String: String]()
        headers = [
//            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
//        headers["Content-Type"] = "application/x-www-form-urlencoded"

        print("Request Params : \(params)")
        print("Request Headers: \(headers)")
        print("Request URL: \(URLString)")
        Alamofire.request(URLString,method: .put, parameters: params , headers : headers)
            .validate(contentType: ["application/vnd.api+json"])
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    var completionVarible = [NSObject : AnyObject]()
                    completionVarible = response.result.value as! [AnyHashable: Any]? as! [NSObject : AnyObject]
                    completion(completionVarible)
                case .failure(let error):
                    self.handleFailureResponse(Error: error as NSError?, parentView: parentView)
                }
        }
    }
    
    
    
    //Sending delete request to server
    //MARK: DELETE Request
    class  func delete(_ URL: String, withParams params: [String : AnyObject], onView parentView: UIViewController, hnadler completion: @escaping ([AnyHashable: Any]?) -> Void) {
        var URLString  = String()
        URLString = APIConstants.kServerURL + URL
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                URLString = APIConstants.kServerArabicURL + URL
            }
        }
        
        
        var headers = [String: String]()
        headers = [
//            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
//       headers["Content-Type"] = "application/x-www-form-urlencoded"

        print("Request Params: \(params)")
        print("Request URL: \(URLString)")
        Alamofire.request(URLString,method: .delete, parameters: params , headers : headers)
            .validate(contentType: ["application/vnd.api+json"])
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    var completionVarible = [NSObject : AnyObject]()
                    completionVarible = response.result.value as! [AnyHashable: Any]? as! [NSObject : AnyObject]
                    completion(completionVarible)
                case .failure(let error):
                    self.handleFailureResponse(Error: error as NSError?, parentView: parentView)
                }
        }
    }
    
    
    //Sending patch request to server
    //MARK: PATCH Request
    class  func patch(_ URL: String, withParams params: [String : AnyObject], onView parentView: UIViewController, hnadler completion: @escaping ([AnyHashable: Any]?) -> Void) {
        var URLString  = String()
        URLString = APIConstants.kServerURL + URL
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                URLString = APIConstants.kServerArabicURL + URL
            }
        }
        
        
        var headers = [String: String]()
        headers = [
//            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
//        headers["Content-Type"] = "application/x-www-form-urlencoded"

        print("Request Params: \(params)")
        print("Request URL: \(URLString)")
        Alamofire.request(URLString,method: .patch, parameters: params , headers : headers)
            .validate(contentType: ["application/vnd.api+json"])
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    var completionVarible = [NSObject : AnyObject]()
                    completionVarible = response.result.value as! [AnyHashable: Any]? as! [NSObject : AnyObject]
                    completion(completionVarible)
                case .failure(let error):
                    self.handleFailureResponse(Error: error as NSError?, parentView: parentView)
                }
        }
    }
    
    
    
    class  func postForAuth(_ URL: String, withParams params: [String : AnyObject], onView parentView: UIViewController, hnadler completion: @escaping ([AnyHashable: Any]?) -> Void) {
        var URLString  = String()
        URLString =  URL
        print(params)
        Alamofire.request(URLString,method: .post, parameters: params )
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    var completionVarible = [NSObject : AnyObject]()
                    completionVarible = response.result.value as! [AnyHashable: Any]? as! [NSObject : AnyObject]
                    print("Response: \(completionVarible)")
                    completion(completionVarible)
                case .failure(let error):
                    self.handleFailureResponse(Error: error as NSError?, parentView: parentView)
                }
        }
    }
    class func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil, completion: @escaping (_ success: Bool, _ message: String, _ response: [[String: AnyObject]]?) -> Void) {
        
        
        
        var webserviceName = APIConstants.kServerURL + path
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                webserviceName = APIConstants.kServerArabicURL + path
            }
        }
        
        
        let request = NSMutableURLRequest(url: NSURL(string: webserviceName)! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        var headers = [String: String]()
        headers = [
//            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
        if let userSession = DataManager.sharedInstance.user?.session_token {
            headers["Authorization"] = "bearer " + userSession
            request.setValue("bearer \(userSession)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try? JSONSerialization.data(withJSONObject: params! as [String : AnyObject], options: [])
        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
        print("request")
        print(request)
        print("request")
        print(params!)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            print(response!)
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                
                print(httpResponse.allHeaderFields)
                
                
                let objectRecive = self.nsdataToJSON(data: (data)!)!
                
                print(objectRecive)
                
                
                completion(true, objectRecive["message"]! as! String, nil )
                
            }
            
        }
        )
        
        task.resume()
    }  
    class func nsdataToJSON(data: Data) -> AnyObject? {
        do {  
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    
    class  func UploadFiles(_ URLString: String,image: UIImage?, imageName : String = "imge",  withParams parameters: Dictionary<String, AnyObject>? = nil , onView parentView: UIViewController, completion: @escaping ([AnyHashable: Any]?) -> Void, progress: LoadingProgress? = nil)  {
       let URLStringNEw = APIConstants.kServerURL + URLString
        
        var headers = [String: String]()
        
        
        
        headers = [
//            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
        if let userSession = DataManager.sharedInstance.user?.session_token {
            headers["Authorization"] = "bearer " + userSession
        }
        
//        print(headers)
//        print(parameters ?? "dfa")
        print("Request Params: \(parameters)")
        print("Request Headers: \(headers)")
        print("Request URL: \(URLStringNEw)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let image = image {
                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: imageName, fileName: String(Date().millisecondsSince1970) + ".png", mimeType: "image/png")
            }
            
            
            if parameters != nil {
                if parameters!.keys.count > 0 {
                    for (key, value) in parameters! {
                        print(key)
                        print(value)
                        let stringValue = value as! String
                        multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }
            
            
        }, to:URLStringNEw , headers: headers )
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    let counter = Int(Progress.fractionCompleted * 100)
                    progress?("\(counter)")
                })
                
                upload.responseJSON { response in
                    print(response.response)
                    print(response)
                    if response.result.value != nil {
                        var completionVarible = [NSObject : AnyObject]()
                        completionVarible = response.result.value as! [AnyHashable: Any]? as! [NSObject : AnyObject]
                        print("Response: \(completionVarible)")
                        self.hideLoadingView(parentView.view)
                        completion(completionVarible)
                    }
                }
            case .failure( _):
                self.hideLoadingView(parentView.view)
                let mainResponse = ["status" : "error" , "Message" : kServerNotReachableMessage] as [String : Any]
                completion(mainResponse)
                break
                
            }
            
        }
    }
    
    
    class  func UploadVideo(_ URL: String, imageMain : UIImage? = nil, urlVideo: URL, imageName : String = "imge",  withParams parameters: Dictionary<String, AnyObject>? = nil, onView parentView: UIViewController, completion: @escaping ([AnyHashable: Any]?) -> Void, progress: LoadingProgress? = nil)  {

        var URLString = APIConstants.kServerURL + URL

        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                URLString = APIConstants.kServerArabicURL + URL
            }
        }
        
        
        

        var headers = [String: String]()

        headers = [
            "Accept": "application/json"
        ]

        if let userSession = DataManager.sharedInstance.user?.session_token {
            headers["Authorization"] = "bearer " + userSession
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in

            if imageMain != nil{
                
//                multipartFormData.append(UIImageJPEGRepresentation(imageMain!, 0.5)!, withName: "Image", fileName: String(Date().millisecondsSince1970) + ".png", mimeType: "image/png")
                
                multipartFormData.append((imageMain?.jpegData(compressionQuality: 0.5))!, withName: imageName, fileName: String(Date().millisecondsSince1970) + ".png", mimeType: "image/png")
            }

            multipartFormData.append(urlVideo, withName: "video")

            if parameters != nil {
                if parameters!.keys.count > 0 {
                    for (key, value) in parameters! {
                        let stringValue = value as! String
                        multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }

        }, to:URLString , headers: headers )
        { (result) in
            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    let counter = Int(Progress.fractionCompleted * 100)
                    progress?("\(counter)")
                })

                upload.responseJSON { response in
                    print(response.response)
                    print(response)
                    if response.result.value != nil {
                        //                        self.hideLoadingView(parentView.view)
                        var completionVarible = [NSObject : AnyObject]()
                        completionVarible = response.result.value as! [AnyHashable: Any]? as! [NSObject : AnyObject]
                        print("Response: \(completionVarible)")
                        
                        completion(completionVarible)
                    }
                }
            case .failure( _):
                self.hideLoadingView(parentView.view)
                print("failure")

                break

            }
            self.hideLoadingView(parentView.view)
        }
    }
    
    
    class  func SendImageMSG(_ URLString: String,image: UIImage,  withParams parameters: Dictionary<String, AnyObject>? = nil , onView parentView: UIViewController, completion: @escaping ([AnyHashable: Any]?) -> Void)  {
        var URLStringNEw = APIConstants.kServerURL + URLString

        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil) {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                URLStringNEw = APIConstants.kServerArabicURL + URLString
            }
        }
        
        var headers = [String: String]()

        headers = [
//            "Content-Type":"application/json",
            "Accept": "application/json"
        ]

        if let userSession = DataManager.sharedInstance.user?.session_token {
            headers["Authorization"] = "bearer " + userSession
            //            request.setValue("bearer \(userSession)", forHTTPHeaderField: "Authorization")
        }

        print(headers)
        print(parameters)


        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: String(Date().millisecondsSince1970) + ".png", mimeType: "image/png")
            //append(UIImageJPEGRepresentation(image, 0.5)!, withName: "Image", fileName: String(Date().millisecondsSince1970) + ".png", mimeType: "image/png")


            if parameters != nil {
                if parameters!.keys.count > 0 {
                    for (key, value) in parameters! {
                        print(key)
                        print(value)
                        let stringValue = value as! String
                        multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }


        }, to:URLStringNEw , headers: headers )
        { (result) in
            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })

                upload.responseJSON { response in
                    print(response.response)
                    print(response)
                    if response.result.value != nil {
                        var completionVarible = [NSObject : AnyObject]()
                        completionVarible = response.result.value as! [AnyHashable: Any]? as! [NSObject : AnyObject]
                        print("Response: \(completionVarible)")
                        completion(completionVarible)
                    }
                }
            case .failure( _):
                let mainResponse = ["status" : "error" , "Message" : kServerNotReachableMessage] as [String : Any]
                completion(mainResponse)
                break

            }
        }
    }
    
 }

