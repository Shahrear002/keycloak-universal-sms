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
    <style>
/* ============================================================
   sms-otp.css  —  Universal SMS Authenticator challenge page
   Compatible with the Keycloak "base" / "keycloak" theme
   ============================================================ */

/* ---- Container ---- */
.sms-otp-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1rem;
    padding: 0.5rem 0;
}

/* ---- Phone icon ---- */
.sms-otp-icon {
    color: var(--pf-global--primary-color--100, #0066cc);
    margin-bottom: 0.25rem;
    animation: sms-pulse 2s ease-in-out infinite;
}

@keyframes sms-pulse {
    0%, 100% { transform: scale(1);   opacity: 1; }
    50%       { transform: scale(1.06); opacity: .8; }
}

/* ---- Instructional copy ---- */
.sms-otp-instruction {
    text-align: center;
    font-size: 1rem;
    color: var(--pf-global--Color--100, #151515);
    margin: 0;
}

.sms-otp-ttl {
    text-align: center;
    font-size: 0.85rem;
    color: var(--pf-global--Color--200, #6a6e73);
    margin: 0;
}

/* ---- Alert banner ---- */
.sms-otp-alert {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    width: 100%;
    padding: 0.65rem 1rem;
    border-radius: 4px;
    font-size: 0.9rem;
}

.sms-otp-alert--error {
    background: #fdf0ef;
    border: 1px solid #c9190b;
    color: #c9190b;
}

.sms-otp-alert--warning {
    background: #fdf4e6;
    border: 1px solid #f0ab00;
    color: #795600;
}

.sms-otp-alert__icon {
    font-weight: 700;
    font-size: 1rem;
}

/* ---- Form ---- */
.sms-otp-form {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}

.sms-otp-input-group {
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
}

.sms-otp-label {
    font-size: 0.875rem;
    font-weight: 600;
    color: var(--pf-global--Color--100, #151515);
}

.sms-otp-input {
    width: 100%;
    padding: 0.65rem 1rem;
    font-size: 1.5rem;
    letter-spacing: 0.35em;
    text-align: center;
    border: 1px solid var(--pf-global--BorderColor--100, #b8bbbe);
    border-radius: 4px;
    outline: none;
    transition: border-color 0.15s ease, box-shadow 0.15s ease;
    background: #fff;
    color: #151515;
}

.sms-otp-input:focus {
    border-color: var(--pf-global--primary-color--100, #0066cc);
    box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.18);
}

.sms-otp-hint {
    font-size: 0.78rem;
    color: var(--pf-global--Color--200, #6a6e73);
}

/* ---- Submit button ---- */
.sms-otp-btn {
    width: 100%;
    padding: 0.7rem 1rem;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.18s ease, transform 0.1s ease;
}

.sms-otp-btn--primary {
    background: var(--pf-global--primary-color--100, #0066cc);
    color: #fff;
}

.sms-otp-btn--primary:hover {
    background: var(--pf-global--primary-color--200, #004d99);
    transform: translateY(-1px);
}

.sms-otp-btn--primary:active {
    transform: translateY(0);
}

.sms-otp-btn--secondary {
    background: transparent;
    color: var(--pf-global--primary-color--100, #0066cc);
    border: 1px solid var(--pf-global--primary-color--100, #0066cc);
}

.sms-otp-btn--secondary:hover {
    background: rgba(0, 102, 204, 0.05);
    transform: translateY(-1px);
}

.sms-otp-btn--secondary:active {
    transform: translateY(0);
}

/* ---- Divider ---- */
.sms-otp-divider {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    width: 100%;
    color: var(--pf-global--Color--200, #6a6e73);
    font-size: 0.8rem;
}

.sms-otp-divider::before,
.sms-otp-divider::after {
    content: "";
    flex: 1;
    border-top: 1px solid var(--pf-global--BorderColor--100, #d2d2d2);
}

/* ---- Back link ---- */
.sms-otp-link {
    font-size: 0.875rem;
    color: var(--pf-global--primary-color--100, #0066cc);
    text-decoration: none;
}

.sms-otp-link:hover {
    text-decoration: underline;
}
    </style>
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
            <button id="sms-otp-resend"
                    type="submit"
                    class="sms-otp-btn sms-otp-btn--secondary"
                    name="resend"
                    value="true"
                    formnovalidate>
                ${msg("smsAuthResendButton")}
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
