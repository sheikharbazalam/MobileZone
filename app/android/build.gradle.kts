// Top-level build.gradle.kts

plugins {
    // Android Gradle Plugin
    id("com.android.application") apply false
    id("com.android.library") apply false

    // Kotlin
    id("org.jetbrains.kotlin.android") apply false

    // DO NOT specify versions for Firebase plugins in Flutter projects
    id("com.google.gms.google-services") apply false
    id("com.google.firebase.crashlytics") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Custom build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
