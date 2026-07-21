# Guia de Correção de Erros de Compilação - proBPMS

## Status Atual
Há 11 problemas de compilação que precisam ser corrigidos antes do build final. A maioria é simples e rápida de resolver.

---

## Erros Identificados

### 1. ✅ CORRIGIDO: Missing `getSupplierName()` em ContractEntity
**Arquivo**: `backend/src/main/java/br/gov/mg/probpms/catalog/infra/ContractEntity.java`
**Erro**: Method `getSupplierName()` is undefined
**Solução**: Adicionado getter público para field `supplierName`
**Status**: ✅ Implementado

---

### 2. ❌ TODO: OperationalDtos.java - Múltiplos Records em Um Arquivo
**Arquivo**: `backend/src/main/java/br/gov/mg/probpms/operational/api/OperationalDtos.java`
**Erro**: The public type X must be defined in its own file
**Motivo**: Java não permite múltiplos tipos `public` em um arquivo

**Solução**: Separar em arquivos individuais:
```
OperationalController/
├── CreateFeatureRequest.java
├── FeatureResponse.java
├── CreateErrorRequest.java
├── ErrorResponse.java
├── CreateApiRequest.java
├── ApiResponse.java
├── CreatePublicationRequest.java
├── PublicationResponse.java
├── CreateModuleRequest.java
└── ModuleResponse.java
```

**Passo a passo**:
1. Criar pasta `operational/api/dto` se não existir
2. Copiar cada record para seu arquivo
3. Adicionar package e imports
4. Remover OperationalDtos.java
5. Atualizar OperationalController.java para importar dos novos arquivos

---

### 3. ❌ TODO: OpenApiConfig.java - Falta Dependency Swagger
**Arquivo**: `backend/src/main/java/br/gov/mg/probpms/api/OpenApiConfig.java`
**Erro**: The import `io.swagger` cannot be resolved
**Causa**: Dependency Springdoc não está no pom.xml

**Solução - Adicionar ao `pom.xml`**:
```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.6.0</version>
</dependency>
```

**Após adicionar**:
```bash
cd backend
mvn clean install
```

---

### 4. ❌ TODO: JwtService.java - Unhandled Exceptions
**Arquivo**: `backend/src/main/java/br/gov/mg/probpms/identity/application/JwtService.java`
**Erro**: Unhandled exception type Exception
**Linhas**: 44, 45, 58

**Solução**:
```java
public DecodedJWT verify(String token) {
  try {
    DecodedJWT decoded = JWT.decode(token);
    Jwk jwk = resolveJwk(decoded);  // Pode lançar Exception
    Algorithm algorithm = Algorithm.RSA256((RSAPublicKey) jwk.getPublicKey(), null);
    return JWT.require(algorithm).withIssuer(issuer).withClockSkewLeeway(60)
        .build().verify(decoded);
  } catch (Exception e) {
    throw new IllegalArgumentException("Invalid token", e);
  }
}

private Jwk resolveJwk(DecodedJWT decoded) throws Exception {  // Declarar throws
  String kid = decoded.getKeyId();
  return kid != null ? jwkProvider.get(kid) : jwkProvider.getAll().stream()
      .findFirst()
      .orElseThrow(() -> new IllegalArgumentException("No JWK found"));
}
```

---

### 5. ❌ TODO: JwtService.java - `getAll()` Method Não Existe
**Arquivo**: `backend/src/main/java/br/gov/mg/probpms/identity/application/JwtService.java`
**Erro**: The method `getAll()` is undefined for type JwkProvider
**Linha**: 58

**Solução**: Usar apenas `get(kid)`:
```java
private Jwk resolveJwk(DecodedJWT decoded) throws Exception {
  String kid = decoded.getKeyId();
  if (kid == null) {
    throw new IllegalArgumentException("Missing key ID in token");
  }
  return jwkProvider.get(kid);
}
```

---

### 6. ❌ TODO: SupabaseAuthService.java - Type Safety Warning
**Arquivo**: `backend/src/main/java/br/gov/mg/probpms/identity/application/SupabaseAuthService.java`
**Erro**: Type safety: The expression of type Map needs unchecked conversion
**Linha**: 41

**Solução - Adicionar type hint**:
```java
@SuppressWarnings("unchecked")
private Map<String, Object> parseResponse(String response) throws IOException {
  return new ObjectMapper().readValue(response, new TypeReference<Map<String, Object>>() {});
}
```

Ou mais simples:
```java
ObjectMapper mapper = new ObjectMapper();
@SuppressWarnings("unchecked")
Map<String, Object> result = (Map<String, Object>) mapper.readValue(response, Map.class);
return result;
```

---

### 7. ✅ OPTIONAL: Remove Unused Imports
**Arquivos com imports não usados**:
- `FinancialSummaryService.java` - linha 4 (BigDecimal)
- `FinancialCommandService.java` - linha 5 (FinancialMovementType)
- `JwtAuthenticationFilter.java` - linha 13 (Map)
- `OperationalController.java` - linha 7 (UUID)
- `SupabaseStorageService.java` - linha 8 (StandardCharsets)

**Solução**: Remover imports não usados
```bash
# IDE automático: Ctrl+Shift+O (Eclipse/VSCode)
# Ou manualmente deletar a linha
```

---

## Ordem de Correção Recomendada

1. **Primeiro**: OpenApiConfig (adicionar dependency ao pom.xml)
2. **Segundo**: OperationalDtos (separar records em arquivos)
3. **Terceiro**: JwtService (tratar exceptions)
4. **Quarto**: SupabaseAuthService (type safety)
5. **Quinto**: Remover imports não usados (opcional)

---

## Validação Final

Após corrigir, compilar e testar:

```bash
cd backend

# Limpar e recompilar
mvn clean compile

# Se tudo OK, fazer build
mvn clean package

# Se tudo OK, testar
mvn spring-boot:run
```

---

## Problemas Esperados em Tempo de Compilação vs Runtime

### Em Tempo de Compilação ✓ (Corrigir agora)
- Imports não resolvidos
- Métodos não encontrados
- Tipos inválidos
- Records em arquivo errado

### Em Tempo de Runtime ⚠️ (Testar depois)
- Connection database
- Supabase auth credentials
- JWT validation
- API routes

---

## Checklist de Correção

- [ ] OpenApiConfig: springdoc dependency adicionado ao pom.xml
- [ ] OperationalDtos: separado em 10 arquivos individuais
- [ ] JwtService: exceptions tratadas com try-catch
- [ ] JwtService: método resolveJwk corrigido
- [ ] SupabaseAuthService: type safety warning resolvido
- [ ] Imports não usados removidos
- [ ] `mvn clean compile` executa sem erros
- [ ] `mvn clean package` cria JAR com sucesso

---

## Próximo Passo

Após compilação bem-sucedida:

```bash
java -jar backend/target/probpms-api-*.jar
```

Acessar **http://localhost:8080/api/v1/health** para verificar.
