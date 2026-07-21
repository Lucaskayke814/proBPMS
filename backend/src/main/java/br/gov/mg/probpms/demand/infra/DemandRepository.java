package br.gov.mg.probpms.demand.infra;

import br.gov.mg.probpms.demand.domain.DemandStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.Optional;

public interface DemandRepository extends JpaRepository<DemandEntity, java.util.UUID> {
  Page<DemandEntity> findByStatusAndDeletedAtIsNull(DemandStatus status, Pageable pageable);
  Page<DemandEntity> findByDeletedAtIsNull(Pageable pageable);
  Optional<DemandEntity> findByIdAndDeletedAtIsNull(java.util.UUID id);
}
