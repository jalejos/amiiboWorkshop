# amiiboWorkshop

## Sections
- [What to learn from this workshop](https://github.com/jalejos/amiiboWorkshop#what-we-expect-to-learn-on-this-workshop)
- [Step by step](https://github.com/jalejos/amiiboWorkshop#step-by-step)
  - [Install Pods](https://github.com/jalejos/amiiboWorkshop#install-project-pods)
  - [Initialize Model](https://github.com/jalejos/amiiboWorkshop#initialize-model)
  - [Map from JSON to Model](https://github.com/jalejos/amiiboWorkshop#map-properties-to-json-keys)
  - [Get Array of Elements](https://github.com/jalejos/amiiboWorkshop#get-example-amiibo-array)
  - [Work on your TableView](https://github.com/jalejos/amiiboWorkshop#configure-basic-table-view)
  - [Make TableView Interactive](https://github.com/jalejos/amiiboWorkshop#make-tableview-interactive)
  - [Display Selected Model's Details](https://github.com/jalejos/amiiboWorkshop#display-selected-amiibo-information)

## What we expect to learn on this workshop
- Swift: the land without null’s
- A common project structure for an iOS application
- Displaying a list of objects on your phone
- Learn how an application decides how to arrange its components

## Step by step
###### Install project Pods
- In case Cocoapods hasn't been installed yet, run the next command
```sudo gem install cocoapods```

- After that, navigate to the project folder and run the following comming
```pod install```

###### Initialize model
- We're going to work with an Amiibo's series name, character name, amiibo name, image and release date on the US. On your Models/Amiibo.swift
```
class Amiibo {
    var series: String      = ""
    var character: String   = ""
    var name: String        = ""
    var imageURL: String    = ""
    var releaseUS: Date     = Date()
}
```

###### Map properties to JSON keys
- We can get the JSON keys from our Utility/AmiiboJSONMockup.swift file. On your Models/Amiibo.swift
```
import Foundation
import ObjectMapper

class Amiibo: Mappable {
/*
*/
}

required init?(map: Map) {}
    
    func mapping(map: Map) {
        series <- map["gameSeries"]
        character <- map["character"]
        name <- map["name"]
        imageURL <- map[“image”]
        releaseUS <- (map["release.na"], DateTransform())
    }
```


###### Get example amiibo array
- We're going to do a basic conversion from the JSON to an array of Amiibos. On your View Controllers/AmiiboListViewController.swift
```
import UIKit
import ObjectMapper

class AmiiboListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let json = AmiiboJSONMockup.getBasicJSON()
        if let jsonArray = json["amiibo"] as? [[String: Any]] {
            let amiiboArray = Mapper<Amiibo>().mapArray(JSONArray: jsonArray)
            print(amiiboArray)
        }
    }
}
```

###### Configure basic table view
- Make sure you link the storyboards' table view to the tableView property
- Assign the table view's dataSource to it's View Controller
- On your View Controllers/AmiiboListViewController.swift
```
class AmiiboListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
/*
*/
}

extension AmiiboListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amiibos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AmiiboCell") as! UITableViewCell
        let amiibo = amiibos[indexPath.row]
        
        cell.textLabel?.text = amiibo.name
        if let url = URL(string: amiibo.imageURL) {
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }
        return cell
    }
}
```

###### Make tableview interactive
- First do the same process to assign the table view's dataSource to assign the delegate
- Create a segue (connection between View Controllers) in your storyboard called `AmiiboDetails`
- On your View Controllers/AmiiboListViewController.swift
```
extension AmiiboListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AmiiboDetails", sender: self)
    }
}
```

###### Display selected amiibo information
- First we need to define that the storyboard's View Controller is our AmiiboDetailsViewController.swift file (Can be done so on the right column properties)
- Link UI elements to the View Controller. On your View Controllers/AmiiboDetailsViewController.swift
```
class AmiiboDetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}
```

- Add configuration functions. On your View Controllers/AmiiboDetailsViewController.swift
```
class AmiiboDetailsViewController: UIViewController {
    /*
    */
    
    var amiibo: Amiibo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = amiibo?.name
        seriesLabel.text = amiibo?.series
        characterLabel.text = amiibo?.character
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MM/dd/yyyy hh:mm a")
        dateLabel.text = formatter.string(from: amiibo!.releaseUS)
        if let url = URL(string: amiibo!.imageURL) {
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    func configureWith(amiibo: Amiibo) {
        self.amiibo = amiibo
    }
}
```

- Change segue preparation. On your View Controllers/AmiiboListViewController.swift
```
class AmiiboListViewController: UIViewController {
   /*
   */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? AmiiboDetailsViewController, let indexPath = sender as? IndexPath {
            detailsVC.configureWith(amiibo: amiibos[indexPath.row])
        }
    }
}

//extensions
```

## Where to go after this
- Make a layer of the application to connect with the backend's endpoints instead of using the JSON utility.
- Add items to a cart
