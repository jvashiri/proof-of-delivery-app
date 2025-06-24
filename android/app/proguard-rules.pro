# Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# For reflection, JSON parsing, etc. (adjust your package name)
-keep class za.webfarming.deliveryapp.** { *; }

# Prevent stripping method/field names used by certain packages
-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.lifecycle.**
