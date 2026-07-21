package br.gov.mg.probpms.demand.api;

import br.gov.mg.probpms.demand.domain.DemandStatus;
import java.time.LocalDate;
import java.util.UUID;

public record DemandResponse(UUID id, String code, String title, String agency, DemandStatus status, LocalDate dueDate) { }
