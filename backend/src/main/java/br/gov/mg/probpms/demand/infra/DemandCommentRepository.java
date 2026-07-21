package br.gov.mg.probpms.demand.infra;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
public interface DemandCommentRepository extends JpaRepository<DemandCommentEntity,UUID>{List<DemandCommentEntity> findByDemandIdOrderByCreatedAtDesc(UUID demandId);}
