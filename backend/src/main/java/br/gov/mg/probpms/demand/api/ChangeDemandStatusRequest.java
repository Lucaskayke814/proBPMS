package br.gov.mg.probpms.demand.api;
import br.gov.mg.probpms.demand.domain.DemandStatus;
import jakarta.validation.constraints.NotNull;
public record ChangeDemandStatusRequest(@NotNull DemandStatus status) { }
