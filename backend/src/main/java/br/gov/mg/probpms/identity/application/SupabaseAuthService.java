package br.gov.mg.probpms.identity.application;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;

@Service
public class SupabaseAuthService {
    private final String url;
    private final String key;
    private final HttpClient httpClient = HttpClient.newHttpClient();

    public SupabaseAuthService(
            @Value("${security.jwt.supabase-url:https://cyolmcowhfhymemmxgrn.supabase.co}") String url,
            @Value("${security.jwt.supabase-anon-key:${security.jwt.supabase-publishable-key:sb_publishable_pLhl-nX5gTgwe9p4bqdtAQ_HKJvDQUo}}") String key) {
        this.url = url;
        this.key = key;
    }

    public Map<String, Object> signIn(String email, String password) {
        try {
            String body = String.format("{\"email\":\"%s\",\"password\":\"%s\"}", escape(email), escape(password));
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url + "/auth/v1/token?grant_type=password"))
                    .header("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                    .header("apikey", key)
                    .header("Authorization", "Bearer " + key)
                    .POST(HttpRequest.BodyPublishers.ofString(body, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() >= 400) {
                throw new IllegalStateException("Falha ao autenticar no Supabase: " + response.body());
            }
            return new com.fasterxml.jackson.databind.ObjectMapper().readValue(response.body(), Map.class);
        } catch (Exception ex) {
            throw new IllegalStateException("Não foi possível autenticar com o Supabase", ex);
        }
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
