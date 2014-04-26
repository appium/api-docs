---
title: API Reference
search: true

language_tabs:
  - ruby: Ruby
  - python: Python
  - java: Java
  - javascript: JavaScript
  - php: PHP
  - csharp: C#

toc_footers:
  - <a href="https://github.com/appium/ruby_lib">Ruby bindings</a>
  - <a href="https://github.com/appium/python-client">Python bindings</a>
  - <a href="https://github.com/appium/java-client">Java bindings</a>
  - <a href="https://github.com/admc/wd">JavaScript bindings</a>
  - <a href="https://github.com/appium/php-client">PHP bindings</a>
  - <a href="https://github.com/appium/appium-dotnet-driver">C# bindings</a>
  - <a href="http://appium.io/">Appium home page</a>
---


# <span id="intro.md"></span>Introduction to Appium


Appium is an open-source tool you can use to automate mobile native,
mobile web, and mobile hybrid applications on iOS and Android platforms.
"Mobile native apps" are those written using the iOS or Android SDKs. "Mobile
web apps" are web apps accessed using a mobile browser (Appium supports
Safari on iOS and Chrome on Android). "Mobile hybrid apps" have a native
wrapper around a "webview" -- a native control that enables interaction with
web content. Projects like [Phonegap](http://phonegap.com/), for example,
make it easy to build apps using web technologies that are then bundled into
a native wrapper -- these are hybrid apps.

Importantly, Appium is "cross-platform": it allows you to write tests against
multiple platforms (iOS, Android), using the same API. This enables a large
or total amount of code reuse between iOS and Android testsuites.

For specific information about what it means for Appium to "support" its
platforms, version, and automation modalities, please see the [platform support doc](#platform-support.md).

## Appium Philosophy

Appium was designed to meet mobile automation needs according to a certain
philosophy. The key points of this philosophy can be stated as 4 requirements:

1. You shouldn't have to recompile your app or modify it in any way in order
   to automate it.
2. You shouldn't be locked into a specific language or framework to write and
   run your tests.
3. A mobile automation framework shouldn't reinvent the wheel when it comes
   to automation APIs.
4. A mobile automation framework should be open source,
   in spirit and practice as well as in name!

## Appium Design

So how does the structure of the Appium project live out this philosophy? We
meet requirement #1 by using vendor-provided automation frameworks under the
hood. That way, we don't need to compile in any Appium-specific or
third-party code or frameworks to your app. This means you're testing the
same app you're shipping. The vendor-provided frameworks we use are:

* iOS: Apple's [UIAutomation](https://developer.apple.com/library/ios/documentation/DeveloperTools/Reference/UIAutomationRef/_index.html)
* Android 4.2+: Google's [UiAutomator](http://developer.android.com/tools/help/uiautomator/index.html)
* Android 2.3+: Google's [Instrumentation](http://developer.android.com/reference/android/app/Instrumentation.html). (Instrumentation support is provided by bundling a separate project, [Selendroid](http://selendroid.io))

We meet requirement #2 by wrapping the vendor-provided frameworks in one API,
the [WebDriver](http://docs.seleniumhq.org/projects/webdriver/) API.
WebDriver (aka "Selenium WebDriver") specifies a client-server protocol
(known as the [JSON Wire Protocol](https://code.google.com/p/selenium/wiki/JsonWireProtocol).
Given this client-server architecture, a client written in any language can
be used to send the appropriate HTTP requests to the server. There are
already clients written in every popular programming language. This also
means that you're free to use whatever test runner and test framework you
want; the client libraries are simply HTTP clients and can be mixed into your
code any way you please. In other words, Appium & WebDriver clients are not
technically "test frameworks"--they are "automation libraries". You can
manage your test environment any way you like!

We meet requirement #3 in the same way: WebDriver has become the de facto
standard for automating web browsers, and is a [W3C Working Draft](https://dvcs.w3.org/hg/webdriver/raw-file/tip/webdriver-spec.html).
Why do something totally different for mobile? Instead we have [extended the protocol](https://code.google.com/p/selenium/source/browse/spec-draft.md?repo=mobile)
with extra API methods useful for mobile automation.

It should be obvious that requirement #4 is a given -- you're reading this
because [Appium is open source](https://github.com/appium/appium).

## Appium Concepts

*Client/Server Architecture*
Appium is at its heart a webserver that exposes a REST API. It receives
connections from a client, listens for commands, executes those commands on a
mobile device, and responds with an HTTP response representing the result of
the command execution. The fact that we have a client/server architecture
opens up a lot of possibilities: we can write our test code in any language
that has a client. We can put the server on a different machine than our
tests are running on. We can write test code and rely on a cloud service
like [Sauce Labs](https://saucelabs.com/mobile) to receive and interpret the commands.

*Session*
Automation is always performed in the context of a session. Clients initiate
a session with a server in ways specific to each library,
but they all end up sending a `POST /session` request to the server,
with a JSON object called  the 'desired capabilities' object. At this point
the server will start up the automation session and respond with a session ID
which can be used in sending further commands.

*Desired Capabilities*
Desired capabilities are sets of keys and values (i.e.,
a map or hash) sent to the Appium server to tell the server what kind of
automation session we're interested in starting up. There are also various
capabilities which can modify the behavior of the server during automation.
For example, we might set the `platformName` capability to `iOS` to tell
Appium that we want an iOS session, rather than an Android one. Or we might
set the `safariAllowPopups` capability to `true` in order to ensure that,
during a Safari automation session, we're allowed to use JavaScript to open
up new windows. See the [capabilities doc](#caps.md) for the complete list of
capabilities available for Appium.

*Appium Server*
Appium is a server written with Node.js. It can be built and installed from
source or directly from NPM.

*Appium.app, Appium.exe*
There exist GUI wrappers around the Appium server that can be downloaded.
These come bundled with everything required to run the Appium server,
so you don't need to worry about Node. They also come with an Inspector,
which enables you to check out the hierarchy of your app. This can come in
very handy when writing tests!

## Getting Started

Congratulations! You are now armed with enough knowledge to begin using
Appium. Why not head back to the [getting started doc](#getting-started.md) for
more detailed requirements and instructions?




# <span id="platform-support.md"></span>Appium Platform Support


Appium supports a variety of platforms and testing modalities (native,
hybrid, web, real devices, simulators, etc...). This document is designed to
make explicit the level of support and requirements for each of these.

## iOS Support

See [Running on OS X: iOS](#running-on-osx.md) for iOS requirements and setup
instructions.

* Versions: 6.1, 7.0, and 7.1
* Devices: iPhone Simulator, iPad Simulator, and real iPhones and iPads
* Native app support: Yes, with debug version of .app (simulator),
  or correctly-signed .ipa (real devices). Underlying support is provided by
  Apple's [UIAutomation](https://developer.apple.com/library/ios/documentation/DeveloperTools/Reference/UIAutomationRef/_index.html)
  framework.
* Mobile web support: Yes, via automation of mobile Safari. For real devices,
  ios-webkit-remote-debugger is required, and automation of native aspects of
  the Safari interface is not possible. See the [mobile web doc](#mobile-web.md) for instructions.
* Hybrid support: Yes. For real devices, ios-webkit-remote-debugger is
  required. See the [hybrid doc](#hybrid.md) for instructions.
* Support for automating multiple apps in one session: No
* Support for automating multiple devices simultaneously: No
* Support for automating vendor-provided or third-party apps: Only
  vendor-provided apps (Preferences, Maps, etc...), and only on the simulator

## Android Support

See [Running on OS X: Android](#running-on-osx.md), [Running on Windows](#running-on-windows.md), or [Running on Linux](#running-on-linux.md) for Android requirements and setup
instructions.

* Versions: 2.3 and up
  * Versions 4.2 and up are supported via Appium's own [UiAutomator](http://developer.android.com/tools/help/uiautomator/index.html)
    libraries. This is the default automation backend.
  * Versions 2.3 through 4.3 are supported via Appium's bundled version of
    [Selendroid](http://selendroid.io), which utilizes [Instrumentation](http://developer.android.com/reference/android/app/Instrumentation.html).
    Selendroid has a different set of commands than the default Appium (though
    this is rapidly being minimized) and a different support profile. To
    access this automation backend, use the `automationName` capability with
    the value `Selendroid`.
* Devices: Android emulators and real Android devices
* Native app support: Yes
* Mobile web support: Yes (but not when using Selendroid backend). Automation
  is effected using a bundled [Chromedriver](https://code.google.com/p/selenium/wiki/ChromeDriver)
  server as a proxy. With 4.2 and 4.3, automation works on official Chrome
  browser or Chromium only. With 4.4+, automation also works on the built-in
  "Browser" app. Chrome/Chromium/Browser must already be installed on the
  device under test. See the [mobile web doc](#mobile-web.md) for instructions.
* Hybrid support: Yes. See the [hybrid doc](#hybrid.md) for instructions.
  * With default Appium automation backend: versions 4.4 and up
  * With Selendroid automation backend: versions 2.3 and up
* Support for automating multiple apps in one session: Yes (but not when
  using the Selendroid backend)
* Support for automating multiple devices simultaneously: Yes,
  though Appium must be started using different ports for the server
   parameters `--port`, `--bootstrap-port` (or `--selendroid-port`) and/or
  `--chromedriver-port`. See the [server args doc](#server-args.md) for more
  information on these parameters.
* Support for automating vendor-provided or third-party apps: Yes (but not
  when using the Selendroid backend)




# <span id="real-devices.md"></span>Appium on real iOS devices


Appium has support for real device testing.

To get started on a real device, you will need the following:

1. An Apple Developer ID and a valid Developer Account with a configured
distribution certificate and provisioning profile.
2. An iPad or iPhone.
3. The source code of your app.
4. A Mac with XCode and the XCode Command Line Developer Tools

## Provisioning Profile

A valid iOS Development Distribution Certificate and Provisioning Profile are
necessary to test on a real device. You can find information about
configuring these in the [Apple documentation](http://developer.apple.com/library/ios/#documentation/ToolsLanguages/Conceptual/YourFirstAppStoreSubmission/TestYourApponManyDevicesandiOSVersions/TestYourApponManyDevicesandiOSVersions.html)

You will also need to [sign your app](http://developer.apple.com/library/ios/#documentation/ToolsLanguages/Conceptual/YourFirstAppStoreSubmission/ProvisionYourDevicesforDevelopment/ProvisionYourDevicesforDevelopment.html#//apple_ref/doc/uid/TP40011375-CH4-SW1).

Appium will attempt to install your app using Fruitstrap,
but it is often easier to pre-install your app using Xcode to ensure there
are no problems.

## Running your tests with Appium

Once your device and app are configured, you can run tests on that device by
passing the -U flag to the server, and passing the bundle ID (if the app is
installed on the device) or the path to the .ipa file via the `--app` flag or
 the `app` desired capability:

```
node . -U <UDID> --app <bundle_id>
```

This will start Appium and have Appium use the device to test the app.

## Troubleshooting ideas

0. Make sure UDID is correct by checking it in xcode organizer or itunes. It
   is a long string (20+ chars)
0. Make sure that you can run your tests against simulator
0. Double check that you can invoke your automation from instruments.
0. Make sure instruments in closed already

## Appium on real Android devices

Hooray! There's nothing extra to know about testing real Android devices: it
works exactly the same as testing on emulators. Make sure that your device
can connect to ADB and has Developer Mode enabled.




# <span id="running-on-osx.md"></span>Running Appium on Mac OS X


Appium on OS X supports iOS and Android testing.

## System setup (iOS)

* Appium requires Mac OS X 10.7, but 10.8 is recommended.
* Make sure you have XCode and the iOS SDK(s) installed. (Appium currently
  supports Xcode 4.6.3 for iOS up to 6.1 and Xcode 5 for iOS 7.0. Note that
  testing against iOS versions below 7.0 using Xcode 5 is not recommended. See
  the next section for more information.)
* You need to authorize use of the iOS Simulator. If you are running Appium
  from NPM, you'll do this by running `sudo authorize_ios` (`authorize_ios` is
  a binary made available by the Appium npm package). If you're running Appium
  from source, simply run `sudo grunt authorize` to do the same thing. If you
  are running `Appium.app`, you can authorize iOS through the GUI.

## Testing against multiple iOS SDKs

Apple's `instruments` binary, which Appium uses to launch the iOS simulator, by
default uses the currently-selected Xcode, and the highest iOS SDK installed
with that version of Xcode. This means that if you want to test iOS 6.1, but
have iOS 7.0 installed, Appium will be forced to use the 7.0 Simulator
regardless. The only way around this is to have multiple copies of Xcode
installed with different sets of SDKs. You can then switch to the particular
copy of Xcode that has the versions you want to test with before starting
Appium.

In addition, it's been discovered that testing against iOS 6.1 with Xcode
5 causes increased slowness and instability, so it's recommended that for
testing against iOS 6.1 and below we use Xcode 4.6.3, and for testing against
iOS 7.0 we use Xcode 5.We can do this by, say, having Xcode 5 at
`/Applications/Xcode.app`, and Xcode 4.6 and `/Applications/Xcode-4.6.app`.
Then we use the following command:

    sudo xcode-select -switch /Applications/Xcode-4.6.app/Contents/Developer/

To prepare for iOS 6.1 testing. We run it again with a different Xcode:

    sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer/

To go back to iOS 7.0 testing.

## System setup (Android)

* Make sure you have the [Android SDK installed](http://developer.android.com/sdk/index.html).
* Make sure you have Android SDK API &gt;= 17 installed. To do this, run the
  Android SDK Manager (`android`) and select the API in the extra packages you can install.
* Make sure you have `ant` installed. Ant is used to build the Appium bootstrap
  jar as well as the test applications. Mac OS X Mavericks no longer comes
  pre-packaged with `ant` so you will need to [download and install it](http://ant.apache.org/bindownload.cgi).
* Make sure you have exported `$ANDROID_HOME`, containing your android sdk
  path. If you unzipped the Android SDK to `/usr/local/adt/`, for example, you
  should add this to your shell startup:

        export ANDROID_HOME="/usr/local/adt/sdk"

* Make sure you have [Maven 3.1.1](http://maven.apache.org/download.cgi)
  or newer installed (`mvn`). We need Maven for Selendroid support,
  which helps Appium run on Android versions below 4.2.
* Make sure you have an AVD set to a recent Android version (one that can run
  UIAutomator. Just choose the latest Android OS). You can create an AVD by
  using the android SDK tools. Remember the name you give the AVD, so that you
  can launch an emulator with it and run tests against it.
* Make sure that `hw.battery=yes` in your AVD's `config.ini`.
* There exists a hardware accelerated emulator for android, it has its own
  limitations. For more information you can check out this
  [page](#android-hax-emulator.md).




# <span id="running-on-windows.md"></span>Running Appium on Windows


## Limitations

If you are running Appium on Windows, you cannot use the prebuilt '.app',
which is built for OS X only. Additionally, you will not be able to test iOS
apps because Appium relies on OS X-only libraries to support iOS testing.

## Setup

To get started:

1. Install [node.js](http://nodejs.org/download/) (v.0.8 or greater). Use the
   installer from nodejs.org.
1. Install the [Android SDK](http://developer.android.com/sdk/index.html).
   You will need to run the 'android' tool (included in the SDK) and make sure
   you have an API Level 17 or greater API installed. Set `ANDROID_HOME` to be
   your Android SDK path and add the tools and platform-tools folders to your
   PATH variable.
1. Install the Java JDK and set `JAVA_HOME` to your JDK folder.
1. Install [Apache Ant](http://ant.apache.org/bindownload.cgi) or use the one
   that comes with the Android Windows SDK in the eclipse\plugins folder. Be
   sure to add the folder containing ant to your PATH variable.
1. Install [Apache Maven](http://maven.apache.org/download.cgi) and set the
   M2HOME and M2 environment variables. Set M2HOME to the directory maven is
   installed in, and set M2 to %M2HOME\bin. Add the path you used for M2 to
   your PATH.
1. Install [Git](http://git-scm.com/download/win) Be sure to install Git for
   windows to run in the regular command prompt.
1. Instal [cURL](http://curl.haxx.se/download.html)

Now that you've downloaded everything, run:

    reset.bat

## Running Appium

To run tests on Windows, you will need to have the Android Emulator booted or
 an Android Device connected that is running an AVD with API Level 17 or
 greater. Then run Appium on the command line using node.js:

    node .

See the [server documentation](#server-args.md)
for all the command line arguments.

## Notes

* you must supply the --no-reset and --full-reset flags currently for android
  to work on Windows.
* There exists a hardware accelerated emulator for android, it has it's own
  limitations. For more information you can check out this
  [page](#android-hax-emulator.md).
* Make sure that `hw.battery=yes` in your AVD's `config.ini`.




# <span id="running-on-linux.md"></span>Running Appium on Linux


## Limitations

If you are running Appium on Linux, you cannot use the prebuilt '.app',
which is built for OS X only. Additionally, you will not be able to test iOS
apps because Appium relies on OS X-only libraries to support iOS testing.

## Setup

To get started, you'll need to install node.js (v.0.8 or greater). Just
follow the [instructions for your flavor of linux](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

Once you've got node.js installed, install the [Android SDK](http://developer.android.com/sdk/index.html).
You will need to run the 'android' tool (included in the SDK) and make sure
you have an API Level 17 or greater API installed. You will also need Ant to
build the bootstrap jar that Appium uses for testing Android.

Finally, set `$ANDROID_HOME` to be your Android SDK path. If you unzipped the
Android SDK to /usr/local/adt/, for example, you should add this to your
shell startup:

    export ANDROID_HOME="/usr/local/adt/sdk"

Now that you're setup to run Appium, run `./reset.sh --android` from your
Appium checkout to install all the dependencies.

## Running Appium

To run tests on Linux, you will need to have the Android Emulator booted and
running an AVD with API Level 17 or greater. Then run Appium on the command
line using node.js:

    node .

See the [server documentation](#server-args.md) for all the command line
arguments.

## Notes

* There exists a hardware accelerated emulator for android, it has it's own
  limitations. For more information you can check out this
  [page](#android-hax-emulator.md).
* Make sure that `hw.battery=yes` in your AVD's `config.ini`.




# <span id="running-tests.md"></span>Running Tests


## Preparing your app for test (iOS)

Test apps run on the simulator have to be compiled specifically for the
simulator, for example by executing the following command in the Xcode project:

    > xcodebuild -sdk iphonesimulator6.0

This creates a `build/Release-iphonesimulator` directory in your Xcode project
that contains the `.app` package that you'll need to communicate with the
Appium server.

If you want, you can zip up the .app directory into a .zip file! Appium will
unpack it for you. Nice if you're not using Appium locally.

## Preparing your app for test (Android)

Nothing in particular needs to be done to run your .apk using Appium. If you
want to zip it up, you can.

## Running your test app with Appium (iOS)

The best way to see what to do currently is to look at the example tests:

[Node.js](https://github.com/appium/appium/tree/master/sample-code/examples/node) | [Python](https://github.com/appium/appium/tree/master/sample-code/examples/python) | [PHP](https://github.com/appium/appium/tree/master/sample-code/examples/php) | [Ruby](https://github.com/appium/appium/tree/master/sample-code/examples/ruby) | [Java](https://github.com/appium/appium/tree/master/sample-code/examples/java)

Basically, first make sure Appium is running:

    node .

Then script your WebDriver test, sending in the following desired capabilities:

```js
{
    platformName: 'iOS',
    platformVersion: '6.1',
    deviceName: 'iPhone Simulator',
    app: myApp
}
```

In this set of capabilities, `myApp` must be either:

* A local absolute path to your simulator-compiled .app directory or .zip
* A url of a zip file containg your .app package

Using your WebDriver library of choice, set the remote session to use these
capabilities and connect to the server running at port 4723 of localhost (or
whatever host and port you specified when you started Appium). You should be
all set now!

## Running your test app with Appium (Android)

First, make sure you have one and only one Android emulator or device
connected. If you run `adb devices`, for example, you should see one device
connected. This is the device Appium will use for tests. Of course, to have
a device connected, you'll need to have made an Android AVD (see system
setup  [Windows](#running-on-windows.md), [Mac](#running-on-osx.md),
or [Linux](#running-on-linux.md))
for more information). If the Android SDK tools are on your path, you can
simply run:

    emulator -avd <MyAvdName>

And wait for the android emulator to finish launching. Sometimes, for various
reasons, `adb` gets stuck. If it's not showing any connected devices or
otherwise failing, you can restart it by running:

    adb kill-server && adb devices

Now, make sure Appium is running:

    node .

Then script your WebDriver test, sending in the following desired capabilities:

```js
{
    platformName: 'Android',
    platformVersion: '4.2',
    deviceName: 'Android Emulator',
    app: myApp
}
```

In this set of capabilities, `myApp` must be either:

* A local absolute path to your .apk or a .zip of it
* A url of a zip file containg your .apk

Using your WebDriver library of choice, set the remote session to use these
capabilities and connect to the server running at port 4723 of localhost (or
whatever host and port you specified when you started Appium). You should be
all set now!

## Running your test app with Appium (Android devices &lt; 4.2, and hybrid tests)

Android devices before version 4.2 (API Level 17) do not have Google's
[UiAutomator framework](http://developer.android.com/tools/help/uiautomator/index.html)
installed. This is what Appium uses to perform the automation behaviors on
the device. For earlier devices or tests of hybrid (webview-based) apps,
Appium comes bundled with another automation backend called [Selendroid]
(http://selendroid.io/).

To use Selendroid, all that is required is to slightly change the set of
desired capabilities mentioned above, by adding the `automationName` capability
and specifying the Selendroid automation backend.

```js
{
    automationName: 'Selendroid',
    platformName: 'Android',
    platformVersion: '2.3',
    deviceName: 'Android Emulator',
    version: '2.3',
    app: myApp
}
```

Now Appium will start up a Selendroid test session instead of the default test
session. One of the downsides to using Selendroid is that its API differs
sometimes significantly with Appium's. Therefore we recommend you thoroughly
read [Selendroid's documentation](http://selendroid.io/native.html) before
writing your scripts for older devices or hybrid apps.




# <span id="android-hax-emulator.md"></span>Intel® Hardware Accelerated Execution Manager


If you find the android emulator a slow and your system runs on an Intel®
cpu, you can check out HAXM. HAXM let's you leverage your hardware for
virtualization accelerating the emulator.

* To install HAXM open the Android SDK Manager, you will find the package
  under Extras.
* You can find all relevant documentation on [Intel's website][1]
* This will require an x86 emulator image
* Use Intel's package to install HAXM; The Android SDK Manager appears to not
  do so successfully.

[1]: http://software.intel.com/en-us/articles/intel-hardware-accelerated-execution-manager/




# <span id="android_coverage.md"></span>Android Coverage


Android coverage requires the emulator or a rooted device. Build your app
using the instrument target, for example `$ ant instrument`

Pass `androidCoverage` to your device capabilities and set it to your
instrumentation class.

```ruby
caps = { androidCoverage: 'com.example.pkg/com.example.pkg.instrumentation.MyInstrumentation' }
```

Appium will start your app like this:

`adb shell am instrument -e coverage true -w com.example.pkg/com.example.pkg.instrumentation.MyInstrumentation`

After your test completes, it's time to end the coverage collection and pull
the coverage.ec file from the device.

```ruby
mobile :endCoverage, intent: 'com.example.pkg.END_EMMA', path: '/mnt/sdcard/coverage.ec'
```

`AndroidManifest.xml` defines the instrumentation and broadcast receiver.

```xml
    <instrumentation
        android:name="com.example.pkg.instrumentation.MyInstrumentation"
        android:targetPackage="com.example.pkg" >
    </instrumentation>
    
    <!-- adb shell am broadcast -a com.example.pkg.END_EMMA -->
    <receiver android:name="com.example.pkg.instrumentation.EndEmmaBroadcast" >
       <intent-filter>
           <action android:name="com.example.pkg.END_EMMA" />
       </intent-filter>
    </receiver>
```

`EndEmmaBroadcast.java` is defined as:

```java
package com.example.pkg.instrumentation;

import java.io.File;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Process;
import android.util.Log;

// adb shell am broadcast -a com.example.pkg.END_EMMA
@SuppressLint("SdCardPath")
public class EndEmmaBroadcast extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("AppiumEmma", "EndEmmaBroadcast broadcast received!");
        // reflection is used so emma doesn't cause problems for other build targets
        // that do not include emma.
        try {
            Class.forName("com.vladium.emma.rt.RT")
                    .getMethod("dumpCoverageData", File.class, boolean.class, boolean.class)
                    .invoke(null, new File("/mnt/sdcard/coverage.ec"), false, false);
        } catch (Exception e) {
            Log.d("AppiumEmma", e.toString());
        }

        // once coverage is dumped, the processes is ended.
        Process.killProcess(Process.myPid());
    }
}
```

`MyInstrumentation.java` is defined as:

```java
package com.example.pkg.instrumentation;

import android.app.Instrumentation;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;

public class MyInstrumentation extends Instrumentation {
    private Intent intent;

    @Override
    public void onCreate(Bundle arguments) {
        intent = getTargetContext().getPackageManager()
                .getLaunchIntentForPackage("com.example.pkg")
                .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        start(); // creates new thread which invokes onStart
    }

    @Override
    public void onStart() {
        startActivitySync(intent);
        LocalBroadcastManager.getInstance(getTargetContext()).registerReceiver(
                new EndEmmaBroadcast(), new IntentFilter("com.example.pkg.END_EMMA"));
    }
}
```

## Coverage Reports

`ant instrument` generates a `coverage.em` file. The `mobile :endCoverage`
will download the coverage.ec file for that particular run. Note that you can
 have any number of coverage.ec files. To merge them all together into a
 report, use this command:

> java -cp /path/to/android-sdk-macosx/tools/lib/emma_device.jar emma report -r html -in coverage.em,coverage0.ec,coverage1.ec -sp /path/to/your-app/src




# <span id="server-args.md"></span>Appium server arguments


Usage: `node . [flags]`

## Server flags

All flags are optional, but some are required in conjunction with certain others.

|Flag|Default|Description|Example|
|----|-------|-----------|-------|
|`--shell`|null|Enter REPL mode||
|`--app`|null|IOS: abs path to simulator-compiled .app file or the bundle_id of the desired target on device; Android: abs path to .apk file|`--app /abs/path/to/my.app`|
|`--ipa`|null|(IOS-only) abs path to compiled .ipa file|`--ipa /abs/path/to/my.ipa`|
|`-q`, `--quiet`|false|Don't use verbose logging output||
|`-U`, `--udid`|null|Unique device identifier of the connected physical device|`--udid 1adsf-sdfas-asdf-123sdf`|
|`-a`, `--address`|0.0.0.0|IP Address to listen on|`--address 0.0.0.0`|
|`-p`, `--port`|4723|port to listen on|`--port 4723`|
|`-bp`, `--bootstrap-port`|4724|(Android-only) port to use on device to talk to Appium|`--bootstrap-port 4724`|
|`-k`, `--keep-artifacts`|false|(IOS-only) Keep Instruments trace directories||
|`-r`, `--backend-retries`|3|(iOS-only) How many times to retry launching Instruments before saying it crashed or timed out|`--backend-retries 3`|
|`--session-override`|false|Enables session override (clobbering)||
|`--full-reset`|false|(iOS) Delete the entire simulator folder. (Android) Reset app state by uninstalling app instead of clearing app data. On Android, this will also remove the app after the session is complete.||
|`--no-reset`|false|Don't reset app state between sessions (IOS: don't delete app plist files; Android: don't uninstall app before new session)||
|`-l`, `--pre-launch`|false|Pre-launch the application before allowing the first session (Requires --app and, for Android, --app-pkg and --app-activity)||
|`-lt`, `--launch-timeout`|90000|(iOS-only) how long in ms to wait for Instruments to launch||
|`-g`, `--log`|null|Also send log output to this file|`--log /path/to/appium.log`|
|`--log-timestamp`|false|Show timestamps in console output||
|`--log-no-colors`|false|Don't use colors in console output||
|`-G`, `--webhook`|null|Also send log output to this HTTP listener|`--webhook localhost:9876`|
|`--native-instruments-lib`|false|(IOS-only) IOS has a weird built-in unavoidable delay. We patch this in appium. If you do not want it patched, pass in this flag.||
|`--force-quit-instruments`, `-fqi`|false|Run the watcher process that will force-kill an unresponsive instruments||
|`--app-pkg`|null|(Android-only) Java package of the Android app you want to run (e.g., com.example.android.myApp)|`--app-pkg com.example.android.myApp`|
|`--app-activity`|null|(Android-only) Activity name for the Android activity you want to launch from your package (e.g., MainActivity)|`--app-activity MainActivity`|
|`--app-wait-package`|false|(Android-only) Package name for the Android activity you want to wait for (e.g., com.example.android.myApp)|`--app-wait-package com.example.android.myApp`|
|`--app-wait-activity`|false|(Android-only) Activity name for the Android activity you want to wait for (e.g., SplashActivity)|`--app-wait-activity SplashActivity`|
|`--android-coverage`|false|(Android-only) Fully qualified instrumentation class. Passed to -w in adb shell am instrument -e coverage true -w |`--android-coverage com.my.Pkg/com.my.Pkg.instrumentation.MyInstrumentation`|
|`--avd`|null|(Android-only) Name of the avd to launch|`--avd @default`|
|`--avd-args`|null|(Android-only) Additional emulator arguments to launch the avd|`--avd-args -no-snapshot-load`|
|`--device-ready-timeout`|5|(Android-only) Timeout in seconds while waiting for device to become ready|`--device-ready-timeout 5`|
|`--safari`|false|(IOS-Only) Use the safari app||
|`--device-name`|null|Name of the mobile device to use|`--device-name iPhone Retina (4-inch), Android Emulator`|
|`--platform-name`|null|Name of the mobile platform: iOS, Android, or FirefoxOS|`--platform-name iOS`|
|`--platform-version`|null|Version of the mobile platform|`--platform-version 7.1`|
|`--automation-name`|null|Name of the automation tool: Appium or Selendroid|`--automation-name Appium`|
|`--browser-name`|null|Name of the mobile browser: Safari or Chrome|`--browser-name Safari`|
|`--default-device`, `-dd`|false|(IOS-Simulator-only) use the default simulator that instruments launches on its own||
|`--force-iphone`|false|(IOS-only) Use the iPhone Simulator no matter what the app wants||
|`--force-ipad`|false|(IOS-only) Use the iPad Simulator no matter what the app wants||
|`--language`|null|(IOS-only) language for the iOS simulator|`--language en`|
|`--locale`|null|(IOS-only) locale for the iOS simulator|`--locale en_US`|
|`--calendar-format`|null|(IOS-only) calendar format for the iOS simulator|`--calendar-format gregorian`|
|`--orientation`|null|(IOS-only) use LANDSCAPE or PORTRAIT to initialize all requests to this orientation|`--orientation LANDSCAPE`|
|`--tracetemplate`|null|(IOS-only) .tracetemplate file to use with Instruments|`--tracetemplate /Users/me/Automation.tracetemplate`|
|`--show-sim-log`|false|(IOS-only) if set, the iOS simulator log will be written to the console||
|`--nodeconfig`|null|Configuration JSON file to register appium with selenium grid|`--nodeconfig /abs/path/to/nodeconfig.json`|
|`-ra`, `--robot-address`|0.0.0.0|IP Address of robot|`--robot-address 0.0.0.0`|
|`-rp`, `--robot-port`|-1|port for robot|`--robot-port 4242`|
|`--selendroid-port`|8080|Local port used for communication with Selendroid|`--selendroid-port 8080`|
|`--chromedriver-port`|9515|Port upon which ChromeDriver will run|`--chromedriver-port 9515`|
|`--use-keystore`|false|(Android-only) When set the keystore will be used to sign apks.||
|`--keystore-path`|/Users/user/.android/debug.keystore|(Android-only) Path to keystore||
|`--keystore-password`|android|(Android-only) Password to keystore||
|`--key-alias`|androiddebugkey|(Android-only) Key alias||
|`--key-password`|android|(Android-only) Key password||
|`--show-config`|false|Show info about the appium server configuration and exit||
|`--command-timeout`|60|The default command timeout for the server to use for all sessions. Will still be overridden by newCommandTimeout cap||
|`--keep-keychains`|false|(iOS) Whether to keep keychains (Library/Keychains) when reset app between sessions||




# <span id="caps.md"></span>Appium server capabilities


|Capability|Description|Values|
|----|-----------|-------|
|`automationName`|Which automation engine to use|`Appium` (default) or `Selendroid`|
|`platformName`|Which mobile OS platform to use|`iOS`, `Android`, or `FirefoxOS`|
|`platformVersion`|Mobile OS version|e.g., `7.1`, `4.4`|
|`deviceName`|The kind of mobile device or emulator to use|`iPhone Simulator`, `iPad Simulator`, `iPhone Retina 4-inch`, `Android Emulator`, `Galaxy S4`, etc...|
|`app`|The absolute local path _or_ remote http URL to an `.ipa` or `.apk` file, or a `.zip` containing one of these. Appium will attempt to install this app binary on the appropriate device first. Note that this capability is not required for Android if you specify `appPackage` and `appActivity` capabilities (see below). Incompatible with `browserName`.|`/abs/path/to/my.apk` or `http://myapp.com/app.ipa`|
|`browserName`|Name of mobile web browser to automate. Should be an empty string if automating an app instead.|'Safari' for iOS and 'Chrome', 'Chromium', or 'Browser' for Android|
|`newCommandTimeout`|How long (in seconds) Appium will wait for a new command from the client before assuming the client quit and ending the session|e.g. `60`|
|`autoLaunch`|Whether to have Appium install and launch the app automatically. Default `true`|`true`, `false`|

### Android Only

|Capability|Description|Values|
|----|-----------|-------|
|`appActivity`| Activity name for the Android activity you want to launch from your package|`MainActivity`, `.Settings`|
|`appPackage`| Java package of the Android app you want to run|`com.example.android.myApp`, `com.android.settings`|
|`appWaitActivity`| Activity name for the Android activity you want to wait for|`SplashActivity`|
|`appWaitPackage`| Java package of the Android app you want to wait for|`com.example.android.myApp`, `com.android.settings`|
|`deviceReadyTimeout`| Timeout in seconds while waiting for device to become ready|`5`|
|`compressXml`| [setCompressedLayoutHeirarchy(true)](http://developer.android.com/tools/help/uiautomator/UiDevice.html#setCompressedLayoutHeirarchy%28boolean%29)| `true`|
|`androidCoverage`| Fully qualified instrumentation class. Passed to -w in adb shell am instrument -e coverage true -w | `com.my.Pkg/com.my.Pkg.instrumentation.MyInstrumentation`|
|`enablePerformanceLogging`| (Chrome and webview only) Enable Chromedriver's performance logging (default `false`)| `true`, `false`|
|`avdLaunchTimeout`| How long to wait in milliseconds for an avd to launch and connect to ADB (default `120000`)| `300000`|
|`avdReadyTimeout`| How long to wait in milliseconds for an avd to finish its boot animations (default `120000`)| `300000`|


### iOS Only

|Capability|Description|Values|
|----|-----------|-------|
|`calendarFormat`| (Sim-only) Calendar format to set for the iOS Simulator|e.g. `gregorian`|
|`bundleId`| Bundle ID of the app under test. Useful for starting an app on a real device or for using other caps which require the bundle ID during test startup|e.g. `io.appium.TestApp`|
|`language`| (Sim-only) Language to set for the iOS Simulator|e.g. `fr`|
|`launchTimeout`| Amount of time in ms to wait for instruments before assuming it hung and failing the session|e.g. `20000`|
|`locale`| (Sim-only) Locale to set for the iOS Simulator|e.g. `fr_CA`|
|`locationServicesEnabled`| (Sim-only) Force location services to be either on or off. Default is to keep current sim setting.|`true` or `false`|
|`locationServicesAuthorized`| (Sim-only) Set location services to be authorized or not authorized for app via plist, so that location services alert doesn't pop up. Default is to keep current sim setting. Note that if you use this setting you MUST also use the `bundleId` capability to send in your app's bundle ID.|`true` or `false`|
|`autoAcceptAlerts`| Accept iOS privacy access permission alerts (e.g., location, contacts, photos) automatically if they pop up. Default is false.|`true` or `false`|
|`nativeInstrumentsLib`| Use native intruments lib (ie disable instruments-without-delay).|`true` or `false`|
|`nativeWebTap`| (Sim-only) Enable "real", non-javascript-based web taps in Safari. Default: `false`. Warning: depending on viewport size/ratio this might not accurately tap an element|`true` or `false`|
|`safariAllowPopups`| (Sim-only) Allow javascript to open new windows in Safari. Default keeps current sim setting|`true` or `false`|
|`safariIgnoreFraudWarning`| (Sim-only) Prevent Safari from showing a fraudulent website warning. Default keeps current sim setting.|`true` or `false`|
|`safariOpenLinksInBackground`| (Sim-only) Whether Safari should allow links to open in new windows. Default keeps current sim setting.|`true` or `false`|
|`keepKeyChains`| (Sim-only) Whether to keep keychains (Library/Keychains) when appium session is started/finished|`true` or `false`|




# <span id="finding-elements.md"></span>Finding and interacting with elements


Appium supports a subset of the WebDriver locator strategies:

* find by "tag name" (i.e., ui component type)
* find by "name" (i.e., the text, label, or developer-generated ID a.k.a
'accessibilityIdentifier' of an element)
  NOTE: the "name" locator strategy will be deprecated on mobile devices,
  and will not be a part of Appium v1.0
* find by "xpath" (i.e., an abstract representation of a path to an element,
with certain constraints)

Appium additionally supports some of the [Mobile JSON Wire Protocol](https://code.google.com/p/selenium/source/browse/spec-draft.md?repo=mobile) locator strategies

* `-ios uiautomation`: a string corresponding to a recursive element search
using the UIAutomation library (iOS-only)
* `-android uiautomator`: a string corresponding to a recursive element
search using the UiAutomator Api (Android-only)
* `accessibility id`: a string corresponding to a recursive element search
using the Id/Name that the native Accessibility options utilize.

## Tag name mapping

You can use the direct UIAutomation component type name for the tag name,
or use the simplified mapping (used in some examples below) found here:

https://github.com/appium/appium-uiauto/blob/master/uiauto/lib/mechanic.js#L30

## Issues

There's a known issue with table cell elements becoming invalidated before
there's time to interact with them. We're working on a fix

## Examples

### Find all the UIAButtons on the screen

WD.js:

```js
driver.elementsByTagName('button', function(err, buttons) {
  // tap all the buttons
  var tapNextButton = function() {
    var button = buttons.shift();
    if (typeof button !== "undefined") {
      button.click(function(err) {
        tapNextButton();
      })
    } else {
      driver.quit();
    }
  }
  tapNextButton();
});
```

Ruby:

```ruby
buttons = @driver.find_elements :tag_name, :button
buttons.each { |b| b.click }
```

Python:

```python
[button.click() for button in driver.find_elements_by_tag_name('button')]
```

### Find the element with the text (or accessibilityIdentifier) "Go"

WD.js:

```js
driver.elementByName('Go', function(err, el) {
  el.tap(function(err) {
    driver.quit();
  });
});
```

Ruby:

```ruby
@driver.find_element(:name, 'Go').click
```

Python:

```python
driver.find_element_by_name('Go').click()
```

### Find the nav bar text element where the text begins with "Hi, "

WD.js:

```js
driver.elementByXpath('//navigationBar/text[contains(@value, "Hi, ")]', function(err, el) {
  el.text(function(err, text) {
    console.log(text);
    driver.quit();
  });
});
```

Ruby:

```ruby
@driver.find_element :xpath, '//navigationBar/text[contains(@value, "Hi, ")]'
```

### Find an element by tagName

Java:

```java
driver.findElement(By.tagName("button")).sendKeys("Hi");

WebELement element = findElement(By.tagName("button"));
element.sendKeys("Hi");

List<WebElement> elems = findElements(By.tagName("button"));
elems.get(0).sendKeys("Hi");
```

Python:

```python
driver.find_elements_by_tag_name('tableCell')[5].click()
```

### Using the "-ios uiautomation" locator strategy

WD.js:

```js
driver.element('-ios uiautomation', '.elements()[1].cells()[2]').getAttribute('name');
```

### Using the "-android uiautomator" locator strategy

WD.js:

```js
driver.element('-android uiautomator', 'new UiSelector().clickable(true)').getAttribute('name');
```

### Pull to refresh using a swipe gesture

Python:

```python
js_snippet = "mobile: swipe"
args = {'startX':0.5, 'startY':0.2, 'startX':0.5, 'startY':0.95, 'tapCount':1, 'duration':10}
driver.execute_script(js_snippet, args)
```

## Using The Appium Inspector To Locate Elements

Appium provides you with a neat tool that allows you to find the the elements
you're looking for without leaving the Appium app. With the Appium Inspector
(the i symbol next to the start test button) you can find any element and
it's name by either clicking the element on the preview page provided,
or locating it in the UI navigator.

### Overview

The Appium inspector has a simple layout, complete with a UI navigator,
a preview, and record and refresh buttons, and interaction tools.

![Step 1](https://raw.github.com/appium/appium/master/assets/InspectorImages/Overview.png)

### Example

After launching the Appium Inspector (you can do this by clicking the small
"i" button in the top right of the app) you can locate any element in the
preview. In this test, I'm looking for the id of the "show alert" button.

![Step 1](https://raw.github.com/appium/appium/master/assets/InspectorImages/Step1.png)

To find the id of this button, I click the "show alert" button in the
inspector preview. The Appium inspector then highlights the element in the UI
navigator, showing me both the id and element type of the button I clicked.

![Step 1](https://raw.github.com/appium/appium/master/assets/InspectorImages/Step2.png)




# <span id="gestures.md"></span>Automating mobile gestures


While the Selenium WebDriver spec has support for certain kinds of mobile
interaction, its parameters are not always easily mappable to the
functionality that the underlying device automation (like UIAutomation in the
 case of iOS) provides. To that end, Appium augments the WebDriver spec with
 extra commands and parameters for mobile gestures:

* **tap** (on screen or on element) with options:
  * how many fingers
  * how long to tap
  * how many taps
  * where precisely to tap on the screen or element
* **flick** (on screen or on element) with options:
  * how many fingers
  * where to start the flick on screen or element
  * where to end the flick on screen or element
* **swipe/drag** (on screen or on element) with options:
  * how many fingers
  * how long the swipe/drag takes in seconds
  * where to start the swipe on screen or element
  * where to end the swipe on screen or element
* **scroll to** (element)
* **slider**
* **shake**
* **longTap** (element)
* set the **orientation** with option:
  * new orientation (landscape or portrait)

## JSON Wire Protocol server extensions

Here are the endpoints with which we have implemented these additions to the
spec.

**Note on coordinates:** All the X and Y parameters listed below can be used
in two ways. If they are between 0 and 1 (e.g., 0.5), they are taken to be
percentage of screen or element size. In other words,
`{x: 0.5, y: 0.25}` means a coordinate that is 50% from the left side of the
screen/element, and 25% from the top of the screen/element. If the values are
 greater than 1, they are taken as pixels. So, `{x: 100,
 y: 300}` means a coordinate that is 100 pixels from the left and 300 from
 the top of the screen/element.

**Note on performing actions on screen vs elements:** These methods all take
an optional `element` parameter. If present, this is taken to be the ID of an
element which has already been retrieved. So in this case,
the coordinates will be taken to refer to the rectangle of that element only
. So `{x: 0.5, y: 0.5, element: '3'}` means "the exact middle point of the
element with ID '3'".

* `POST session/:sessionId/touch/tap` - perform a tap on the screen or an element
    * URL Parameter: sessionId of session to route to
    * JSON parameters:
        * `tapCount` (optional, default `1`): how many times to tap
        * `touchCount` (optional, default `1`): how many fingers to tap with
        * `duration` (optional, default `0.1`): how long (in seconds) to tap
        * `x` (optional, default `0.5`): x coordinate to tap (in pixels or relative units)
        * `y` (optional, default `0.5`): y coordinate to tap (in pixels or relative units)
        * `element` (optional): ID of element to scope this command to
* `POST session:/sessionId/touch/flick_precise` - perform a flick on the screen or an element
    * URL Parameter: sessionId of session to route to
    * JSON parameters:
        * `touchCount` (optional, default `1`): how many fingers to flick with
        * `startX` (optional, default `0.5`): x coordinate where flick begins (in pixels or relative units)
        * `startY` (optional, default `0.5`): y coordinate where flick begins (in pixels or relative units)
        * `endX` (required): x coordinate where flick ends (in pixels or relative units)
        * `endY` (required): y coordinate where flick ends (in pixels or relative units)
        * `element` (optional): ID of element to scope this command to
* `POST session:/sessionId/touch/swipe` - perform a swipe/drag on the screen or an element
    * URL Parameter: sessionId of session to route to
    * JSON parameters:
        * `touchCount` (optional, default `1`): how many fingers to flick with
        * `startX` (optional, default `0.5`): x coordinate where swipe begins (in pixels or relative units)
        * `startY` (optional, default `0.5`): y coordinate where swipe begins (in pixels or relative units)
        * `endX` (required): x coordinate where swipe ends (in pixels or relative units)
        * `endY` (required): y coordinate where swipe ends (in pixels or relative units)
        * `duration` (optional, default `0.8`): time (in seconds) to spend performing the swipe/drag
        * `element` (optional): ID of element to scope this command to

**Note on setting orientation:** Setting the orientation takes different
parameters than the tap, flick, and swipe methods. This action is performed
by setting the orientation of the browser to "LANDSCAPE" or "PORTRAIT". The
alternative access method below does not apply to setting orientation.

* `POST /session/:sessionId/orientation` - set the orientation of the browser
    * URL Parameter: sessionId of session to route to
    * JSON parameters:
        * `orientation` (required): new orientation, either "LANDSCAPE" or "PORTRAIT"

## Alternative access method

Extending the JSON Wire Protocol is great, but it means that the various
WebDriver language bindings will have to implement access to these endpoints
in their own way. Naturally, this will take different amounts of time
depending on the project. We have instituted a way to get around this delay,
by using `driver.execute()` with special parameters.

`POST session/:sessionId/execute` takes two JSON parameters:
  * `script` (usually a snippet of javascript)
  * `args` (usually an array of arguments passed to that snippet in the javascript engine)

In the case of these new mobile methods, `script` must be one of:
  * `mobile: tap`
  * `mobile: flick`
  * `mobile: swipe`
  * `mobile: scrollTo`
  * `mobile: scroll`
  * `mobile: shake`
(The `mobile:` prefix allows us to route these requests to the appropriate
endpoint).

And `args` will be an array with one element: a Javascript object defining
the parameters for the corresponding function. So, let's say I want to call
`tap` on a certain screen position. I can do so by calling `driver.execute`
with these JSON parameters:

```json
{
  "script": "mobile: tap",
  "args": [{
    "x": 0.8,
    "y": 0.4
  }]
}
```
In this example, our new `tap` method will be called with the `x` and `y`
params as described above.

## Code examples

In these examples, note that the element parameter is always optional.

## Tap

* **WD.js:**

```js
driver.elementsByTagName('tableCell', function(err, els) {
var tapOpts = {
  x: 150 // in pixels from left
  , y: 30 // in pixels from top
  , element: els[4].value // the id of the element we want to tap
};
driver.execute("mobile: tap", [tapOpts], function(err) {
  // continue testing
});
});
```

* **Java:**

```java
WebElement row = driver.findElements(By.tagName("tableCell")).get(4);
JavascriptExecutor js = (JavascriptExecutor) driver;
HashMap<String, Double> tapObject = new HashMap<String, Double>();
tapObject.put("x", 150); // in pixels from left
tapObject.put("y", 30); // in pixels from top
tapObject.put("element", ((RemoteWebElement) row).getId()); // the id of the element we want to tap
js.executeScript("mobile: tap", tapObject);
```

```java
//In iOS app, if UI element visbile property is "false".
//Using element location tap on it.
WebElement element = wd.findElement(By.xpath("//window[1]/scrollview[1]/image[1]"));
JavascriptExecutor js = (JavascriptExecutor) wd;
HashMap<String, Double> tapObject = new HashMap<String, Double>();
tapObject.put("x", (double) element.getLocation().getX());
tapObject.put("y", (double) element.getLocation().getY());
tapObject.put("duration", 0.1);
js.executeScript("mobile: tap", tapObject);
```

* **Python:**

```python
driver.execute_script("mobile: tap", {"touchCount":"1", "x":"0.9", "y":"0.8", "element":element.id})
```

* **Ruby:**

```ruby
@driver.execute_script 'mobile: tap', :x => 150, :y => 30
```

* **Ruby:**

```ruby
b = @driver.find_element :name, 'Sign In'
@driver.execute_script 'mobile: tap', :element => b.ref
```

* **C#:**

```c#
Dictionary<String, Double> coords = new Dictionary<string, double>();
coords.Add("x", 12);
coords.Add("y", 12);
driver.ExecuteScript("mobile: tap", coords);
```

## Flick

* **WD.js:**

```js
// options for a 2-finger flick from the center of the screen to the top left
var flickOpts = {
endX: 0
, endY: 0
, touchCount: 2
};
driver.execute("mobile: flick", [flickOpts], function(err) {
// continue testing
});
```

* **Java:**

```java
JavascriptExecutor js = (JavascriptExecutor) driver;
HashMap<String, Double> flickObject = new HashMap<String, Double>();
flickObject.put("endX", 0);
flickObject.put("endY", 0);
flickObject.put("touchCount", 2);
js.executeScript("mobile: flick", flickObject);
```

## Swipe

*Note*: Swiping is unfortunately broken in iOS7, because of a bug in Apple's
frameworks. For iOS7, see `mobile: scroll` as a workaround that works for most
cases.

* **WD.js:**

```js
// options for a slow swipe from the right edge of the screen to the left
var swipeOpts = {
startX: 0.95
, startY: 0.5
, endX: 0.05
, endY: 0.5
, duration: 1.8
};
driver.execute("mobile: swipe", [swipeOpts], function(err) {
// continue testing
});
```

* **Java:**

```java
JavascriptExecutor js = (JavascriptExecutor) driver;
HashMap<String, Double> swipeObject = new HashMap<String, Double>();
swipeObject.put("startX", 0.95);
swipeObject.put("startY", 0.5);
swipeObject.put("endX", 0.05);
swipeObject.put("endY", 0.5);
swipeObject.put("duration", 1.8);
js.executeScript("mobile: swipe", swipeObject);
```
  
## Scroll

* **WD.js:**

```js
// scroll the view down
driver.execute("mobile: scroll", [{direction: 'down'}], function(err) {
// continue testing
});
```

* **Java:**

```java
JavascriptExecutor js = (JavascriptExecutor) driver;
HashMap<String, String> scrollObject = new HashMap<String, String>();
scrollObject.put("direction", "down");
scrollObject.put("element", ((RemoteWebElement) element).getId());
js.executeScript("mobile: scroll", scrollObject);
```

## Slider
 
**iOS**
 
 * **Java**
 
```java
// slider values can be string representations of numbers between 0 and 1
// e.g., "0.1" is 10%, "1.0" is 100%
WebElement slider =  wd.findElement(By.xpath("//window[1]/slider[1]"));
slider.sendKeys("0.1");
```
 
**Android**

The best way to interact with the slider on Android is with the 'mobile:
tap' gesture. It is difficult to find a reliable way to set a specific
percentage that works on all screen sizes, however. Therefore,
it is recommended to write tests that focus on minimum, 50%, and maximum.

* **Ruby**

```ruby
# 0%
@driver.execute_script 'mobile: tap', :x =>slider.location.x, :y =>slider.location.y

# 100%
@driver.execute_script 'mobile: tap', :x =>slider.location.x + slider.size.width - 1, :y =>slider.location.y

# 50%
slider.click
```
## Set orientation

* **WD.js:**

```js
driver.setOrientation("LANDSCAPE", function(err) {
// continue testing
});
```

* **Python:**

```python
driver.orientation = "LANDSCAPE"
```

## Scroll To

```ruby
  b = @driver.find_element :name, 'Sign In'
  @driver.execute_script 'mobile: scrollTo', :element => b.ref
```

```java
JavascriptExecutor js = (JavascriptExecutor) driver;
WebElement element = wd.findElement(By.name("Log In"));;
HashMap<String, String> scrollToObject = new HashMap<String, String>();
scrollToObject.put("element",((RemoteWebElement) element).getId());
js.executeScript("mobile: scrollTo", scrollToObject);
```

## longTap
 
 * **c#**
 
```c#
// long tap an element
//
Dictionary<string, object> parameters = new Dictionary<string, object>();
parameters.Add("using", _attributeType);
parameters.Add("value", _attribute);
Response response = rm.executescript(DriverCommand.FindElement, parameters);
Dictionary<string, object> elementDictionary = response.Value as Dictionary<string, object>;
string id = null;
if (elementDictionary != null)
{
 id = (string)elementDictionary["ELEMENT"];
}
IJavaScriptExecutor js = (IJavaScriptExecutor)remoteDriver;
Dictionary<String, String> longTapObject = new Dictionary<String, String>();
longTapObject.Add("element", id);
js.ExecuteScript("mobile: longClick", longTapObject);
```




# <span id="grid.md"></span>Selenium Grid


You are able to register your appium server with a local grid by using the
**"--nodeconfig"** server parameter.

```bash
> node . -V --nodeconfig /path/to/nodeconfig.json
```

In the node config file you have to define the **"browserName"**,
**"version"** and **"platform"** and based on these parameters the grid
will re-direct your test to the right device. You will also need to
configure you **host** details and the **selenium grid** details. For
a full list of all parameters and descriptions look
[here](http://code.google.com/p/selenium/source/browse/java/server/src/org/openqa/grid/common/defaults/GridParameters.properties)

Once you start the appium server and it registers with the grid,
you will see your device on the grid console page:

"http://**\<grid-ip-adress\>**:**\<grid-port\>**/grid/console"

## Grid Node Configuration Example json file

```xml
{
  "capabilities":
      [
        {
          "browserName": "<e.g._iPhone5_or_iPad4>",
          "version":"<version_of_iOS_e.g._6.1>",
          "maxInstances": 1,
          "platform":"<platform_e.g._MAC_or_ANDROID>"
        }
      ],
  "configuration":
  {
    "cleanUpCycle":2000,
    "timeout":30000,
    "proxy": "org.openqa.grid.selenium.proxy.DefaultRemoteProxy",
    "url":"http://<host_name_appium_server_or_ip-address_appium_server>:<appium_port>/wd/hub",
    "host": <host_name_appium_server_or_ip-address_appium_server>,
    "port": <appium_port>,
    "maxSession": 1,
    "register": true,
    "registerCycle": 5000,
    "hubPort": <grid_port>,
    "hubHost": "<Grid_host_name_or_grid_ip-address>"
  }
}
```

Valid platforms are listed [here](http://selenium.googlecode.com/git/docs/api/java/org/openqa/selenium/Platform.html)

If `url`, `host`, and `port` are not given, the config will be auto updated
to point to localhost:whatever-port-Appium-started-on.




# <span id="hybrid.md"></span>Automating hybrid apps


One of the core principles of Appium is that you shouldn't have to change
your app to test it. In line with that methodology, it is possible to test
hybrid web apps (e.g., the "UIWebView" elements in an iOS app) the same* way
you can with Selenium for web apps. There is a bit of technical complexity
required so that Appium knows whether you want to automate the native aspects
of the app or the web views, but thankfully, we can stay within the
WebDriver protocol for everything.

## Automating hybrid iOS apps

Here are the steps required to talk to a web view in your Appium test:

1.  Navigate to a portion of your app where a web view is active
1.  Call [GET session/:sessionId/contexts](https://code.google.com/p/selenium/source/browse/spec-draft.md?repo=mobile)
1.  This returns a list of contexts we can access, like 'NATIVE_APP' or 'WEBVIEW_1'
1.  Call [POST session/:sessionId/context](https://code.google.com/p/selenium/source/browse/spec-draft.md?repo=mobile)
    with the id of the context you want to access
1.  (This puts your Appium session into a mode where all commands are
    interpreted as being intended for automating the web view,
    rather than the native portion of the app. For example,
    if you run getElementByTagName, it will operate on the DOM of the web
    view, rather than return UIAElements. Of course,
    certain WebDriver methods only make sense in one context or another,
    so in the wrong context you will receive an error message).
1.  To stop automating in the web view context and go back to automating the
    native portion of the app, simply call `context` again with the native
    context id to leave the web frame.

## Execution against a real iOS device

To interrogate and interact with a web view appium establishes a connection
using a remote debugger. When executing the examples below against a
simulator this connection can be established directly as the simulator and
the appium server are on the same machine. When executing against a real
device appium is unable to access the web view directly. Therefore the
connection has to be established through the USB lead. To establish this
connection we use the [ios-webkit-debugger-proxy](https://github.com/google/ios-webkit-debug-proxy).

To install the latest tagged version of the ios-webkit-debug-proxy using
brew, run the following commands in the terminal:

``` bash
# The first command is only required if you don't have brew installed.
> ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
> brew update
> brew install ios-webkit-debug-proxy
```

You can also install the latest proxy by cloning it from git and installing
it yourself:

``` bash
# Please be aware that this will install the proxy with the latest code (and not a tagged version).
> git clone https://github.com/google/ios-webkit-debug-proxy.git
> cd ios-webkit-debug-proxy
> ./autogen.sh
> ./configure
> make
> sudo make install
```

Once installed you can start the proxy with the following command:

``` bash
# Change the udid to be the udid of the attached device and make sure to set the port to 27753 
# as that is the port the remote-debugger uses.
> ios_webkit_debug_proxy -c 0e4b2f612b65e98c1d07d22ee08678130d345429:27753 -d
``` 

**NOTE:** the proxy requires the **"web inspector"** to be turned on to
allow a connection to be established. Turn it on by going to **settings >
safari > advanced**. Please be aware that the web inspector was **added as
part of iOS 6** and was not available previously.

## Wd.js Code example

```js
  // assuming we have an initialized `driver` object working on the UICatalog app
  driver.elementByName('Web, Use of UIWebView', function(err, el) { // find button to nav to view
    el.click(function(err) { // nav to UIWebView
      driver.contexts(function(err, contexts) { // get list of available views
        driver.context(contexts[1], function(err) { // choose what is probably the webview context
          driver.elementsByCss('.some-class', function(err, els) { // get webpage elements by css
            els.length.should.be.above(0); // there should be some!
            els[0].text(function(elText) { // get text of the first element
              elText.should.eql("My very own text"); // it should be extremely personal and awesome
              driver.context('NATIVE_APP', function(err) { // leave webview context
                // do more native stuff here if we want
                driver.quit(); // stop webdrivage
              });
            });
          });
        });
      });
    });
  });
```

* For the full context, see [this node example](https://github.com/appium/appium/blob/master/sample-code/examples/node/hybrid.js)
* *we're working on filling out the methods available in web view contexts. [Join us in our quest!](http://appium.io/get-involved.html)

## Wd.java Code example

```java
  //setup the web driver and launch the webview app.
  DesiredCapabilities desiredCapabilities = new DesiredCapabilities();
  desiredCapabilities.setCapability("device", "iPhone Simulator");
  desiredCapabilities.setCapability("app", "http://appium.s3.amazonaws.com/WebViewApp6.0.app.zip");  
  URL url = new URL("http://127.0.0.1:4723/wd/hub");
  RemoteWebDriver remoteWebDriver = new RemoteWebDriver(url, desiredCapabilities);
  
  //switch to the latest web view
  for(String contextHandle : remoteWebDriver.getContexts()){
    remoteWebDriver.switchTo().context(contextHandle);
  }
  
  //Interact with the elements on the guinea-pig page using id.
  WebElement div = remoteWebDriver.findElement(By.id("i_am_an_id"));
  Assert.assertEquals("I am a div", div.getText()); //check the text retrieved matches expected value
  remoteWebDriver.findElement(By.id("comments")).sendKeys("My comment"); //populate the comments field by id.
  
  //leave the webview to go back to native app.
  remoteWebDriver.switchTo().context('NATIVE_APP')
  
  //close the app.
  remoteWebDriver.quit();
```

## Wd.rb Code example using cucumber

```ruby
TEST_NAME = "Example Ruby Test"
SERVER_URL = "http://127.0.0.1:4723/wd/hub" 
APP_PATH = "https://dl.dropboxusercontent.com/s/123456789101112/ts_ios.zip"
capabilities =
    {
      'browserName' => 'iOS 6.0',
      'platform' => 'Mac 10.8',
      'device' => 'iPhone Simulator',
      'app' => APP_PATH,
      'name' => TEST_NAME
    }
@driver = Selenium::WebDriver.for(:remote, :desired_capabilities => capabilities, :url => SERVER_URL)

# I switch to the last window because its always the webview in our case, in other cases you may need to specify a window number
# View the appium logs while running @driver.window_handles to figure out which window is the one you want and find the associated number
# Then switch to it using @driver.switch_to_window("6")

Given(/^I switch to webview$/) do 
  webview = @driver.contexts.last
  @driver.switch_to.context(webview)
end

Given(/^I switch out of webview$/) do
  @driver.switch_to(@driver.contexts.first)    
end

# Now you can use CSS to select an element inside your webview

And(/^I click a webview button $/) do
  @driver.find_element(:css, ".green_button").click
end
```

### Troubleshooting Webview with Ruby:

I created a quick function in my helper class to find web elements no matter
what window its in (this is useful if your webview id changes or if you are
using the same codebase to test android and ios)
https://gist.github.com/feelobot/7309729

## Automating hybrid Android apps

Appium comes with built-in hybrid support via Chromedriver. Appium also uses
Selendroid under the hood for webview support on devices older than 4.4. (In
that case, you'll want to specify `"device": "selendroid"` as a desired
capability). Then follow all the same steps as above for iOS, i.e.,
switching contexts, etc...

## Wd.js Code example

```js
// assuming we have an initialized `driver` object working on a hybrid app
driver.context("WEBVIEW", function(err) { // choose the only available view
  driver.elementsByCss('.some-class', function(err, els) { // get webpage elements by css
    els.length.should.be.above(0); // there should be some!
    els[0].text(function(elText) { // get text of the first element
      elText.should.eql("My very own text"); // it should be extremely personal and awesome
      driver.context("NATIVE_APP", function(err) { // leave webview context
        // do more native stuff here if we want
        driver.quit(); // stop webdrivage
      });
    });
  });
});
```

## Wd.java Code example

```java
  //setup the web driver and launch the webview app.
  DesiredCapabilities desiredCapabilities = new DesiredCapabilities();
  desiredCapabilities.setCapability("device", "Selendroid");
  desiredCapabilities.setCapability("app", "/path/to/some.apk");  
  URL url = new URL("http://127.0.0.1:4723/wd/hub");
  RemoteWebDriver remoteWebDriver = new RemoteWebDriver(url, desiredCapabilities);
  
  //switch to the web view
  remoteWebDriver.switchTo().context("WEBVIEW");
  
  //Interact with the elements on the guinea-pig page using id.
  WebElement div = remoteWebDriver.findElement(By.id("i_am_an_id"));
  Assert.assertEquals("I am a div", div.getText()); //check the text retrieved matches expected value
  remoteWebDriver.findElement(By.id("comments")).sendKeys("My comment"); //populate the comments field by id.
  
  //leave the webview to go back to native app.
  remoteWebDriver.switchTo().context("NATIVE_APP");
  
  //close the app.
  remoteWebDriver.quit();
```




# <span id="ios-deploy.md"></span>Deploying your iOS app to your device


To prepare for your Appium tests to run on a real device, you will need to:

1. Build your app with specific device-targeted parameters
1. Use [fruitstrap](https://github.com/ghughes/fruitstrap), a 3rd-party tool,
 to deploy this build to your device

## Xcodebuild with parameters:
A newer xcodebuild now allows settings to be specified. Taken from [developer.apple.com](https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html):

```
xcodebuild [-project projectname] [-target targetname ...]
             [-configuration configurationname] [-sdk [sdkfullpath | sdkname]]
             [buildaction ...] [setting=value ...] [-userdefault=value ...]
```

This is a resource to explore the available [settings](https://developer.apple.com/library/mac/#documentation/DeveloperTools/Reference/XcodeBuildSettingRef/1-Build_Setting_Reference/build_setting_ref.html#//apple_ref/doc/uid/TP40003931-CH3-DontLinkElementID_10)

```
CODE_SIGN_IDENTITY (Code Signing Identity)
    Description: Identifier. Specifies the name of a code signing identity.
    Example value: iPhone Developer
```

PROVISIONING_PROFILE is missing from the index of available commands,
but may be necessary.

Specify "CODE_SIGN_IDENTITY" & "PROVISIONING_PROFILE" settings in the
xcodebuild command:

```
xcodebuild -sdk <iphoneos> -target <target_name> -configuration <Debug> CODE_SIGN_IDENTITY="iPhone Developer: Mister Smith" PROVISIONING_PROFILE="XXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX"
```

On success, the app will be built to your ```<app_dir>/build/<configuration>-iphoneos/<app_name>.app```

## Deploy using Fruitstrap

Go clone a forked version of fruitstrap as the [ghughes version](https://github.com/ghughes/fruitstrap)
is no longer maintained. Success has been confirmed with the [unprompted fork](https://github.com/unprompted/fruitstrap),
but others are reportedly functional.

Once cloned, run `make fruitstrap`
Now, copy the resulting `fruitstrap` executable to your app's project or a
parent directory.

Execute fruitstrap after a clean build by running (commands available depend
on your fork of fruitstrap):

```
./fruitstrap -d -b <PATH_TO_APP> -i <Device_UDID>
```

If you are aiming to use continuous integration in this setup,
you may find it useful to want to log the output of fruitstrap to both
command line and log, like so:

```
./fruitstrap -d -b <PATH_TO_APP> -i <Device_UDID> 2>&1 | tee fruit.out
```

Since fruitstrap will need to be killed before the node server can be
launched, an option is to scan the output of the fruitstrap launch for some
telling sign that the app has completed launching. This may prove useful if
you are doing this via a Rakefile and a ``go_device.sh`` script:

```
bundle exec rake ci:fruit_deploy_app | while read line ; do 
   echo "$line" | grep "text to identify successful launch" 
   if [ $? = 0 ] 
   then 
   # Actions 
       echo "App finished launching: $line" 
       sleep 5 
       kill -9 `ps -aef | grep fruitstrap | grep -v grep | awk '{print $2}'` 
   fi
 done
```

Once fruitstrap is killed, node server can be launched and Appium tests can run!

Next: [Running Appium on Real Devices](./real-devices.html)




# <span id="mobile-web.md"></span>Automating mobile web apps


If you're interested in automating your web app in Mobile Safari on iOS or
Chrome on Android, Appium can help you. Basically, you write a normal WebDriver
test, and use Appium as the Selenium server with a special set of desired
capabilities.

## Mobile Safari on Simulator

First of all, make sure developer mode is turned on in your Safari
preferences so that the remote debugger port is open.

If you are using the simulator or a real device, you MUST run Safari before
attempting to use Appium.

Then, use desired capabilities like these to run your test in mobile Safari:

```js
{
  app: 'safari'
  , device: 'iPhone Simulator'
  , version: '6.1'
}
```

## Mobile Safari on a Real iOS Device

To be able to run your tests against mobile Safari we use the [SafariLauncher
 App](https://github.com/snevesbarros/SafariLauncher) to launch Safari. Once
 Safari has been launched the Remote Debugger automatically connects using
 the [ios-webkit-webkit-proxy](https://github.com/google/ios-webkit-debug-proxy).

**NOTE:** There is currently [a bug](https://github.com/google/ios-webkit-debug-proxy/issues/38)
in the ios-webkit-debug-proxy. You have to trust the machine before you can
run the ios-webkit-debug-proxy
against your iOS device.

## Setup

Before you can run your tests against Safari on a real device you will need to:
* Have the **ios-webkit-debug-proxy** installed and running (see the [hybrid docs](#hybrid.md) for instructions)
* Turn on **web inspector** on iOS device (**settings > safari >
advanced**, only for iOS 6.0 and up)
* Create a **provisioning profile** that can be used to deploy the SafariLauncherApp.

To create a profile for the launcher go into the **Apple Developers Member Center** and:
  * **Step 1:** Create a **new App Id** and select the WildCard App ID option and set it to "*"
  * **Step 2:** Create a **new Development Profile** and for App Id select the one created in step 1.
  * **Step 3:** Select your **certificate(s) and device(s)** and click next.
  * **Step 4:** Set the profile name and **generate the profile**.
  * **Step 5:** Download the profile and open it with a text editor.
  * **Step 6:** Search for the **UUID** and the string for it is your **identity code**.

Now that you have a profile open a terminal and run the following commands:

```bash
$ git clone https://github.com/appium/appium.git
$ cd appium

# Option 1: You dont define any parameters and it will set the code signing identity to 'iPhone Developer'
$ ./reset.sh --ios --real-safari

# Option 2: You define the code signing identity and allow xcode to select the profile identity code (if it can).
$ ./reset.sh --ios --real-safari --code-sign '<code signing idendity>'

# Option 3: You define both the code signing identity and profile identity code.
$ ./reset.sh --ios --real-safari --code-sign '<code signing idendity>' --profile '<retrieved profile identity code>'

# Once successfully configured and with the safari launcher built, start the server as per usual
$ node /lib/server/main.js -U <UDID>
```

## Running your test

To configure you test to run against safari simpley set the **"app"** to be **"safari"**.

## Java Example

```java
//setup the web driver and launch the webview app.
DesiredCapabilities desiredCapabilities = new DesiredCapabilities();
desiredCapabilities.setCapability("app", "safari");
URL url = new URL("http://127.0.0.1:4723/wd/hub");
RemoteWebDriver remoteWebDriver = new RemoteWebDriver(url, desiredCapabilities);

// Navigate to the page and interact with the elements on the guinea-pig page using id.
remoteWebDriver.get("http://saucelabs.com/test/guinea-pig");
WebElement div = remoteWebDriver.findElement(By.id("i_am_an_id"));
Assert.assertEquals("I am a div", div.getText()); //check the text retrieved matches expected value
remoteWebDriver.findElement(By.id("comments")).sendKeys("My comment"); //populate the comments field by id.

//close the app.
remoteWebDriver.quit();
```

## Mobile Chrome on Emulator or Real Device

Pre-requisites:

*  Make sure Chrome (an app with the package `com.android.chrome`) is installed on your device or emulator. Getting Chrome for the x86 version of the emulator is not currently possible without building Chromium, so you may want to run an ARM emulator and then copy a Chrome APK from a real device to get Chrome on an emulator.
*  If downloaded from [NPM](https://www.npmjs.org/package/appium), or running from the [.app](https://github.com/appium/appium-dot-app), nothing needs to be done. If running from source, the `reset` script will download ChromeDriver and put it in `build`. A particular version can be specified by passing the `--chromedriver-version` option (e.g., `./reset.sh --android --chromedriver-version 2.8`), otherwise the most recent one will be retrieved.

Then, use desired capabilities like these to run your test in Chrome:

```js
{
  app: 'chrome'
  , device: 'Android'
};
```




# <span id="mobile_methods.md"></span>Cross platform mobile methods


## Reset

Mobile reset will reset the app's state.

Ruby + [appium_lib gem](https://github.com/appium/ruby_lib)

```ruby
mobile :reset
```

Ruby without the gem

```ruby
@driver.execute_script 'mobile: reset'
```

## pullFile

Fetch a file from the device's filesystem, returning it base64 encoded.

Takes a single argument, `path`. On Android and iOS, this is either the path
to the file (relative to the root of the app's file system).  On iOS only,
if path starts with `/AppName.app`, which will be replaced with the
application's .app directory

```ruby
# Android and iOS
@driver.execute_script 'mobile: pullFile', {path: '/Library/AddressBook/AddressBook.sqlitedb'} #=> /Library/AddressBook/AddressBook.sqlitedb

# iOS only
@driver.execute_script 'mobile: pullFile, {path: '/UICatalog.app/logfile.log'} #=> /Applications/12323-452262-24241-23-124124/UICatalog.app/logfile.log
```

Ruby

```ruby
@driver.execute_script('mobile: pullFile', {path: '/Library/AddressBook/AddressBook.sqlitedb'})
```

## Android mobile methods

## KeyEvent

[KeyEvent](http://developer.android.com/reference/android/view/KeyEvent.html) enables sending a keycode to Android.

Press the system menu button in Java.

```java
HashMap<String, Integer> keycode = new HashMap<String, Integer>();
keycode.put("keycode", 82);
((JavascriptExecutor)driver).executeScript("mobile: keyevent", keycode);
```

Ruby + [appium_lib gem](https://github.com/appium/ruby_lib)

```ruby
mobile :keyevent, keycode: 82
```

Ruby without the gem

```ruby
@driver.execute_script 'mobile: keyevent', :keycode => 82
```

## Mobile find

Java

See [MobileFindJavaTest.java](https://github.com/appium/appium/blob/master/sample-code/examples/java/junit/src/test/java/com/saucelabs/appium/MobileFindJavaTest.java)

Ruby + [appium_lib gem](https://github.com/appium/ruby_lib)

```ruby
scroll_to 'Gallery'
```




# <span id="touch-actions.md"></span>Touch Actions


WebDriver provides an API to send some kinds of touch gestures to the devices,
for example, to long press an element you can do:

For iOS Application:

```java
final WebElement imageView = searchResults.findElement(By.tagName("ImageView"));
new TouchActions(driver).longPress(imageView).perform();
```

For Android Application:

Java:

```java
WebElement element = wd.findElement(By.name("API Demo"));
JavascriptExecutor js = (JavascriptExecutor) wd;
HashMap<String, String> tapObject = new HashMap<String, String>();
tapObject.put("element", ((RemoteWebElement) element).getId());
js.executeScript("mobile: longClick", tapObject);
```

Python:

```python
element = wd.find_element_by_xpath("your_element_xpath")
wd.execute_script("mobile: longClick",{ "touchCount": 1, "x": 0, "y": 300, "element":element.id })
```

Currently Appium support some of the gestures in the Touch Actions API:

* flick
* long press
* single tap

Some other gestures are supported through the "Alternative access method"
explained in [Automating mobile gestures](#gestures.md)




# <span id="troubleshooting.md"></span>Troubleshooting Appium


Here's what to do if you're experiencing problems, before you submit a ticket
to github or write to the appium-discuss mailing list.

## General

* Make sure you've followed the getting started steps in the [README](https://github.com/appium/appium/blob/master/README.md)
* Make sure your system is set up appropriately (i.e., XCode is updated,
  Android SDK is installed and `ANDROID_HOME` is set:
  [setup instructions](#running-on-osx.md)
* Make sure the paths to your applications are correct

## If you're running Appium.app

* Update the app and restart. If you get a message saying the app can't be updated,
  re-download it from [appium.io](http://appium.io).

## If you're running Appium from source

* `git pull` to make sure you're running the latest code
* Run the appropriate flavor of `reset.sh` based on what you're trying to
automate:
    
    ./reset.sh               # all
    ./reset.sh --ios         # ios-only
    ./reset.sh --android     # android-only
    ./reset.sh --selendroid  # selendroid-only
* You might also want to run `reset.sh` with the `--dev` flag if you want the
  test apps downloaded and built as well.
* You can also use `appium-doctor` to automatically verify that all
  dependencies are met. If running from source, you may have to use
  `bin/appium-doctor.js` or `node bin/appium-doctor.js`.
* If you get this error after upgrading to Android SDK 22: 
  `{ANDROID_HOME}/tools/ant/uibuild.xml:155: SDK does not have any Build Tools installed.`
In the Android SDK 22, the platform and build tools are split up into their
own items in the SDK manager. Make sure you install the build-tools and platform-tools.

## Android

* Make sure the Android emulator is up and running.
* It's sometimes useful to run `adb kill-server && adb devices`. This can
  reset the connection to the Android device.
* Make sure you set ANDROID_HOME pointing to the Android SDK directory

## IOS

* Make sure Instruments.app is not open
* If you're running the simulator, make sure your actual device is not
  plugged in
* Make sure the accessibility helper is turned off in your Settings app 
* Make sure the app is compiled for the version of the simulator that's being
  run
* If you've ever run Appium with sudo, you might need to `sudo rm
  /tmp/instruments_sock` and try again as not-sudo.
* If this is the first time you've run Appium, make sure to authorize the use
  of Instruments. Usually a box will pop up that you enter your password into
  . If you're running Appium from source, you can simply run `sudo grunt authorize`
  from the main repo to avoid getting this popup. If you're running from npm,
  run `sudo authorize_ios` instead.
* If you see `iOS Simulator failed to install the application.` and the
  paths are correct, try restarting the computer.

## Webview/Hybrid/Safari app support

* Make Sure you enable the 'Web Inspector' on the real device.
* Make Sure you enable the Safari - Advance Preferences- Developer menu for
  simulators.
* If you getting this error: select_port() failed, when trying to open the
  proxy, see this [discussion](https://groups.google.com/forum/#!topic/appium-discuss/tw2GaSN8WX0)

## FirefoxOS

* Make sure the Boot-to-Gecko simulator is up and running.
* Make sure the simulator screen is alive and unlocked (might require restarting B2G).

## Let the community know

Once you've tried the above steps and your issue still isn't resolved,
here's what you can do:

If you've found what you believe is a bug, go straight to the [issue tracker](https://github.com/appium/appium/issues)
and submit an issue describing the bug and a repro case.

If you're having trouble getting Appium working and the error messages Appium
provides are not clear, join the [mailing list](https://groups.google.com/d/forum/appium-discuss)
and send a message. Please include the following:

* How you're running Appium (Appium.app, npm, source)
* The client-side and server-side errors you're getting (i.e.,
"In Python this is the exception I get in my test script,
and here's a link to a paste of the Appium server output)
* Per above, it's very important to include a paste of the Appium server
output when it's run in verbose mode so that we can diagnose what's going on.

## Known Issues

* If you've installed Node from the Node website, it requires that you use sudo
  for `npm`. This is not ideal. Try to get node with `brew install node` instead!
* Webview support works on real iOS devices with a proxy, see [discussion](https://groups.google.com/d/msg/appium-discuss/u1ropm4OEbY/uJ3y422a5_kJ).
* Sometimes iOS UI elements become invalidated milliseconds after they are
  found. This results in an error that looks like `(null) cannot be tapped`.
  Sometimes the only solution is to put the finding-and-clicking code in a retry
  block.
* Appium may have difficulties finding the `node` executable if you've
  installed Node and npm via MacPorts. You must make sure that the MacPorts bin
  folder (`/opt/local/bin` by default) is added to `PATH` somewhere in your
  `~/.profile`, `~/.bash_profile` or `~/.bashrc`.

## Specific Errors

|Action|Error|Resolution|
|------|-----|----------|
|Running reset.sh|xcodebuild: error: SDK "iphonesimulator6.1" cannot be located|Install the iPhone 6.1 SDK _or_ build the test apps with a separate SDK, e.g., `grunt buildApp:UICatalog:iphonesimulator5.1`|




# <span id="style-guide.md"></span>Style guide for contributors


Thanks for your contribution to Appium! Here are the principles we use when
writing javascript. Please conform to these so we can merge your pull request
 without going back and forth about style. The main principle is: *make your
 code look like the surrounding code*.

## Rebasing

Commits in a pull request should consist of [logical changes](https://github.com/appium/appium/pull/920#issuecomment-21588553).
If there are multiple authors, make sure each author has their own commit.
It's not a good idea to modify author information. Merge commits should be
rebased out of pull requests.

## Linting

All code (except for code in `bootstrap.js` which uses proprietary Apple
methods) must pass JSLint. To check your code, you can simply run `grunt
lint` from the Appium repo dir. If you've created a new .js file,
please make sure it is covered by the wildcards in `grunt.js` or that it is
added specifically.

It's easy to have your code linted as you type, which makes the whole process
much smoother. We like [jshint](http://www.jshint.com),
which has integrations with a lot of source code editors. The file `
.jshintrc` is checked into the repo, and its contents are:

```json
{
  "laxcomma": true,
  "strict": true,
  "undef": true,
  "unused": true,
  "trailing": true,
  "node": true,
  "es5": true,
  "white": true,
  "indent": 2
}
```

These defined what we want to see warnings about, etc...,
while we're editing. See [this page](http://www.jshint.com/platforms/) for
the list of editors and platforms and how to get your editor set up with
automatic linting.

## Style notes

*   Use two spaces for indentation, *no tabs*
*   Use single spaces around operators

    ```js
    var x = 1;
    ```
    not
    ```js
    var x=1;
    ```        
    
*   Spaces after commas and colons in lists, objects, function calls, etc...

    ```js
    var x = myFunc("lol", {foo: bar, baz: boo});
    ```
    not
    ```js
    var x = myFunc("lol",{foo:bar,baz:boo});
    ```

*   Always end statements with semicolons
*   Comma-first

    ```js
    var x = {
      foo: 'bar'
    , baz: 'boo'
    , wuz: 'foz'
    };
    ```

*   Brackets for `function`, `if`, etc... go on same line, `else` gets sandwiched

    ```js
    if (foo === bar) {
      // do something
    } else {
      // do something else
    }
    ```

*   Space after `if`, `for`, and `function`:

    ```js
    if (foo === bar) {
    ```
    ```js
    for (var i = 0; i < 10; i ++) {
    ```
    ```js
    var lol = function (foo) {
    ```
    not
    ```js
    if(foo === bar) {
    ```
    ```js
    for(var i = 0; i < 10; i ++) {
    ```
    ```js
    var lol = function(foo) {
    ```

*   Avoid bracketless `if` for one-liners:

    ```js
    if (foo === bar) {
      foo++;
    }
    ```
    not
    ```js
    if (foo === bar)
      foo++;
    ```

*   Use `===`, not `==`, and `!==`, not `!=` for no surprises
*   Line length shouldn't be longer than 79 characters
*   Break up long strings like this:

    ```js
    myFunc("This is a really long string that's longer " +
            "than 79 characters so I broke it up, woo");
    ```

*   Comments should line up with code

    ```js
    if (foo === 5) {
      myFunc(foo);
      // foo++;
    }
    ```
    not
    ```js
    if (foo === 5) {
      myFunc(foo);
    //foo++;
    }
    ```

*   Subclassing by extending prototypes

    ```js
    var _ = require('underscore');

    var SuperClass = function () {
      this.init();
    };

    SuperClass.prototype.init = function () {
      // initialize
    };

    // Create a subclass
    
    var SubClass = function () {
        this.init();
    };

    _.extend(SubClass.prototype, SuperClass.prototype);
    ```

*   Callbacks are always last in function definitions

    ```js
    var foo = function (arg1, arg2, cb) {
      ...
    };
    ```

*   Define functions as variables

    ```js
    var myFunc = function (a, b, c) {};
    ```
    not
    ```js
    function myFunc (a, b, c) {}
    ```
    
*   Variable names should be camelCased:

    ```js
    var myVariable = 42;
    ```
    not
    ```js
    var my_variable = 42;
    ```

*    Check for undefined

    ```js
    typeof myVariable === "undefined"
    ```
    not
    ```js
    myVariable === undefined
    ```

## Test Style:
    
Keep on the same line if it makes sense semantically and length is not an issue:

Examples:

```js
  driver.elementByTagName('el1').should.become("123")
    .nodeify(done);
  
  driver
    .elementsByTagName('el1').should.eventually.have.length(0)
    .nodeify(done);
```

Alternatively use extra indents to improve readability:

```js
h.driver
  .elementById('comments')
    .clear()
    .click()
    .keys("hello world")
    .getValue()
    .should.become("hello world")
  .elementById('comments')
    .getValue().should.become("hello world")
  .nodeify(done);

h.driver
  .execute("'nan'--")
    .should.be.rejectedWith("status: 13")
  .nodeify(done);        
```




# <span id="grunt.md"></span>Appium grunt commands


[Grunt](http://gruntjs.com) is like make for Node.js! We use it to automate all
kinds of appium dev tasks. Here's what you can do:

|Task|Description|
|----|-----------|
|grunt lint|Run JSLint|
|grunt test|Run the unit tests|
|grunt unit|Run the unit tests|
|grunt buildApp:&lt;AppName&gt;:&lt;SDK&gt;|Build an iOS app for the iPhone Simulator.  Expects there to be a .app at `sample-code/apps/<AppName>/build/Release-iphonesimulator/<AppName>.app`. Default SDK is 'iphonesimulator6.0'|
|grunt signApp:&lt;certName&gt;|Signs the test app with an absolute path to an iOS dev certificate|
|grunt authorize|Authorize your simulator to run without prompting|
|grunt log|Tail appium.log (useful when running tests)|
|grunt configAndroidBootstrap|Configure the android bootstrap jar so it can be built with ant|
|grunt buildAndroidBootstrap|Build the android bootstrap jar with ant|
|grunt buildSelendroidServer|Build the selendroid server|
|grunt configAndroidApp:&lt;AppName&gt;|Configure an android test app so it can be built with ant. Expects an android project at `sample-code/apps/<AppName>`|
|grunt buildAndroidApp:&lt;AppName&gt;|Build an android app using ant. Expects the app to be at `sample-code/apps/<AppName>`|
|grunt installAndroidApp:&lt;AppName&gt;|Installs an android app to the currently running emulator or device|
|grunt docs|Generate docs|
|grunt generateAppiumIo|Take Appium's README.md and turn it into HTML for getting-started.html of appium.io|
|grunt setConfigVer:&lt;device&gt;|Say that &lt;device&gt; is configured for the version of Appium listed in package.json|

## Miscellaneous notes

By default, `grunt buildApp` builds apps using the iPhone 6.1 simulator SDK.
You can overwrite the simulator by passing another SDK to grunt (to figure out
which SDKs you have available, try `xcodebuild -showsdks`:

    > grunt buildApp:UICatalog:iphonesimulator6.0




# <span id="how-to-write-docs.md"></span>How to write docs


`#` is used to write a h1 header. Each document must start with a h1 header.
Don't use the `===` underline method of creating headers.

## Subheaders

`##` is used to write subheaders. Don't use the `---` underline method of
creating sub headers.

### Regular headers

`###` is used for headers that don't appear in the table of contents.
Don't use h4 `####`, h5 `#####`, or h6 `######`.

### Line breaks

Don't use line breaks such as `--` or `---`. This will confuse Slate.

### Linking

Link to another document using this syntax:  [link text](#filename.md)`

To link inside a document, use the `#` from the Slate URL.
`[go direct to json](#json-wire-protocol-server-extensions)`




# <span id="credits.md"></span>Credits


###  These are the projects that inspired us, or are depended upon to make Appium awesome.

* [Apple UIAutomation](http://developer.apple.com/library/ios/#documentation/DeveloperTools/Reference/UIAutomationRef/_index.html)
* [GhostDriver](https://github.com/detro/ghostdriver)
* [IOS Auto](https://github.com/penguinho/applecart)
* [IOS Driver](https://github.com/ios-driver/ios-driver)
* [Mechanic.js](https://github.com/jaykz52/mechanic)
* [node-webkit](https://github.com/rogerwang/node-webkit)
* [Remote Debug](https://github.com/leftlogic/remote-debug)
* [Selenium Project](http://code.google.com/p/selenium/)
* [ios-webkit-debug-proxy](https://github.com/google/ios-webkit-debug-proxy)


