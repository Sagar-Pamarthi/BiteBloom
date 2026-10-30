package com.tap.controller;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/** Sends OTP messages through configured SMTP; credentials are read from environment variables. */
public final class PasswordResetMailer {
    private PasswordResetMailer() { }

    public static void sendOtpEmail(String recipient, String otp, int expiryMinutes) throws MessagingException {
        final String host = requiredEnv("SMTP_HOST");
        final String port = envOrDefault("SMTP_PORT", "587");
        final String username = requiredEnv("SMTP_USERNAME");
        final String password = requiredEnv("SMTP_PASSWORD");
        final String from = requiredEnv("SMTP_FROM");

        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.starttls.required", "true");
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", port);
        properties.put("mail.smtp.connectiontimeout", "10000");
        properties.put("mail.smtp.timeout", "10000");
        properties.put("mail.smtp.writetimeout", "10000");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient, false));
        message.setSubject("Your BiteBloom password reset code", "UTF-8");
        message.setText(
                "Your BiteBloom password reset code is: " + otp + "\n\n"
                + "Enter this code on the BiteBloom password reset page within " + expiryMinutes + " minutes.\n"
                + "The code can be used once and expires after the time shown.\n\n"
                + "If you did not request a password reset, you can ignore this email.",
                "UTF-8");
        Transport.send(message);
    }

    private static String requiredEnv(String name) {
        String value = System.getenv(name);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalStateException("Required environment variable is not configured: " + name);
        }
        return value.trim();
    }

    private static String envOrDefault(String name, String fallback) {
        String value = System.getenv(name);
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }
}
