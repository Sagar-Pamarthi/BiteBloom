package com.tap.util;

import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Locale;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/** Secure generation and keyed hashing of short-lived password-reset OTPs. */
public final class PasswordResetOtpUtil {
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final String HMAC_ALGORITHM = "HmacSHA256";
    private static final String SECRET_ENV = "OTP_HASH_SECRET";

    private PasswordResetOtpUtil() { }

    /** Returns a zero-padded, uniformly generated six-digit code. */
    public static String generateOtp() {
        return String.format(Locale.ROOT, "%06d", RANDOM.nextInt(1_000_000));
    }

    /**
     * Hashes an OTP using HMAC-SHA256 and a server-only environment secret.
     * The normalized email is included so the same code for two users has a different hash.
     */
    public static String hashOtp(String email, String otp) {
        if (email == null || otp == null) {
            throw new IllegalArgumentException("Email and OTP are required.");
        }
        String secret = System.getenv(SECRET_ENV);
        if (secret == null || secret.trim().length() < 32) {
            throw new IllegalStateException("OTP_HASH_SECRET is missing or shorter than 32 characters.");
        }
        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        String payload = normalizedEmail + "\n" + otp;
        try {
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);
            mac.init(new SecretKeySpec(secret.trim().getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM));
            byte[] digest = mac.doFinal(payload.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder(digest.length * 2);
            for (byte value : digest) {
                hex.append(Character.forDigit((value >>> 4) & 0x0F, 16));
                hex.append(Character.forDigit(value & 0x0F, 16));
            }
            return hex.toString();
        } catch (GeneralSecurityException exception) {
            throw new IllegalStateException("Could not hash the password-reset OTP.", exception);
        }
    }

    /** Generate a random 32-byte secret in a Java utility if needed by local tooling. */
    public static String generateSecretForManualSetup() {
        byte[] secret = new byte[32];
        RANDOM.nextBytes(secret);
        return Base64.getEncoder().encodeToString(secret);
    }
}
