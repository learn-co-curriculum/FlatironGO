
# FLATIRON GO

---


## Firebase & Geofire Component

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


## Custom Map w/ MapBox

* Utilizing [MapBox](https://www.mapbox.com/ios-sdk/api/3.3.0/) which allows us to easitly create a custom looking map (like the one being used in the app).
* Through [MapBox](https://www.mapbox.com/ios-sdk/api/3.3.0/), we're creating the custom treasure annotation.
* Our map is customized through the various delegate methods available to us.
* Setting up the Map View which is then added tou our `view`

```swift
mapView = MGLMapView(frame: view.bounds,
                                 styleURL: NSURL(string: "mapbox://styles/ianrahman/ciqodpgxe000681nm8xi1u1o9"))
```

---

## AR Component

![Bull](http://i.imgur.com/hvYIBsb.png)

* When the `treasure` annotation is tapped on the Map, we are presenting a new `UIViewController` - the `ViewController.swift` file. 
* We know based upon what annotation was tapped, what `treasure` object should be transferred forward to display in our camera preview.
* So.. now that we know what `treasure` to display, what steps do we need to take to get this `image` displayed on screen?

**1** - Tell our `AVCaptureSession` instance to start running!

The `captureSession` variable being used in this code snippet is an instance of `AVCaptureSession`. The `cameraDeviceInput` is an instance of `AVCaptureDeviceInput`. Checking first that we can add the `cameraDeviceInput` to the sesion we then move forward by adding the `cameraDeviceInput` to the `captureSession`. That's a mouth full, and if you want to know more of what's going on here - I recommend option clicking the various types of these objects and reading through the documentation. 

```swift
let cameraDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
let cameraDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice)
guard let camera = cameraDeviceInput where captureSession.canAddInput(camera) else { return }
captureSession.addInput(cameraDeviceInput)
captureSession.startRunning() 
```
---

**2** - Setup the Preview Layer!

The `previewLayer` is a property on the `ViewController`. It's an instance of `AVCaptureVideoPreviewLayer`. 

![PreviewLayer](http://i.imgur.com/Pezoh71.png?1)

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


**3** - Setup the `CMMotionManager`

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


