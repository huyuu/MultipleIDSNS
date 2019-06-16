//
//  ResourcesForAddSnsidScene.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/07.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit
import Firebase

class ResourcesForAddSnsidScene: ProjectResource {
    
    // MARK: - General
    
    let owner: Account
    let navigationItemTitle = "Creating ID"
    /// should be set by delegate
    var existingNames: [String]
    let segueIdToSearchTopic = "searchTopic"
    let segueIdToChooseThemeColor = "chooseThemeColor"
    let segueIdToNewTopic = "newTopic"
    var existingTopics: [Topic]! = nil
    
    
    
    // MARK: - New Name TableView Configuration
    
    var newNameCells = [ NewNameCellAttributes(of: .title, content: "New Name"),
                         NewNameCellAttributes(of: .name, content: "Enter the name") ]
    var numberOfNewNameCells: Int { return newNameCells.count }
    var nameIsAvailable: Bool {
        guard userInputForNewName != "" else { return false }
        let isAvailable = !( existingNames.map({ $0.lowercased() }).contains(userInputForNewName.lowercased()) )
        return isAvailable
    }
    var userInputForNewName: String = ""
    let textFieldBorderWidth: CGFloat = 1.5
    let borderWidthOfNewNameCell: CGFloat = 4.0
    let cornerRadiusOfNewNameCell: CGFloat = 20.0
    /// should be set before segue to searchTopic
    var newName: String!
    
    
    
    // MARK: - Search Topic TableView Configuration
    
    var numberOfSearchTopicCells: Int { return totalSearchTopicCells.count }
    var staticSearchTopicCells = [ SearchTopicCellAttributes(of: .title("Search Topic")),
                             SearchTopicCellAttributes(of: .searchBar(placeHolderString: "Searching Topics...")) ]
    var chosenTopicsCell: [SearchTopicCellAttributes] = []
    var searchResultCells: [SearchTopicCellAttributes] {
        /// get matchedTopics
        let matchedTopics = existingTopics.filter({ $0.title.lowercased().contains(userInputForSearchTopic.lowercased()) })
        // asign it to searResultCells
        return matchedTopics.map({ (topic) -> SearchTopicCellAttributes in
            return SearchTopicCellAttributes(of: .searchResult(topicTitle: topic.title))
        })
    }
    var searchTopicDoneCell = [SearchTopicCellAttributes.init(of: .doneButton)]
    /// use this property to determine rows for display
    var totalSearchTopicCells: [SearchTopicCellAttributes] {
        var newValue = [SearchTopicCellAttributes]()
        newValue.append(contentsOf: staticSearchTopicCells)
        newValue.append(contentsOf: chosenTopicsCell)
        newValue.append(contentsOf: searchResultCells)
        if shouldNavigateToChooseThemeColorScene {
            newValue.append(contentsOf: searchTopicDoneCell)
        }
        return newValue
    }
    /// this is the only property should be set
    var userInputForSearchTopic = ""
    let edgesOfSearchResultCell = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    let cornerRadiusOfSearchResultCell: CGFloat = 20.0
    let borderWidthOfSearchResultCell: CGFloat = 2.0
    /// use this property to judge whether topics are acceptible
    var topicsAreAcceptibale: Bool {
        return chosenTopicTitles.count > 0 ? true : false
    }
    /// use this property to judge whether should navigate to next scene
    var shouldNavigateToChooseThemeColorScene: Bool {
        guard topicsAreAcceptibale else { return false }
        // if user is still choosing topics, return false
        guard searchResultCells.count == 0 else { return false }
        return true
    }
    var doneButtonCellRowIndex: Int {
        return totalSearchTopicCells.count - 1
    }
    
    
    
    // MARK: - Chosen Topics CollectionView Configuration
    
    var chosenTopicTitles: [String] {
        guard let first = self.chosenTopicsCell.first,
            case .chosenTopics(let topicTitles) = first.type else { return [String]() }
        return topicTitles
    }
    var numberOfChosenTopics: Int { return self.chosenTopicTitles.count }
    let reuseIdForChosenTopicsCVCell = "chosenTopicsCVCell"
    
    let itemsPerRow: CGFloat = 3
    let minInterItemSpacing: CGFloat = 5.0
    let minLineSpacing: CGFloat = 5.0
    let heightForItem: CGFloat = 30.0
    
    let cornerRadiusOfChosenTopicCell: CGFloat = 10.0
    let borderWidthOfChosenTopicCell: CGFloat = 2.0
    
//    var chosenTopic: Topic {
//        return self.chosenTopicTitles.map({ (topicTitle) -> Topic in
//            Topic(title: topicTitle, adherents: )
//        })
//    }
    
    
    
    // MARK: - Choose Theme Color
    
    var themeColor: UIColor = UIColor.defaultBlueColor
    
    
    
    
    // MARK: - Firebase
    
    let snsidTankRef = Database.rootReference().child("snsidTank")
    let topicTankRef = Database.rootReference().child("topicTank")
    
    
    
    // MARK: - Functions
    
    init(owner: Account, snsids: [SNSID]) {
        self.owner = owner
        self.existingNames = snsids.map({ $0.name })
        self.fetchExistingTopics()
    }
    
    
    /// Asynchronously fetch existing topics from database.
    internal func fetchExistingTopics(completion: (() -> Void)?=nil  ) {
        self.topicTankRef.observe(.value, with: { (snapshot) in
            guard let topicsDict = snapshot.value as? JSONDATA else {
                raiseWeakError("Can't get existing topics properly.")
                fatalError()
            }
            
            let topics = topicsDict.map{ (_, info) -> Topic in
                // check if data have correct attributes
                guard let info = info as? JSONDATA,
                    let title = info["title"] as? String,
                    let adherents = info["adherents"] as? JSONDATA else {
                        raiseWeakError("Can't get existing topics properly.")
                        fatalError()
                }
                return Topic(title: title, adherents: adherents)
            }.sorted(by: { (first, second) -> Bool in
                // sort by title
                return first.title < second.title
            })
            // update UI
            self.existingTopics = topics
            completion?()
        })
    }
    
    
//    internal func updateSearchResults(accordingTo string: String, completion: @escaping () -> ()) {
//        /// get search results according to given string
//        let searchResults: [Topic] = self.existingTopics.filter { (topic) -> Bool in
//            return topic.title.contains(string)
//        }
//
//        self.searchResultBlocks = searchResults.map({ (topic) -> SearchTopicBlock in
//            return SearchTopicBlock(type: .availableTopic, content: topic.title)
//        })
//        completion()
//    }
    
    
    internal static func indicatorColor(accordingTo isValid: Bool) -> UIColor {
        return isValid  ? #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) : #colorLiteral(red: 0.8275103109, green: 0.03921728841, blue: 0.09085532289, alpha: 1)
    }
    
    
    internal func getHeightForDoneButtonCell() -> CGFloat {
        let count = self.chosenTopicTitles.count
        let itemsPerRow = Int(self.itemsPerRow)
        let inititalInset: CGFloat = 200.0
        
        if count <= itemsPerRow {
            return inititalInset
        } else if itemsPerRow * 2 < count {
            return inititalInset - (heightForItem + minLineSpacing) * 2
        } else {
            return inititalInset - (heightForItem + minLineSpacing)
        }
    }
}



// MARK: - NewNameCellAttributes

enum NewNameCellAttributesType: String {
    case title
    case name
}


struct NewNameCellAttributes {
    var content: String? = nil
    let type: NewNameCellAttributesType
    lazy var reuseId: String = { return "\(type.rawValue)CellForNewName" }()
    
    
    init(of type: NewNameCellAttributesType, content: String?=nil) {
        self.content = content
        self.type = type
    }
}



// MARK: - SearchTopicCellAttributes

enum SearchTopicCellAttributesType {
    case title(_ titleLabelString: String)
    case searchBar(placeHolderString: String)
    case chosenTopics(_ topicTitles: [String])
    case searchResult(topicTitle: String)
    case doneButton
}


struct SearchTopicCellAttributes {
    let type: SearchTopicCellAttributesType
    lazy var reuseId: String = {
        let commonString = "CellForSearchTopic"
        switch self.type {
        case .title(_):
            return "title\(commonString)"
        case .searchBar(_):
            return "searchBar\(commonString)"
        case .chosenTopics(_):
            return "chosenTopics\(commonString)"
        case .searchResult(_):
            return "searchResult\(commonString)"
        case .doneButton:
            return "doneButton\(commonString)"
        }
    }()
    
    
    init(of type: SearchTopicCellAttributesType) {
        self.type = type
    }
}



// MARK: - DataSourceForAddSnsidScene Protocol

protocol DataSourceForAddSnsidScene {
    func translateToResourcesForAddSnsidScene() -> ResourcesForAddSnsidScene
}
