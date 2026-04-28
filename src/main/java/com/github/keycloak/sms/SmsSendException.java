package com.github.keycloak.sms;

/**
 * Thrown when an SMS could not be delivered to the gateway.
 *
 * <p>The message should contain enough context for operators to diagnose the
 * failure without leaking sensitive data (OTP values must never appear in
 * exception messages).
 */
public class SmsSendException extends Exception {

    private static final long serialVersionUID = 1L;

    /** HTTP status code returned by the gateway, or -1 if unavailable. */
    private final int httpStatusCode;

    public SmsSendException(String message) {
        super(message);
        this.httpStatusCode = -1;
    }

    public SmsSendException(String message, Throwable cause) {
        super(message, cause);
        this.httpStatusCode = -1;
    }

    public SmsSendException(String message, int httpStatusCode) {
        super(message);
        this.httpStatusCode = httpStatusCode;
    }

    public SmsSendException(String message, int httpStatusCode, Throwable cause) {
        super(message, cause);
        this.httpStatusCode = httpStatusCode;
    }

    /**
     * Returns the HTTP status code from the upstream gateway response, or
     * {@code -1} if the request never reached the gateway (e.g. timeout,
     * DNS failure).
     */
    public int getHttpStatusCode() {
        return httpStatusCode;
    }
}
