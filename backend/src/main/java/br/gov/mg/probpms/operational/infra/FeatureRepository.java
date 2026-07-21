package br.gov.mg.probpms.operational.infra;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FeatureRepository extends JpaRepository<FeatureEntity, UUID> {
}
