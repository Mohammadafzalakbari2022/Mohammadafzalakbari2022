allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Workaround for AGP 8+ requiring `namespace` in Android library modules.
// Some hosted Flutter plugins (notably `isar_flutter_libs`) still ship without it.
subprojects {
    afterEvaluate {
        if (name == "isar_flutter_libs") {
            plugins.withId("com.android.library") {
                // Reflection keeps this resilient across AGP versions.
                val androidExt = extensions.findByName("android") ?: return@withId
                runCatching {
                        androidExt
                            .javaClass
                            .methods
                            .firstOrNull { it.name == "setNamespace" && it.parameterTypes.size == 1 }
                            ?.invoke(androidExt, "com.isar.isar_flutter_libs")
                    }
                    .getOrNull()
            }
        }
    }
}

// `package:jni` and vendored `isar_flutter_libs` ship with low compileSdk values.
// Release resource linking needs API 31+ (`android:attr/lStar`). Match Flutter's template
// (`FlutterExtension.kt`: compileSdk 36, NDK 28.2).
subprojects {
    afterEvaluate {
        if (name != "jni" && name != "isar_flutter_libs") return@afterEvaluate
        val androidExt = extensions.findByName("android") ?: return@afterEvaluate
        val intType = Integer.TYPE
        runCatching {
                val setCompile =
                    androidExt.javaClass.methods.firstOrNull { m ->
                        (m.name == "setCompileSdk" || m.name == "setCompileSdkVersion") &&
                            m.parameterTypes.size == 1 &&
                            m.parameterTypes[0] == intType
                    }
                setCompile?.invoke(androidExt, 36)
            }
            .getOrNull()
        runCatching {
                androidExt
                    .javaClass
                    .methods
                    .firstOrNull { it.name == "setNdkVersion" && it.parameterTypes.size == 1 }
                    ?.invoke(androidExt, "28.2.13676358")
            }
            .getOrNull()
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
