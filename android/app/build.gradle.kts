plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Apply Flutter Gradle Plugin after Android/Kotlin
}

android {
    namespace = "com.rajdeep.myapp"
    compileSdk = 35 // Android 15

    ndkVersion = "29.0.13113456" // Ensure compatibility

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.rajdeep.myapp"
        minSdk = 26               // Android 8.0 (minimum supported version)
        targetSdk = 35            // Android 15
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
