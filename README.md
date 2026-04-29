# Keycloak Universal SMS Authenticator

[![Maven Central](https://img.shields.io/maven-central/v/io.github.shahrear002/keycloak-universal-sms.svg?label=Maven%20Central)](https://search.maven.org/artifact/io.github.shahrear002/keycloak-universal-sms)

A production-ready, provider-agnostic SMS Authenticator SPI for modern **Keycloak 17+ (Quarkus)**. 

This plugin allows you to add SMS-based 2FA / OTP to your Keycloak authentication flows without writing custom Java code for specific SMS gateways (like Twilio, AWS SNS, Infobip, etc.). Instead, you configure your SMS gateway's REST API details directly in the Keycloak Admin Console.

## Features

- **Provider Agnostic**: Works with almost any HTTP/REST-based SMS gateway.
- **Admin Console Configured**: Define URL, Method (GET/POST), Headers, and Payload templates from the UI.
- **Secure & Resilient**: Implements constant-time OTP comparison, configurable Time-To-Live (TTL), and never logs OTP values.
- **Phone Normalisation**: Automatically cleans up user input, strips spaces, and converts local numbers to E.164 format.
- **Customisable UI**: Comes with a clean, responsive FreeMarker template (`sms-validation.ftl`) that you can override in your own theme.
- **Zero Dependencies**: Uses standard Java 11+ HTTP clients; doesn't bloat your Keycloak deployment.

---

## 📦 Installation

### Option 1: Maven Dependency
If you are building a custom Keycloak distribution or want to include this in your own project, you can pull it directly from Maven Central:

```xml
<dependency>
    <groupId>io.github.shahrear002</groupId>
    <artifactId>keycloak-universal-sms</artifactId>
    <version>1.0.0</version>
</dependency>
```

### Option 2: Manual Build

1. **Build the JAR**
   Make sure you have JDK 11+ and Maven installed.
   ```bash
   mvn clean package
   ```
   This produces a fat JAR at `target/keycloak-universal-sms-1.0.0.jar`.

2. **Deploy to Keycloak**
   Copy the generated JAR into your Keycloak `providers/` directory:
   ```bash
   cp target/keycloak-universal-sms-1.0.0.jar /opt/keycloak/providers/
   ```

3. **Rebuild Keycloak (Quarkus only)**
   For Keycloak 17+, you must run a build step to register the new provider:
   ```bash
   /opt/keycloak/bin/kc.sh build
   ```

4. **Restart Keycloak**
   ```bash
   /opt/keycloak/bin/kc.sh start
   ```

---

## ⚙️ Configuration in Keycloak

### 1. Add the Authenticator to a Flow

1. Go to the Keycloak Admin Console -> **Authentication**.
2. Duplicate the **Browser** flow (call it e.g., "Browser with SMS 2FA").
3. Find the execution step where you want to require SMS (usually after Username/Password).
4. Click **Add execution** and select **Universal SMS OTP**.
5. Set its requirement to **Required** or **Alternative** depending on your needs.
6. Bind this new flow as the default Browser flow for the realm.

### 2. Configure the SMS Gateway

On the "Universal SMS OTP" execution you just added, click the **⚙️ (Config)** icon or **Actions -> Config**.

Fill in the fields based on your SMS Gateway provider:

#### Example 1: Twilio (POST / Form-Encoded)
- **SMS API URL**: `https://api.twilio.com/2010-04-01/Accounts/YOUR_ACCOUNT_SID/Messages.json`
- **HTTP Method**: `POST`
- **Authorization Header Value**: `Basic base64(YOUR_ACCOUNT_SID:YOUR_AUTH_TOKEN)`
- **Payload Template**: `To={phoneNumber}&From=%2B15005550006&Body=Your+Keycloak+verification+code+is+{code}`

#### Example 2: Generic JSON API (POST)
- **SMS API URL**: `https://api.some-gateway.com/v1/send`
- **HTTP Method**: `POST`
- **Authorization Header Value**: `Bearer YOUR_API_KEY`
- **Payload Template**: `{"to":"{phoneNumber}","message":"Your OTP is {code}"}`

#### Example 3: Simple GET Gateway
- **SMS API URL**: `https://sms.example.com/send?to={phoneNumber}&msg=OTP+{code}&key=SECRET_KEY`
- **HTTP Method**: `GET`
- **Authorization Header Value**: *(Leave blank)*
- **Payload Template**: *(Leave blank)*

### 3. Ensure Users Have Phone Numbers

The authenticator looks for a user attribute named `phoneNumber`. 
- Make sure your users have this attribute populated.
- The value should ideally be in E.164 format (e.g., `+1234567890`), but the plugin attempts to normalise local formats automatically.
- To handle local numbers safely, you can set the **Default Country Code** (e.g. `880`) in the authenticator config.

---

## 🎨 UI & Theme Customisation

The plugin provides a default template: `sms-validation.ftl`.

To customise it:
1. Copy `src/main/resources/theme-resources/templates/sms-validation.ftl` into your custom Keycloak theme's `login/` folder.
2. Edit the HTML/CSS as needed.
3. You can override the text by copying the keys from `src/main/resources/theme-resources/messages/messages_en.properties` into your theme's message bundles.

---

## 💻 Developer Guide: Writing a Custom Sender

If you have highly specific needs (e.g., AWS SNS SDK integration, cryptographic signing of requests), you can implement the `SmsSender` interface in Java instead of using the generic HTTP sender.

1. Create a class implementing `com.github.keycloak.sms.SmsSender`.
2. Register it using the Java SPI mechanism by creating `META-INF/services/com.github.keycloak.sms.SmsSender`.
3. Modify `SmsAuthenticator.java` to load your custom SPI implementation instead of instantiating `GenericHttpSmsSender`.

---

## License

Apache License, Version 2.0. See `LICENSE` for details.
