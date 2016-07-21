// 
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
// 


import UIKit
import Social
import zshare
import WireExtensionComponents
import Classy



@objc protocol ConversationListViewControllerDelegate {
    optional func conversationList(conversationList: ConversationListViewController, didSelectConversation conversation:Conversation)
}



class ConversationListViewController: UITableViewController {
    
    @IBOutlet private weak var backButton: IconButton!
    @IBOutlet private weak var cancelButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 52.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        let image = UIImage(forLogoWithColor: UIColor.accentColor, iconSize: .Medium)
        self.navigationItem.titleView = UIImageView(image: image)
        
        self.cancelButton.setIcon(.X, withSize: .Tiny, forState: .Normal)
        self.backButton.setIcon(.ChevronLeft, withSize: .Tiny, forState: .Normal)
        
        let barButtonOffset: CGFloat = (self.traitCollection.userInterfaceIdiom == .Phone) ? 8 : 4
        if let leftItem = self.navigationItem.leftBarButtonItem {
            let leftSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
            leftSpacer.width = barButtonOffset
            self.navigationItem.leftBarButtonItems = [leftSpacer, leftItem]
        }
        
        if let rightItem = self.navigationItem.rightBarButtonItem {
            let rightSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
            rightSpacer.width = barButtonOffset
            self.navigationItem.rightBarButtonItems = [rightSpacer, rightItem]
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Following manual Classy update is a workarround for a bug:
        // sometimes Classy does not update ConversationListViewController when it is pushed.
        // Will remove this, once elegant solution is found.
        self.view.cas_updateStyling()
        self.navigationController?.navigationBar.cas_updateStyling()
        self.backButton.cas_updateStyling()
        self.cancelButton.cas_updateStyling()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 
    
    var delegate: ConversationListViewControllerDelegate? = nil
    
    var searchTerm: String = "" {
        didSet {
            self.tableView.reloadData()
            if (self.tableView.numberOfRowsInSection(0) > 0) {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
            }
        }
    }
    
    var excludedConversations: Array<Conversation> = [] {
        didSet {
            self.tableView.reloadData()
            if (self.tableView.numberOfRowsInSection(0) > 0) {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.extensionContext!.cancelRequestWithError(NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil))
    }
    
    // MARK: - API
    
    var shareExtensionAPI: ShareExtensionAPI! = nil {
        didSet {
            if let api = self.shareExtensionAPI {
                api.conversations { (conversations: [Conversation], error: NSError?) -> () in
                    self.model = conversations
                }
            }
        }
    }
    
    // MARK: - Temp model
    var model: Array<Conversation> = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var filteredModel: Array<Conversation> {
        var model: Array<Conversation> = []
        if (self.searchTerm.characters.count == 0) {
            model = self.model.filter { self.excludedConversations.map { $0.displayName }.indexOf($0.displayName) == nil }
        } else {
            model = self.model.filter { ($0.displayName.rangeOfString(self.searchTerm, options: .CaseInsensitiveSearch, range:nil, locale:nil)?.isEmpty == false) &&
                (self.excludedConversations.map { $0.displayName }.indexOf($0.displayName) == nil)}
        }
        
        //        The results are shown in the following order:
        //        - 1:1 conversations
        //        - group conversations
        //        - archived 1:1 conversations (40% alpha)
        //        - archived group conversations (40% alpha)
        let oneOnOneUnarchived = model.filter { conversation in conversation.type == .OneOnOne && !conversation.archived! }
        let groupUnarchived = model.filter { conversation in conversation.type == .Group && !conversation.archived! }
        let oneOnOneArchived = model.filter { conversation in conversation.type == .OneOnOne && conversation.archived! }
        let groupArchived = model.filter { conversation in conversation.type == .Group && conversation.archived! }
        model = [oneOnOneUnarchived, groupUnarchived, oneOnOneArchived, groupArchived].flatMap() {$0}
        
        return model
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredModel.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConversationListCell", forIndexPath: indexPath) as! ConversationListCell

        let conversation = self.filteredModel[indexPath.row]
        cell.conversation = conversation
        self.shareExtensionAPI.conversationImage(conversation) { (conversation: Conversation, image: UIImage?) -> () in
            if cell.conversation == conversation {
                cell.conversationImage = image
            }
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.conversationList?(self, didSelectConversation: self.filteredModel[indexPath.row])
    }
    
}
