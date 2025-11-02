plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.car_rental_project"
    compileSdk = 36 // ✅ aman untuk emulator Android 9

    compileOptions {
        isCoreLibraryDesugaringEnabled = true 
        // ✅ Desugaring tidak wajib untuk Flutter biasa
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.car_rental_project"
        minSdk = flutter.minSdkVersion       // ✅ aman untuk semua emulator
        targetSdk = 33     // ✅ cocok untuk Android 9–13
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false  // ✅ matikan dulu biar gampang debug
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    buildFeatures {
        viewBinding = true
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.8.22")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") 
}
