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
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
