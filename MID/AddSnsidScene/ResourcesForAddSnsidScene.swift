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
    var rowOfErrorDescriptionCell: Int { return numberOfNewNameCells-1 }
    var nameIsAvailable: Bool {
        guard userInputForNewName != "" else { return false }
        let isAvailable = !( existingNames.map({ $0.lowercased() }).contains(userInputForNewName.lowercased()) )
        return isAvailable
    }
    /// is the only property should be set
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
    /// use this property to determine rows for display
    var totalSearchTopicCells: [SearchTopicCellAttributes] {
        var newValue = [SearchTopicCellAttributes]()
        newValue.append(contentsOf: staticSearchTopicCells)
        newValue.append(contentsOf: chosenTopicsCell)
        newValue.append(contentsOf: searchResultCells)
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
    
    let cornerRadiusOfChosenTopicCell: CGFloat = 10.0
    let borderWidthOfChosenTopicCell: CGFloat = 2.0
    
//    var chosenTopic: Topic {
//        return self.chosenTopicTitles.map({ (topicTitle) -> Topic in
//            Topic(title: topicTitle, adherents: )
//        })
//    }
    
    
    
    // MARK: - Choose Theme Color
    
    var themeColor: UIColor = UIColor.placeHolderForThemeColor
    let pieces: Int = 6
    var colorUnitPositions: [ColorUnitPositionInfo]!
    let requiredAmountOfColorUnits = 4000
    let determineDistanceAdjustingCoefficient: CGFloat = 0.8
    weak var colorContainerView: ColorContainerView!
    var previouslyChoosenButtonIndex: Int!
    
    
    
    // MARK: - New Topic Scene
    
    var newTopicCells = [NewTopicCellAttributes(of: .title),
                         NewTopicCellAttributes(of: .icon),
                         NewTopicCellAttributes(of: .description),
                         NewTopicCellAttributes(of: .dummy),
                         NewTopicCellAttributes(of: .combination)]
    

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

    
    
    
    // MARK: - Firebase
    
    let snsidTankRef = Database.rootReference().child("snsidTank")
    let topicTankRef = Database.rootReference().child("topicTank")
    
    
    
    // MARK: - Functions
    
    init(owner: Account, snsids: [SNSID]) {
        self.owner = owner
        self.existingNames = snsids.map({ $0.name })
        /// for preFetching colorUnitPositions. contentFrame should be updated synchronously with storybord
        let contentFrame = CGRect(x: 0, y: 0, width: 3000, height: 3000)
        self.generateColorUnitPositions(in: contentFrame, elementSize: ColorUnitButton.intrinsicSize, completionHandler: { (positions) in
            return
        })
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
        return isValid  ? #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) : #colorLiteral(red: 0.8275103109, green: 0.03921728841, blue: 0.09085532289, alpha: 1)
    }
    
    
    internal func generateColorUnitPositions(in viewFrame: CGRect, elementSize: CGSize, completionHandler: @escaping ([ColorUnitPositionInfo]) -> ()) {
        let containerCenter = CGPoint(x: viewFrame.origin.x + viewFrame.width/2, y: viewFrame.origin.y + viewFrame.height/2)
        let pointsPerFrame = Int( requiredAmountOfColorUnits/(pieces*pieces) )
        /// determine whether a point is isolated
        let determineDistance = elementSize.width * self.determineDistanceAdjustingCoefficient
        // preparation for concurrent operations
        let runQueue = DispatchQueue(label: "colorUnitPositions", qos: .default, attributes: .concurrent)
        let group = DispatchGroup()
        
        var totalPositions: [ColorUnitPositionInfo] = []
        let frames = self.splitFrame(of: viewFrame, into: pieces)
        
        for frame in frames {
            group.enter()
            runQueue.async {
                var localPositions: [ColorUnitPositionInfo] = []
                var count = 0
                while count < pointsPerFrame {
                    let randomX = CGFloat.random(in: frame.minX..<frame.maxX)
                    let randomY = CGFloat.random(in: frame.minY..<frame.maxY)
                    let position = ColorUnitPositionInfo(CGPoint(x: randomX, y: randomY), containerCenter: containerCenter)
                    
                    if position.isIsolated(in: localPositions, determineDistance: determineDistance) {
                        localPositions.append(position)
                        count += 1
                    }
                }
                totalPositions.append(contentsOf: localPositions)
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.colorUnitPositions = totalPositions
            completionHandler(totalPositions)
        }
    }
    
    
    /// Privately used in _func_ generateColorUnitPositions(in:elementSize:completionHandler:).
    private func splitFrame(of originFrame: CGRect, into pieces: Int) -> [CGRect] {
        let width = originFrame.width / CGFloat(pieces)
        let height = originFrame.height / CGFloat(pieces)
        
        let xs = (0..<pieces).map { (multiplier) -> CGFloat in
            return originFrame.origin.x + width * CGFloat(multiplier)
        }
        let ys = (0..<pieces).map { (multiplier) -> CGFloat in
            return originFrame.origin.y + height * CGFloat(multiplier)
        }
        
        var frames: [CGRect] = []
        for x in xs {
            for y in ys {
                let frame = CGRect(x: x, y: y, width: width, height: height)
                frames.append(frame)
            }
        }
        return frames
    }
    
    
    deinit {
        self.topicTankRef.removeAllObservers()
    }
}



// MARK: - NewNameCellAttributes

enum NewNameCellAttributesType: String {
    case title
    case name
    case errorDescription
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



// MARK: - ColorUnitPositionInfo Struct Definition

/// Only for generating ColorUnit positions
struct ColorUnitPositionInfo {
    var center: CGPoint
    let distanceFromContainerCenter: CGFloat
    let normalizedAngle: CGFloat
    
    
    init(_ center: CGPoint, containerCenter: CGPoint) {
        self.center = center
        self.distanceFromContainerCenter = center.distance(from: containerCenter)
        self.normalizedAngle = center.angle(from: containerCenter, normalizedBy: 2*CGFloat.pi)
    }
    
    
    private init(center: CGPoint, distanceFromContainerCenter: CGFloat, normalizedAngle: CGFloat) {
        self.center = center
        self.distanceFromContainerCenter = distanceFromContainerCenter
        self.normalizedAngle = normalizedAngle
    }
    

    fileprivate func isIsolated(in positions: [ColorUnitPositionInfo], determineDistance: CGFloat) -> Bool {
        for existingPosition in positions {
            if self.center.distance(from: existingPosition.center) <= determineDistance {
                return false
            }
        }
        return true
    }
    
    
    internal func insetsBy(_ inset: CGPoint) -> ColorUnitPositionInfo {
        let newValue = ColorUnitPositionInfo(center: self.center + inset, distanceFromContainerCenter: self.distanceFromContainerCenter, normalizedAngle: self.normalizedAngle)
        return newValue
    }
}



// MARK: - DataSourceForAddSnsidScene Protocol

protocol DataSourceForAddSnsidScene {
    func translateToResourcesForAddSnsidScene() -> ResourcesForAddSnsidScene
}
