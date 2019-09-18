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
    let segueIdToFinalConfirm = "finalConfirm"
    var existingTopics: [Topic]! = nil
    
    
    
    // MARK: - Container
    
    let nextSceneObserverKey = "nextScene"
    
    
    
    // MARK: - New Name TableView Configuration
    
    let pageIndexOfNewName = 0
    private var staticNewNameCells = [ NewNameCellAttributes(of: .title, content: "New Name"),
                         NewNameCellAttributes(of: .name, content: "Enter the name") ]
    private var errorDescriptionCells = [ NewNameCellAttributes(of: .errorDescription, content: "Name already exists or is blank.") ]
    var totalNewNameCells: [NewNameCellAttributes] {
        var newValue: [NewNameCellAttributes] = []
        newValue.append(contentsOf: staticNewNameCells)
        newValue.append(contentsOf: errorDescriptionCells)
        return newValue
    }
    var numberOfNewNameCells: Int { return totalNewNameCells.count }
    var rowNumberOfErrorDescriptionCell: Int { return numberOfNewNameCells-1 }
    var isNameAvailable: Bool {
        guard !userInputForNewName.isEmpty else { return false }
        let isAvailable = !( existingNames.map({ $0.lowercased() }).contains(userInputForNewName.lowercased()) )
        return isAvailable
    }
    /// is the only property should be set
    var userInputForNewName: String = ""
    /// should be set before segue to searchTopic
    var newName: String!
    
    
    
    // MARK: - Search Topic TableView Configuration
    
    let pageIndexOfSearchTopic = 1
    var numberOfSearchTopicCells: Int { return totalSearchTopicCells.count }
    private var staticSearchTopicCells = [ SearchTopicCellAttributes(of: .title("Search Topic")),
                             SearchTopicCellAttributes(of: .searchBar(placeHolderString: "Searching Topics...")) ]
    var chosenTopicsCell: [SearchTopicCellAttributes] = []
    private var searchResultCells: [SearchTopicCellAttributes] {
        /// get matchedTopics
        let matchedTopics = existingTopics.filter({ $0.title.lowercased().contains(userInputForSearchTopic.lowercased()) })
        // asign it to searResultCells
        return matchedTopics.map({ (topic) -> SearchTopicCellAttributes in
            return SearchTopicCellAttributes(of: .searchResult(topicTitle: topic.title))
        })
    }
    /// use this property to determine rows for display
    var totalSearchTopicCells: [SearchTopicCellAttributes] {
        var newValue = [SearchTopicCellAttributes]()
        newValue.append(contentsOf: staticSearchTopicCells)
        newValue.append(contentsOf: chosenTopicsCell)
        newValue.append(contentsOf: searchResultCells)
        return newValue
    }
    var indicesBelowSearchTopicBar: [IndexPath] {
        var indices: [IndexPath] = []
        for (index, attributes) in totalSearchTopicCells.enumerated() {
            if case .title(_) = attributes.type { continue }
            else {
                indices.append(IndexPath(row: index, section: 0))
            }
        }
        return indices
    }
    /// this is the only property should be set
    var userInputForSearchTopic = ""
    let edgesOfSearchResultCell = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    /// use this property to judge whether topics are acceptible
    var topicsAreAcceptibale: Bool {
        return chosenTopicTitles.count > 0 ? true : false
    }
    var topicCanBeNew: Bool {
        // a nil string can't be a new topic ="=
        guard userInputForSearchTopic != "" else { return false }
        for cell in searchResultCells {
            // should always be true
            if case .searchResult(let topicTitle) = cell.type {
                // if userInput matches an existing topic in topicTank, return false.
                if topicTitle == userInputForSearchTopic {
                    return false
                }
            }
        }
        // else
        return true
    }
    /// use this property to judge whether should navigate to next scene
    var shouldNavigateToChooseThemeColorScene: Bool {
        guard topicsAreAcceptibale else { return false }
        // if user is still choosing topics, return false
        guard searchResultCells.count == 0 else { return false }
        return true
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
    
    
    
    // MARK: - Choose Theme Color
    
    let pageIndexOfChooseThemeColor = 2
    var themeColor: UIColor? = nil
    let pieces: Int = 6
    let requiredAmountOfColorUnits = 4000
    let colorContainerBounds = CGRect(x: 0, y: 0, width: 3000, height: 3000)
    let determineDistanceAdjustingCoefficient: CGFloat = 0.8
    let colorUnitViewSize = CGSize(width: 40, height: 40)
    
    
    
    // MARK: - New Topic Scene
    
    var newTopicCells = [NewTopicCellAttributes(of: .title),
                         NewTopicCellAttributes(of: .icon),
                         NewTopicCellAttributes(of: .description),
                         NewTopicCellAttributes(of: .dummy),
                         NewTopicCellAttributes(of: .combination),
                         NewTopicCellAttributes(of: .dummy)]
    

    var newTopicTitle: String? = nil
    var newTopicIcon: UIImage? = nil
    var newTopicDescription: String? = nil
    /// use this property to determine whether a new topic is created successfully
    var isCreatingNewTopicDone: Bool {
        guard let _ = newTopicTitle,
            let _ = newTopicIcon,
            !userInputForNewTopicDescription.isEmpty else {
                return false
        }
        return true
    }
    var userInputForNewTopicDescription: String = ""
    let placeHolderForNewTopicTextView = "Enter description of topic..."
    var descriptionTextViewShouldBecomeFirstResponder = false
    var indexPathOfDescriptionCellInNewTopicScene: IndexPath {
        for (row, attribute) in newTopicCells.enumerated() {
            if case .description = attribute.type {
                return IndexPath(row: row, section: 0)
            }
        }
        // shouldn't happened
        return IndexPath(row: 2, section: 0)
    }
    var indexPathOfCombinationCellInNewTopicScene: IndexPath? {
        for (row, attribute) in newTopicCells.enumerated() {
            if case .combination = attribute.type {
                return IndexPath(row: row, section: 0)
            }
        }
        // if still not available
        return nil
    }
    var shouldScrollToCombinationCell: Bool = false
    var createdTopicTitles: [String] = []
    
    
    
    // MARK: - Final Confirm Scene
    
    let pageIndexOfFinalConfirm = 3
    let finalConfirmCells = [FinalConfirmCellAttributes(of: .title),
                             FinalConfirmCellAttributes(of: .icon),
                             FinalConfirmCellAttributes(of: .information),
                             FinalConfirmCellAttributes(of: .dummy)]
    lazy var indexOfNameCellInFinalConfirm: IndexPath = {
        for (index, cellAttributes) in self.finalConfirmCells.enumerated() {
            if case .information = cellAttributes.type {
                return IndexPath(row: index, section: 0)
            }
        }
        return IndexPath(row: 2, section: 0) // shouldn't happen
    }()
    lazy var indexOfIconCellInFinalConfirm: IndexPath = {
        for (index, cellAttributes) in self.finalConfirmCells.enumerated() {
            if case .icon = cellAttributes.type {
                return IndexPath(row: index, section: 0)
            }
        }
        return IndexPath(row: 1, section: 0) // shouldn't happen
    }()
    var snsidIconImage: UIImage? = nil
    var bottomNavDrawerState: BottomNavigationDrawerViewController.ExpansionState = .closed
    let snsidDescriptionPlaceHolder = "Enter descriptions of your account."
    var snsidDescription = ""
    
    
    
    // MARK: - Final Confirm Cell Bottom Navigation Drawer
    
    let fullyExpandedHeight: CGFloat = 100
    let closedHeight: CGFloat = UIScreen.main.bounds.height - 60
    
    
    
    
    
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
    
    
    internal static func indicatorColor(accordingTo isValid: Bool) -> UIColor {
//        return isValid  ? UIColor("#7cb342")! : #colorLiteral(red: 0.8275103109, green: 0.03921728841, blue: 0.09085532289, alpha: 1)
        return isValid  ? UIColor("#7cb342")! : UIColor("#e64a19")!
    }
    
    
    
    // MARK: - NewNameCellAttributes
    
    enum NewNameCellAttributesType: String {
        case title
        case name
        case errorDescription
    }
    
    struct NewNameCellAttributes {
        let content: String
        let type: NewNameCellAttributesType
        let reuseId: String
        
        init(of type: NewNameCellAttributesType, content: String="") {
            self.content = content
            self.type = type
            self.reuseId = "\(type.rawValue)CellForNewName"
        }
    }
}







// MARK: - SearchTopicCellAttributes

enum SearchTopicCellAttributesType {
    case title(_ titleLabelString: String)
    case searchBar(placeHolderString: String)
    case chosenTopics(_ topicTitles: [String])
    case searchResult(topicTitle: String)
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
        }
    }()
    
    
    init(of type: SearchTopicCellAttributesType) {
        self.type = type
    }
}



// MARK: - NewTopicCell Atrributes

enum NewTopicCellAttributesType {
    case title
    case icon
    case description
    case dummy
    case combination
}


struct NewTopicCellAttributes {
    let type: NewTopicCellAttributesType
    let reuseId: String
    
    init(of type: NewTopicCellAttributesType) {
        self.type = type
        // for reuseId
        let commonString = "CellForNewTopic"
        switch type {
        case .title:
            self.reuseId = "title\(commonString)"
        case .icon:
            self.reuseId = "icon\(commonString)"
        case .description:
            self.reuseId = "description\(commonString)"
        case .dummy:
            self.reuseId = "dummy\(commonString)"
        case .combination:
            self.reuseId = "combination\(commonString)"
        }
    }
}



// MAKR: - Final Confirm Cell Enum

enum FinalConfirmCellAttributesType {
    case title
    case icon
    case information
    case dummy
}


struct FinalConfirmCellAttributes {
    let type: FinalConfirmCellAttributesType
    let reuseId: String
    
    init(of type: FinalConfirmCellAttributesType) {
        self.type = type
        // for reuseId
        let commonString = "CellForNewSnsidFinalConfirm"
        switch type {
        case .title:
            self.reuseId = "title\(commonString)"
        case .icon:
            self.reuseId = "icon\(commonString)"
        case .information:
            self.reuseId = "information\(commonString)"
        case .dummy:
            self.reuseId = "dummy\(commonString)"
        }
    }
}



// MARK: - Bottom Navigation Drawer of Final Confirm

enum BottomNavigationDrawerAttributesType {
    case name
}


struct BottomNavigationDrawerAttributes {
    let type: BottomNavigationDrawerAttributesType
    let reuseId: String
    let cellAmount = 1
    
    init(of type: BottomNavigationDrawerAttributesType) {
        self.type = type
        let commonString = "CellForBottomNavigationDrawerOfNewSnsidFinalConfirm"
        switch type {
        case .name:
            self.reuseId = "changingName\(commonString)"
        }
    }
}



// MARK: - DataSourceForAddSnsidScene Protocol

protocol DataSourceForAddSnsidScene {
    func translateToResourcesForAddSnsidScene() -> ResourcesForAddSnsidScene
}
