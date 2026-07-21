package br.gov.mg.probpms.demand.api;
import jakarta.validation.constraints.NotBlank;
public record CreateCommentRequest(@NotBlank String message) { }
