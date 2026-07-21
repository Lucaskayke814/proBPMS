package br.gov.mg.probpms.demand.api;
import java.time.Instant; import java.util.UUID;
public record DemandCommentResponse(UUID id,String message,String author,Instant createdAt) { }
