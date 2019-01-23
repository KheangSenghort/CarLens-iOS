# CarLens
![blog post image 1440x500 1](https://user-images.githubusercontent.com/18245585/51602699-ea70bd80-1f07-11e9-9bf9-8e333ffb63da.png)

[<img src="https://user-images.githubusercontent.com/18245585/51603579-771c7b00-1f0a-11e9-866d-5ce9fb0d1aca.png" width="150">](https://itunes.apple.com/us/app/carlens/id1417168518?mt=8)

**CarLens** is a mobile app that uses **Augmented Reality** and **Machine Learning** to detect different car models. It connects to your smartphone camera and enables you to verify cars around as you walk on the streets. 

We currently support the newest versions of 4 cars in CarLens:
* Honda Civic
* Ford Fiesta
* Nissan Qashqai
* Volkswagen Passat

Discover **car recognition** together with CarLens!

<img src="https://user-images.githubusercontent.com/18245585/51602207-af21bf00-1f06-11e9-8306-2dbc7310928d.gif" width="800">
<img src="https://user-images.githubusercontent.com/18245585/51602423-2e16f780-1f07-11e9-8491-af4144111b44.png" width="800">

## Tools & Frameworks

* Tools:
	* Xcode 10.1 with latest iOS stable SDK (12.0) and Swift 4.2
	* [Carthage](https://github.com/Carthage/Carthage) 0.29 or higher
	* [CocoaPods](https://github.com/CocoaPods/CocoaPods) 1.5 or higher
* Frameworks:
	* [Core ML](https://developer.apple.com/documentation/coreml)
	* [ARKit](https://developer.apple.com/arkit/)
	* [Vision](https://developer.apple.com/documentation/vision)
	* [Lottie](https://github.com/airbnb/lottie-ios)
	* [SwiftLint](https://github.com/realm/SwiftLint)

## Configuration

### Prerequisites

- [Bundler](http://bundler.io) (`gem install bundler`)
- [Homebrew](https://brew.sh)
- [Carthage](https://github.com/Carthage/Carthage) (`brew install carthage`)
- [CocoaPods](https://cocoapods.org) (`brew install cocoapods`)

### Instalation

1. Clone repository:

	```bash
	# over https:
	git clone https://github.com/netguru/CarLens-iOS
	# or over SSH:
	git@github.com:netguru/CarLens-iOS.git
	```

2. Install required Gems:

	```bash
	bundle install
	```

3. Run Carthage:

	```bash
	carthage bootstrap --platform iOS --cache-builds
	```

4. Rename `.env.sample` to `.env`. If you're Netguru employee update it with values from project's 1password vault.

5. Install pods through Bundler:

	```bash
	bundle exec pod install
	```

6. Open `CarLens.xcworkspace` file and build the project.

## CarLensCollectionViewLayout

As a part of CarLens we've launched another open source tool - **CarLensCollectionViewLayout**. Its an easy-to-use Collection View Layout for card-like animation 🎉. [Make sure to check it out too!](https://github.com/netguru/CarLensCollectionViewLayout) 

<p align="center">
	<img src="https://user-images.githubusercontent.com/18245585/50694808-2b795e80-103b-11e9-839d-f2d8dc533bb4.gif" width="250">
</p>

## About

This project is made with ❤️ by [Netguru](https://netguru.co) and maintained by [Anna-Mariia Shkarlinska](https://github.com/anyashka).

### License

*CarLens* is licensed under the Apache License. See [LICENSE](LICENSE) for more info.

### Contribution

All contributions are welcome! Feel free to create issues and PRs. Please, respect the following coding guidelines:

- Respect Swift [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- The code must be readable and self-explanatory - full variable names, meaningful methods, etc.
- Don't leave any commented-out code.
- Write documentation for every method and property accessible outside the class. For example, well-documented method looks as follows:

	```swift
	/// Tells the magician to perform a given trick.
	///
	/// - Parameter trick: The magic trick to perform.
	/// - Returns: Whether the magician succeeded in performing the magic trick.
	func perform(magicTrick trick: MagicTrick) -> Bool {
		// body
	}
	```

### Read More About CarLens

- [How We Built CarLens](https://www.netguru.com/blog/machine-learning-and-augmented-reality-combined-in-one-sleek-mobile-app-how-we-built-car-lens)

### Related Links

- [CarLens Page](https://www.netguru.com/carlens)
- [CarLens in App Store](https://itunes.apple.com/us/app/carlens/id1417168518?mt=8)
- [CarLens Android - repository](https://github.com/netguru/car-recognition-android)
- [CarLens on Google Play](https://play.google.com/store/apps/details?id=co.netguru.android.carrecognition&hl=en)
- [CarLensCollectionViewLayout - repository](https://github.com/netguru/CarLensCollectionViewLayout)
- [CarLensCollectionViewLayout - article](https://www.netguru.com/codestories/introducing-carlenscollectionviewlayout-a-new-open-source-ios-tool-by-netguru)
