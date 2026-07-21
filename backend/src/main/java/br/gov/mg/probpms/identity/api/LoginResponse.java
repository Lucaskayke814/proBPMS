package br.gov.mg.probpms.identity.api;

public record LoginResponse(String accessToken, String tokenType, long expiresIn) { }
