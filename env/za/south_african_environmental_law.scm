;; South African Environmental Law Framework
;; Scheme implementation based on NEMA and related environmental legislation

;; =============================================================================
;; CORE ENVIRONMENTAL PRINCIPLES (NEMA)
;; =============================================================================

;; National Environmental Management Principles
(define nema-principles? (lambda (action)
  (and (sustainable-development? action)
       (polluter-pays? action)
       (precautionary-principle? action)
       (waste-minimization? action)
       (environmental-justice? action))))

;; Sustainable Development
(define sustainable-development? (lambda (action)
  (and (meets-present-needs? action)
       (not-compromise-future-generations? action)
       (balances-economic-social-environmental? action))))

;; Precautionary Principle
(define precautionary-principle? (lambda (action)
  (and (risk-of-serious-harm? action)
       (lack-of-scientific-certainty? action)
       (preventive-measures-taken? action))))

;; =============================================================================
;; ENVIRONMENTAL IMPACT ASSESSMENT (EIA)
;; =============================================================================

(define eia-required? (lambda (activity)
  (or (listed-activity? activity)
      (potential-significant-impact? activity))))

(define eia-process-compliant? (lambda (process)
  (and (screening-done? process)
       (scoping-conducted? process)
       (impact-assessment-done? process)
       (public-participation? process)
       (environmental-management-plan? process)
       (authorization-obtained? process))))

;; =============================================================================
;; ENVIRONMENTAL AUTHORIZATION
;; =============================================================================

(define environmental-authorization-valid? (lambda (authorization)
  (and (competent-authority-granted? authorization)
       (eia-process-followed? authorization)
       (conditions-complied-with? authorization)
       (not-expired? authorization))))

;; =============================================================================
;; POLLUTION AND WASTE MANAGEMENT
;; =============================================================================

;; Air Quality
(define air-quality-compliant? (lambda (activity)
  (and (atmospheric-emission-license? activity)
       (emission-standards-met? activity)
       (monitoring-and-reporting? activity))))

;; Water Use
(define water-use-authorized? (lambda (use)
  (and (water-use-license? use)
       (efficient-water-use? use)
       (no-pollution-of-water-resources? use))))

;; Waste Management
(define waste-management-compliant? (lambda (waste)
  (and (waste-management-license? waste)
       (waste-hierarchy-followed? waste)
       (cradle-to-grave-responsibility? waste)
       (proper-disposal? waste))))

;; Waste Hierarchy
(define waste-hierarchy-followed? (lambda (waste)
  (prioritizes-in-order? waste 
    '(avoidance reduction reuse recycling recovery treatment disposal))))

;; =============================================================================
;; BIODIVERSITY AND CONSERVATION
;; =============================================================================

;; Protected Areas
(define protected-area-compliant? (lambda (activity)
  (and (within-protected-area? activity)
       (permit-obtained? activity)
       (conservation-objectives-met? activity))))

;; Threatened Species
(define threatened-species-protected? (lambda (activity)
  (and (no-harm-to-endangered-species? activity)
       (habitat-protection? activity)
       (permit-if-required? activity))))

;; =============================================================================
;; ENVIRONMENTAL COMPLIANCE AND ENFORCEMENT
;; =============================================================================

;; Duty of Care
(define duty-of-care-environment? (lambda (person)
  (and (take-reasonable-measures? person)
       (prevent-pollution? person)
       (prevent-degradation? person)
       (remedy-damage? person))))

;; Environmental Management Inspector
(define inspector-powers? (lambda (inspector)
  (and (right-to-enter-premises? inspector)
       (right-to-inspect? inspector)
       (right-to-take-samples? inspector)
       (issue-compliance-notice? inspector)
       (issue-directives? inspector))))

;; Compliance Notice
(define compliance-notice-valid? (lambda (notice)
  (and (issued-by-authorized-person? notice)
       (specifies-non-compliance? notice)
       (remedial-measures-specified? notice)
       (timeframe-for-compliance? notice))))

;; =============================================================================
;; ENVIRONMENTAL OFFENCES
;; =============================================================================

(define environmental-offence? (lambda (act)
  (or (pollution-without-authorization? act)
      (failure-to-obtain-eia-authorization? act)
      (non-compliance-with-conditions? act)
      (failure-to-remedy-damage? act)
      (obstruction-of-inspector? act))))

;; =============================================================================
;; REMEDIATION AND REHABILITATION
;; =============================================================================

(define remediation-required? (lambda (damage)
  (and (environmental-damage-occurred? damage)
       (person-responsible-identified? damage)
       (remediation-plan-prepared? damage)
       (financial-provision-made? damage))))

;; =============================================================================
;; CLIMATE CHANGE
;; =============================================================================

(define climate-change-response? (lambda (entity)
  (and (greenhouse-gas-inventory? entity)
       (mitigation-measures? entity)
       (adaptation-measures? entity)
       (reporting-obligations-met? entity))))

;; =============================================================================
;; ENVIRONMENTAL RIGHTS (CONSTITUTION SECTION 24)
;; =============================================================================

(define environmental-right-protected? (lambda (person)
  (and (right-to-healthy-environment? person)
       (environment-protected-for-benefit? person)
       (sustainable-development-promoted? person))))

;; =============================================================================
;; ATTRIBUTE ACCESS HELPER FUNCTIONS
;; =============================================================================

(define has-attribute (lambda (entity attribute)
  (and (not (null? entity))
       (if (pair? entity)
           (or (eq? (car entity) attribute)
               (has-attribute (cdr entity) attribute))
           (eq? entity attribute)))))

(define get-attribute (lambda (entity attribute)
  (if (pair? entity)
      (if (eq? (car entity) attribute)
          (cdr entity)
          (get-attribute (cdr entity) attribute))
      #f)))

;; =============================================================================
;; NEMA PRINCIPLES - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Polluter Pays Principle
(define polluter-pays? (lambda (action)
  (and (polluter-identified? action)
       (costs-allocated-to-polluter? action)
       (financial-responsibility-assigned? action))))

(define polluter-identified? (lambda (action)
  (has-attribute action 'polluter)))

(define costs-allocated-to-polluter? (lambda (action)
  (and (has-attribute action 'remediation-costs)
       (has-attribute action 'cost-allocation))))

(define financial-responsibility-assigned? (lambda (action)
  (or (has-attribute action 'financial-provision)
      (has-attribute action 'insurance-coverage)
      (has-attribute action 'bank-guarantee))))

;; Precautionary Principle (Redefined)
(define precautionary-principle? (lambda (action)
  (and (risk-of-serious-harm? action)
       (lack-of-scientific-certainty? action)
       (preventive-measures-taken? action))))

(define risk-of-serious-harm? (lambda (action)
  (or (has-attribute action 'irreversible-damage)
      (has-attribute action 'significant-harm)
      (widespread-impact? action))))

(define widespread-impact? (lambda (action)
  (and (has-attribute action 'impact-area)
       (let ((area (get-attribute action 'impact-area)))
         (> area 100)))) ; hectares

(define lack-of-scientific-certainty? (lambda (action)
  (or (has-attribute action 'insufficient-data)
      (has-attribute action 'conflicting-studies)
      (has-attribute action 'unknown-long-term-effects))))

(define preventive-measures-taken? (lambda (action)
  (and (has-attribute action 'prevention-measures)
       (measures-implemented? action)
       (monitoring-in-place? action))))

(define measures-implemented? (lambda (action)
  (has-attribute action 'measures-status)))

(define monitoring-in-place? (lambda (action)
  (has-attribute action 'monitoring-plan)))

;; Waste Minimization
(define waste-minimization? (lambda (action)
  (and (waste-reduction-targets-set? action)
       (cleaner-production-methods? action)
       (waste-avoidance-prioritized? action))))

(define waste-reduction-targets-set? (lambda (action)
  (and (has-attribute action 'waste-reduction-target)
       (let ((target (get-attribute action 'waste-reduction-target)))
         (>= target 10)))) ; minimum 10% reduction

(define cleaner-production-methods? (lambda (action)
  (or (has-attribute action 'cleaner-technology)
      (has-attribute action 'process-optimization)
      (has-attribute action 'material-substitution))))

(define waste-avoidance-prioritized? (lambda (action)
  (and (has-attribute action 'waste-hierarchy-compliance)
       (avoidance-first-priority? action))))

(define avoidance-first-priority? (lambda (action)
  (has-attribute action 'avoidance-measures)))

;; Environmental Justice
(define environmental-justice? (lambda (action)
  (and (equitable-distribution-of-benefits? action)
       (no-disproportionate-burden? action)
       (meaningful-participation? action)
       (access-to-environmental-information? action))))

(define equitable-distribution-of-benefits? (lambda (action)
  (and (has-attribute action 'benefit-sharing)
       (community-benefits? action))))

(define community-benefits? (lambda (action)
  (or (has-attribute action 'local-employment)
      (has-attribute action 'skills-development)
      (has-attribute action 'infrastructure-development))))

(define no-disproportionate-burden? (lambda (action)
  (not (or (affects-vulnerable-communities? action)
           (cumulative-impacts-excessive? action)
           (environmental-racism? action)))))

(define affects-vulnerable-communities? (lambda (action)
  (and (has-attribute action 'affected-community)
       (vulnerable-community? action))))

(define vulnerable-community? (lambda (action)
  (or (has-attribute action 'low-income-community)
      (has-attribute action 'historically-disadvantaged)
      (has-attribute action 'indigenous-community))))

(define cumulative-impacts-excessive? (lambda (action)
  (and (has-attribute action 'cumulative-impacts)
       (exceeds-threshold? action))))

(define exceeds-threshold? (lambda (action)
  (has-attribute action 'threshold-exceedance)))

(define environmental-racism? (lambda (action)
  (and (has-attribute action 'racial-disparities)
       (has-attribute action 'discriminatory-impact))))

(define meaningful-participation? (lambda (action)
  (and (has-attribute action 'public-consultation)
       (adequate-notice? action)
       (accessible-information? action)
       (consideration-of-comments? action))))

(define adequate-notice? (lambda (action)
  (and (has-attribute action 'notice-period)
       (let ((days (get-attribute action 'notice-period)))
         (>= days 30)))) ; minimum 30 days

(define accessible-information? (lambda (action)
  (and (has-attribute action 'information-language)
       (local-language-used? action))))

(define local-language-used? (lambda (action)
  (has-attribute action 'vernacular-translation)))

(define consideration-of-comments? (lambda (action)
  (and (has-attribute action 'comments-received)
       (has-attribute action 'response-to-comments))))

(define access-to-environmental-information? (lambda (action)
  (and (information-publicly-available? action)
       (no-unreasonable-fees? action)
       (timely-provision? action))))

(define information-publicly-available? (lambda (action)
  (has-attribute action 'public-record)))

(define no-unreasonable-fees? (lambda (action)
  (or (not (has-attribute action 'access-fee))
      (reasonable-fee? action))))

(define reasonable-fee? (lambda (action)
  (and (has-attribute action 'access-fee)
       (let ((fee (get-attribute action 'access-fee)))
         (< fee 100)))) ; ZAR

(define timely-provision? (lambda (action)
  (and (has-attribute action 'response-time)
       (let ((days (get-attribute action 'response-time)))
         (<= days 14)))) ; within 14 days

;; Sustainable Development (Redefined)
(define sustainable-development? (lambda (action)
  (and (meets-present-needs? action)
       (not-compromise-future-generations? action)
       (balances-economic-social-environmental? action))))

(define meets-present-needs? (lambda (action)
  (and (economic-viability? action)
       (social-acceptability? action)
       (addresses-development-needs? action))))

(define economic-viability? (lambda (action)
  (and (has-attribute action 'economic-benefits)
       (financially-sustainable? action))))

(define financially-sustainable? (lambda (action)
  (or (has-attribute action 'positive-roi)
      (has-attribute action 'break-even-point))))

(define social-acceptability? (lambda (action)
  (and (has-attribute action 'social-impact-assessment)
       (community-support? action))))

(define community-support? (lambda (action)
  (or (has-attribute action 'community-endorsement)
      (has-attribute action 'social-license))))

(define addresses-development-needs? (lambda (action)
  (or (has-attribute action 'poverty-alleviation)
      (has-attribute action 'job-creation)
      (has-attribute action 'service-delivery))))

(define not-compromise-future-generations? (lambda (action)
  (and (no-irreversible-damage? action)
       (resource-conservation? action)
       (long-term-sustainability-ensured? action))))

(define no-irreversible-damage? (lambda (action)
  (not (has-attribute action 'irreversible-harm))))

(define resource-conservation? (lambda (action)
  (and (efficient-resource-use? action)
       (renewable-resources-prioritized? action))))

(define efficient-resource-use? (lambda (action)
  (has-attribute action 'resource-efficiency)))

(define renewable-resources-prioritized? (lambda (action)
  (or (has-attribute action 'renewable-energy)
      (has-attribute action 'sustainable-materials))))

(define long-term-sustainability-ensured? (lambda (action)
  (and (has-attribute action 'sustainability-plan)
       (monitoring-and-adaptive-management? action))))

(define monitoring-and-adaptive-management? (lambda (action)
  (and (has-attribute action 'monitoring-program)
       (has-attribute action 'adaptive-management-strategy))))

(define balances-economic-social-environmental? (lambda (action)
  (and (triple-bottom-line-assessed? action)
       (trade-offs-justified? action)
       (integrated-decision-making? action))))

(define triple-bottom-line-assessed? (lambda (action)
  (and (has-attribute action 'economic-assessment)
       (has-attribute action 'social-assessment)
       (has-attribute action 'environmental-assessment))))

(define trade-offs-justified? (lambda (action)
  (and (has-attribute action 'trade-off-analysis)
       (has-attribute action 'justification))))

(define integrated-decision-making? (lambda (action)
  (has-attribute action 'integrated-approach)))

;; =============================================================================
;; EIA PROCESS - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Listed Activities
(define listed-activity? (lambda (activity)
  (or (listing-notice-1? activity)
      (listing-notice-2? activity)
      (listing-notice-3? activity))))

(define listing-notice-1? (lambda (activity)
  (and (has-attribute activity 'activity-type)
       (member (get-attribute activity 'activity-type)
               '(infrastructure-development industrial-activities mining-operations)))))

(define listing-notice-2? (lambda (activity)
  (and (has-attribute activity 'basic-assessment-required)
       (has-attribute activity 'activity-code))))

(define listing-notice-3? (lambda (activity)
  (and (has-attribute activity 'specific-geographic-area)
       (has-attribute activity 'sensitive-area))))

;; Significant Environmental Impact
(define potential-significant-impact? (lambda (activity)
  (or (large-scale-activity? activity)
      (sensitive-area-affected? activity)
      (cumulative-impacts? activity)
      (irreversible-effects? activity))))

(define large-scale-activity? (lambda (activity)
  (and (has-attribute activity 'project-size)
       (let ((size (get-attribute activity 'project-size)))
         (> size 1000)))) ; hectares or relevant unit

(define sensitive-area-affected? (lambda (activity)
  (or (has-attribute activity 'wetland-impact)
      (has-attribute activity 'protected-area-impact)
      (has-attribute activity 'heritage-site-impact)
      (has-attribute activity 'critical-biodiversity-area))))

(define cumulative-impacts? (lambda (activity)
  (has-attribute activity 'cumulative-effects)))

(define irreversible-effects? (lambda (activity)
  (has-attribute activity 'irreversible-impact)))

;; EIA Screening
(define screening-done? (lambda (process)
  (and (has-attribute process 'screening-report)
       (activity-categorized? process)
       (eia-level-determined? process))))

(define activity-categorized? (lambda (process)
  (has-attribute process 'activity-category)))

(define eia-level-determined? (lambda (process)
  (or (has-attribute process 'basic-assessment)
      (has-attribute process 'full-eia)
      (has-attribute process 'no-authorization-required))))

;; EIA Scoping
(define scoping-conducted? (lambda (process)
  (and (has-attribute process 'scoping-report)
       (issues-identified? process)
       (alternatives-identified? process)
       (terms-of-reference-developed? process)
       (stakeholders-consulted? process))))

(define issues-identified? (lambda (process)
  (has-attribute process 'key-issues)))

(define alternatives-identified? (lambda (process)
  (and (has-attribute process 'alternatives)
       (let ((alts (get-attribute process 'alternatives)))
         (>= (length alts) 2)))) ; minimum 2 alternatives including no-go

(define terms-of-reference-developed? (lambda (process)
  (has-attribute process 'terms-of-reference)))

(define stakeholders-consulted? (lambda (process)
  (and (has-attribute process 'stakeholder-list)
       (has-attribute process 'consultation-record))))

;; Impact Assessment
(define impact-assessment-done? (lambda (process)
  (and (has-attribute process 'impact-assessment-report)
       (baseline-established? process)
       (impacts-assessed? process)
       (mitigation-measures-identified? process)
       (significance-evaluated? process))))

(define baseline-established? (lambda (process)
  (and (has-attribute process 'baseline-study)
       (environmental-baseline? process)
       (social-baseline? process))))

(define environmental-baseline? (lambda (process)
  (and (has-attribute process 'air-quality-baseline)
       (has-attribute process 'water-quality-baseline)
       (has-attribute process 'biodiversity-baseline))))

(define social-baseline? (lambda (process)
  (and (has-attribute process 'socioeconomic-baseline)
       (has-attribute process 'cultural-heritage-baseline))))

(define impacts-assessed? (lambda (process)
  (and (has-attribute process 'impact-matrix)
       (direct-impacts-assessed? process)
       (indirect-impacts-assessed? process)
       (cumulative-impacts-assessed? process))))

(define direct-impacts-assessed? (lambda (process)
  (has-attribute process 'direct-impacts)))

(define indirect-impacts-assessed? (lambda (process)
  (has-attribute process 'indirect-impacts)))

(define cumulative-impacts-assessed? (lambda (process)
  (has-attribute process 'cumulative-assessment)))

(define mitigation-measures-identified? (lambda (process)
  (and (has-attribute process 'mitigation-hierarchy)
       (avoidance-measures? process)
       (minimization-measures? process)
       (restoration-measures? process))))

(define avoidance-measures? (lambda (process)
  (has-attribute process 'avoidance)))

(define minimization-measures? (lambda (process)
  (has-attribute process 'minimization)))

(define restoration-measures? (lambda (process)
  (has-attribute process 'restoration)))

(define significance-evaluated? (lambda (process)
  (and (has-attribute process 'significance-rating)
       (methodology-applied? process))))

(define methodology-applied? (lambda (process)
  (has-attribute process 'assessment-methodology)))

;; Public Participation (Redefined)
(define public-participation? (lambda (process)
  (and (public-notified? process)
       (comments-period-provided? process)
       (public-meetings-held? process)
       (interested-and-affected-parties-registered? process)
       (comments-and-responses-report? process))))

(define public-notified? (lambda (process)
  (and (has-attribute process 'notification-method)
       (multiple-notification-channels? process))))

(define multiple-notification-channels? (lambda (process)
  (and (has-attribute process 'notification-channels)
       (let ((channels (get-attribute process 'notification-channels)))
         (>= (length channels) 2)))) ; minimum 2 channels

(define comments-period-provided? (lambda (process)
  (and (has-attribute process 'comment-period)
       (let ((days (get-attribute process 'comment-period)))
         (>= days 30)))) ; minimum 30 days

(define public-meetings-held? (lambda (process)
  (and (has-attribute process 'public-meetings)
       (let ((meetings (get-attribute process 'public-meetings)))
         (>= meetings 1)))) ; minimum 1 meeting

(define interested-and-affected-parties-registered? (lambda (process)
  (has-attribute process 'iap-database)))

(define comments-and-responses-report? (lambda (process)
  (and (has-attribute process 'crr)
       (all-comments-addressed? process))))

(define all-comments-addressed? (lambda (process)
  (has-attribute process 'responses-complete)))

;; Environmental Management Plan
(define environmental-management-plan? (lambda (process)
  (and (has-attribute process 'emp)
       (impact-management-actions? process)
       (monitoring-program-specified? process)
       (responsibilities-assigned? process)
       (emergency-response-plan? process))))

(define impact-management-actions? (lambda (process)
  (has-attribute process 'management-actions)))

(define monitoring-program-specified? (lambda (process)
  (and (has-attribute process 'monitoring-plan)
       (monitoring-frequency-specified? process)
       (monitoring-parameters-identified? process))))

(define monitoring-frequency-specified? (lambda (process)
  (has-attribute process 'monitoring-frequency)))

(define monitoring-parameters-identified? (lambda (process)
  (has-attribute process 'monitoring-parameters)))

(define responsibilities-assigned? (lambda (process)
  (has-attribute process 'responsibility-matrix)))

(define emergency-response-plan? (lambda (process)
  (has-attribute process 'emergency-procedures)))

;; Authorization
(define authorization-obtained? (lambda (process)
  (and (has-attribute process 'environmental-authorization)
       (authorization-number-issued? process)
       (authorization-date-specified? process))))

(define authorization-number-issued? (lambda (process)
  (has-attribute process 'authorization-number)))

(define authorization-date-specified? (lambda (process)
  (has-attribute process 'authorization-date)))

;; =============================================================================
;; ENVIRONMENTAL AUTHORIZATION - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Competent Authority
(define competent-authority-granted? (lambda (authorization)
  (and (has-attribute authorization 'issuing-authority)
       (valid-authority? authorization))))

(define valid-authority? (lambda (authorization)
  (or (has-attribute authorization 'dea-issued)
      (has-attribute authorization 'provincial-issued)
      (has-attribute authorization 'municipal-issued))))

;; EIA Process Followed (Redefined)
(define eia-process-followed? (lambda (authorization)
  (and (has-attribute authorization 'eia-reference)
       (procedural-compliance? authorization))))

(define procedural-compliance? (lambda (authorization)
  (has-attribute authorization 'procedure-compliant)))

;; Conditions Compliance
(define conditions-complied-with? (lambda (authorization)
  (and (has-attribute authorization 'conditions)
       (all-conditions-met? authorization)
       (no-breaches-recorded? authorization))))

(define all-conditions-met? (lambda (authorization)
  (has-attribute authorization 'compliance-status)))

(define no-breaches-recorded? (lambda (authorization)
  (not (has-attribute authorization 'breach-notice))))

;; Authorization Validity
(define not-expired? (lambda (authorization)
  (and (has-attribute authorization 'expiry-date)
       (authorization-current? authorization))))

(define authorization-current? (lambda (authorization)
  (let ((expiry (get-attribute authorization 'expiry-date))
        (current (get-current-date)))
    (> expiry current))))

(define get-current-date (lambda ()
  (has-attribute 'system 'current-date)))

;; =============================================================================
;; AIR QUALITY - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Atmospheric Emission License
(define atmospheric-emission-license? (lambda (activity)
  (and (listed-activity-aqm? activity)
       (has-attribute activity 'ael-number)
       (ael-conditions-met? activity))))

(define listed-activity-aqm? (lambda (activity)
  (and (has-attribute activity 'activity-category)
       (member (get-attribute activity 'activity-category)
               '(category-1 category-2 category-3)))))

(define ael-conditions-met? (lambda (activity)
  (has-attribute activity 'ael-compliance)))

;; Emission Standards
(define emission-standards-met? (lambda (activity)
  (and (has-attribute activity 'emission-data)
       (below-emission-limits? activity)
       (stack-height-compliant? activity))))

(define below-emission-limits? (lambda (activity)
  (and (has-attribute activity 'emission-concentration)
       (let ((concentration (get-attribute activity 'emission-concentration))
             (limit (get-attribute activity 'emission-limit)))
         (< concentration limit)))))

(define stack-height-compliant? (lambda (activity)
  (and (has-attribute activity 'stack-height)
       (has-attribute activity 'minimum-stack-height)
       (let ((height (get-attribute activity 'stack-height))
             (minimum (get-attribute activity 'minimum-stack-height)))
         (>= height minimum)))))

;; Monitoring and Reporting (Redefined)
(define monitoring-and-reporting? (lambda (activity)
  (and (continuous-monitoring? activity)
       (regular-reporting? activity)
       (records-maintained? activity))))

(define continuous-monitoring? (lambda (activity)
  (or (has-attribute activity 'cems-installed)
      (periodic-monitoring-conducted? activity))))

(define periodic-monitoring-conducted? (lambda (activity)
  (and (has-attribute activity 'monitoring-frequency)
       (adequate-frequency? activity))))

(define adequate-frequency? (lambda (activity)
  (let ((freq (get-attribute activity 'monitoring-frequency)))
    (member freq '(continuous daily weekly monthly quarterly)))))

(define regular-reporting? (lambda (activity)
  (and (has-attribute activity 'reporting-schedule)
       (reports-submitted-timely? activity))))

(define reports-submitted-timely? (lambda (activity)
  (has-attribute activity 'timely-submission)))

(define records-maintained? (lambda (activity)
  (and (has-attribute activity 'record-keeping)
       (retention-period-met? activity))))

(define retention-period-met? (lambda (activity)
  (and (has-attribute activity 'retention-period)
       (let ((period (get-attribute activity 'retention-period)))
         (>= period 5)))) ; minimum 5 years

;; =============================================================================
;; WATER USE - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Water Use License
(define water-use-license? (lambda (use)
  (and (section-21-water-use? use)
       (has-attribute use 'wul-number)
       (wul-conditions-met? use))))

(define section-21-water-use? (lambda (use)
  (and (has-attribute use 'water-use-type)
       (member (get-attribute use 'water-use-type)
               '(abstraction storage discharge impeding-flow altering-bed)))))

(define wul-conditions-met? (lambda (use)
  (has-attribute use 'wul-compliance)))

;; Efficient Water Use
(define efficient-water-use? (lambda (use)
  (and (water-conservation-measures? use)
       (water-demand-management? use)
       (best-practicable-technology? use))))

(define water-conservation-measures? (lambda (use)
  (or (has-attribute use 'recycling-system)
      (has-attribute use 'water-saving-devices)
      (has-attribute use 'leak-detection))))

(define water-demand-management? (lambda (use)
  (and (has-attribute use 'demand-reduction-target)
       (progressive-reduction? use))))

(define progressive-reduction? (lambda (use)
  (has-attribute use 'reduction-plan)))

(define best-practicable-technology? (lambda (use)
  (has-attribute use 'technology-assessment)))

;; No Pollution of Water Resources
(define no-pollution-of-water-resources? (lambda (use)
  (and (no-unauthorized-discharge? use)
       (effluent-standards-met? use)
       (groundwater-protection? use))))

(define no-unauthorized-discharge? (lambda (use)
  (or (not (has-attribute use 'discharge))
      (authorized-discharge? use))))

(define authorized-discharge? (lambda (use)
  (has-attribute use 'discharge-authorization)))

(define effluent-standards-met? (lambda (use)
  (and (has-attribute use 'effluent-quality)
       (meets-general-standard? use))))

(define meets-general-standard? (lambda (use)
  (has-attribute use 'standard-compliance)))

(define groundwater-protection? (lambda (use)
  (and (no-contamination? use)
       (monitoring-boreholes-installed? use))))

(define no-contamination? (lambda (use)
  (not (has-attribute use 'groundwater-contamination))))

(define monitoring-boreholes-installed? (lambda (use)
  (or (not (has-attribute use 'potential-groundwater-impact))
      (has-attribute use 'monitoring-boreholes))))

;; =============================================================================
;; WASTE MANAGEMENT - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Waste Management License
(define waste-management-license? (lambda (waste)
  (and (listed-waste-activity? waste)
       (has-attribute waste 'wml-number)
       (wml-conditions-met? waste))))

(define listed-waste-activity? (lambda (waste)
  (and (has-attribute waste 'waste-activity)
       (member (get-attribute waste 'waste-activity)
               '(treatment storage disposal))))

(define wml-conditions-met? (lambda (waste)
  (has-attribute waste 'wml-compliance)))

;; Cradle to Grave Responsibility
(define cradle-to-grave-responsibility? (lambda (waste)
  (and (waste-generator-identified? waste)
       (duty-of-care-exercised? waste)
       (safe-disposal-certificate? waste))))

(define waste-generator-identified? (lambda (waste)
  (has-attribute waste 'generator)))

(define duty-of-care-exercised? (lambda (waste)
  (and (appropriate-containers? waste)
       (proper-labeling? waste)
       (manifest-system? waste))))

(define appropriate-containers? (lambda (waste)
  (has-attribute waste 'suitable-containers)))

(define proper-labeling? (lambda (waste)
  (has-attribute waste 'waste-labels)))

(define manifest-system? (lambda (waste)
  (or (not (has-attribute waste 'hazardous))
      (has-attribute waste 'waste-manifest))))

(define safe-disposal-certificate? (lambda (waste)
  (or (not (has-attribute waste 'disposed))
      (has-attribute waste 'disposal-certificate))))

;; Proper Disposal
(define proper-disposal? (lambda (waste)
  (and (licensed-facility-used? waste)
       (appropriate-disposal-method? waste)
       (no-illegal-dumping? waste))))

(define licensed-facility-used? (lambda (waste)
  (has-attribute waste 'licensed-facility)))

(define appropriate-disposal-method? (lambda (waste)
  (and (has-attribute waste 'disposal-method)
       (method-suitable-for-waste-type? waste))))

(define method-suitable-for-waste-type? (lambda (waste)
  (has-attribute waste 'method-approved)))

(define no-illegal-dumping? (lambda (waste)
  (not (has-attribute waste 'illegal-disposal))))

;; Waste Hierarchy Prioritization
(define prioritizes-in-order? (lambda (waste order)
  (and (has-attribute waste 'waste-hierarchy-level)
       (highest-feasible-level? waste order))))

(define highest-feasible-level? (lambda (waste order)
  (let ((level (get-attribute waste 'waste-hierarchy-level)))
    (member level order))))

;; =============================================================================
;; BIODIVERSITY - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Protected Areas
(define within-protected-area? (lambda (activity)
  (or (has-attribute activity 'national-park)
      (has-attribute activity 'nature-reserve)
      (has-attribute activity 'world-heritage-site)
      (has-attribute activity 'marine-protected-area))))

(define permit-obtained? (lambda (activity)
  (and (permit-required? activity)
       (has-attribute activity 'permit-number)
       (permit-valid? activity))))

(define permit-required? (lambda (activity)
  (or (restricted-activity-in-protected-area? activity)
      (threatened-species-involved? activity))))

(define restricted-activity-in-protected-area? (lambda (activity)
  (and (within-protected-area? activity)
       (has-attribute activity 'restricted-activity)))

(define threatened-species-involved? (lambda (activity)
  (has-attribute activity 'threatened-species)))

(define permit-valid? (lambda (activity)
  (and (has-attribute activity 'permit-expiry)
       (not-past-expiry? activity))))

(define not-past-expiry? (lambda (activity)
  (let ((expiry (get-attribute activity 'permit-expiry))
        (current (get-current-date)))
    (> expiry current))))

(define conservation-objectives-met? (lambda (activity)
  (and (no-negative-impact-on-conservation? activity)
       (conservation-enhanced-or-maintained? activity))))

(define no-negative-impact-on-conservation? (lambda (activity)
  (not (has-attribute activity 'conservation-impact))))

(define conservation-enhanced-or-maintained? (lambda (activity)
  (or (has-attribute activity 'conservation-benefit)
      (neutral-impact? activity))))

(define neutral-impact? (lambda (activity)
  (has-attribute activity 'neutral-conservation-impact)))

;; Threatened Species
(define no-harm-to-endangered-species? (lambda (activity)
  (and (no-killing-or-capture? activity)
       (no-trade-in-specimens? activity)
       (no-disturbance-during-breeding? activity))))

(define no-killing-or-capture? (lambda (activity)
  (not (or (has-attribute activity 'specimen-killed)
           (has-attribute activity 'specimen-captured)))))

(define no-trade-in-specimens? (lambda (activity)
  (or (not (has-attribute activity 'trade))
      (cites-permit-obtained? activity))))

(define cites-permit-obtained? (lambda (activity)
  (has-attribute activity 'cites-permit)))

(define no-disturbance-during-breeding? (lambda (activity)
  (or (not (breeding-season? activity))
      (mitigation-implemented? activity))))

(define breeding-season? (lambda (activity)
  (has-attribute activity 'breeding-period)))

(define mitigation-implemented? (lambda (activity)
  (has-attribute activity 'mitigation-measures)))

(define habitat-protection? (lambda (activity)
  (and (critical-habitat-identified? activity)
       (habitat-maintained-or-restored? activity)
       (buffer-zones-established? activity))))

(define critical-habitat-identified? (lambda (activity)
  (has-attribute activity 'critical-habitat)))

(define habitat-maintained-or-restored? (lambda (activity)
  (or (has-attribute activity 'habitat-restoration)
      (no-habitat-destruction? activity))))

(define no-habitat-destruction? (lambda (activity)
  (not (has-attribute activity 'habitat-loss))))

(define buffer-zones-established? (lambda (activity)
  (or (not (habitat-edge-affected? activity))
      (has-attribute activity 'buffer-zone))))

(define habitat-edge-affected? (lambda (activity)
  (has-attribute activity 'edge-effects)))

(define permit-if-required? (lambda (activity)
  (or (not (permit-required? activity))
      (permit-obtained? activity))))

;; =============================================================================
;; COMPLIANCE AND ENFORCEMENT - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Duty of Care
(define take-reasonable-measures? (lambda (person)
  (and (measures-identified? person)
       (measures-implemented-timely? person)
       (measures-appropriate? person))))

(define measures-identified? (lambda (person)
  (has-attribute person 'measures-list)))

(define measures-implemented-timely? (lambda (person)
  (has-attribute person 'implementation-status)))

(define measures-appropriate? (lambda (person)
  (has-attribute person 'measures-adequacy)))

(define prevent-pollution? (lambda (person)
  (and (pollution-sources-controlled? person)
       (best-available-technology? person)
       (spill-prevention-plan? person))))

(define pollution-sources-controlled? (lambda (person)
  (has-attribute person 'source-control)))

(define best-available-technology? (lambda (person)
  (or (has-attribute person 'bat-assessment)
      (has-attribute person 'cleaner-technology))))

(define spill-prevention-plan? (lambda (person)
  (or (not (hazardous-substances? person))
      (has-attribute person 'spill-plan))))

(define hazardous-substances? (lambda (person)
  (has-attribute person 'hazardous-materials)))

(define prevent-degradation? (lambda (person)
  (and (land-use-appropriate? person)
       (erosion-control? person)
       (rehabilitation-plan? person))))

(define land-use-appropriate? (lambda (person)
  (has-attribute person 'land-use-authorization)))

(define erosion-control? (lambda (person)
  (or (low-erosion-risk? person)
      (has-attribute person 'erosion-measures))))

(define low-erosion-risk? (lambda (person)
  (not (has-attribute person 'high-erosion-potential))))

(define rehabilitation-plan? (lambda (person)
  (or (not (temporary-disturbance? person))
      (has-attribute person 'rehabilitation-strategy))))

(define temporary-disturbance? (lambda (person)
  (has-attribute person 'temporary-land-use)))

(define remedy-damage? (lambda (person)
  (and (damage-assessed? person)
       (remediation-commenced? person)
       (completion-timeframe? person))))

(define damage-assessed? (lambda (person)
  (has-attribute person 'damage-assessment)))

(define remediation-commenced? (lambda (person)
  (or (not (damage-occurred? person))
      (has-attribute person 'remediation-started))))

(define damage-occurred? (lambda (person)
  (has-attribute person 'environmental-damage)))

(define completion-timeframe? (lambda (person)
  (has-attribute person 'remediation-deadline)))

;; Inspector Powers
(define right-to-enter-premises? (lambda (inspector)
  (and (has-attribute inspector 'designation-certificate)
       (reasonable-time? inspector)
       (identification-provided? inspector))))

(define reasonable-time? (lambda (inspector)
  (or (emergency-situation? inspector)
      (advance-notice-given? inspector))))

(define emergency-situation? (lambda (inspector)
  (has-attribute inspector 'emergency)))

(define advance-notice-given? (lambda (inspector)
  (has-attribute inspector 'notice-of-inspection)))

(define identification-provided? (lambda (inspector)
  (has-attribute inspector 'id-shown)))

(define right-to-inspect? (lambda (inspector)
  (and (has-attribute inspector 'inspection-authority)
       (scope-within-mandate? inspector))))

(define scope-within-mandate? (lambda (inspector)
  (has-attribute inspector 'mandate-compliance)))

(define right-to-take-samples? (lambda (inspector)
  (and (has-attribute inspector 'sampling-authority)
       (proper-sampling-procedure? inspector)
       (chain-of-custody? inspector))))

(define proper-sampling-procedure? (lambda (inspector)
  (has-attribute inspector 'sampling-protocol)))

(define chain-of-custody? (lambda (inspector)
  (has-attribute inspector 'custody-records)))

(define issue-compliance-notice? (lambda (inspector)
  (and (has-attribute inspector 'issuing-authority)
       (non-compliance-identified? inspector)
       (notice-requirements-met? inspector))))

(define non-compliance-identified? (lambda (inspector)
  (has-attribute inspector 'non-compliance-evidence)))

(define notice-requirements-met? (lambda (inspector)
  (and (in-writing? inspector)
       (specific-and-clear? inspector)
       (reasonable-timeframe? inspector))))

(define in-writing? (lambda (inspector)
  (has-attribute inspector 'written-notice)))

(define specific-and-clear? (lambda (inspector)
  (has-attribute inspector 'clear-requirements)))

(define reasonable-timeframe? (lambda (inspector)
  (and (has-attribute inspector 'compliance-deadline)
       (deadline-achievable? inspector))))

(define deadline-achievable? (lambda (inspector)
  (has-attribute inspector 'reasonable-deadline)))

(define issue-directives? (lambda (inspector)
  (and (has-attribute inspector 'directive-authority)
       (serious-non-compliance? inspector))))

(define serious-non-compliance? (lambda (inspector)
  (or (has-attribute inspector 'imminent-danger)
      (has-attribute inspector 'significant-harm))))

;; Compliance Notice Validity
(define issued-by-authorized-person? (lambda (notice)
  (and (has-attribute notice 'issuer)
       (issuer-designated? notice))))

(define issuer-designated? (lambda (notice)
  (has-attribute notice 'designation-verified)))

(define specifies-non-compliance? (lambda (notice)
  (and (has-attribute notice 'non-compliance-details)
       (specific-violation-cited? notice))))

(define specific-violation-cited? (lambda (notice)
  (has-attribute notice 'violation-reference)))

(define remedial-measures-specified? (lambda (notice)
  (and (has-attribute notice 'required-actions)
       (actions-clear-and-specific? notice))))

(define actions-clear-and-specific? (lambda (notice)
  (has-attribute notice 'action-details)))

(define timeframe-for-compliance? (lambda (notice)
  (and (has-attribute notice 'compliance-date)
       (date-reasonable? notice))))

(define date-reasonable? (lambda (notice)
  (has-attribute notice 'reasonable-period)))

;; =============================================================================
;; ENVIRONMENTAL OFFENCES - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define pollution-without-authorization? (lambda (act)
  (and (pollution-occurred? act)
       (no-authorization-in-place? act))))

(define pollution-occurred? (lambda (act)
  (or (has-attribute act 'water-pollution)
      (has-attribute act 'air-pollution)
      (has-attribute act 'soil-pollution)
      (has-attribute act 'noise-pollution))))

(define no-authorization-in-place? (lambda (act)
  (not (or (has-attribute act 'environmental-authorization)
           (has-attribute act 'license)
           (has-attribute act 'permit)))))

(define failure-to-obtain-eia-authorization? (lambda (act)
  (and (listed-activity? act)
       (activity-commenced? act)
       (no-authorization? act))))

(define activity-commenced? (lambda (act)
  (has-attribute act 'commencement-date)))

(define no-authorization? (lambda (act)
  (not (has-attribute act 'ea-number))))

(define non-compliance-with-conditions? (lambda (act)
  (and (has-attribute act 'authorization-conditions)
       (condition-breached? act))))

(define condition-breached? (lambda (act)
  (has-attribute act 'condition-violation)))

(define failure-to-remedy-damage? (lambda (act)
  (and (environmental-damage-occurred? act)
       (duty-to-remedy-exists? act)
       (remediation-not-undertaken? act))))

(define duty-to-remedy-exists? (lambda (act)
  (has-attribute act 'remediation-obligation)))

(define remediation-not-undertaken? (lambda (act)
  (not (has-attribute act 'remediation-completed))))

(define obstruction-of-inspector? (lambda (act)
  (and (inspector-performing-duties? act)
       (obstruction-conduct? act))))

(define inspector-performing-duties? (lambda (act)
  (has-attribute act 'inspector-present)))

(define obstruction-conduct? (lambda (act)
  (or (has-attribute act 'refused-entry)
      (has-attribute act 'refused-information)
      (has-attribute act 'interference-with-duties))))

;; =============================================================================
;; REMEDIATION - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define environmental-damage-occurred? (lambda (damage)
  (and (has-attribute damage 'damage-type)
       (damage-quantified? damage)
       (baseline-established-for-damage? damage))))

(define damage-quantified? (lambda (damage)
  (has-attribute damage 'damage-extent)))

(define baseline-established-for-damage? (lambda (damage)
  (has-attribute damage 'pre-damage-baseline)))

(define person-responsible-identified? (lambda (damage)
  (and (has-attribute damage 'responsible-party)
       (causal-link-established? damage))))

(define causal-link-established? (lambda (damage)
  (has-attribute damage 'causation-proof)))

(define remediation-plan-prepared? (lambda (damage)
  (and (has-attribute damage 'remediation-plan)
       (plan-scientifically-sound? damage)
       (plan-approved? damage))))

(define plan-scientifically-sound? (lambda (damage)
  (and (has-attribute damage 'technical-assessment)
       (specialist-review? damage))))

(define specialist-review? (lambda (damage)
  (has-attribute damage 'specialist-approval)))

(define plan-approved? (lambda (damage)
  (has-attribute damage 'authority-approval)))

(define financial-provision-made? (lambda (damage)
  (and (costs-estimated? damage)
       (funding-secured? damage))))

(define costs-estimated? (lambda (damage)
  (has-attribute damage 'cost-estimate)))

(define funding-secured? (lambda (damage)
  (or (has-attribute damage 'financial-guarantee)
      (has-attribute damage 'trust-fund)
      (has-attribute damage 'insurance-coverage))))

;; =============================================================================
;; CLIMATE CHANGE - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define greenhouse-gas-inventory? (lambda (entity)
  (and (has-attribute entity 'ghg-inventory)
       (scope-1-emissions-calculated? entity)
       (scope-2-emissions-calculated? entity)
       (reporting-period-annual? entity))))

(define scope-1-emissions-calculated? (lambda (entity)
  (has-attribute entity 'scope-1-emissions)))

(define scope-2-emissions-calculated? (lambda (entity)
  (has-attribute entity 'scope-2-emissions)))

(define reporting-period-annual? (lambda (entity)
  (has-attribute entity 'annual-report)))

(define mitigation-measures? (lambda (entity)
  (and (emission-reduction-targets? entity)
       (mitigation-actions-implemented? entity)
       (progress-monitored? entity))))

(define emission-reduction-targets? (lambda (entity)
  (and (has-attribute entity 'reduction-target)
       (let ((target (get-attribute entity 'reduction-target)))
         (> target 0)))) ; any positive target

(define mitigation-actions-implemented? (lambda (entity)
  (or (has-attribute entity 'energy-efficiency)
      (has-attribute entity 'renewable-energy)
      (has-attribute entity 'carbon-offsetting))))

(define progress-monitored? (lambda (entity)
  (has-attribute entity 'progress-tracking)))

(define adaptation-measures? (lambda (entity)
  (and (climate-risks-assessed? entity)
       (adaptation-plan-developed? entity)
       (resilience-building? entity))))

(define climate-risks-assessed? (lambda (entity)
  (has-attribute entity 'climate-risk-assessment)))

(define adaptation-plan-developed? (lambda (entity)
  (has-attribute entity 'adaptation-strategy)))

(define resilience-building? (lambda (entity)
  (or (has-attribute entity 'infrastructure-hardening)
      (has-attribute entity 'ecosystem-restoration)
      (has-attribute entity 'early-warning-systems))))

(define reporting-obligations-met? (lambda (entity)
  (and (annual-report-submitted? entity)
       (report-complete-and-accurate? entity)
       (report-timely? entity))))

(define annual-report-submitted? (lambda (entity)
  (has-attribute entity 'climate-report-submitted)))

(define report-complete-and-accurate? (lambda (entity)
  (and (has-attribute entity 'report-completeness)
       (has-attribute entity 'third-party-verification))))

(define report-timely? (lambda (entity)
  (has-attribute entity 'on-time-submission)))

;; =============================================================================
;; ENVIRONMENTAL RIGHTS - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define right-to-healthy-environment? (lambda (person)
  (and (has-attribute person 'constitutional-right-section-24)
       (not-harmful-to-health? person)
       (not-harmful-to-wellbeing? person))))

(define not-harmful-to-health? (lambda (person)
  (not (has-attribute person 'health-threat))))

(define not-harmful-to-wellbeing? (lambda (person)
  (not (has-attribute person 'wellbeing-threat))))

(define environment-protected-for-benefit? (lambda (person)
  (and (for-present-generation? person)
       (for-future-generations? person)
       (through-reasonable-measures? person))))

(define for-present-generation? (lambda (person)
  (has-attribute person 'current-benefit)))

(define for-future-generations? (lambda (person)
  (has-attribute person 'intergenerational-equity)))

(define through-reasonable-measures? (lambda (person)
  (and (prevent-pollution-and-degradation? person)
       (promote-conservation? person)
       (secure-ecologically-sustainable-development? person))))

(define prevent-pollution-and-degradation? (lambda (person)
  (has-attribute person 'prevention-measures)))

(define promote-conservation? (lambda (person)
  (has-attribute person 'conservation-actions)))

(define secure-ecologically-sustainable-development? (lambda (person)
  (has-attribute person 'sustainable-use)))

(define sustainable-development-promoted? (lambda (person)
  (and (has-attribute person 'sustainability-principles)
       (integrated-environmental-management? person))))

(define integrated-environmental-management? (lambda (person)
  (has-attribute person 'iem-applied)))

;; =============================================================================
;; END OF SOUTH AFRICAN ENVIRONMENTAL LAW FRAMEWORK
;; =============================================================================
