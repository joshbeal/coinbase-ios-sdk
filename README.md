# Coinbase iOS SDK

This open-source iOS library allows you to integrate Coinbase into your iOS application.

##Getting Started

* Register your application on the [Coinbase website](https://coinbase.com/oauth/applications).

* Set **Callback url** to cb\[clientId\]://authorize (first enter some default until clientId is returned).

* Make sure you've edited your application's .plist file properly, so that your application binds to the cb\[clientId\]:// URL scheme (where "\[clientId\]" is your Coinbase application Client Id).

* Capture Coinbase schema in your application
``` objective-c
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    	[Coinbase handleUrl:url];
    	return YES;
}
```

## Usage

To run the example project; clone the repo, and run `pod install` from the Examples/CoinbaseClient directory.

## Requirements

The library requires iOS 6.0 or above and depends on the [AFNetworking](https://github.com/AFNetworking/AFNetworking) library.

## Installation

Coinbase is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "Coinbase"

## Author

Josh Beal, jbeal24@gmail.com

18XTMe1DwAVkpVMFmsN2YAb5FDbGcwKipG

## License

Copyright (C) 2013 [Josh Beal](https://github.com/joshbeal/)

Distributed under the MIT License.

