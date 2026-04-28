package com.github.keycloak.sms;

import java.util.regex.Pattern;

/**
 * Utility methods for sanitising and normalising phone numbers before they are
 * sent to an SMS gateway.
 *
 * <p>The normaliser:
 * <ol>
 *   <li>Strips all whitespace, dashes, dots, and parentheses.</li>
 *   <li>Converts a leading {@code 00} international prefix to {@code +}.</li>
 *   <li>Optionally prepends a country code when the number starts with a
 *       {@code 0} (local format) and a default country code is supplied.</li>
 * </ol>
 */
public final class PhoneNumberNormaliser {

    /** Allowed characters after stripping formatting: digits, leading '+'. */
    private static final Pattern STRIP = Pattern.compile("[\\s\\-.()+]");

    private PhoneNumberNormaliser() {
        // utility class
    }

    /**
     * Normalises a phone number to E.164 format.
     *
     * @param raw             raw phone number as typed by the user
     * @param defaultCountryCode country code WITHOUT the leading {@code +},
     *                           e.g. {@code "880"} for Bangladesh.
     *                           Pass {@code null} or empty to disable
     *                           country-code injection.
     * @return E.164-formatted phone number (e.g. {@code +8801712345678})
     * @throws IllegalArgumentException if the result contains non-digit
     *                                  characters (after stripping)
     */
    public static String normalise(String raw, String defaultCountryCode) {
        if (raw == null || raw.trim().isEmpty()) {
            throw new IllegalArgumentException("Phone number must not be blank");
        }

        // 1. Remove formatting characters but keep leading '+'
        String stripped = raw.trim();
        boolean hasPlus = stripped.startsWith("+");
        stripped = STRIP.matcher(stripped).replaceAll("");

        // 2. Convert 00-prefix international format  →  E.164
        if (stripped.startsWith("00")) {
            stripped = stripped.substring(2);
            hasPlus = true;
        }

        // 3. Inject default country code for local (0-prefixed) numbers
        if (!hasPlus && stripped.startsWith("0")
                && defaultCountryCode != null && !defaultCountryCode.isEmpty()) {
            stripped = defaultCountryCode + stripped.substring(1);
            hasPlus = true;
        }

        // 4. Validate: only digits should remain at this point
        if (!stripped.matches("\\d+")) {
            throw new IllegalArgumentException(
                    "Phone number contains invalid characters after normalisation: " + stripped);
        }

        return "+" + stripped;
    }

    /**
     * Convenience overload that uses no default country code.
     * Use when the user is expected to enter full international numbers.
     */
    public static String normalise(String raw) {
        return normalise(raw, null);
    }
}
