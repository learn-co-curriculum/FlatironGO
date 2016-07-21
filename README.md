


## What components make up this iOS app?
*Map, Users Location, Treasures, Camera displaying the treasure*

### Setting up the Map

We launch an iOS app, does everything happen all at once? What code gets run first? Is it all executed at the same time?

First things first, we need to setup our initial view controller. A `ViewController` is provided to us by Apple, it gives us an entry point to execute code of our own **BEFORE** anything is displayed on screen.

![AppLaunch](https://i.imgur.com/xJZdYT7.png)


Well, we can take advantage of this and setup our Map.

That lovely arrow on the left here is setup in `Main.Storyboard`. Here, we're telling Xcode.. "HEY!, this particular View Controller is our initial one.. the one that should be first in line!"

Ok... now what?

Now that our `MapViewController` is the initial view controller, we can get going.

Inheriting from a `UIViewController`, we can override `viewDidLoad()`. `viewDidLoad()` is a function called by our `MapViewController`.

Lets think of `MapViewController` as an individual as a stage-hand. `viewDidLoad()` is the equiavalent of the stage-hand walking up to you stating.. "HEY, we're about to show ourselves to the world (reveal the curtains), is there ANYTHING you need for me to do before we get you out on stage.

Why YES!

First things first... we need a **MAP**

So we call on our function (we implemented) called `setupMapView()`. Don't forget, we are NOT YET on stage (nothing is displayed on screen at this point).

An important line of code is run in this function:

```swift
mapView.delegate = self
```

Self here is an instance of the `MapViewController`, thats US!

When the map is displayed on screen (which it isn't yet, don't get ahead of yourself), who is responding to taps, gestures, swipes, zooms, all that fun stuff? The `mapView` is handling all of that for us... but who is RESPONDING to it? Do we need to respond to it?

We don't have to. This is known as the delegate pattern, you can think of it as a parent-child relationship. The child is screaming up to its parent that it wasnts candy... does the parent need to respond? YES.

Here, the parent is US (the `MapViewController`), the child is the `mapView`. So when a user drags, pinches and taps something on our `mapView`, the `mapView` is screaming up to its parent.. "HEY SOMEONE PINCHED ME!" and it sends that message to its parent (its parent in this scenario is the `MapViewController`.

Ok.. our `mapView` seems to be setup.. but it's not yet on screen, our stage-hand isn't done doing its thing, we still have more instructions for him. His name is Fred.



---

### Setting up Current Location

So the `setupMapView()` function call is done doing its thing and now our stage-hand is out of breath.. but we have more instructions.

Next, we call on this function `setupCurrentLocation()`, we tell it to do something else!

In grabbing the users current location, we have to play nice.. we have to ask the current user of our app if we can see where they are?

After the user says "YES, I'll glady show you where I am", we store the coordinates of the users current location on the `MapViewController`. Think of the various properties on the `MapViewController` as these things we can carry along in our back-pack that are available to us at all times. Now that we stored the users current location, we can pull it out of our back-pack whenever we need to.. its ours to hold onto forever.

I'm pretty sure our stage-hand **hates** us as this point.. but we have even MORE tasks for Fred.

Fred has done good (so far). As of right now, we have Map in one hand and a users location in the other hand.. but we haven't done naything with them (we're not on stage yet! The user still doesn't see anything.

By the way, computers are fast.. really fast, so you can imagine Fred getting this done in less than a second.


---

### Treasures!

Next order of business for our stage-hand is to get the treasures, so we call on this method:

```swift
getTreasuresFor(userStartLocation) { result in
     //TODO: Handle failure
}
```

Ok.. so this is a weird looking piece of code. In programming, tasks can be done asynchronously. Fred can do more than one thing at a time.. He can make a phone call while he's running around doing stuff for us.

So while this function gets called, he tells us to get on stage!!! Why? Because the `viewDidLoad()` function has ended, there are no other tasks to be done. The `getTreasuresFor(_:)` function isn't done though.. so how can `viewDidLoad()` be done? That' show asynchornous code works, it's doing it's own thing and tells the main part of your code to carry on doing what it's doing.

Ok.. we're on stage... our users can NOW SEE US. They see a map, they see our current location.. but within the bilnk of an eye (almost hard to even tell), our treasure icons show up. Lets talk about that.

Stepping through the `getTreasuresFor(_:)` function using our story.
We've asked Fred to make a phone call to get some info. Our info lives on the server somewhere (Firebase!). 

We're telling him to make a phone call to firebase asking the following (with the info we now have). Here's how his phone call will go..

"Hello, this is Fred! .. and I have this location (latitude and longitude), can you do me a favor and give to me all the treasure within a 10.0 mile radius of this location?"

.. firebase might take a few seconds, but probably even less because it's VERY FAST.

Firebase responds..and gives us back a `String`. It represents a Key... well what good is a key? We can open doors I guess.

Well, we're able to take this `Key` which corresponds to a Treasure stored in Firebase. So. what happens is, Fred having wrote doesn't this particular `Key` has to make another phone call to someone else in Firebase. When Firebase answers, Fred provides this individual with the `Key`, and states... "I have this `String` value which represents a `Key`, i need you to lookup in your database the `Treasure` that lies behind the door this `Key` will open.

Firebase... again operating super fast will take the `Key`, find the door associated with key, open the door and return the contents back to Fred.

After Fred does this for each `Key` received, which in our demo is 5... he has 5 treasure objects in his hand.

He **RUNS** back to us to let us know that he has the 5 treasure objects.

These treasure objects have a latitude and longitude property associated with them.. we take that info and display treasure icons on the map at these various locations.

---

### Segue

We have a **Map**, we have our users **Location** and we have our **Treasure** icons displayed on the map. If you remember from my earlier point, the `MapViewController` is the delegate of the `mapView`. This means that we respond to anything that happens with it.

If our `mapView` cries up.. "HEY I'VE BEEN PINCHED!", we can respond to that cry.

So if someone taps on an annotation on the map (our treasure icons), then we can respond to that!

```swift
func mapView(mapView: MGLMapView, didSelectAnnotationView annotationView: MGLAnnotationView) {
     handleTapOfAnnotationView(annotationView)
}
```

This is the function that the `mapView` calls which we implement on our `MapViewController`. This is us responding to the child crying because they were pinched.

In our implementation of the `handleTapOfAnnotationView()` function call, we then move forward to an entirely **NEW** View Controller. In the `prepareForSegue(_:sender:)` function, we can pass forward the treasure object that was tapped. Sort of like handing the baton forward.

---

# AR Component

![Bull](http://i.imgur.com/hvYIBsb.png)

* When the `treasure` annotation is tapped on the Map, we are presenting a new `UIViewController` - the `ViewController.swift` file. 
* We know based upon what annotation was tapped, what `treasure` object should be transferred forward to display in our camera preview.
* So.. now that we know what `treasure` to display, what steps do we need to take to get this `image` displayed on screen?
* In my `ViewController`, when the `view` appears,  I'm calling on the following function,`setupMainComponents()`. Following is a walkthrough of the implementation of these various methods. Feel free to follow along with the Xcode project open.

```swift
private func setupMainComponents() {
    setupCaptureCameraDevice()
    setupPreviewLayer()
    setupMotionManager()
    setupGestureRecognizer()
    setupDismissButton()
}
```

### **1** - Setup our AVCaptureSession & tell it to start running

The `captureSession` used here is initialized in the declaration of the property on the `ViewController`

```swift
let captureSession = AVCaptureSession()
```

The `cameraDeviceInput` is an instance of `AVCaptureDeviceInput`. Checking first that we can add the `cameraDeviceInput` to the session we then move forward by adding the `cameraDeviceInput` to the `captureSession`. That's a mouth full, and if you want to know more of what's going on here - I recommend option clicking the various types of these objects and reading through the documentation. 

In short, this setups our camera and tell it to begin running!
```swift
let cameraDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
let cameraDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice)
guard let camera = cameraDeviceInput where captureSession.canAddInput(camera) else { return }
captureSession.addInput(cameraDeviceInput)
captureSession.startRunning() 
```
---

### **2** - Setup the Preview Layer

The `previewLayer` is a property on the `ViewController`. It's an instance of `AVCaptureVideoPreviewLayer`. 

![PreviewLayer](https://i.imgur.com/0k76NAV.png)

We are first initializing it, then settings it's frame to equal the view's bounds (it will fill the entire screen). If the treasure object we were handed from the previous MapViewController's image is not nil, then we will move forward!

The item property on `treasure` is of type `CALayer`. See the `Treasure.swift` file for how this is created. We position it so it's within view when the preview layer launches.

We then add this `previewLayer` to the `view`.

We should now see our treasure on screen!


```swift
previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
previewLayer.frame = view.bounds
        
if treasure.image != nil {
    let height = treasure.image!.size.height
    let width = treasure.image!.size.height
    treasure.item.bounds = CGRectMake(100.0, 100.0, width, height)
    treasure.item.position = CGPointMake(view.bounds.size.height / 2, view.bounds.size.width / 2)
    previewLayer.addSublayer(treasure.item)
    view.layer.addSublayer(previewLayer)
}
 ```
---


### **3** - Setup the Motion Manager

The `motionManager` is a property on the `ViewController` which is initialized within the declaration of the property like so:
```swift
let motionManager = CMMotionManager()
```

In the implementation of the block of code passed into the `startDeviceMotionUpdatesToQueue` function call, we have a `motion` object we can work with of type `CMDeviceMotion`.

```swift
if motionManager.deviceMotionAvailable && motionManager.accelerometerAvailable {
      motionManager.deviceMotionUpdateInterval = 2.0 / 60.0
      motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!) { [unowned self] motion, error in
                
          if error != nil { print("wtf. \(error)"); return }
          guard let motion = motion else { print("Couldn't unwrap motion"); return }
                
          self.quaternionX = motion.attitude.quaternion.x
          self.quaternionY = motion.attitude.quaternion.y
     }
}
```

![motion](http://i.imgur.com/n25qC0B.png)

This is getting called continuously as the iPhone is moving and there are *MANY* properties on this object to take advantage of. For now, we're utilizing the `quaternion.x` and `quaternion.y` values to update our `quaternionX` and `quaternionY` properties on our `ViewController`. 

This is being done, because we have `didSet` observers on theses properties which will in turn update our `treasure` object on screen (to make it appear as if it's moving with you in real time).

Here is what those `disSet` observers look like:

```swift
var quaternionX: Double = 0.0 {
    didSet {
        if !foundTreasure { treasure.item.center.y = (CGFloat(quaternionX) * view.bounds.size.width - 180) * 4.0 }
     }
}

var quaternionY: Double = 0.0 {
    didSet {
        if !foundTreasure { treasure.item.center.x = (CGFloat(quaternionY) * view.bounds.size.height + 100) * 4.0 }
     }
}
```

---

### **4** - Setting up our Gesture Recognizer

We want to know when a user taps on the screen.. simple enough!

```swift
let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
gestureRecognizer.cancelsTouchesInView = false
view.addGestureRecognizer(gestureRecognizer)
```
When a tap comes in, the `viewTapped()` method is called. One of the arguments to this method calld `gesture` is of type `UITapGestureRecognizer`. Through this object, we are able to tell where the tap occurred within the `view` and check it against where the `treasure` object is to see if their tap is within range of where the item is.

```swift
func viewTapped(gesture: UITapGestureRecognizer) {
 	  let location = gesture.locationInView(view)
      // See the Xcode project for how this was implemented 
}
```

---

Check out the Xcode project to see how the spring animations were created after tapping the treasure object on screen.

![bear](http://i.imgur.com/nAwylOw.png)

---


---

# Firebase & Geofire Component

```swift
let geofireRef = FIRDatabase.database().referenceWithPath(FIRReferencePath.treasureLocations)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let geoQuery = geoFire.queryAtLocation(location, withRadius: 10.0)
```

* We get a hold of our firebase reference.
* Query up using GeoFire using the users current location.
* In our callback, we receive multiple "Treasure" objects" which we parse through.
* Receiving the coordinates of these "Treasure Objects", we create annotations and place them on the map. These annotations are selectable.


* Our firebase database (Firebase):

![http://i.imgur.com/u8UxY6X.png?1](http://i.imgur.com/u8UxY6X.png?1)

---


# Custom Map w/ MapBox

* Utilizing [MapBox](https://www.mapbox.com/ios-sdk/api/3.3.0/) which allows us to easitly create a custom looking map (like the one being used in the app).
* Through [MapBox](https://www.mapbox.com/ios-sdk/api/3.3.0/), we're creating the custom treasure annotation.
* Our map is customized through the various delegate methods available to us.
* Setting up the Map View which is then added tou our `view`

```swift
mapView = MGLMapView(frame: view.bounds,
                                 styleURL: NSURL(string: "mapbox://styles/ianrahman/ciqodpgxe000681nm8xi1u1o9"))
```

---

