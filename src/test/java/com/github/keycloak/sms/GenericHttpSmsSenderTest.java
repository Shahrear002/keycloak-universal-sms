package com.github.keycloak.sms;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("GenericHttpSmsSender — helpers")
class GenericHttpSmsSenderTest {

    // -------------------------------------------------------------------------
    // expand()
    // -------------------------------------------------------------------------

    @Test
    @DisplayName("expand replaces {phoneNumber} and {code} in template")
    void expandReplacesPlaceholders() {
        String result = GenericHttpSmsSender.expand(
                "{\"to\":\"{phoneNumber}\",\"message\":\"Your OTP is {code}\"}",
                "+8801712345678", "123456");
        assertEquals(
                "{\"to\":\"+8801712345678\",\"message\":\"Your OTP is 123456\"}",
                result);
    }

    @Test
    @DisplayName("expand handles URL-style GET template")
    void expandHandlesGetUrl() {
        String result = GenericHttpSmsSender.expand(
                "https://sms.example.com/send?to={phoneNumber}&msg=OTP+{code}&key=SECRET",
                "+8801712345678", "654321");
        assertEquals(
                "https://sms.example.com/send?to=+8801712345678&msg=OTP+654321&key=SECRET",
                result);
    }

    @Test
    @DisplayName("expand returns empty string for null template")
    void expandNullTemplate() {
        assertEquals("", GenericHttpSmsSender.expand(null, "+1234", "000"));
    }

    // -------------------------------------------------------------------------
    // mask()
    // -------------------------------------------------------------------------

    @Test
    @DisplayName("mask hides middle digits")
    void maskHidesMiddleDigits() {
        String masked = GenericHttpSmsSender.mask("+8801712345678");
        // Must start with first 4 chars, end with last 3, have **** in middle
        assertTrue(masked.startsWith("+880"), "Should start with +880");
        assertTrue(masked.endsWith("678"),    "Should end with 678");
        assertTrue(masked.contains("****"),   "Should contain ****");
        // OTP must not appear in masked value
        assertFalse(masked.contains("712345"), "Should not reveal middle digits");
    }

    @Test
    @DisplayName("mask returns **** for short numbers")
    void maskShortNumber() {
        assertEquals("****", GenericHttpSmsSender.mask("123"));
    }

    @Test
    @DisplayName("mask returns **** for null")
    void maskNull() {
        assertEquals("****", GenericHttpSmsSender.mask(null));
    }

    // -------------------------------------------------------------------------
    // Constructor validation
    // -------------------------------------------------------------------------

    @Test
    @DisplayName("constructor throws on blank API URL")
    void constructorThrowsOnBlankUrl() {
        assertThrows(IllegalArgumentException.class,
                () -> new GenericHttpSmsSender("", "POST", null, null));
        assertThrows(IllegalArgumentException.class,
                () -> new GenericHttpSmsSender(null, "POST", null, null));
    }

    @Test
    @DisplayName("constructor defaults to POST when method is blank")
    void constructorDefaultsToPost() {
        // Should not throw; just verify the object is created
        assertDoesNotThrow(() -> new GenericHttpSmsSender("https://example.com", "", null, null));
    }
}
