<#-- sms-validation.ftl — Keycloak SMS OTP Challenge Screen
     Theme: Universal SMS Authenticator
     Compatible with Keycloak 17+ (Quarkus / Freemarker 2.x)

     Available template variables:
       ${phoneNumber}  — obfuscated phone number (e.g. +880 171****678)
       ${ttlMinutes}   — OTP lifetime in minutes
       ${msg("key")}   — i18n message lookup
-->
<#import "template.ftl" as layout>

<@layout.registrationLayout displayInfo=true; section>

    <#-- ===== Header ===== -->
    <#if section = "header">
        ${msg("smsAuthTitle")}

    <#-- ===== Body ===== -->
    <#elseif section = "form">
    <div class="sms-otp-container">

        <#-- Icon -->
        <div class="sms-otp-icon" aria-hidden="true">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                 stroke="currentColor" stroke-width="1.8" stroke-linecap="round"
                 stroke-linejoin="round" width="56" height="56">
                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07
                         19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67
                         A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81
                         a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27
                         a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7
                         A2 2 0 0 1 22 16.92z"/>
            </svg>
        </div>

        <#-- Instructional text -->
        <p class="sms-otp-instruction">
            ${msg("smsAuthInstruction", phoneNumber!"")}
        </p>
        <p class="sms-otp-ttl">
            ${msg("smsAuthTtlHint", ttlMinutes!5)}
        </p>

        <#-- Error alert -->
        <#if message?has_content && (message.type = "error" || message.type = "warning")>
        <div class="sms-otp-alert sms-otp-alert--${message.type}" role="alert">
            <span class="sms-otp-alert__icon" aria-hidden="true">
                <#if message.type = "error">✕<#else>⚠</#if>
            </span>
            <span>${kcSanitize(message.summary)?no_esc}</span>
        </div>
        </#if>

        <#-- OTP Form -->
        <form id="sms-otp-form"
              action="${url.loginAction}"
              method="post"
              class="sms-otp-form"
              autocomplete="off">

            <div class="sms-otp-input-group">
                <label for="code" class="sms-otp-label">
                    ${msg("smsAuthCodeLabel")}
                </label>
                <input id="code"
                       name="code"
                       type="text"
                       inputmode="numeric"
                       pattern="[0-9]*"
                       maxlength="8"
                       autocomplete="one-time-code"
                       class="sms-otp-input"
                       placeholder="••••••"
                       autofocus
                       required
                       aria-describedby="code-hint"/>
                <span id="code-hint" class="sms-otp-hint">
                    ${msg("smsAuthCodeHint")}
                </span>
            </div>

            <button id="sms-otp-submit"
                    type="submit"
                    class="sms-otp-btn sms-otp-btn--primary"
                    name="login"
                    value="true">
                ${msg("smsAuthVerifyButton")}
            </button>

        </form>

        <#-- Divider + back link -->
        <div class="sms-otp-divider">
            <span>${msg("smsAuthOr")}</span>
        </div>

        <a href="${url.loginUrl}" class="sms-otp-link">
            ${msg("smsAuthBackToLogin")}
        </a>

    </div><!-- /.sms-otp-container -->

    <#-- ===== Info block below the card ===== -->
    <#elseif section = "info">
        ${msg("smsAuthInfoNote")}

    </#if>
</@layout.registrationLayout>
