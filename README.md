# Flatiron Go - iOS Application



[![](http://img.youtube.com/vi/ggv31MfTPBo/0.jpg)](https://www.youtube.com/watch?v=ggv31MfTPBo "Intro")




![](https://media.giphy.com/media/3o7TKyqT3OioraCvLi/giphy.gif)

Pokemon GO is the biggest US mobile game ever--that's quite an accomplishment. There are various components within the game which help drive its appeal (including Pokemon is obviously one of them). We will cover some of these components in this tutorial to help you implement your own iOS app. 

The idea that we can walk around with Pokemon amongst us and be able to catch them is a great concept. When attempting to catch the various Pokemon, it appears as if they're right in front of us as we move our mobile device around--which is awesome!

We created an iOS app that isn't about Pokemon. It's about various treasures that are placed throughout NYC (right now, it's just 4 treasures in downtown Manhattan). When a user taps on one of these treasure icons, they are brought to a screen which displays the contents of that treasure. Similar to Pokemon GO--the contents of this treasure will display on screen with your camera activated. As you move the iPhone around, it will appear as if this treasure is right in front of you.

You will be able to "catch" this treasure by tapping on it when it's in front of you.

To provide you with a bit of a challenge/code-along, you can download the necessary Xcode project [here](https://s3.amazonaws.com/learn-verified/FIS-Go-Project.zip).

In this project file, we've already set up the Map and Treasures for you. If you were to run the app on your iPhone, you will find that the map comes up, it displays some treasures and you're even able to tap these treasure icons. But when doing so, you'll notice that we're brought to a black screen.

This is where you come in.

![](https://media.giphy.com/media/l0HlPsJnWAOUGc74I/giphy.gif)

Going through the "Setting up Augmented Reality" section below, you can code-along and build out this functionality to create the AR portion of our iOS app. It was fun building this as I imagine it will be fun for you to code-along. I wish you luck on your journey and hope that you're able to execute on the app idea you have in mind that involves these various concepts!

Download the Xcode project to be used throughout this tutorial [here](https://s3.amazonaws.com/learn-verified/FIS-Go-Project.zip).

Make sure to open the `FlatironGo.xcworkspace` file after downloading the Xcode Project to begin working!

**iOS**: 9.3  
**Xcode**: 7.3.1

As well, you will find the "Setting up our database and our map view:" portion. If you have the desire to implement maps, database and storage yourself you can follow along with that portion of the tutorial to get something up and running in your own iOS app! The project which implements Firebase can be found [here](https://github.com/learn-co-curriculum/FlatironGO/tree/WorkingProject).



---

The various components of this demo app consist of using:

[AVFoundation](https://developer.apple.com/av-foundation/), [CoreMotion](https://developer.apple.com/library/ios/documentation/CoreMotion/Reference/CoreMotion_Reference/), [UIKit](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIKit_Framework/), [Firebase](https://www.firebase.com), [GeoFire](https://github.com/firebase/geofire-objc), [Mapbox](https://www.mapbox.com/ios-sdk/)


# Contents

### Setting up Augmented Reality:

* [Augmented Reality](#augmented-reality)
* [Brief Overview](#brief-overview)
* [Camera Device](#setupcapturecameradevice)
* [Preview Layer](#setuppreviewlayer)
* [Motion Manager](#setupmotionmanager)
* [Gesture Recognizer](#setupgesturerecognizer)
* [Bloopers](#bloopers)

### Setting up our database and our map view:

* [Firebase](#firebase) 
* [Maps](#map)
* [Maps, part 2](#back-to-maps)
* [Treasures](#treasures)
* [Maps & Treasures](#maps-and-treasure)
* [Users Current Location](#users-current-location)
* [Map View Delegate](#map-view-delegate)
* [Tapping the treasure icon](#tapping-the-treasure-icon)
* [Constants file](#constants-file)


![](https://i.imgur.com/iH0HDpt.png)

![](https://i.imgur.com/wKJBOh1.png) 




---

# Augmented Reality


![OtherBear](https://i.imgur.com/jWZDeRy.pngF)

Navigate to the `ViewController.swift` file. How do we ultimately wind up at our instance of `ViewController` which now is just a black screen. When a treasure icon is tapped from the `MapViewController`, we segue over to an instance of `ViewController`. In the `prepareForSegue(_:sender:)` method on the `MapViewController`, we're able to get a hold of the instance of the `ViewController` through the `segue`'s `destinationViewController` property. This segue connection was made in our `Main.storyboard` file. In that `prepareForSegue(_:sender:)` function on the `MapViewController`, we assigned a value to the following instance property on our `ViewController` (which is the `.destinationViewController`):

```swift
var treasure: Treasure!
```

That way, within our `viewDidLoad()` method on the `ViewController`, we have full access to a `treasure` object. With this `treasure` object, we can go through with the necessary steps to displaying it on screen.

Recap: Our `ViewController` has an instance property called `treasure` of type `Treasure!`. It's an implicitly unwrapped optional, that way it has a default value of `nil` when our `ViewController` is loaded into memory because we don't have access to the `ViewController`'s initializer. Because of that, we can't add a stored property to a subclass of `UIViewController` without providing a default value to it when we define it. By making it an implicitly unwrapped optional, it has a default value of `nil` which solves our problem. We assign it an actual value in the `prepareForSegue(_:sender:)` method on our instance of `MapViewController` through the `segue` argument which is of type `UIStoryboardSegue`. The `segue` object knows where we're going (because we set this up within our `Main.storyboard` file). Through that `segue` object, we get a hold of the instance of our `ViewController`. At that moment, we assign a value to the `treasure` instance property. What value? Well, it has to be of type `Treasure`--it's the `Treasure` instance that was tapped on the map.

We can now move forward. Just like a chef that needs eggs to make an omelette, we've now provided the chef (you) with some eggs (the treasure). 

# Brief Overview
  
* `viewDidLoad()` - Here the view is loaded into memory, we are just changing the `backgroundColor` property on our `view` instance property.
* `viewWillAppear(_:)` - The view is about to appear on screen so we're calling on a method called `setupMainComponents()` which will go through all the necessary steps to getting this AR component to work.
* `setupMainComponents()` - This function calls on the following functions to get everything setup:
	* `setupCaptureCameraDevice()` - Setting up the camera device to put the user in a mode as if they're going to take a picture.
	* `setupPreviewLayer()` - Setting up our image to be displayed on screen.
	* `setupMotionManager()` - Setting up an object that allows us to listen to changes in the device when the user moves the iPhone around.
	* `setupGestureRecognizer()` - Setting up an object that listens for any tap on the screen. We want to see if a user was able to tap the image on screen.
	* `setupDismissButton()` - Setting up a `UIButon` to appear on screen after a user is able to tap the image (this will allow the user to go back to the map).
	

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupMainComponents()
    }
    
    private func setupMainComponents() {
        setupCaptureCameraDevice()
        setupPreviewLayer()
        setupMotionManager()
        setupGestureRecognizer()
        setupDismissButton()
    }
```

Without discussing exactly what these various instance properties do yet, I would ask that you include them above the `viewDidLoad()` method for now as they will be used throughout these various methods. Some of them are already provided for you in the `ViewController.swift` file.

```swift
    let captureSession = AVCaptureSession()
    let motionManager = CMMotionManager()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var treasure: Treasure!
    var foundImageView: UIImageView!
    var dismissButton: UIButton!
    var foundTreasure = false

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

# setupCaptureCameraDevice

What we will be creating:

```swift
// MARK: - AVFoundation Methods
extension ViewController {
    
    private func setupCaptureCameraDevice() {
        let cameraDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let cameraDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice)
        guard let camera = cameraDeviceInput where captureSession.canAddInput(camera) else { return }
        captureSession.addInput(camera)
        captureSession.startRunning()
    }
        
}
```

**1** - Create an extension on the `ViewController`, adding a `// MARK: - ` above the extension labeled AVFoundation Methods
  
**2** - Within this extension, create a function named `setupCaptureCameraDevice()`. This method will take in no arguments and return no values. In our implementation we want to do the following:  

Create a constant called `cameraDevice` and assign it the return value of the following function call - `AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)`. This `defaultDeviceWithMediaType(_:)` type method on the `AVCaptureDevice` type, when passing in the `AVMediaTypeVideo` `String` constant to it, will return back to us the built in camera on our iPhone. This is great--we can now work with this camera (but do so in a way that simulates Pokemon GO, the user isn't going to be using this camera in the traditional sense). 


Create a constant called `cameraDeviceInput` and assign it the return value of the call to `try? AVCaptureDeviceInput(device: cameraDevice)`. The initializer we're calling on `AVCaptureDeviceInput` can fail, which is why we use the `try?` keyword here. We're not handling any error this might throw (something we should look to do if we want to release this app). This `init` function takes in an argument of type `AVCaptureDevice` which matches up with the type of our `cameraDevice` constant we just created. This initializer will create an instance of `AVCaptureDeviceInput` which will be used to capture data from an `AVCaptureDevice` instance (which is what our `cameraDevice` constant is). This particular function will open up our device for capture--which is awesome! We got hold of our camera, we've now made an attempt to open it and read its data.

Because our creation of the `cameraDeviceInput` constant might be nil, we need to check to see that `cameraDeviceInput` is not nil. We do that here by using the `guard` statement. Not only do we want to make sure the `cameraDeviceInput` is not nil, we want to make sure we can add it as input to our `captureSession` (quick note: `captureSession` is of type `AVCaptureSession` and we've assigned this instance property a default value above our `viewDidLoad()` function--this object handles the various inputs and outputs from the camera). There's a method on our `captureSession` instance property which allows us to check that we can indeed add this `cameraDeviceInput` as input. If all is OK, `camera` is a constant which is assigned the value of `cameraDeviceInput` if it's not `nil`.


Next we want to call on the `addInput(_:)` method available to instances of `AVCaptureSession`. So we call on the `addInput(_:)` method on our `captureSession` instance property passing in the `camera` instance.


Lastly, we call `startRunning()` on our `captureSession` instance property. This begins the flow of data from inputs to outputs connected to our `AvCaptureSession` instance. We are not handling any errors that might come of this `startRunning()` method which is something we should look into if we were to release this app.


# setupPreviewLayer

What we will be creating:

```swift
// MARK: - AVFoundation Methods
extension ViewController {
    
    private func setupCaptureCameraDevice() {
        let cameraDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let cameraDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice)
        guard let camera = cameraDeviceInput where captureSession.canAddInput(camera) else { return }
        captureSession.addInput(cameraDeviceInput)
        captureSession.startRunning()
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        
        let height = treasure.image!.size.height
        let width = treasure.image!.size.height
        treasure.item.bounds = CGRectMake(100.0, 100.0, width, height)
        treasure.item.position = CGPointMake(view.bounds.size.height / 2, view.bounds.size.width / 2)
        previewLayer.addSublayer(treasure.item)
        view.layer.addSublayer(previewLayer)
    }
    
}
```

We're not creating a new extension here. We're adding to the one we had created in the previous step. We're creating a new method we're adding below the `setupCaptureCameraDevice()` method.

**1** - Create a function named `setupPreviewLayer()` which takes in no arguments and returns no values.

Before we dive into any code, lets quickly talk about this `previewLayer` instance property were about to use.

Above our `viewDidLoad()`, we have an instance property

```swift
var previewLayer: AVCaptureVideoPreviewLayer!
```

The `AVCaptureVideoPreviewLayer` class  is a sublcass of `CALayer`. It means we gain all the functionality available to us with a `CALayer` object. This layer instance can be initialized with a Capture Session. This means that when we hand over to it a capture session, this layer is previewing (or showing to our user) the camera input as that is what the captures session is in charge of.

Considering our `previewLayer` right now has the default value of `nil`--because it's an implicitly unwrapped optional, we want to assign it an actual value now.

In assigning it a value, we call on the `AVCaptureVidePreviewLayer` initializer which takes in a session as an argument. We have a `captureSession` all setup ready to be passed into this initializer--so that's what we do!

After doing so, we setup our `previewLayer` to fit the entire screen by having the frame equal the `view`'s bounds.

Next, we begin to setup the positioning of an instance property on our `treasure` object called `item`. What is this?

```swift
var item = CALayer()
```

Hey look! Another `CALayer` object. Our images (stored locally) are of type `UIImage`. But we can't add a `UIImage` to a `CALayer`--which is our ultimate goal here. How do we then turn a `UIImage` into a `CALayer` object which will allow us to add our lovely images to the `previewLayer`? If you were to do some digging into the `Treasure.swift` file to check out its implementation you will notice the following method:

```swift
    func createItem() {
        guard let image = image else {print("fix this later"); return }
        item.contents = image.CGImage
    }
```

This is called (not by you) in our `MapViewController.swift` file when we setup our dummy data to be used within this demo. But the line of code most interesting is:

```swift
item.contents = image.CGImage
```

Taking the `CGImage` computed property on our `UIImage` instance (called `image` here), we're storing that return value to the `contents` instance property available on our `item` property. This allows us to display our image within a `CALayer` now using this `item` instance property!


This is why we're adding `treasure.item` to the `previewLayer` in the function `addSublayer(_:)`. After we do that, we need to now add the `previewLayer` object to our `view`'s `layer` property in the `addSublayer(_:)` method.

We are almost there!!


# setupMotionManager

What we will be creating:

```swift
// MARK: - Detect Movements
extension ViewController {
    
    private func setupMotionManager() {
        
        if motionManager.deviceMotionAvailable && motionManager.accelerometerAvailable {
            motionManager.deviceMotionUpdateInterval = 2.0 / 60.0
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!) { [unowned self] motion, error in
                
                if error != nil { print("wtf. \(error)"); return }
                guard let motion = motion else { print("Couldn't unwrap motion"); return }
                
                self.quaternionX = motion.attitude.quaternion.x
                self.quaternionY = motion.attitude.quaternion.y
            }
        }
    }
}
```

**1** - Create another extension on the `ViewController` marking it with a comment like above.

**2** - Within that extension, lets create a method called `setupMotionManager()` which takes in no arguments and returns no values.

Looking above our `viewDidLoad()` function, you will see that I asked you to copy/paste in this piece of code:

```swift
let motionManager = CMMotionManager()
```

We're calling on the default initializer on `CMMotionManager` here which will assign a default value to the `motionManager` instance property.

This `CMMotionManager` class will allow us to detect movements within our device.
But we're not going to be utilizing all of it's functionality here, there's a lot to work with. I suggest digging into the documentation to see what you have available to you, it's pretty cool stuff.

Within our `setupMotionManager()` method, before we start setting any properties on our `motionManager` object, we want to make sure that we're able to do so with the following line of code:

```swift
        if motionManager.deviceMotionAvailable && motionManager.accelerometerAvailable {
        
        }
```

If the device motion and accelerometer is available, we will then enter this if statement and begin to setup our `motionManager`.

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
    }
```
I've setup an interval here which  will determine how often the following block of code will be run. Imagine you're a kid in the back seat of a car and your Mom is doing her best driving you to Florida for vacation and you continue to nag her over and over and over again. This determines how often and at what interval we will nag Mom for (forever!) until we tell it to stop.  This interval is in seconds.

`startDeviceMotionUpdatesToQueue(_:withHandler:)` method is then called on our `motionManager` object. It takes in two arguments.

First argument is of type `NSOperationQueue`. So we provide it with an instance of `NSOperationQueue`--the currentQueue which is a type method available on the `NSOperationQueue` class which will return back to us the current queue. As this type method returns back to us an optional `NSOperationQueue`, we're force-unwrapping it because the method we're passing this along to requires that we give it an `NSOperationQueue` not a `NSOperationQueue?`. Force-unwrapping isn't the best approach here, we should handle this properly if this winds up returning `nil`. By not handling the `nil` case--we could have a run-time error where our app crashes if indeed it returns `nil`.

Second argument to this function is of type `(CMDeviceMotion?, NSError?) -> Void`. What is that? Well, it means we have to provide it with a function (without a name) that takes in two arguments itself, the first argument being of type `CMDeviceMotion?`, the second argument being of type `NSError?`--this function will return nothing. OK, how do we pass a function to another function? We can do this using closure expression syntax. Our `motion` constant here is of type `CMDeviceMotion?`. This particular object brings with it an _incredible_ amount of functionality, we will only be using one piece of what this object brings to the table.

![](https://s3.amazonaws.com/learn-verified/FISGoSS.png)

So here we are providing the implementation of a function, passing it along to another function which will use it whenever it likes. But when does our implementation here get called? How often does it get called?

Take a look at the code I highlighted below. The highlighted code is our implementation. This gets called by the `startDeviceMotionUpdatesToQueue(_:withHandler:)` method. We're handing it over to this method and it will do with it as it pleases (and it does). It will call on this function a lot.. but how often? How often it calls on this function is dictated by the `deviceMotionUpdateInterval` property we set in the line of code above this which we set to 2.0 / 60.0. 30 times a second it will call on this block of code passing it a new `motion` object every single time.

![](https://s3.amazonaws.com/learn-verified/FISGoCodeBlock.png)

So if this block of code gets called that often, and each time we're given this `motion` object--what can we do with it? Well.. we will want to read the `attitude.quaternion.x` and `attitude.quaternion.y` properties on it and update our own instance property on our `ViewController` to follow along with what's going on here.


First we check to see if error is not nil, meaning.. there is an error and something went wrong! so lets not move forward. We should handle errors better than that here, but lets carry on.

Considering the first argument to this function is of type `CMDeviceMotion?` it means it can be nil, it's an optional `CMDeviceMotion`. So we use the guard statement to make sure it's not nil and move forward. 

`CMDeviceMotion` has an incredible amount of instance properties available to it. In this scenario (through some trial & error), I found that the best one to move the image around as I moved the iPhone was 
`attitude`. This `attitude` instance property is of type `CMAttitude` which itself has a property called `quaternion` which we will be utilizing. The `quaternion` property returns a `quaternion` representing the device's attitude.

The properties available on `CMQuaternion` object are the following:

```swift
    public var x: Double
    public var y: Double
    public var z: Double
    public var w: Double
```

We're most concerned with the `x` and `y` values only (for this demo) which will help us determine how the person is moving their iPhone around.

The type of `x` and `y` here are of type `Double` which matches our `quaternionX` & `quaternionY` instance properties on the `ViewController`, so lets assign these values to those properties like so:

```swift
self.quaternionX = motion.attitude.quaternion.x
self.quaternionY = motion.attitude.quaternion.y
```

This block of code is getting called over and over and over again until we tell it stop. So it's constantly passing through a new `motion` object which has these properties available to it which we're reading and assigning to our own instance property on the `ViewController`. If we were to add `print()` statements within this block of code, we would see it being called a lot (and fast). 

Ok, so we're setting a value to an instance property on our `ViewController`, lets take a look at those instance properties:


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

We setup `didSet` observers on both of these instance properties. So every time we assign a value to them (which we do often), the piece of code in that `didSet` block will get run (which again, will happen often). So what's happening in those `didSet` blocks:

```swift
if !foundTreasure { 
	treasure.item.center.y = (CGFloat(quaternionX) * view.bounds.size.width - 180) * 4.0 
}

if !foundTreasure { 
	treasure.item.center.x = (CGFloat(quaternionY) * view.bounds.size.height + 100) * 4.0 }
}
```

We are moving the `treasure ` object around the screen dependent on the new values produced by whats on the other side of the equal sign. The math used here was done to simulate a slight movement to the object so it didn't appear static on the screen. I would argue that this might not be the best approach but it's an approach that got this working to how I liked. 

We move the iPhone around and we have a slight bounce / movement to the treasure object to make it appear somewhat real-life like.

`foundTreasure` is an instance property of type `Bool` on our `ViewController`. This instance property is only set to `true` when someone actually taps on the image displayed on screen (something we do in the `setupGestureRecognizer()` method below). When someone does "catch" this image on screen by tapping it, I want to center the image and stop it from moving around, so I don't want it to update it's values based upon the new `quaternionX` and `quaternionY` values. You might ask.. well why don't you just stop the `motionManager` from doing its thing, then it won't update these values. Well.. you're right! I am doing that though (which you will implement below), this was just a way of really making sure the image stops moving as soon as its tapped.

That should be everything to get this image displayed on screen where when you move your iPhone around it should move with you!

[![](http://img.youtube.com/vi/LWEKbr1Lisw/0.jpg)](https://www.youtube.com/watch?v=LWEKbr1Lisw "Middle")

# setupGestureRecognizer

Here is what we will be creating here:

```swift
// MARK: - Gesture Recognizer Methods
extension ViewController {
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func viewTapped(gesture: UITapGestureRecognizer) {
        let location = gesture.locationInView(view)
        
        let topLeftX = Int(treasure.item.origin.x)
        let topRightX = topLeftX + Int(treasure.item.width)
        let topLeftY = Int(treasure.item.origin.y)
        let bottomLeftY = topLeftY + Int(treasure.item.height)
        
        guard topLeftX < topRightX && topLeftX < bottomLeftY else { return }
        
        let xRange = topLeftX...topRightX
        let yRange = topLeftY...bottomLeftY
        
        checkForRange(xRange, yRange, withLocation: location)
    }
    
    private func checkForRange(xRange: Range<Int>, _ yRange: Range<Int>, withLocation location: CGPoint) {
        guard foundTreasure == false else { return }
        
        let tapIsInRange = xRange.contains(Int(location.x)) && yRange.contains(Int(location.y))
        
        if tapIsInRange {
            
            foundTreasure = true
            motionManager.stopDeviceMotionUpdates()
            captureSession.stopRunning()
            
            treasure.item.springToMiddle(withDuration: 1.5, damping: 9, inView: view)
            treasure.item.centerInView(view)
            
            previewLayer.fadeOutWithDuration(1.0)
            
            animateInTreasure()
            animateInDismissButton()
            displayNameOfTreasure()
            displayDiscoverLabel()
            
        }
    }
}
```

Ultimately, we want to setup our gesture recognizer object where the target is `self`. `self` being the current instance of the `ViewController`. This `gestureRecognizer` will call on the `viewTapped(_:)` method when tapped. 

In the implementation of `viewTapped(_:)`, we will look to see through the `gesture` argument, where the user tapped within the `view` through the `locationInView(_:)` method available on any instance of `UIGestureRecognizer` which is what `gesture` is.

After that, we're creating a range of where the `treasure` lives on screen (at this current moment of the tap) and passing those ranges and the tap location to another helper function we made which will check to see if that tap falls within that range.

If the tap falls within range, we call on our various helper functions here to perform the various animations. These helper functions were created for you to make your life much easier with regards to the animations. Feel free to step through these methods to see how they were implemented and what's going on.


# Congrats, you did it!

![](https://media.giphy.com/media/f31DK1KpGsyMU/giphy.gif)

![](https://media.giphy.com/media/3o6gEbd93QQIt61us8/giphy.gif)

![](https://media.giphy.com/media/yhfTY8JL1wIAE/giphy.gif)


[![](http://img.youtube.com/vi/deogww1OOR8/0.jpg)](https://www.youtube.com/watch?v=deogww1OOR8 "End")

---

# Bloopers

Puttinng this entire tutorial together has been so much fun. The idea for this particaulr app came from Avi Flombaum who has been such a great inspiration. The iOS team here at Flatiron School has grouped together to make this app happen--you're all awesome.

Enjoy this bloopers video--mistakes were made.

[![](http://img.youtube.com/vi/2mhObSKoeE/0.jpg)](https://www.youtube.com/watch?v=2mhObSKoeE "Middle")

---

# Steps Moving Forward. Building Out Maps & Firebase yourself.

# Firebase 

Setup a [Firebase](https://www.firebase.com) account. We will be utilizing the database & storage that a firebase account can provide. Get your XCode project up and running with firebase.

We installed Firebase into our Xcode project using Cocoapods. This isn't all the contents of our `Podfile`, just the portion that relates to Firebase.

```swift
pod 'Firebase'
pod 'Firebase/Database'
pod 'Firebase/Storage'
```

The [iOS guide](https://www.firebase.com/docs/ios/guide/) provided by firebase to setup your Xcode project is incredible. I highly recommend going through each step they provide in getting your project setup as opposed to winging it.

# Map

Open up your `Podfile`. 

Add the following lines to your `Podfile` underneath where it states **#Pods for ABC** (ABC being the name of your project).

```swift
pod 'GeoFire', :git => 'https://github.com/firebase/geofire-objc.git'
pod 'Mapbox-iOS-SDK', '~> 3.3'
```

We will be going into exactly what these two frameworks provide shortly. For now, I want to get your enviornment setup.

After you added that to your `Podfile`, go ahead and type in `pod install` within your Terminal. Make sure that you're within your directory when typing `pod install`, otherwise nothing will happen.

Lets create our `MapViewController.swift` file. This will be the entry point to our app. Hit File --> New  --> File then underneath the iOS section, highlight Source then highlight the Cocoa Touch Class option. Then click Next.

We want to make sure the Subclass of: option is set to `UIViewController`. The Language should be `Swift` and "Also create XIB file" should be unchecked. The Class: will be the name of our file so name it `MapViewController`. After doing so click Next. Like any new file you're creating, it should be associated with the Target you intend to write code for. In our case, we're interested in our Main Target (not any test target). So make sure that's checked (which should be by default), then click Create. 

Locate your `MapViewController.swift` file in the Project navigator. Remove the unnecessary code to where your file looks just like this (you can keep those comments at the top):

```swift
import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
```

Locate the `Main.storyboard` file in your project navigator. Locate that first View Controller Scene you see there. We need to select that scene and change the Custom Class of that View Controller to our `MapViewController`. Like so:

![](http://i.imgur.com/1nczYco.png?1)

Now head on back to the `MapViewController.swift` file, we're going to be setting up our various components programmatically.

Above the `viewDidLoad()` method, we will want to create an instance property. It will be a variable called `mapView` of type `MGLMapView!`. In order to use this `MGLMapView` type, you will first need to import `MapBox` at the top of the file here. If you don't see `Mapbox` auto-completing when you try to import it, hit command + b to compile your project. At this point, you should be able to import Mapbox.

```swift
var mapView: MGLMapView!
```

Within the `MapViewController.swift` file, below the last curly brace that encompasses our `MapViewController` class, we will want to create an extension on the `MapViewController` and create the following methods within that extension, like so:

```swift
// MARK: - Map View Methods
extension MapViewController {
    
    private func setupMapView() {
        mapView = MGLMapView(frame: view.bounds, styleURL: NSURL(string: "mapbox://styles/ianrahman/ciqodpgxe000681nm8xi1u1o9"))
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.delegate = self
        mapView.userTrackingMode = .Follow
        mapView.pitchEnabled = true
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        mapView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        mapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        mapView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
    }
    
}
```

We're creating this method here which will be available to any instance of the `MapViewController`. `setupMapView()`. The `setupMapView()` instance method initializes a `MGLMapView` and assigns this instance to our `mapView` property, that way we can utilize it throughout our application. We're adding it to our `view` and having it fit the entire screen.

Now head back to the `viewDidLoad()` method. We should add the following methods we just created to it.

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
```

Our `viewDidLoad()` function now does its thing by first calling on `super.viewDidLoad()` then proceeds to call on `setupMapView()` which creates that pretty map then adds it to our `view`.

# Users Current Location

Above `viewDidLoad()`, we need to add two more instance properties to our class. One will be a variable named `locationManager` which will be of type `CLLocationManager`. This is what it sounds like, it will act as our manager allowing us to see what the users current location is. The other instance property will be a variable called `userStartLocation` of type `CLLocation`. These two instance properties have been assigned a default value. We've used initializer syntax to provide default values to both of these instance properties.

```swift
var locationManager = CLLocationManager()
var userStartLocation = CLLocation()
```

Getting the users current location isn't that easy.

Below the extension we made which related to the Map View Methods, we will create another extension which deals solely with the users current location.

```swift
// MARK: - Current Location Methods
extension MapViewController: CLLocationManagerDelegate {
    
    func getUserLocation() -> CLLocation? {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        let weHaveAuthorization = (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways)
        
        if weHaveAuthorization { return locationManager.location } else { return nil }
    }
    
    private func setupCurrentLocation() {
        if let location = getUserLocation() {
            userStartLocation = location
        }
    }
    
}
```

We've setup two functions. One called `getUserLocation()` which takes in no arguments but returns back a `CLLocation?`. The other called `setupCurrentLocation()` which will call on this `getUserLocation()` function and store the return value of `getUserLocation()` to the `userStartLocation` instance property if the value returned isn't nil.

Before we head back up to the `viewDidLoad()` function to add our new methods we made to it, there's one more thing we need to do.

Head over to the Map View Methods extension we made earlier. Below the `setupMapView()` function we created and implemented, add this method.

```swift
private func setCenterCoordinateOnMapView() {
        mapView.setCenterCoordinate(userStartLocation.coordinate, zoomLevel: 15, direction: 150, animated: false)
    }
```

When we call on this particular function, it will utilize the users current location and center the map on that particular point.

Heading back to the `viewDidLoad()` function, it should now look like this (after you add the necessary functions):

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupCurrentLocation()
        setCenterCoordinateOnMapView()
    }
```

Stepping through this, it will first call on `super.viewDidLoad()` then call on the functions we provided. It will setup the Map View, grab the users current location then center coordinate of the map on that users location.

# Treasures

Create a new `Treasure.swift` file with the following contents.

[Treasure.swift](https://github.com/learn-co-curriculum/FlatironGO/blob/master/FlatironGo/Treasure.swift)

An instance of `Treasure` is made up of various properties and methods. It has a `location`, `name` and `item` which are most important. The `item` instance property will come into use later when we get to the Augmented Reality portion. The `Treasure` instance will be able to download its own image as well as create the `item` which is of type `CALayer` when it's required later. Any logic or functionality associated with a treasure object is done here in our implementation of the `Treasure` class to keeps things very simple for us.


# Back to Maps

Head back to the `MapViewController.swift` file. Lets create another extension, labeling it as "Treasure Methods"

```swift
// MARK: - Treasure Methods
extension MapViewController {
     
}
```

Our treasures are stored in Firebase as JSON. What does that mean?

![](http://i.imgur.com/tkIdqmr.png?1)

Well, we have a base URL which acts as our firebase reference. The name of this location is flatiron-go. At this location we have two other locations, one named `treasureLocations` and the other named `treasureProfiles`. Lets do some digging into the `treasureProfiles`.

![](http://i.imgur.com/NIm49XJ.png?1)

Lets look a little closer at one of these items. The first one.

![](http://i.imgur.com/taAmtKo.png?1)

The `kMrX9X2cUklCtYYjS9K` is a `key` within the `treasuresProfiles` location. With this `key`, we have access to another dictionary with two `key-value` pairs. One `key` is named `imageURL` where the value is  `String` representing a URL. The other `key` is called `name` and the value is a `String` representing the name of this treasure. Here, the name is "Hairy Harry".

The name is pretty self explanatory but the `imageURL` is where the actual image of Hairy Harry lives and where we can download it from within our app. That's perfect.

We don't want to store every single image of these various treasures in our iOS application. Imagine if we had 10,000 images or even 100,000 user-generated treasures, no-one would want to keep the app on their iPhone. Here, we're storing all of the information (including the images) of these treasure objects in Firebase. 

What about `treasureLocations`. What lives within that dictionary?

![](http://i.imgur.com/Drvv0Q6.png?1)

We can ignore the contents of this dictionary for now. What is important to take away from this right now is that the `key`'s here which look like a bunch of random numbers and letters match up with the `key`'s within the `treasureProfiles` dictionary. You might then ask, why have the locations and profile information of these treasure objects separate? How we're creating these treasure objects is something we will cover last here--but in working with GeoFire, we wanted to let it do its thing. Its thing being able to generate these values you see here (like 7zzzzzz) for the key g which can represent a specific lat & long on a map (which is awesome!). So we have a separate dictionary where the keys of these particular objects are unique where we can easily retrieve the name, image and location when we have a `key`. 

So now when we head back to Xcode, how can make the connection here to this particular URL which has all of this great info regarding treasures with our app?

*NOTE*: How did we get this info on firebase? That will be discussed shortly.

# Maps and Treasure

Going back to our extension, lets add a `typealias` in there to make our lives easier.

```swift
// MARK: - Treasure Methods
extension MapViewController {
    
    typealias ResponseDictionary = [String: AnyObject]
    
}
```

Now anytime we type out `ResponseDictionary`, it's the equivalent of typing out [`String`: `AnyObject`] which is a dictionary where the keys are `String`'s and the values are `AnyObject`. When dealing with the responses we will get back in our communications with Firebase, it takes this format - so we'll associate a word with it so that way we're not typing the same thing over and over again. We also get the benefit of Auto-Complete when typing out `ResponseDictionary` now.

Lets finally add a function to this extension now. We will call this function `setupGeoQueryWithLocation(_:)` It will take in one argument called `location` of type `CLLocation`. It will also return back a `GFCircleQuery`.

```swift
private func setupGeoQueryWithLocation(location: CLLocation) -> GFCircleQuery {
        let geofireRef = FIRDatabase.database().referenceWithPath(FIRReferencePath.treasureLocations)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let geoQuery = geoFire.queryAtLocation(location, withRadius: 10.0)
        return geoQuery
    }
``` 

In its implementation we're creating a constant named `geoFireRef`. That will equal (if you read that line of code) some path, but not just _any_ path. It will equal the location of the `treasureLocations` that we looked at earlier!

That next line of code will create a new constant called `geoFire`. We assign it a value which is an instance of `Geofire`. We initialize our `Geofire` object by passing in our `geofireRef` object to it, we get back an instance of `GeoFire` which has reference to the URL where our treasure locations live.

On the following line of code we are asking our `geoFire` object to create a query at the location that was passed into this function with a radius of 10.0. After we assign the return value of calling `queryAtLocation(_:withRadius:)` to a constant called `geoQuery`, we return `geoQuery` back to the caller of this function.

This is how we search for treasures that live within a certain radius of the location that is passed into this function.

To help us out (for a function we will soon write), lets create another function within this extension. This one will be called `generateLatAndLongFromLocation(_:)` that takes in one argument called `location` of type `CLLocation` and it will return a tuple of type (`Float`, `Float`).

```swift
private func generateLatAndLongFromLocation(location: CLLocation) -> (lat: Float, long: Float) {
        return (Float((location.coordinate.latitude)), Float((location.coordinate.longitude)))
    }
```

The implementation of this function is fairly simple. It returns back a tuple accessing the `location`'s properties (specifically the coordinate property and then the lat and long properties from that coordinate property). This is a helper function which we will use shortly.

Still within the same extension, lets create a function that will be able to create a `Treasure` object. We know what a `Treasure` object looks like, we designed it! We also know what a `Treasure` object looks like within Firebase. It's identified by that unique `key`. That unique `key` provides us access to the TreasureLocation and TreasureProfile (within Firebase). 

Lets think of what happens between our iOS app and Firebase as a conversation. We walk up to Firebase with our users current location. Firebase does its thing in locating treasure objects within the provided radius of the users current location. It hands us the unique `key` of the treasure object and its location (lat & long). It doesn't provide this to us in one big batch, for each one it finds that falls within that provided radius, it gives it to us. One at a time. Ok, so we're given a `key` and the location. We take that info and reach back up to a Firebase (for a second time), with the provided `key` and we ask it for the `name` and `imageURL` of the treasure object with this `key` we have. If you remember from earlier, the way we setup our database was to have the `TreasureLocations` split from the `TreasureProfiles`. This was because of how we have to work with GeoFire (in how we're creating these treasure objects within Xcode--which we will talk about). When we reach back up to Firebase that second time, what format is the response in? Meaning.. how is Firebase giving us back this name and imageURL? They're doing so as a dictionary.... drum roll... as that `ResponseDictionary` we created earlier. If you recall, the type of `ResponseDictionary` is [`String`: `AnyObject`]. 

With this info, lets create another function within this same extension called `saveTreasureLocally(response:key:location:)` that takes in three arguments. The first argument has an external name of `withResponse` and an internal name of `response` of type `ResponseDictionary`. The second argument is called `key` of type `String`. The third argument has an external name of `andLocation` and an internal name of `location` of type `GPSLocation`. It doesn't return anything.

```swift
private func saveTreasureLocally(withResponse response: ResponseDictionary, key: String, andLocation location: GPSLocation) {
        let name = response["name"] as? String ?? ""
        let imageURL = response["imageURL"] as? String ?? ""
        let treasure = Treasure(location: location, name: name, imageURLString: imageURL)
        let newTreasure = (key, treasure)
        treasures.append(newTreasure)
        treasure.makeImage { _ in }
    }
``` 

In our implementation, we will first create a constant called `name` and assign it a value utilizing the `response` argument we take in. `response` is a dictionary of type [`String`: `AnyObject`] which means if were to access a value within this dictionary we have to cast it using as, as? or as!. We will go with as? coupled with optional chaining to produce a default value if it turns up nil. Working with dictionaries in Swift, they're might not be a value at a particular key, the key might not even exist, so you get back an optional of the type that should be there. So we're utilizing optional chaining here which can be read as follows:

Look to grab the value for key `name` within the `response` dictionary. If it's not nil in that there's a value there, treat it as a `String` and assign that value to our constant called `name`. If the value for key `name` is nil, then assign the string literal "" to our constant `name` and move on to the next piece of code.

We do something similar with `imageURL` in the following line.

Then on the third line of code, we create a `treasure` constant which is a `Treasure` instance instantiated with our three most important items, the `location`, `name`, and `imageURL`.

What is this `treasures` variable we're utilizing here? This is a new property we're about to make on our `MapViewController` class. Scroll all the way back to the top of your `MapViewController` class and lets add another instance property.

```swift
var treasures: [(String, Treasure)] = []
```

This is a new instance property which is a variable called `treasures` of type [(`String`, `Treasure`)] It's an `Array` of tuples. We assign it a default value being an empty array of tuples. 

Scrolling back down to your implementation of `saveTreasureLocally(response:key:location)`, we will append to this `treasures` property we have a tuple with the `key` being the first part of the tuple, and the `treasure` object being the second part of the tuple.

`makeImage` is then called on our `treasure` instance here. We had implemented this function earlier--for now I will ask that you type it in, but we will discuss this further when we utilize it.

Lets now create a function which will communicate with Firebase and retrieve the profile information. The profile information of a treasure item consists of its name and imageURL. In order to make this connection to firebase we will need to the `key` of the treasure item. This function will be called `getTreasureProfileFor(_:completion:)` with no return type. It's first argument will be called `key` of type `String`, the second argument will be called `completion` of type `(Bool) -> ()`. This is the signature of a function and functions can be types as well! The type of this function is `(Bool) -> ()` which means it has one argument of type `Bool` and it returns nothing. So whoever calls on this `getTreasureProfileFor(_:completion:)` function is required to provide it with two arguments (and expect nothing in return). Those two arguments are a `String` and a function that takes in a `Bool` as an argument and returns nothing.


```swift
private func getTreasureProfileFor(key: String, completion: (Bool) -> ()) {
        let profileRef = FIRDatabase.database().referenceWithPath(FIRReferencePath.treasureProfiles + "/" + key)
        
        profileRef.observeEventType(FIRDataEventType.Value, withBlock: { [unowned self] snapshot in
            guard let profile = snapshot.value as? ResponseDictionary,
                treasureLocation = self.treasureLocations[snapshot.key]
                else { print("Unable to produce snapshot value or key"); completion(false); return }
            
            self.saveTreasureLocally(withResponse: profile, key: snapshot.key, andLocation: treasureLocation)
            completion(true)
            })
    }
```

Lets step through the implementation. When this function is called, we have two things handed to us - a `key` which is of type `String` and a `completion` constant which is of type `(Bool) -> ()`, it's a function we can call on (whenever we want) within the scope of this function.

First things first, we're creating our connection to firebase. 

```swift
let profileRef = FIRDatabase.database().referenceWithPath(FIRReferencePath.treasureProfiles + "/" + key)
```

This constant, called `profileRef` is a direct connection going through the inter-webs to Firebase locating our exact treasure (the provided `key`). With this constant, we're now able to call on a specific method available to the `FIRDatabaseReference` type which is the what the type of `profileRef` is.

Calling `observeEventType` on this constant, we provide it with a function where one of the arguments is `snapshot` of type `FIRDataSnapshot`. This argument, provided to us when `observeEventType` decides to call on this provided function contains the information we're looking for. 

Scrolling back up to above the `viewDidLoad()` function, we need to add another property:

```swift
var treasureLocations: [String: GPSLocation] = [:]
```

We will be adding items to this later. It will be a place that stores our loctations where the Keys to this dictionary will be the `key` `String` associated with the treasure and the value will be their location as a `GPSLocation` coordinate. The `GPSLocation` struct is a type we made within `Treasure.swift` file.

At this point, we would have already made the query up to firebase, making the request for treasures that fall within a certain radius and have stored them in this `treasureLocations` dictionary. So here, we have the `key` to our treasure-- we're going back up to firebase getting back a snapshot that now contains the name and imageURL within our `profile` constant. We're passing along this info to the `saveTreasureLocally` function we created earlier which will use this info to create a `Treasure` object and store it locally. After we do that, we will call on the `completion` argument handed to us in this function, passing in the value `true` to let the person who called on this function know that we are done!

This piece of code handed over to the `observeEventType` function on `profileRef` is happening asynchronously. It could take 2 seconds, it could take 5 min. but it's doing its thing as the rest of our app continues to run. It's not blocking the main thread, it's not holding anything else up.

Lets implement the final piece of this puzzle. We want to create a function that will do all of these various parts in one (to make our life very easy). We will call the function `getTreasuresFor(_:completion:)`. It will take in two arguments. The first argument is called `location` of type `CLLocation` and the second argument is called `completion` of type `(Bool) -> ()`. It will return nothing.

We call on our `setupGeoQueryWithLocation()` function, passing in the `location` argument we receive. This sets up our `geoQuery` object which allows us to communicate with firebase. We have a query object created that's able to retrieve the `key`'s of treasures that fall within a certain radius. So the `observeEventType` function we call on the `geoQuery` object is able to provide us with a `key` and `location` which we utilize to step through the various functions we created above to store these treasures locally on the phone that fall within a certain radius of the users current location. Like I stated earlier, this block of code provided to the `observeEventType` function here gets called repeatedly within the implementation of the `observeEventType` function when its able to located a `key` and `location` that falls within radius--it doesn't give us all the info within one chunk, we get it one at a time.


```swift
private func getTreasuresFor(location: CLLocation, completion: (Bool) -> ()) {
        let geoQuery = setupGeoQueryWithLocation(location)
    
        geoQuery.observeEventType(.KeyEntered) { [unowned self] key, location in
            guard let geoKey = key,
                geoLocation = location
                else { print("No Key and/or No Location"); completion(false); return }
            
            let treasureLocation = self.generateLatAndLongFromLocation(geoLocation)
            
            self.treasureLocations[geoKey] = (GPSLocation(latitude: treasureLocation.lat, longitude: treasureLocation.long))
            
            self.getTreasureProfileFor(geoKey) { [unowned self] result in
                if result { self.createAnnotations() }
                completion(result)
            }
        }
    }
```

Within our implementation, we're calling on a function `createAnnotations()` which is what places our treasure annotation on the map (for our user to be able to interact with).

```swift
// MARK: - Annotation Methods
extension MapViewController {
    
    private func createAnnotations() {
        guard let (_, treasure) = treasures.last else { print("No last treasure"); return }
        generateAnnotationWithTreasure(treasure)
    }
    
    private func generateAnnotationWithTreasure(treasure: Treasure) {
        let newAnnotation = MGLPointAnnotation()
        let lat = Double(treasure.location.latitude)
        let long = Double(treasure.location.longitude)
        newAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        newAnnotation.title = treasure.name
        mapView.addAnnotation(newAnnotation)
        
        let key = String(newAnnotation.coordinate.latitude) + String(newAnnotation.coordinate.longitude)
        annotations[key] = treasure
    }
    
}
```

We're utilizing another instance property here which should be created above the `viewDidLoad() ` function.

```swift
var annotations: [String: Treasure] = [:]
```

We want to now add this new function we made to our `viewDidLoad()` function.

```swift
getTreasuresFor(userStartLocation) { _ in }
```

Our `viewDidLoad()` should now look like this:

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupCurrentLocation()
        setCenterCoordinateOnMapView()
        getTreasuresFor(userStartLocation) { _ in }
    }
```

# Map View Delegate

Check out the extension on `MapViewController` where we adopt the `MGLMapViewDelegate` protocol. Above this extension, we marked it as "MapView Delegate Methods":

[MapViewController.swift](https://github.com/learn-co-curriculum/FlatironGO/blob/master/FlatironGo/MapViewController.swift)

![bear](http://i.imgur.com/nAwylOw.png)

# Constants file

```swift
struct Constants {
    static let mapBoxAccessToken = "YOUR_ACCESS_TOKEN_HERE"
    static let styleUrl = "mapbox://styles/ianrahman/ciqodpgxe000681nm8xi1u1o9"
    static let bullImage = "https://firebasestorage.googleapis.com/v0/b/flatiron-go.appspot.com/o/images%2Fchargingbull.png?alt=media&token=73e58c88-2172-4218-b78d-67125f8514dc"
}

struct FIRReferencePath {
    static let treasureLocations = "treasureLocations"
    static let treasureProfiles = "treasureProfiles"
}

struct FIRStorageReference {
    static let storageBucket = "YOUR_URL_HERE"
}
```



<a href='https://learn.co/lessons/HowToFlatironGO' data-visibility='hidden'>View this lesson on Learn.co</a>
