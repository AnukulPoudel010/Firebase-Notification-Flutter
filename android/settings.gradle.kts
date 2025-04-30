pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // needed to make changes here too but already made by flutter so just changing version to 8.6.0
    id("com.android.application") version "8.6.0" apply false
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version("4.3.15") apply false
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
}

include(":app")

// added here as a remainder 
//There have been reports that enabling desugaring may result in a Flutter apps crashing on Android 12L and above. This would be an issue with Flutter itself, not the plugin. One possible fix is adding the WindowManager library as a dependency:
//Kotlin - build.gradle.kts

//dependencies {
//    implementation("androidx.window:window:1.0.0")
//    implementation("androidx.window:window-java:1.0.0")
//    ...
//}
