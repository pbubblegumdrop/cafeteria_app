plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // ❌ Removed version here
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Apply it here
}

android {
    namespace = "com.example.the_cafeteria_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.the_cafeteria_app"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
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

dependencies {
    // ✅ Firebase BoM (Bill of Materials)
    implementation(platform("com.google.firebase:firebase-bom:33.14.0"))

    // ✅ Firebase SDKs you need
    implementation("com.google.firebase:firebase-analytics")
}
