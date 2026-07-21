package br.gov.mg.probpms.operational.infra;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "error_report")
public class ErrorEntity {
    @Id
    private UUID id;
    @Column(name = "system_name", nullable = false)
    private String systemName;
    @Column(nullable = false, columnDefinition = "text")
    private String description;
    @Column(nullable = false)
    private String severity;
    @Column
    private String environment;
    @Column(name = "steps_to_reproduce", columnDefinition = "text")
    private String stepsToReproduce;
    @Column(name = "print_path")
    private String printPath;
    @Column(name = "video_url")
    private String videoUrl;
    @Column(name = "responsible_name")
    private String responsibleName;
    @Column
    private String version;
    @Column(name = "correction_notes", columnDefinition = "text")
    private String correctionNotes;
    @Column(nullable = false)
    private String status;
    @Column(name = "resolution_time_hours")
    private BigDecimal resolutionTimeHours;
    @Column(name = "created_at", nullable = false)
    private Instant createdAt;
    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    protected ErrorEntity() {
    }

    public ErrorEntity(UUID id, String systemName, String description, String severity, String environment,
            String stepsToReproduce, String printPath, String videoUrl, String responsibleName, String version,
            String correctionNotes, String status, BigDecimal resolutionTimeHours) {
        this.id = id;
        this.systemName = systemName;
        this.description = description;
        this.severity = severity == null ? "MEDIA" : severity;
        this.environment = environment;
        this.stepsToReproduce = stepsToReproduce;
        this.printPath = printPath;
        this.videoUrl = videoUrl;
        this.responsibleName = responsibleName;
        this.version = version;
        this.correctionNotes = correctionNotes;
        this.status = status == null ? "OPEN" : status;
        this.resolutionTimeHours = resolutionTimeHours;
        this.createdAt = Instant.now();
        this.updatedAt = this.createdAt;
    }

    public UUID getId() {
        return id;
    }

    public String getSystemName() {
        return systemName;
    }

    public String getSeverity() {
        return severity;
    }

    public String getStatus() {
        return status;
    }

    public String getResponsibleName() {
        return responsibleName;
    }
}
