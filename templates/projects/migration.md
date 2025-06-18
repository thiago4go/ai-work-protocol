---
type: project
status: active
priority: high
created: {{DATE}}
updated: {{DATE}}
title: {{TITLE}}
description: Data or system migration project
---

# PROJECT: {{TITLE}}

## Goal
Migrate {{WHAT}} from {{SOURCE}} to {{DESTINATION}}

## Context
- **Scale**: {{DATA_SIZE}} records, {{STORAGE_SIZE}}GB
- **Downtime Window**: {{ACCEPTABLE_DOWNTIME}}
- **Criticality**: {{BUSINESS_IMPACT_IF_FAILED}}

## Success Criteria
1. **Complete**: 100% of data successfully migrated
2. **Accurate**: Zero data loss, checksums match
3. **Timely**: Completed within {{TIME_WINDOW}}

## Migration Strategy
- [ ] **Analyze Source**: Document schema, count records (1 day)
- [ ] **Build Pipeline**: Create migration scripts + validation (2 days)
- [ ] **Test Migration**: Run on subset, verify accuracy (1 day)
- [ ] **Dry Run**: Full migration to staging (1 day)
- [ ] **Execute**: Production migration with monitoring (1 day)
- [ ] **Validate**: Confirm all data, cleanup source (1 day)

## Migration Details
- **Data Types**: {{TABLES/COLLECTIONS/FILES}}
- **Transformation**: {{ANY_SCHEMA_CHANGES}}
- **Dependencies**: {{WHAT_DEPENDS_ON_THIS_DATA}}

## Rollback Plan
1. **Before Point of No Return**: Stop migration, revert to source
2. **After Point of No Return**: Reverse migrate from destination
3. **Emergency**: Restore from backup taken at {{BACKUP_TIME}}

## Constraints
- **Zero Data Loss**: Every record must be accounted for
- **Minimal Downtime**: Use {{STRATEGY}} approach
- **Audit Trail**: Log every record migrated

---INSTRUCTIONS---
This template inherits from base_project.md workflow.

<migration_specific>
For MIGRATION projects:
- Count everything twice (source & destination)
- Test with real data subset first
- Have rollback plan for each phase
- Monitor throughout migration
- Keep source until verified

<migration_queries>
Before starting:
```
# Find similar migrations
rag_memory___hybridSearch query="migration {{SOURCE}} {{DESTINATION}}"
rag_memory___searchNodes query="type:project category:migration"

# Find migration issues
rag_memory___searchNodes query="type:bug category:migration data loss"
```
</migration_queries>

<migration_checklist>
Pre-migration:
- [ ] Full backup taken
- [ ] Migration scripts tested
- [ ] Rollback tested
- [ ] Stakeholders notified

Post-migration:
- [ ] Record counts match
- [ ] Checksums verified
- [ ] Applications working
- [ ] Performance normal
</migration_checklist>
</migration_specific>
---END-INSTRUCTIONS---