import Foundation

let signInBaseURL = "http://youtiao.im/oauth/token"
let signOutBaseURL = "http://youtiao.im/oauth/revoke"

class APIClient: AFHTTPRequestOperationManager{
  static let sharedInstance = APIClient()

  var accessToken: String?

  init() {
    super.init(baseURL: NSURL(string: "http://api.youtiao.im/v1"))

    self.requestSerializer = AFJSONRequestSerializer()
    self.responseSerializer = AFJSONResponseSerializer()
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func HTTPRequestOperationWithRequest(request: NSURLRequest!, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void)!, failure: ((AFHTTPRequestOperation!, NSError!) -> Void)!) -> AFHTTPRequestOperation! {
    let mutableRequest = request as! NSMutableURLRequest
    if (self.accessToken != nil) {
      mutableRequest.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    }

    return super.HTTPRequestOperationWithRequest(request, success: success, failure: failure)
  }

  func get(URLString: String, parameters: AnyObject?, responseClass: AnyClass, success: ((AnyObject) -> Void)?, failure: ((NSError) -> Void)?) {
    self.GET(URLString, parameters: parameters,
      success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
        var error: NSError?
        let model: AnyObject! = MTLJSONAdapter.modelOfClass(responseClass, fromJSONDictionary: responseObject as! [NSObject: AnyObject], error: &error)
        if (error != nil) {
          failure?(error!)
        } else {
          success?(model)
        }
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        failure?(self.convertError(operation: operation, error: error))
      }
    )
  }

  func gets(URLString: String, parameters: AnyObject?, responseElementClass: AnyClass, success: (([AnyObject]) -> Void)?, failure: ((NSError) -> Void)?) {
    self.GET(URLString, parameters: parameters,
      success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
        var error: NSError?
        let models: [AnyObject]! = MTLJSONAdapter.modelsOfClass(responseElementClass, fromJSONArray: responseObject as! [AnyObject], error: &error)
        if (error != nil) {
          failure?(error!)
        } else {
          success?(models)
        }
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        failure?(self.convertError(operation: operation, error: error))
      }
    )
  }

  func post(URLString: String, parameters: AnyObject?, success: (([NSObject: AnyObject]) -> Void)?, failure: ((NSError) -> Void)?) {
    self.POST(URLString, parameters: parameters,
      success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
        success?(responseObject as! [NSObject: AnyObject])
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        failure?(self.convertError(operation: operation, error: error))
      }
    )
  }

  func post(URLString: String, parameters: AnyObject?, responseClass: AnyClass, success: ((AnyObject) -> Void)?, failure: ((NSError) -> Void)?) {
    self.post(URLString, parameters: parameters,
      success: { (dictionary: [NSObject : AnyObject]) -> Void in
        var error: NSError?
        let model: AnyObject! = MTLJSONAdapter.modelOfClass(responseClass, fromJSONDictionary: dictionary, error: &error)
        if (error != nil) {
          failure?(error!)
        } else {
          success?(model)
        }
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  private func convertError(#operation: AFHTTPRequestOperation!, error: NSError!) -> NSError! {
    if operation.cancelled {
      return OperationCancelledError()
    } else if error.domain == "NSURLErrorDomain" {
      return NetworkError(domain: error.domain, code: error.code, userInfo: error.userInfo)
    } else {
      switch operation.response.statusCode {
      case 401:
        return UnauthorizedError()
      case 403:
        return ForbiddenError()
      case 404:
        return NotFoundError()
      case 422:
        let dictionary = operation.responseObject as! [NSObject: AnyObject]
        return UnprocessableEntityError.fromErrorString(dictionary["error"] as! String)
      default:
        return ServerError()
      }
    }
  }

  func signUpWithEmail(email: String?, password: String?, name: String?, success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
    var parameters = [String: String]()
    if email != nil {
      parameters["email"] = email
    }
    if password != nil {
      parameters["password"] = password
    }
    if name != nil {
      parameters["name"] = name
    }
    self.post("users.sign_up", parameters: parameters, responseClass: User.self, success: { (model: AnyObject) -> Void in
        success?(model as! User)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  private func encodedStringForURLParameterString(stringValue: String) -> String? {
    let encodedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, stringValue, nil, ":/?#[]@!$&'()*+,;=", CFStringBuiltInEncodings.UTF8.rawValue) as String
    return encodedString
  }

  func signInWithEmail(email: String, password: String, success: (([NSObject: AnyObject]) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "grant_type": "password",
      "username": email,
      "password": password]

    var requestURLString = signInBaseURL
    var queryString: String? = nil
    for (fieldKey, fieldValue) in parameters {
      if let encodedKey = self.encodedStringForURLParameterString(fieldKey) {
        if let encodedValue = self.encodedStringForURLParameterString(fieldValue) {
          if queryString == nil {
            queryString = "?"
          } else {
            queryString! += "&"
          }
          queryString! += encodedKey + "=" + encodedValue
        }
      }
    }
    if queryString != nil {
      requestURLString += queryString!
    }

    var signInRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: requestURLString)!)
    signInRequest.HTTPMethod = "POST"
    let signInOperation: AFHTTPRequestOperation = AFHTTPRequestOperation(request: signInRequest)
    signInOperation.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
      let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers, error: nil)
      let dictionaryObj = jsonObject as! NSDictionary
      self.accessToken = dictionaryObj.valueForKey("access_token") as? String
      success?(jsonObject as! [NSObject: AnyObject])
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        failure?(self.convertError(operation: operation, error: error))
      }
    )
    self.operationQueue.addOperation(signInOperation)
  }

  func signOut(#success: (([NSObject: AnyObject]) -> Void)?, failure: ((NSError) -> Void)?) {
    let requestURLString = signOutBaseURL
    var signOutRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: requestURLString)!)
    signOutRequest.HTTPMethod = "POST"
    if self.accessToken != nil {
      signOutRequest.setValue(self.accessToken, forHTTPHeaderField: "Authorization: Bearer \(self.accessToken)")
    }
    let signOutOperation: AFHTTPRequestOperation = AFHTTPRequestOperation(request: signOutRequest)
    signOutOperation.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        success?(jsonObject as! [NSObject: AnyObject])
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        failure?(self.convertError(operation: operation, error: error))
      }
    )
    self.operationQueue.addOperation(signOutOperation)
  }

  func fetchCurrentUser(#success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
    get("user.info", parameters: nil, responseClass: User.self,
      success: { (model: AnyObject) -> Void in
        success?(model as! User)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func updateCurrentUserWithName(name: String?, avatatId: String?, success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters: NSMutableDictionary = NSMutableDictionary()
    if name != nil {
      parameters["name"] = name!
    }
    if avatatId != nil {
      parameters["avatat_id"] = avatatId!
    }

    self.post("user.update", parameters: parameters, responseClass: User.self,
      success: { (model: AnyObject) -> Void in
        success?(model as! User)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func changeCurrentUserName(name: String, success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
    self.updateCurrentUserWithName(name, avatatId: nil, success: success, failure: failure)
  }

  func changeCurrentUserAvatarWithImage(image: UIImage, success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
    self.uploadImage(image,
      success: { (blob: Blob) -> Void in
        self.updateCurrentUserWithName(nil, avatatId: blob.id!, success: success, failure: failure)
      }, failure: { (error: NSError!) -> Void in
        failure?(error)
      }
    )
  }

  func updateCurrentUserWithPassword(originalPassword: String?, newPassword: String?, success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
    var parameters: [NSString : NSString] = [NSString : NSString]()
    if originalPassword != nil {
      parameters["password"] = originalPassword
    }
    if newPassword != nil {
      parameters["new_password"] = newPassword
    }

    self.post("user.change_password", parameters: parameters, responseClass: User.self, success: { (model: AnyObject) -> Void in
        success?(model as! User)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func changeCurrentUserPassword(originalPassword: String, newPassword: String, success: ((User) -> Void)?, failure: ((NSError) -> Void)?) {
    self.updateCurrentUserWithPassword(originalPassword, newPassword: newPassword, success: success, failure: failure)
  }

  func fetchGroups(#success: (([Group]) -> Void)?, failure: ((NSError) -> Void)?) {
    self.gets("groups.list", parameters: nil, responseElementClass: Group.self,
      success: { (models: [AnyObject]) -> Void in
        success?(models as! [Group])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func createGroupWithName(name: String, code: String?, success: ((Group) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters: NSMutableDictionary = [
      "name": name]
    if code != nil {
      parameters["code"] = code!
    }

    self.post("groups.create", parameters: parameters, responseClass: Group.self,
      success: { (model: AnyObject) -> Void in
        success?(model as! Group)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func updateGroup(group: Group, name: String?, code: String?, success: ((Group) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters: NSMutableDictionary = NSMutableDictionary()
    parameters["id"] = group.id!
    if name != nil {
      parameters["name"] = name!
    }
    if code != nil {
      parameters["code"] = code!
    }

    self.post("groups.update", parameters: parameters, responseClass: Group.self,
      success: { (model: AnyObject) -> Void in
        success?(model as! Group)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func joinGroupWithCode(code: String, success: ((Group) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "code": code]

    self.post("groups.join", parameters: parameters, responseClass: Group.self,
      success: { (model: AnyObject) -> Void in
        success?(model as! Group)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func leaveGroup(group: Group?, success: ((dictionary: [NSObject: AnyObject]) -> Void)?, failure: ((NSError) -> Void)?) {
    if group == nil || group!.id == nil {
      return
    }
    var parameter: AnyObject?
    parameter = NSDictionary(object: group!.id!, forKey: "id")
    self.post("groups.leave", parameters: parameter, success: { (dictionary: [NSObject: AnyObject]) -> Void in
        success?(dictionary: dictionary)
      },failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchGroupAllMemberships(group: Group, success: (([Membership]) -> Void)?, failure: ((NSError) -> Void)?) {
    var parameters: [NSObject: AnyObject] = ["group_id": group.id!]
    self.gets("memberships.list", parameters: parameters, responseElementClass: Membership.self, success: { (models: [AnyObject]) -> Void in
        success?(models as! [Membership])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchGroupMemberships(group: Group,  roles: [String]?, success: (([Membership]) -> Void)?, failure: ((NSError) -> Void)?) {
    var parameters: [NSObject : AnyObject] = ["group_id": group.id!]
    if let roles = roles {
      parameters["roles"] = roles
    }

    self.gets("memberships.list", parameters: parameters, responseElementClass: Membership.self, success: { (models: [AnyObject]) -> Void in
        success?(models as! [Membership])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchGroupMembershipsCreatedBeforeMembership(group: Group, roles: [String]?, createdBeforeMembership membership: Membership?, success: (([Membership]) -> Void)?, failure: ((NSError) -> Void)?) {
    var parameters: [NSObject : AnyObject] = ["group_id": group.id!]
    if let roles = roles {
      parameters["roles"] = roles
    }

    if let membership = membership {
      parameters["before_id"] = membership.id
    }

    self.gets("memberships.list", parameters: parameters, responseElementClass: Membership.self, success: { (models: [AnyObject]) -> Void in
        success?(models as! [Membership])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchBulletins(#success: (([Bulletin]) -> Void)?, failure: ((NSError) -> Void)?) {
    self.gets("bulletins.list", parameters: nil, responseElementClass: Bulletin.self,
      success: { (models: [AnyObject]) -> Void in
        success?(models as! [Bulletin])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchBulletinsCreatedBeforeBulletin(bulletin: Bulletin, success: (([Bulletin]) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "before_id": bulletin.id!]

    self.gets("bulletins.list", parameters: parameters, responseElementClass: Bulletin.self,
      success: { (models: [AnyObject]) -> Void in
        success?(models as! [Bulletin])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchBulletinsForGroup(group: Group, success: (([Bulletin]) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "group_id": group.id!]

    self.gets("bulletins.list", parameters: parameters, responseElementClass: Bulletin.self,
      success: { (models: [AnyObject]) -> Void in
        success?(models as! [Bulletin])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchBulletinsForGroup(group: Group, createdBeforeBulletin bulletin: Bulletin, success: (([Bulletin]) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "group_id": group.id!,
      "before_id": bulletin.id!]

    self.gets("bulletins.list", parameters: parameters, responseElementClass: Bulletin.self,
      success: { (models: [AnyObject]) -> Void in
        success?(models as! [Bulletin])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func createBulletinWithText(text: String, forGroup group: Group, success: ((Bulletin) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "group_id": group.id!,
      "text": text]

    self.post("bulletins.create", parameters: parameters, responseClass: Bulletin.self,
      success: { (model: AnyObject) -> Void in
        success?(model as! Bulletin)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func stampBulletin(bulletin: Bulletin, withSymbol symbol: String, success: ((Bulletin) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "id": bulletin.id!,
      "symbol": symbol]

    self.post("bulletins.stamp", parameters: parameters, responseClass: Bulletin.self,
      success: { (model: AnyObject) -> Void in
        success?(model as! Bulletin)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchStampsForBulletin(bulletin: Bulletin, success: (([Stamp]) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "bulletin_id": bulletin.id!]

    self.gets("stamps.list", parameters: parameters, responseElementClass: Stamp.self,
      success: { (models: [AnyObject]) -> Void in
        success?(models as! [Stamp])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchStampsForBulletin(bulletin: Bulletin, createdBeforeStamp stamp: Stamp, success: (([Stamp]) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "bulletin_id": bulletin.id!,
      "before_id": stamp.id!]

    self.gets("stamps.list", parameters: parameters, responseElementClass: Stamp.self,
      success: { (models: [AnyObject]) -> Void in
        success?(models as! [Stamp])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchCommentsForBulletin(bulletin: Bulletin, success: (([Comment]) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "bulletin_id": bulletin.id!]

    self.gets("comments.list", parameters: parameters, responseElementClass: Comment.self,
      success: { (models: [AnyObject]) -> Void in
        success?(models as! [Comment])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func fetchCommentsForBulletin(bulletin: Bulletin, createdBeforeComment comment: Comment, success: (([Comment]) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "bulletin_id": bulletin.id!,
      "before_id": comment.id!]

    self.gets("comments.list", parameters: parameters, responseElementClass: Comment.self,
      success: { (models: [AnyObject]) -> Void in
        success?(models as! [Comment])
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func createCommentWithText(text: String, forBulletin bulletin: Bulletin, success: ((Comment) -> Void)?, failure: ((NSError) -> Void)?) {
    let parameters = [
      "bulletin_id": bulletin.id!,
      "text": text]

    self.post("comments.create", parameters: parameters, responseClass: Comment.self,
      success: { (model: AnyObject) -> Void in
        success?(model as! Comment)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  func uploadImage(image: UIImage, success: ((Blob) -> Void)?, failure: ((NSError) -> Void)?) {
    self.getUploadTokenWithSuccess({ (uploadToken: String) -> Void in
      self.uploadData(UIImagePNGRepresentation(image), withUploadToken: uploadToken, success: success, failure: failure)
      }, failure: { (error: NSError!) -> Void in
        failure?(error)
      }
    )
  }

  private func getUploadTokenWithSuccess(success: ((String) -> Void)?, failure: ((NSError) -> Void)?) {
    self.post("blobs.token", parameters: nil,
      success: { (dictionary: [NSObject : AnyObject]) -> Void in
        success?(dictionary["upload_token"] as! String)
      }, failure: { (error: NSError) -> Void in
        failure?(error)
      }
    )
  }

  private func uploadData(data: NSData, withUploadToken uploadToken: String, success: ((Blob) -> Void)?, failure: ((NSError) -> Void)?) {
    let uploadManager = QNUploadManager()
    uploadManager.putData(data, key: nil, token: uploadToken,
      complete: { (responseInfo: QNResponseInfo!, key: String!, response: [NSObject: AnyObject]!) -> Void in
        var error: NSError?
        let blob = MTLJSONAdapter.modelOfClass(Blob.self, fromJSONDictionary: response, error: &error) as! Blob
        if (error != nil) {
          failure?(error!)
        } else {
          success?(blob)
        }
      },
      option: nil)
  }
}
