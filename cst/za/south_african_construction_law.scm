;; South African Construction Law Framework
;; Scheme implementation for construction law reasoning and rule-based systems

;; =============================================================================
;; CONSTRUCTION CONTRACTS
;; =============================================================================

;; Contract Formation
(define construction-contract-valid? (lambda (contract)
  (and (contract-valid? contract)
       (scope-of-work-defined? contract)
       (time-for-completion? contract)
       (contract-price? contract))))

;; Standard Forms
(define standard-form-contract? (lambda (contract)
  (or (jbcc-contract? contract)
      (fidic-contract? contract)
      (nec-contract? contract)
      (gcc-contract? contract))))

;; =============================================================================
;; PARTIES TO CONSTRUCTION CONTRACT
;; =============================================================================

(define employer? (lambda (party contract)
  (commissioning-works? party contract)))

(define contractor? (lambda (party contract)
  (executing-works? party contract)))

(define engineer-architect? (lambda (party contract)
  (or (designing-works? party)
      (supervising-works? party)
      (certifying-works? party))))

(define subcontractor? (lambda (party contract)
  (and (contracted-by-contractor? party)
       (performing-part-of-works? party))))

;; =============================================================================
;; CONTRACTOR OBLIGATIONS
;; =============================================================================

(define contractor-obligations? (lambda (contractor)
  (and (complete-works-timeously? contractor)
      (complete-works-properly? contractor)
      (use-proper-materials? contractor)
      (workmanship-standard? contractor)
      (comply-with-specifications? contractor))))

;; Quality Standards
(define workmanship-acceptable? (lambda (work)
  (and (meets-specifications? work)
       (meets-industry-standards? work)
       (free-from-defects? work))))

;; =============================================================================
;; EMPLOYER OBLIGATIONS
;; =============================================================================

(define employer-obligations? (lambda (employer)
  (and (provide-site-access? employer)
       (pay-contract-price? employer)
       (cooperate-with-contractor? employer)
       (timeous-instructions? employer))))

;; Payment
(define payment-due? (lambda (payment)
  (and (work-completed? payment)
       (certificate-issued? payment)
       (payment-period-expired? payment))))

;; =============================================================================
;; VARIATIONS AND CLAIMS
;; =============================================================================

;; Variations
(define variation-valid? (lambda (variation)
  (and (instruction-from-employer? variation)
       (changes-scope-of-works? variation)
       (valued-in-accordance-with-contract? variation))))

;; Extension of Time Claims
(define extension-of-time-granted? (lambda (claim)
  (and (delay-occurred? claim)
       (delay-not-fault-of-contractor? claim)
       (critical-path-affected? claim)
       (claim-submitted-timeously? claim))))

;; Additional Cost Claims
(define additional-cost-claimable? (lambda (claim)
  (and (cost-incurred? claim)
       (not-within-contract-price? claim)
       (caused-by-employer-or-variation? claim))))

;; =============================================================================
;; DEFECTS AND WARRANTIES
;; =============================================================================

(define defect-liability? (lambda (defect)
  (and (defect-in-works? defect)
       (within-defects-liability-period? defect)
       (contractor-liable? defect))))

(define latent-defect? (lambda (defect)
  (and (not-discoverable-at-completion? defect)
       (manifests-later? defect))))

(define patent-defect? (lambda (defect)
  (discoverable-at-completion? defect)))

;; =============================================================================
;; DELAYS AND LIQUIDATED DAMAGES
;; =============================================================================

(define liquidated-damages-payable? (lambda (delay)
  (and (completion-delayed? delay)
       (delay-fault-of-contractor? delay)
       (liquidated-damages-clause? delay)
       (not-penalty? delay))))

(define penalty-clause? (lambda (clause)
  (and (disproportionate-to-loss? clause)
       (punitive-nature? clause))))

;; =============================================================================
;; SUSPENSION AND TERMINATION
;; =============================================================================

(define right-to-suspend? (lambda (party reason)
  (or (non-payment? reason)
      (breach-by-other-party? reason)
      (force-majeure? reason))))

(define right-to-terminate? (lambda (party reason)
  (or (material-breach? reason)
      (insolvency? reason)
      (prolonged-suspension? reason)
      (repudiation? reason))))

;; =============================================================================
;; HEALTH AND SAFETY
;; =============================================================================

;; Construction Regulations
(define health-safety-compliant? (lambda (site)
  (and (construction-regulations-complied? site)
       (safety-plan-in-place? site)
       (safety-officer-appointed? site)
       (ppe-provided? site))))

;; Occupational Health and Safety Act
(define ohsa-compliant? (lambda (site)
  (and (safe-working-environment? site)
       (risk-assessment-done? site)
       (incidents-reported? site))))

;; =============================================================================
;; PROFESSIONAL LIABILITY
;; =============================================================================

(define professional-negligence? (lambda (professional)
  (and (duty-of-care? professional)
       (breach-of-duty? professional)
       (causation? professional)
       (damage? professional))))

(define architect-engineer-liability? (lambda (professional)
  (or (design-defects? professional)
      (inadequate-supervision? professional)
      (incorrect-certification? professional))))

;; =============================================================================
;; DISPUTE RESOLUTION
;; =============================================================================

(define dispute-resolution-method? (lambda (dispute)
  (or (negotiation? dispute)
      (adjudication? dispute)
      (mediation? dispute)
      (arbitration? dispute)
      (litigation? dispute))))

;; Adjudication (CIDB)
(define adjudication-available? (lambda (dispute)
  (and (construction-dispute? dispute)
       (interim-binding-decision? dispute)
       (cidb-adjudication? dispute))))

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
;; CONTRACT FORMATION - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; General Contract Validity
(define contract-valid? (lambda (contract)
  (and (offer-and-acceptance? contract)
       (consensus-ad-idem? contract)
       (parties-have-capacity? contract)
       (lawful-object? contract)
       (formalities-complied? contract))))

(define offer-and-acceptance? (lambda (contract)
  (and (has-attribute contract 'offer)
       (has-attribute contract 'acceptance)
       (acceptance-matches-offer? contract))))

(define acceptance-matches-offer? (lambda (contract)
  (has-attribute contract 'mirror-image)))

(define consensus-ad-idem? (lambda (contract)
  (and (has-attribute contract 'consensus)
       (no-material-misunderstanding? contract))))

(define no-material-misunderstanding? (lambda (contract)
  (not (has-attribute contract 'material-mistake))))

(define parties-have-capacity? (lambda (contract)
  (and (has-attribute contract 'parties)
       (all-parties-capacitated? contract))))

(define all-parties-capacitated? (lambda (contract)
  (and (not (has-attribute contract 'minor-party))
       (not (has-attribute contract 'insane-party))
       (not (has-attribute contract 'insolvent-party)))))

(define lawful-object? (lambda (contract)
  (and (not (illegal-contract? contract))
       (not (contrary-to-public-policy? contract)))))

(define illegal-contract? (lambda (contract)
  (has-attribute contract 'illegal-purpose)))

(define contrary-to-public-policy? (lambda (contract)
  (has-attribute contract 'public-policy-violation)))

(define formalities-complied? (lambda (contract)
  (or (not (formalities-required? contract))
      (written-contract? contract))))

(define formalities-required? (lambda (contract)
  (or (has-attribute contract 'alienation-of-land)
      (has-attribute contract 'long-term-lease))))

(define written-contract? (lambda (contract)
  (has-attribute contract 'written-document)))

;; Construction Contract Specific Requirements
(define scope-of-work-defined? (lambda (contract)
  (and (has-attribute contract 'scope-of-work)
       (drawings-and-specifications? contract)
       (work-adequately-described? contract))))

(define drawings-and-specifications? (lambda (contract)
  (and (has-attribute contract 'drawings)
       (has-attribute contract 'specifications))))

(define work-adequately-described? (lambda (contract)
  (and (has-attribute contract 'work-description)
       (sufficiently-detailed? contract))))

(define sufficiently-detailed? (lambda (contract)
  (not (has-attribute contract 'ambiguous-scope))))

(define time-for-completion? (lambda (contract)
  (and (has-attribute contract 'commencement-date)
       (has-attribute contract 'completion-date)
       (time-certain-or-determinable? contract))))

(define time-certain-or-determinable? (lambda (contract)
  (or (has-attribute contract 'fixed-completion-date)
      (has-attribute contract 'duration-specified))))

(define contract-price? (lambda (contract)
  (and (has-attribute contract 'contract-sum)
       (price-certain-or-determinable? contract))))

(define price-certain-or-determinable? (lambda (contract)
  (or (lump-sum-contract? contract)
      (remeasurement-contract? contract)
      (cost-plus-contract? contract)
      (unit-rate-contract? contract))))

(define lump-sum-contract? (lambda (contract)
  (has-attribute contract 'lump-sum)))

(define remeasurement-contract? (lambda (contract)
  (and (has-attribute contract 'remeasurement)
       (has-attribute contract 'bill-of-quantities))))

(define cost-plus-contract? (lambda (contract)
  (and (has-attribute contract 'cost-reimbursement)
       (has-attribute contract 'fee-percentage))))

(define unit-rate-contract? (lambda (contract)
  (and (has-attribute contract 'unit-rates)
       (has-attribute contract 'schedule-of-rates))))

;; Standard Form Contracts
(define jbcc-contract? (lambda (contract)
  (and (has-attribute contract 'contract-type)
       (eq? (get-attribute contract 'contract-type) 'jbcc)
       (jbcc-edition-valid? contract))))

(define jbcc-edition-valid? (lambda (contract)
  (and (has-attribute contract 'jbcc-edition)
       (member (get-attribute contract 'jbcc-edition)
               '(series-2000 principal-building-agreement minor-works)))))

(define fidic-contract? (lambda (contract)
  (and (has-attribute contract 'contract-type)
       (eq? (get-attribute contract 'contract-type) 'fidic)
       (fidic-book-valid? contract))))

(define fidic-book-valid? (lambda (contract)
  (and (has-attribute contract 'fidic-book)
       (member (get-attribute contract 'fidic-book)
               '(red-book yellow-book silver-book gold-book)))))

(define nec-contract? (lambda (contract)
  (and (has-attribute contract 'contract-type)
       (eq? (get-attribute contract 'contract-type) 'nec)
       (nec-version-valid? contract))))

(define nec-version-valid? (lambda (contract)
  (and (has-attribute contract 'nec-version)
       (member (get-attribute contract 'nec-version)
               '(nec3 nec4)))))

(define gcc-contract? (lambda (contract)
  (and (has-attribute contract 'contract-type)
       (eq? (get-attribute contract 'contract-type) 'gcc)
       (public-sector-contract? contract))))

(define public-sector-contract? (lambda (contract)
  (has-attribute contract 'state-client)))

;; =============================================================================
;; PARTIES - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Employer/Client
(define commissioning-works? (lambda (party contract)
  (and (has-attribute contract 'employer)
       (eq? (get-attribute contract 'employer) party)
       (contractual-counterparty? party contract))))

(define contractual-counterparty? (lambda (party contract)
  (has-attribute contract 'bilateral-agreement)))

;; Contractor
(define executing-works? (lambda (party contract)
  (and (has-attribute contract 'contractor)
       (eq? (get-attribute contract 'contractor) party)
       (responsible-for-construction? party))))

(define responsible-for-construction? (lambda (party)
  (has-attribute party 'construction-responsibility)))

;; Engineer/Architect
(define designing-works? (lambda (party)
  (and (has-attribute party 'professional-role)
       (member (get-attribute party 'professional-role)
               '(architect engineer designer)))))

(define supervising-works? (lambda (party)
  (and (has-attribute party 'supervisory-role)
       (site-supervision-duties? party))))

(define site-supervision-duties? (lambda (party)
  (or (has-attribute party 'inspection-duties)
      (has-attribute party 'quality-control))))

(define certifying-works? (lambda (party)
  (and (has-attribute party 'certification-authority)
       (issues-payment-certificates? party))))

(define issues-payment-certificates? (lambda (party)
  (has-attribute party 'payment-certification)))

;; Subcontractor
(define contracted-by-contractor? (lambda (party)
  (and (has-attribute party 'subcontract)
       (has-attribute party 'main-contractor))))

(define performing-part-of-works? (lambda (party)
  (and (has-attribute party 'scope-of-subcontract)
       (limited-scope? party))))

(define limited-scope? (lambda (party)
  (has-attribute party 'partial-works)))

;; =============================================================================
;; CONTRACTOR OBLIGATIONS - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Timeous Completion
(define complete-works-timeously? (lambda (contractor)
  (and (has-attribute contractor 'completion-date)
       (works-completed-by-date? contractor)
       (no-culpable-delay? contractor))))

(define works-completed-by-date? (lambda (contractor)
  (or (has-attribute contractor 'practical-completion)
      (completion-certified? contractor))))

(define completion-certified? (lambda (contractor)
  (has-attribute contractor 'completion-certificate)))

(define no-culpable-delay? (lambda (contractor)
  (not (contractor-caused-delay? contractor))))

(define contractor-caused-delay? (lambda (contractor)
  (or (has-attribute contractor 'slow-progress)
      (has-attribute contractor 'resource-shortage)
      (has-attribute contractor 'poor-planning))))

;; Proper Completion
(define complete-works-properly? (lambda (contractor)
  (and (workmanship-acceptable? contractor)
       (fit-for-purpose? contractor)
       (free-from-defects-at-completion? contractor))))

(define fit-for-purpose? (lambda (contractor)
  (and (functional-requirements-met? contractor)
       (performance-criteria-satisfied? contractor))))

(define functional-requirements-met? (lambda (contractor)
  (has-attribute contractor 'functional-compliance)))

(define performance-criteria-satisfied? (lambda (contractor)
  (has-attribute contractor 'performance-tests-passed)))

(define free-from-defects-at-completion? (lambda (contractor)
  (not (has-attribute contractor 'patent-defects-at-completion))))

;; Proper Materials
(define use-proper-materials? (lambda (contractor)
  (and (materials-as-specified? contractor)
       (materials-fit-for-purpose? contractor)
       (materials-free-from-defects? contractor)
       (materials-properly-stored? contractor))))

(define materials-as-specified? (lambda (contractor)
  (and (has-attribute contractor 'material-specifications)
       (specification-compliance? contractor))))

(define specification-compliance? (lambda (contractor)
  (has-attribute contractor 'compliant-materials)))

(define materials-fit-for-purpose? (lambda (contractor)
  (has-attribute contractor 'material-suitability)))

(define materials-free-from-defects? (lambda (contractor)
  (not (has-attribute contractor 'defective-materials))))

(define materials-properly-stored? (lambda (contractor)
  (and (has-attribute contractor 'storage-facilities)
       (proper-storage-conditions? contractor))))

(define proper-storage-conditions? (lambda (contractor)
  (and (weather-protection? contractor)
       (security-measures? contractor))))

(define weather-protection? (lambda (contractor)
  (has-attribute contractor 'covered-storage)))

(define security-measures? (lambda (contractor)
  (has-attribute contractor 'site-security)))

;; Workmanship Standard
(define workmanship-standard? (lambda (contractor)
  (and (skilled-labor-employed? contractor)
       (work-executed-properly? contractor)
       (industry-standards-followed? contractor))))

(define skilled-labor-employed? (lambda (contractor)
  (and (has-attribute contractor 'qualified-workers)
       (trade-tested-artisans? contractor))))

(define trade-tested-artisans? (lambda (contractor)
  (has-attribute contractor 'trade-certificates)))

(define work-executed-properly? (lambda (contractor)
  (and (correct-methods-used? contractor)
       (good-practice-followed? contractor))))

(define correct-methods-used? (lambda (contractor)
  (has-attribute contractor 'approved-methods)))

(define good-practice-followed? (lambda (contractor)
  (has-attribute contractor 'best-practice-compliance)))

(define industry-standards-followed? (lambda (contractor)
  (and (sans-standards-met? contractor)
       (industry-codes-followed? contractor))))

(define sans-standards-met? (lambda (contractor)
  (has-attribute contractor 'sans-compliance)))

(define industry-codes-followed? (lambda (contractor)
  (has-attribute contractor 'code-compliance)))

;; Specification Compliance
(define comply-with-specifications? (lambda (contractor)
  (and (drawings-followed? contractor)
       (specification-requirements-met? contractor)
       (tolerances-achieved? contractor))))

(define drawings-followed? (lambda (contractor)
  (has-attribute contractor 'as-per-drawings)))

(define specification-requirements-met? (lambda (contractor)
  (has-attribute contractor 'spec-compliance)))

(define tolerances-achieved? (lambda (contractor)
  (and (has-attribute contractor 'tolerance-compliance)
       (within-acceptable-limits? contractor))))

(define within-acceptable-limits? (lambda (contractor)
  (not (has-attribute contractor 'tolerance-exceedance))))

;; Work Quality
(define meets-specifications? (lambda (work)
  (and (has-attribute work 'specification-ref)
       (specification-requirements-satisfied? work))))

(define specification-requirements-satisfied? (lambda (work)
  (has-attribute work 'spec-satisfied)))

(define meets-industry-standards? (lambda (work)
  (and (applicable-standards-identified? work)
       (standards-compliance-verified? work))))

(define applicable-standards-identified? (lambda (work)
  (has-attribute work 'applicable-standards)))

(define standards-compliance-verified? (lambda (work)
  (or (has-attribute work 'test-results)
      (has-attribute work 'inspection-approval))))

(define free-from-defects? (lambda (work)
  (and (visual-inspection-passed? work)
       (functional-testing-passed? work)
       (no-defects-identified? work))))

(define visual-inspection-passed? (lambda (work)
  (has-attribute work 'visual-ok)))

(define functional-testing-passed? (lambda (work)
  (or (not (testing-required? work))
      (has-attribute work 'tests-passed))))

(define testing-required? (lambda (work)
  (has-attribute work 'test-protocol)))

(define no-defects-identified? (lambda (work)
  (not (has-attribute work 'defect-list))))

;; =============================================================================
;; EMPLOYER OBLIGATIONS - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Site Access
(define provide-site-access? (lambda (employer)
  (and (site-available? employer)
       (access-unobstructed? employer)
       (possession-given-timeously? employer))))

(define site-available? (lambda (employer)
  (and (has-attribute employer 'site-available-date)
       (site-ready-for-works? employer))))

(define site-ready-for-works? (lambda (employer)
  (and (vacant-possession? employer)
       (existing-structures-removed? employer))))

(define vacant-possession? (lambda (employer)
  (not (has-attribute employer 'occupants-on-site))))

(define existing-structures-removed? (lambda (employer)
  (or (not (demolition-required? employer))
      (has-attribute employer 'demolition-completed))))

(define demolition-required? (lambda (employer)
  (has-attribute employer 'existing-buildings)))

(define access-unobstructed? (lambda (employer)
  (and (access-roads-available? employer)
       (utilities-accessible? employer))))

(define access-roads-available? (lambda (employer)
  (has-attribute employer 'site-access-route)))

(define utilities-accessible? (lambda (employer)
  (has-attribute employer 'utility-connections)))

(define possession-given-timeously? (lambda (employer)
  (and (has-attribute employer 'possession-date)
       (possession-on-time? employer))))

(define possession-on-time? (lambda (employer)
  (not (has-attribute employer 'late-possession))))

;; Payment
(define pay-contract-price? (lambda (employer)
  (and (payment-certificates-honored? employer)
       (payment-within-period? employer)
       (no-unfair-withholding? employer))))

(define payment-certificates-honored? (lambda (employer)
  (has-attribute employer 'payments-made)))

(define payment-within-period? (lambda (employer)
  (and (has-attribute employer 'payment-period)
       (let ((days (get-attribute employer 'payment-period)))
         (<= days 30)))) ; typically 30 days

(define no-unfair-withholding? (lambda (employer)
  (not (or (withholding-without-reason? employer)
           (excessive-retention? employer)))))

(define withholding-without-reason? (lambda (employer)
  (and (has-attribute employer 'payment-withheld)
       (not (has-attribute employer 'withholding-reason))))

(define excessive-retention? (lambda (employer)
  (and (has-attribute employer 'retention-percentage)
       (let ((retention (get-attribute employer 'retention-percentage)))
         (> retention 10)))) ; max 10%

;; Cooperation
(define cooperate-with-contractor? (lambda (employer)
  (and (no-hindrance? employer)
       (information-provided-timeously? employer)
       (decisions-made-promptly? employer))))

(define no-hindrance? (lambda (employer)
  (not (or (has-attribute employer 'obstruction)
           (has-attribute employer 'interference)))))

(define information-provided-timeously? (lambda (employer)
  (and (has-attribute employer 'information-requests)
       (responses-timely? employer))))

(define responses-timely? (lambda (employer)
  (not (has-attribute employer 'delayed-information))))

(define decisions-made-promptly? (lambda (employer)
  (not (has-attribute employer 'delayed-decisions))))

;; Timeous Instructions
(define timeous-instructions? (lambda (employer)
  (and (instructions-when-required? employer)
       (instructions-clear? employer)
       (no-undue-delay-in-instructions? employer))))

(define instructions-when-required? (lambda (employer)
  (has-attribute employer 'instructions-issued)))

(define instructions-clear? (lambda (employer)
  (and (has-attribute employer 'written-instructions)
       (not (has-attribute employer 'ambiguous-instructions)))))

(define no-undue-delay-in-instructions? (lambda (employer)
  (not (has-attribute employer 'instruction-delays))))

;; =============================================================================
;; PAYMENT - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Work Completion for Payment
(define work-completed? (lambda (payment)
  (and (has-attribute payment 'work-item)
       (work-item-finished? payment)
       (work-approved? payment))))

(define work-item-finished? (lambda (payment)
  (or (has-attribute payment 'milestone-achieved)
      (has-attribute payment 'percentage-complete))))

(define work-approved? (lambda (payment)
  (or (has-attribute payment 'engineer-approval)
      (no-rejection? payment))))

(define no-rejection? (lambda (payment)
  (not (has-attribute payment 'work-rejected))))

;; Payment Certificate
(define certificate-issued? (lambda (payment)
  (and (has-attribute payment 'payment-certificate)
       (certificate-by-authorized-person? payment)
       (certificate-amount-stated? payment))))

(define certificate-by-authorized-person? (lambda (payment)
  (or (has-attribute payment 'engineer-certified)
      (has-attribute payment 'architect-certified)
      (has-attribute payment 'quantity-surveyor-certified))))

(define certificate-amount-stated? (lambda (payment)
  (has-attribute payment 'certified-amount)))

;; Payment Period
(define payment-period-expired? (lambda (payment)
  (and (has-attribute payment 'certificate-date)
       (has-attribute payment 'payment-due-date)
       (due-date-passed? payment))))

(define due-date-passed? (lambda (payment)
  (let ((due-date (get-attribute payment 'payment-due-date))
        (current-date (get-current-date)))
    (>= current-date due-date))))

(define get-current-date (lambda ()
  (has-attribute 'system 'current-date)))

;; =============================================================================
;; VARIATIONS - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Variation Instruction
(define instruction-from-employer? (lambda (variation)
  (and (has-attribute variation 'instruction)
       (authorized-person-issued? variation)
       (in-writing? variation))))

(define authorized-person-issued? (lambda (variation)
  (or (has-attribute variation 'employer-instruction)
      (has-attribute variation 'engineer-instruction)
      (has-attribute variation 'architect-instruction))))

(define in-writing? (lambda (variation)
  (has-attribute variation 'written-instruction)))

;; Scope Change
(define changes-scope-of-works? (lambda (variation)
  (or (additional-work? variation)
      (omitted-work? variation)
      (changed-work? variation))))

(define additional-work? (lambda (variation)
  (has-attribute variation 'additional-items)))

(define omitted-work? (lambda (variation)
  (has-attribute variation 'omitted-items)))

(define changed-work? (lambda (variation)
  (has-attribute variation 'modified-items)))

;; Variation Valuation
(define valued-in-accordance-with-contract? (lambda (variation)
  (or (contract-rates-applied? variation)
      (agreed-rates-used? variation)
      (fair-valuation-method? variation))))

(define contract-rates-applied? (lambda (variation)
  (and (has-attribute variation 'bill-rates)
       (rates-applicable? variation))))

(define rates-applicable? (lambda (variation)
  (has-attribute variation 'similar-work)))

(define agreed-rates-used? (lambda (variation)
  (and (has-attribute variation 'negotiated-rates)
       (parties-agreed? variation))))

(define parties-agreed? (lambda (variation)
  (has-attribute variation 'rate-agreement)))

(define fair-valuation-method? (lambda (variation)
  (or (daywork-rates? variation)
      (star-rates? variation)
      (fair-valuation? variation))))

(define daywork-rates? (lambda (variation)
  (has-attribute variation 'daywork-records)))

(define star-rates? (lambda (variation)
  (has-attribute variation 'new-rates-determined)))

(define fair-valuation? (lambda (variation)
  (has-attribute variation 'reasonable-valuation)))

;; =============================================================================
;; EXTENSION OF TIME CLAIMS - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Delay Occurrence
(define delay-occurred? (lambda (claim)
  (and (has-attribute claim 'delay-event)
       (delay-quantified? claim)
       (delay-documented? claim))))

(define delay-quantified? (lambda (claim)
  (and (has-attribute claim 'delay-days)
       (let ((days (get-attribute claim 'delay-days)))
         (> days 0)))))

(define delay-documented? (lambda (claim)
  (and (has-attribute claim 'delay-evidence)
       (contemporaneous-records? claim))))

(define contemporaneous-records? (lambda (claim)
  (has-attribute claim 'site-records)))

;; Not Contractor's Fault
(define delay-not-fault-of-contractor? (lambda (claim)
  (or (employer-caused-delay? claim)
      (neutral-event-delay? claim)
      (force-majeure-delay? claim))))

(define employer-caused-delay? (lambda (claim)
  (or (has-attribute claim 'late-information)
      (has-attribute claim 'late-possession)
      (has-attribute claim 'variation-delay)
      (has-attribute claim 'suspension-by-employer))))

(define neutral-event-delay? (lambda (claim)
  (or (has-attribute claim 'exceptional-weather)
      (has-attribute claim 'unforeseen-ground-conditions)
      (has-attribute claim 'statutory-delays))))

(define force-majeure-delay? (lambda (claim)
  (or (has-attribute claim 'act-of-god)
      (has-attribute claim 'war)
      (has-attribute claim 'riot)
      (has-attribute claim 'pandemic))))

;; Critical Path Impact
(define critical-path-affected? (lambda (claim)
  (and (has-attribute claim 'programme)
       (delay-on-critical-path? claim)
       (completion-date-affected? claim))))

(define delay-on-critical-path? (lambda (claim)
  (has-attribute claim 'critical-activity-delayed)))

(define completion-date-affected? (lambda (claim)
  (has-attribute claim 'completion-delay)))

;; Timeous Claim Submission
(define claim-submitted-timeously? (lambda (claim)
  (and (has-attribute claim 'notice-given)
       (notice-within-time-bar? claim)
       (full-particulars-submitted? claim))))

(define notice-within-time-bar? (lambda (claim)
  (and (has-attribute claim 'notice-days)
       (let ((days (get-attribute claim 'notice-days)))
         (<= days 28)))) ; typically 28 days

(define full-particulars-submitted? (lambda (claim)
  (and (has-attribute claim 'claim-details)
       (substantiation-provided? claim))))

(define substantiation-provided? (lambda (claim)
  (and (has-attribute claim 'supporting-documents)
       (programme-analysis? claim))))

(define programme-analysis? (lambda (claim)
  (has-attribute claim 'delay-analysis)))

;; =============================================================================
;; ADDITIONAL COST CLAIMS - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Cost Incurred
(define cost-incurred? (lambda (claim)
  (and (has-attribute claim 'cost-amount)
       (costs-proven? claim)
       (costs-reasonable? claim))))

(define costs-proven? (lambda (claim)
  (and (has-attribute claim 'invoices)
       (has-attribute claim 'payment-records))))

(define costs-reasonable? (lambda (claim)
  (not (has-attribute claim 'excessive-costs))))

;; Outside Contract Price
(define not-within-contract-price? (lambda (claim)
  (and (additional-to-contract-scope? claim)
       (not-contractor-risk? claim))))

(define additional-to-contract-scope? (lambda (claim)
  (has-attribute claim 'extra-contractual)))

(define not-contractor-risk? (lambda (claim)
  (not (has-attribute claim 'contractor-priced-risk))))

;; Employer or Variation Caused
(define caused-by-employer-or-variation? (lambda (claim)
  (or (employer-breach-caused? claim)
      (variation-caused? claim)
      (employer-risk-event? claim))))

(define employer-breach-caused? (lambda (claim)
  (has-attribute claim 'employer-breach)))

(define variation-caused? (lambda (claim)
  (has-attribute claim 'variation-order)))

(define employer-risk-event? (lambda (claim)
  (or (has-attribute claim 'unforeseen-conditions)
      (has-attribute claim 'employer-risk-item))))

;; =============================================================================
;; DEFECTS - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Defect in Works
(define defect-in-works? (lambda (defect)
  (and (has-attribute defect 'defect-description)
       (work-not-as-specified? defect)
       (work-not-fit-for-purpose? defect))))

(define work-not-as-specified? (lambda (defect)
  (has-attribute defect 'specification-breach)))

(define work-not-fit-for-purpose? (lambda (defect)
  (has-attribute defect 'functional-failure)))

;; Defects Liability Period
(define within-defects-liability-period? (lambda (defect)
  (and (has-attribute defect 'discovery-date)
       (has-attribute defect 'completion-date)
       (within-dlp-period? defect))))

(define within-dlp-period? (lambda (defect)
  (let ((completion (get-attribute defect 'completion-date))
        (discovery (get-attribute defect 'discovery-date))
        (dlp-months (get-attribute defect 'dlp-months)))
    (< (- discovery completion) (* dlp-months 30)))) ; approximate months to days

;; Contractor Liability
(define contractor-liable? (lambda (defect)
  (and (defect-attributable-to-contractor? defect)
       (not-excluded-from-liability? defect))))

(define defect-attributable-to-contractor? (lambda (defect)
  (or (has-attribute defect 'poor-workmanship)
      (has-attribute defect 'defective-materials)
      (has-attribute defect 'design-by-contractor))))

(define not-excluded-from-liability? (lambda (defect)
  (not (or (employer-design? defect)
           (fair-wear-and-tear? defect)
           (improper-use? defect)))))

(define employer-design? (lambda (defect)
  (has-attribute defect 'employer-design-responsibility)))

(define fair-wear-and-tear? (lambda (defect)
  (has-attribute defect 'normal-deterioration)))

(define improper-use? (lambda (defect)
  (has-attribute defect 'misuse-by-employer)))

;; Latent Defects
(define not-discoverable-at-completion? (lambda (defect)
  (and (concealed-defect? defect)
       (not-apparent-on-inspection? defect))))

(define concealed-defect? (lambda (defect)
  (has-attribute defect 'hidden-defect)))

(define not-apparent-on-inspection? (lambda (defect)
  (not (has-attribute defect 'visible-at-completion))))

(define manifests-later? (lambda (defect)
  (and (has-attribute defect 'manifestation-date)
       (after-completion-date? defect))))

(define after-completion-date? (lambda (defect)
  (let ((completion (get-attribute defect 'completion-date))
        (manifestation (get-attribute defect 'manifestation-date)))
    (> manifestation completion))))

;; Patent Defects
(define discoverable-at-completion? (lambda (defect)
  (or (visible-defect? defect)
      (discoverable-on-reasonable-inspection? defect))))

(define visible-defect? (lambda (defect)
  (has-attribute defect 'visually-apparent)))

(define discoverable-on-reasonable-inspection? (lambda (defect)
  (has-attribute defect 'inspection-discoverable)))

;; =============================================================================
;; LIQUIDATED DAMAGES - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Completion Delay
(define completion-delayed? (lambda (delay)
  (and (has-attribute delay 'contract-completion-date)
       (has-attribute delay 'actual-completion-date)
       (actual-after-contract-date? delay))))

(define actual-after-contract-date? (lambda (delay)
  (let ((contract-date (get-attribute delay 'contract-completion-date))
        (actual-date (get-attribute delay 'actual-completion-date)))
    (> actual-date contract-date))))

;; Contractor's Fault
(define delay-fault-of-contractor? (lambda (delay)
  (and (no-extension-of-time-granted? delay)
       (delay-attributable-to-contractor? delay))))

(define no-extension-of-time-granted? (lambda (delay)
  (not (has-attribute delay 'eot-granted))))

(define delay-attributable-to-contractor? (lambda (delay)
  (has-attribute delay 'contractor-caused)))

;; LD Clause Exists
(define liquidated-damages-clause? (lambda (delay)
  (and (has-attribute delay 'ld-clause)
       (has-attribute delay 'daily-rate)
       (rate-specified? delay))))

(define rate-specified? (lambda (delay)
  (let ((rate (get-attribute delay 'daily-rate)))
    (> rate 0))))

;; Not a Penalty
(define not-penalty? (lambda (delay)
  (and (genuine-pre-estimate? delay)
       (not-disproportionate? delay))))

(define genuine-pre-estimate? (lambda (delay)
  (has-attribute delay 'pre-estimate-of-loss)))

(define not-disproportionate? (lambda (delay)
  (not (disproportionate-to-loss? delay))))

(define disproportionate-to-loss? (lambda (clause)
  (and (has-attribute clause 'daily-rate)
       (has-attribute clause 'actual-loss)
       (rate-excessive? clause))))

(define rate-excessive? (lambda (clause)
  (let ((rate (get-attribute clause 'daily-rate))
        (loss (get-attribute clause 'actual-loss)))
    (> rate (* loss 2)))) ; more than double actual loss

(define punitive-nature? (lambda (clause)
  (has-attribute clause 'punishment-intent)))

;; =============================================================================
;; SUSPENSION AND TERMINATION - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Non-Payment
(define non-payment? (lambda (reason)
  (and (has-attribute reason 'payment-due)
       (payment-overdue? reason)
       (no-valid-set-off? reason))))

(define payment-overdue? (lambda (reason)
  (and (has-attribute reason 'days-overdue)
       (let ((days (get-attribute reason 'days-overdue)))
         (> days 14)))) ; typically 14 days grace

(define no-valid-set-off? (lambda (reason)
  (not (has-attribute reason 'legitimate-set-off))))

;; Breach by Other Party
(define breach-by-other-party? (lambda (reason)
  (and (has-attribute reason 'breach)
       (breach-identified? reason)
       (notice-to-remedy-given? reason)
       (breach-not-remedied? reason))))

(define breach-identified? (lambda (reason)
  (has-attribute reason 'breach-description)))

(define notice-to-remedy-given? (lambda (reason)
  (and (has-attribute reason 'notice-date)
       (reasonable-time-to-remedy? reason))))

(define reasonable-time-to-remedy? (lambda (reason)
  (and (has-attribute reason 'remedy-period)
       (let ((days (get-attribute reason 'remedy-period)))
         (>= days 14)))) ; minimum 14 days

(define breach-not-remedied? (lambda (reason)
  (has-attribute reason 'continuing-breach)))

;; Force Majeure
(define force-majeure? (lambda (reason)
  (and (has-attribute reason 'fm-event)
       (event-beyond-control? reason)
       (event-unforeseeable? reason)
       (event-unavoidable? reason))))

(define event-beyond-control? (lambda (reason)
  (not (has-attribute reason 'party-control))))

(define event-unforeseeable? (lambda (reason)
  (not (has-attribute reason 'reasonably-foreseeable))))

(define event-unavoidable? (lambda (reason)
  (has-attribute reason 'unavoidable-event)))

;; Material Breach
(define material-breach? (lambda (reason)
  (and (has-attribute reason 'breach)
       (substantial-breach? reason)
       (goes-to-root-of-contract? reason))))

(define substantial-breach? (lambda (reason)
  (or (has-attribute reason 'significant-breach)
      (repeated-breaches? reason))))

(define repeated-breaches? (lambda (reason)
  (has-attribute reason 'persistent-breaches)))

(define goes-to-root-of-contract? (lambda (reason)
  (has-attribute reason 'fundamental-breach)))

;; Insolvency
(define insolvency? (lambda (reason)
  (or (has-attribute reason 'liquidation)
      (has-attribute reason 'business-rescue)
      (has-attribute reason 'sequestration)
      (has-attribute reason 'unable-to-pay-debts))))

;; Prolonged Suspension
(define prolonged-suspension? (lambda (reason)
  (and (has-attribute reason 'suspension-period)
       (let ((months (get-attribute reason 'suspension-period)))
         (>= months 3))))) ; typically 3 months

;; Repudiation
(define repudiation? (lambda (reason)
  (and (has-attribute reason 'repudiatory-conduct)
       (clear-intention-not-to-perform? reason))))

(define clear-intention-not-to-perform? (lambda (reason)
  (or (has-attribute reason 'express-refusal)
      (has-attribute reason 'conduct-inconsistent-with-contract))))

;; =============================================================================
;; HEALTH AND SAFETY - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Construction Regulations
(define construction-regulations-complied? (lambda (site)
  (and (regulations-applicable? site)
       (client-duties-fulfilled? site)
       (principal-contractor-duties? site)
       (designer-duties? site))))

(define regulations-applicable? (lambda (site)
  (or (has-attribute site 'construction-work)
      (has-attribute site 'civil-engineering-work))))

(define client-duties-fulfilled? (lambda (site)
  (and (has-attribute site 'health-safety-specification)
       (competent-persons-appointed? site))))

(define competent-persons-appointed? (lambda (site)
  (and (has-attribute site 'construction-health-safety-agent)
       (has-attribute site 'principal-contractor-appointed))))

(define principal-contractor-duties? (lambda (site)
  (and (health-safety-plan-implemented? site)
       (baseline-risk-assessment-done? site))))

(define health-safety-plan-implemented? (lambda (site)
  (has-attribute site 'hs-plan-implementation)))

(define baseline-risk-assessment-done? (lambda (site)
  (has-attribute site 'baseline-risk-assessment)))

(define designer-duties? (lambda (site)
  (or (not (design-work? site))
      (hazards-identified-in-design? site))))

(define design-work? (lambda (site)
  (has-attribute site 'design-phase)))

(define hazards-identified-in-design? (lambda (site)
  (has-attribute site 'design-hazard-identification)))

;; Safety Plan
(define safety-plan-in-place? (lambda (site)
  (and (has-attribute site 'health-safety-plan)
       (plan-comprehensive? site)
       (plan-site-specific? site))))

(define plan-comprehensive? (lambda (site)
  (and (hazard-identification? site)
       (risk-mitigation-measures? site)
       (emergency-procedures? site))))

(define hazard-identification? (lambda (site)
  (has-attribute site 'hazards-identified)))

(define risk-mitigation-measures? (lambda (site)
  (has-attribute site 'mitigation-measures)))

(define emergency-procedures? (lambda (site)
  (and (has-attribute site 'emergency-plan)
       (evacuation-procedures? site))))

(define evacuation-procedures? (lambda (site)
  (has-attribute site 'evacuation-plan)))

(define plan-site-specific? (lambda (site)
  (and (has-attribute site 'site-address)
       (site-specific-risks-addressed? site))))

(define site-specific-risks-addressed? (lambda (site)
  (has-attribute site 'site-risks)))

;; Safety Officer
(define safety-officer-appointed? (lambda (site)
  (and (has-attribute site 'safety-officer)
       (officer-competent? site)
       (officer-on-site? site))))

(define officer-competent? (lambda (site)
  (and (has-attribute site 'safety-qualification)
       (registered-with-sacpcmp? site))))

(define registered-with-sacpcmp? (lambda (site)
  (has-attribute site 'sacpcmp-registration)))

(define officer-on-site? (lambda (site)
  (has-attribute site 'officer-presence)))

;; PPE Provided
(define ppe-provided? (lambda (site)
  (and (has-attribute site 'ppe-supply)
       (ppe-appropriate? site)
       (ppe-used? site))))

(define ppe-appropriate? (lambda (site)
  (and (hazard-specific-ppe? site)
       (ppe-standards-met? site))))

(define hazard-specific-ppe? (lambda (site)
  (has-attribute site 'ppe-for-hazards)))

(define ppe-standards-met? (lambda (site)
  (has-attribute site 'ppe-compliant)))

(define ppe-used? (lambda (site)
  (and (ppe-enforcement? site)
       (workers-trained? site))))

(define ppe-enforcement? (lambda (site)
  (has-attribute site 'ppe-compliance-monitoring)))

(define workers-trained? (lambda (site)
  (has-attribute site 'safety-training)))

;; Safe Working Environment
(define safe-working-environment? (lambda (site)
  (and (fall-protection? site)
       (scaffolding-safe? site)
       (excavations-protected? site)
       (electrical-safety? site))))

(define fall-protection? (lambda (site)
  (or (not (work-at-height? site))
      (fall-protection-measures? site))))

(define work-at-height? (lambda (site)
  (has-attribute site 'elevated-work)))

(define fall-protection-measures? (lambda (site)
  (or (has-attribute site 'guardrails)
      (has-attribute site 'safety-nets)
      (has-attribute site 'fall-arrest-systems))))

(define scaffolding-safe? (lambda (site)
  (or (not (scaffolding-used? site))
      (scaffolding-inspected? site))))

(define scaffolding-used? (lambda (site)
  (has-attribute site 'scaffolding)))

(define scaffolding-inspected? (lambda (site)
  (and (has-attribute site 'scaffold-inspection)
       (has-attribute site 'scaffold-tag))))

(define excavations-protected? (lambda (site)
  (or (not (excavations-present? site))
      (excavation-safety-measures? site))))

(define excavations-present? (lambda (site)
  (has-attribute site 'excavation-work)))

(define excavation-safety-measures? (lambda (site)
  (and (has-attribute site 'shoring)
       (has-attribute site 'barrier-protection))))

(define electrical-safety? (lambda (site)
  (and (qualified-electricians? site)
       (electrical-installation-safe? site))))

(define qualified-electricians? (lambda (site)
  (has-attribute site 'licensed-electricians)))

(define electrical-installation-safe? (lambda (site)
  (and (has-attribute site 'electrical-compliance)
       (has-attribute site 'earth-leakage-protection))))

;; Risk Assessment
(define risk-assessment-done? (lambda (site)
  (and (has-attribute site 'risk-assessment)
       (all-activities-assessed? site)
       (controls-implemented? site))))

(define all-activities-assessed? (lambda (site)
  (has-attribute site 'comprehensive-assessment)))

(define controls-implemented? (lambda (site)
  (has-attribute site 'control-measures)))

;; Incidents Reported
(define incidents-reported? (lambda (site)
  (and (incident-reporting-system? site)
       (timely-reporting? site)
       (investigation-conducted? site))))

(define incident-reporting-system? (lambda (site)
  (has-attribute site 'reporting-procedure)))

(define timely-reporting? (lambda (site)
  (or (not (incident-occurred? site))
      (reported-within-timeframe? site))))

(define incident-occurred? (lambda (site)
  (has-attribute site 'incident)))

(define reported-within-timeframe? (lambda (site)
  (and (has-attribute site 'report-date)
       (within-7-days? site))))

(define within-7-days? (lambda (site)
  (let ((days (get-attribute site 'days-to-report)))
    (<= days 7))))

(define investigation-conducted? (lambda (site)
  (or (not (major-incident? site))
      (has-attribute site 'investigation-report))))

(define major-incident? (lambda (site)
  (or (has-attribute site 'fatality)
      (has-attribute site 'major-injury)
      (has-attribute site 'dangerous-occurrence))))

;; =============================================================================
;; PROFESSIONAL LIABILITY - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Professional Duty of Care
(define duty-of-care? (lambda (professional)
  (and (professional-relationship-exists? professional)
       (duty-to-exercise-skill? professional)
       (duty-recognized-by-law? professional))))

(define professional-relationship-exists? (lambda (professional)
  (or (has-attribute professional 'appointment-contract)
      (has-attribute professional 'professional-engagement))))

(define duty-to-exercise-skill? (lambda (professional)
  (has-attribute professional 'professional-skill-required)))

(define duty-recognized-by-law? (lambda (professional)
  #t)) ; duty of care is well-established in law

;; Breach of Professional Duty
(define breach-of-duty? (lambda (professional)
  (and (standard-of-care-defined? professional)
       (conduct-falls-below-standard? professional))))

(define standard-of-care-defined? (lambda (professional)
  (reasonably-competent-professional-standard? professional)))

(define reasonably-competent-professional-standard? (lambda (professional)
  (has-attribute professional 'professional-standard)))

(define conduct-falls-below-standard? (lambda (professional)
  (or (errors-in-design? professional)
      (inadequate-supervision-provided? professional)
      (incorrect-advice-given? professional))))

(define errors-in-design? (lambda (professional)
  (has-attribute professional 'design-errors)))

(define inadequate-supervision-provided? (lambda (professional)
  (has-attribute professional 'supervision-deficiency)))

(define incorrect-advice-given? (lambda (professional)
  (has-attribute professional 'erroneous-advice)))

;; Causation
(define causation? (lambda (professional)
  (and (breach-caused-loss? professional)
       (but-for-causation? professional)
       (loss-foreseeable? professional))))

(define breach-caused-loss? (lambda (professional)
  (has-attribute professional 'causal-link)))

(define but-for-causation? (lambda (professional)
  (has-attribute professional 'but-for-test)))

(define loss-foreseeable? (lambda (professional)
  (has-attribute professional 'foreseeable-loss)))

;; Damage/Loss
(define damage? (lambda (professional)
  (and (loss-occurred? professional)
       (loss-quantifiable? professional))))

(define loss-occurred? (lambda (professional)
  (or (has-attribute professional 'financial-loss)
      (has-attribute professional 'property-damage)
      (has-attribute professional 'defective-work))))

(define loss-quantifiable? (lambda (professional)
  (has-attribute professional 'quantum-of-loss)))

;; Specific Professional Liabilities
(define design-defects? (lambda (professional)
  (and (design-responsibility? professional)
       (design-inadequate? professional)
       (defect-attributable-to-design? professional))))

(define design-responsibility? (lambda (professional)
  (has-attribute professional 'design-duty)))

(define design-inadequate? (lambda (professional)
  (or (has-attribute professional 'structural-deficiency)
      (has-attribute professional 'functional-deficiency)
      (has-attribute professional 'non-compliance-with-codes))))

(define defect-attributable-to-design? (lambda (professional)
  (has-attribute professional 'design-caused)))

(define inadequate-supervision? (lambda (professional)
  (and (supervision-duty? professional)
       (supervision-insufficient? professional))))

(define supervision-duty? (lambda (professional)
  (has-attribute professional 'supervision-responsibility)))

(define supervision-insufficient? (lambda (professional)
  (or (has-attribute professional 'infrequent-inspections)
      (has-attribute professional 'defects-not-identified)
      (has-attribute professional 'non-compliance-not-detected))))

(define incorrect-certification? (lambda (professional)
  (and (certification-duty? professional)
       (certificate-incorrect? professional))))

(define certification-duty? (lambda (professional)
  (has-attribute professional 'certification-authority)))

(define certificate-incorrect? (lambda (professional)
  (or (has-attribute professional 'work-not-complete)
      (has-attribute professional 'work-defective)
      (has-attribute professional 'value-overstated))))

;; =============================================================================
;; DISPUTE RESOLUTION - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Negotiation
(define negotiation? (lambda (dispute)
  (and (has-attribute dispute 'negotiation-attempted)
       (parties-willing? dispute))))

(define parties-willing? (lambda (dispute)
  (not (has-attribute dispute 'negotiation-refused))))

;; Adjudication
(define adjudication? (lambda (dispute)
  (and (adjudicator-appointed? dispute)
       (quick-decision-process? dispute)
       (decision-binding-pending-final? dispute))))

(define adjudicator-appointed? (lambda (dispute)
  (or (has-attribute dispute 'adjudicator-agreed)
      (has-attribute dispute 'adjudicator-nominated))))

(define quick-decision-process? (lambda (dispute)
  (and (has-attribute dispute 'decision-timeframe)
       (let ((days (get-attribute dispute 'decision-timeframe)))
         (<= days 28)))) ; typically 28 days

(define decision-binding-pending-final? (lambda (dispute)
  (has-attribute dispute 'interim-binding)))

;; Mediation
(define mediation? (lambda (dispute)
  (and (mediator-appointed? dispute)
       (facilitated-negotiation? dispute)
       (voluntary-settlement? dispute))))

(define mediator-appointed? (lambda (dispute)
  (has-attribute dispute 'mediator)))

(define facilitated-negotiation? (lambda (dispute)
  (has-attribute dispute 'mediation-process)))

(define voluntary-settlement? (lambda (dispute)
  (has-attribute dispute 'settlement-agreement)))

;; Arbitration
(define arbitration? (lambda (dispute)
  (and (arbitration-agreement? dispute)
       (arbitrator-appointed? dispute)
       (award-final-and-binding? dispute))))

(define arbitration-agreement? (lambda (dispute)
  (or (has-attribute dispute 'arbitration-clause)
      (has-attribute dispute 'arbitration-agreement-signed))))

(define arbitrator-appointed? (lambda (dispute)
  (or (has-attribute dispute 'sole-arbitrator)
      (has-attribute dispute 'arbitration-panel))))

(define award-final-and-binding? (lambda (dispute)
  (has-attribute dispute 'binding-award)))

;; Litigation
(define litigation? (lambda (dispute)
  (and (court-proceedings-instituted? dispute)
       (jurisdiction-established? dispute))))

(define court-proceedings-instituted? (lambda (dispute)
  (or (has-attribute dispute 'summons-issued)
      (has-attribute dispute 'application-filed))))

(define jurisdiction-established? (lambda (dispute)
  (has-attribute dispute 'court-jurisdiction)))

;; Construction-Specific Adjudication
(define construction-dispute? (lambda (dispute)
  (or (has-attribute dispute 'construction-contract-dispute)
      (has-attribute dispute 'building-contract-dispute))))

(define interim-binding-decision? (lambda (dispute)
  (and (has-attribute dispute 'adjudication-decision)
       (binding-until-final-determination? dispute))))

(define binding-until-final-determination? (lambda (dispute)
  (has-attribute dispute 'interim-finality)))

(define cidb-adjudication? (lambda (dispute)
  (and (has-attribute dispute 'cidb-process)
       (south-african-construction-industry? dispute))))

(define south-african-construction-industry? (lambda (dispute)
  (has-attribute dispute 'sa-construction)))

;; =============================================================================
;; END OF SOUTH AFRICAN CONSTRUCTION LAW FRAMEWORK
;; =============================================================================

;; This framework provides the foundational structure for implementing
;; South African construction law in a rule-based system.
