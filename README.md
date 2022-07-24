# Santhe Customer

Santhe is a platform built with an objective to Support Local Economy. The platform brings together local merchants like
Kirana Stores and other vendors with local customers in a competitive way. By using Santhe apps the customers can get
best deals and prices for their groceries & essentials from local merchants and shops, while enabling the merchants and
vendors to grow their business by accessing customers via online channel.

## Steps to PRODUCTION build

**IMPORTANT**<br>
Always update app version:<br>
Current Version: **1.0.0+1**<br>
Next Update: **1.0.0+2**<br>

1. Replace **google-services.json** in **android/app/google-services.json** with production firebase json.
2. Replace _dev to false in **lib/core/app_url.dart**
3. Change package name using:
   <br> **flutter pub run change_app_package_name:main com.santhe.customer** <br>
   in terminal.
4. Build flutter apk using:
   <br> **flutter clean**
   <br> **flutter build apk --split-per-abi**

## Steps to DEVELOPMENT build

**IMPORTANT**<br>
Always update app version:<br>
Current Version : **1.0.1+1**<br>
Next Update: **1.0.1+2**<br>

1. Replace **google-services.json** in **android/app/google-services.json** with development firebase json.
2. Replace _dev to true in **lib/core/app_url.dart**
3. Change package name using:
   <br> **flutter pub run change_app_package_name:main com.santhe.customer.dev** <br>
   in terminal.
4. Build flutter apk using:
   <br> **flutter clean**
   <br> **flutter build apk --split-per-abi**
