# xcode-group-tests

## Usage

#### Step 1：**Add stage you want to run upon test function**
```swift
import XCTest

class NewAlbumsTest: XCTestCase {
    var myApp: Page!
    var app: XCUIApplication!
    
    override func setUp() {
        self.app = XCUIApplication()
        self.continueAfterFailure = false
    }
    
    // acceptance
    func testCanSwipeLeftNewAlbumsSection() {
        myApp = TestBuilder(app).launch()
        
        myApp.on(view: HomePage.self).swipeLeftToNewAlbum(at: 9)
             .on(view: HomePage.self).checkNewAlbumsHas(number: 10)
    }
    
    // functional
    func testOpenNewAlbumList() {
        myApp = TestBuilder(app).launch()
        
        myApp.on(view: HomePage.self).openNewAlbums()
             .on(view: NewAlbumsPage.self)
    }
}


```
#### Step 2：**Open terminal and cd to you XCUITests folder** 
```shell
$ cd ./UITests/
```
#### Step 3：**Run shell script and enter output folder behind**
```shell
sh ./generateStageToRun.sh output/
```
