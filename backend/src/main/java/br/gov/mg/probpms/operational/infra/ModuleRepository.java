package br.gov.mg.probpms.operational.infra;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ModuleRepository extends JpaRepository<ModuleEntity, UUID> {
}
