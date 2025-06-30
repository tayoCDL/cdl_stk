# Keep Play Core classes
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.splitinstall.** { *; }
-keep interface com.google.android.play.core.tasks.** { *; }
-keep interface com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
-keep class * implements com.google.android.play.core.tasks.OnSuccessListener { *; }
-keep class * implements com.google.android.play.core.tasks.OnFailureListener { *; }
-keepclassmembers class com.google.android.play.core.** { *; }

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep all classes referenced from Flutter application
-keep class * implements io.flutter.plugin.platform.PlatformView { *; }
-keep class * implements io.flutter.plugins.** { *; }

# Keep R8 rules for other plugins used in the app
-keep class io.flutter.plugins.webviewflutter.** { *; }
-keep class io.flutter.plugins.urllauncher.** { *; }
-keep class io.flutter.plugins.share.** { *; }

# Uncomment this to preserve the line number information for
# debugging stack traces.
-keepattributes SourceFile,LineNumberTable

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.firebase.** { *; }
-keep class org.apache.** { *; }
-keepnames class com.fasterxml.jackson.** { *; }
-keepnames class javax.servlet.** { *; }
-keepnames class org.ietf.jgss.** { *; }
-dontwarn org.w3c.dom.**
-dontwarn org.joda.time.**
-dontwarn org.shaded.apache.**
-dontwarn org.ietf.jgss.**

# Keep custom model classes
-keep class com.creditdirect.sales_toolkit.models.** { *; }
-keep class com.creditdirect.sales_toolkit.domain.** { *; }

# Keep plugin classes
-keep class com.mr.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
