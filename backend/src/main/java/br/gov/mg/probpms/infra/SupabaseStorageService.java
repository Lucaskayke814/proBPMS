package br.gov.mg.probpms.infra;

import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;

@Service
public class SupabaseStorageService {
    private final String supabaseUrl;
    private final String secretKey;
    private final HttpClient httpClient = HttpClient.newHttpClient();

    public SupabaseStorageService(
            @Value("${security.jwt.supabase-url:https://cyolmcowhfhymemmxgrn.supabase.co}") String supabaseUrl,
            @Value("${security.jwt.supabase-secret-key:sb_secret_IkxGFMeYY2GMSVQemViUEA_fzfIPykE}") String secretKey) {
        this.supabaseUrl = supabaseUrl;
        this.secretKey = secretKey;
    }

    public Map<String, Object> uploadFile(String bucket, String filePath, InputStream fileStream, String contentType) {
        try {
            byte[] fileData = fileStream.readAllBytes();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(supabaseUrl + "/storage/v1/object/" + bucket + "/" + filePath))
                    .header("Authorization", "Bearer " + secretKey)
                    .header("Content-Type",
                            contentType != null ? contentType : MediaType.APPLICATION_OCTET_STREAM_VALUE)
                    .POST(HttpRequest.BodyPublishers.ofByteArray(fileData))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() >= 400) {
                throw new IllegalStateException("Falha ao fazer upload no Supabase Storage: " + response.body());
            }

            Map<String, Object> result = new HashMap<>();
            result.put("bucket", bucket);
            result.put("path", filePath);
            result.put("url", supabaseUrl + "/storage/v1/object/public/" + bucket + "/" + filePath);
            return result;
        } catch (Exception ex) {
            throw new IllegalStateException("Não foi possível fazer upload do arquivo", ex);
        }
    }

    public void deleteFile(String bucket, String filePath) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(supabaseUrl + "/storage/v1/object/" + bucket + "/" + filePath))
                    .header("Authorization", "Bearer " + secretKey)
                    .DELETE()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() >= 400) {
                throw new IllegalStateException("Falha ao deletar arquivo do Supabase Storage: " + response.body());
            }
        } catch (Exception ex) {
            throw new IllegalStateException("Não foi possível deletar o arquivo", ex);
        }
    }
}
