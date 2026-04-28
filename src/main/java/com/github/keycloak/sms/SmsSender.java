package com.github.keycloak.sms;

/**
 * Provider-agnostic SMS sending contract.
 *
 * <p>Implement this interface to integrate any SMS gateway. The bundled
 * {@link GenericHttpSmsSender} covers the vast majority of REST-based gateways
 * without writing a single line of code — just configure it in the Keycloak
 * Admin Console.
 *
 * <p>Custom implementations can be registered via standard Java SPI
 * ({@code META-INF/services/com.github.keycloak.sms.SmsSender}) if you need
 * SDK-based integrations (Twilio, AWS SNS, etc.).
 */
public interface SmsSender {

    /**
     * Sends a one-time-password to the given phone number.
     *
     * @param phoneNumber the normalised E.164 phone number (e.g. {@code +8801712345678})
     * @param code        the OTP to deliver
     * @throws SmsSendException if the message could not be delivered
     */
    void send(String phoneNumber, String code) throws SmsSendException;
}
