package br.gov.mg.probpms.api;

import java.time.Instant;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ApiExceptionHandler {
  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<Map<String, Object>> validation(MethodArgumentNotValidException exception) {
    var fields = exception.getBindingResult().getFieldErrors().stream()
        .collect(java.util.stream.Collectors.toMap(error -> error.getField(), error -> error.getDefaultMessage(), (a, b) -> a));
    return ResponseEntity.badRequest().body(Map.of("status", 400, "message", "Dados inválidos", "fields", fields, "timestamp", Instant.now().toString()));
  }
  @ExceptionHandler(MethodArgumentTypeMismatchException.class)
  public ResponseEntity<Map<String, Object>> invalidParameter(MethodArgumentTypeMismatchException exception) {
    return ResponseEntity.badRequest().body(Map.of("status", 400, "message", "Parâmetro inválido: " + exception.getName(), "timestamp", Instant.now().toString()));
  }
  @ExceptionHandler(DataIntegrityViolationException.class)
  public ResponseEntity<Map<String, Object>> conflict(DataIntegrityViolationException exception) {
    return ResponseEntity.status(HttpStatus.CONFLICT).body(Map.of("status", 409, "message", "Já existe um registro com estes dados únicos", "timestamp", Instant.now().toString()));
  }
  @ExceptionHandler(ResponseStatusException.class)
  public ResponseEntity<Map<String, Object>> business(ResponseStatusException exception) {
    var status = exception.getStatusCode();
    var message = exception.getReason() == null ? "Operação não permitida" : exception.getReason();
    return ResponseEntity.status(status).body(Map.of("status", status.value(), "message", message, "timestamp", Instant.now().toString()));
  }
  @ExceptionHandler(Exception.class)
  public ResponseEntity<Map<String, Object>> unexpected(Exception exception) {
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
        .body(Map.of("status", 500, "message", "Ocorreu um erro inesperado", "timestamp", Instant.now().toString()));
  }
}
