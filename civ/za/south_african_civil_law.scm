;; South African Civil Law Framework
;; Scheme implementation for legal reasoning and rule-based systems
;; This file establishes the foundational structure for South African civil legislation

;; =============================================================================
;; CORE LEGAL CONCEPTS AND DEFINITIONS
;; =============================================================================

;; Legal Personhood and Capacity
(define legal-person? (lambda (entity) 
  (or (natural-person? entity) 
      (juristic-person? entity))))

(define natural-person? (lambda (entity)
  (and (has-attribute entity 'birth-date)
       (has-attribute entity 'identity-number))))

(define juristic-person? (lambda (entity)
  (and (has-attribute entity 'registration-number)
       (has-attribute entity 'legal-status))))

;; Legal Capacity
(define legal-capacity? (lambda (person age)
  (cond
    ((< age 18) 'minor)
    ((and (>= age 18) (< age 21)) 'major-with-restrictions)
    ((>= age 21) 'full-capacity)
    (else 'unknown))))

;; =============================================================================
;; CONTRACT LAW FRAMEWORK
;; =============================================================================

;; Essential Elements of a Contract
(define contract-valid? (lambda (contract)
  (and (offer-exists? contract)
       (acceptance-exists? contract)
       (consideration-exists? contract)
       (intention-to-create-legal-relations? contract)
       (capacity-of-parties? contract)
       (legality-of-object? contract))))

;; Offer and Acceptance
(define offer-exists? (lambda (contract)
  (has-attribute contract 'offer)))

(define acceptance-exists? (lambda (contract)
  (has-attribute contract 'acceptance)))

(define consideration-exists? (lambda (contract)
  (has-attribute contract 'consideration)))

;; Contract Formation Rules
(define offer-revoked? (lambda (offer)
  (or (has-attribute offer 'revocation-notice)
      (has-attribute offer 'counter-offer))))

(define acceptance-effective? (lambda (acceptance offer)
  (and (within-reasonable-time? acceptance offer)
       (mirror-image-rule? acceptance offer))))

;; =============================================================================
;; DELICT LAW (TORT LAW) FRAMEWORK
;; =============================================================================

;; Elements of Delict
(define delict-established? (lambda (claim)
  (and (act-or-omission? claim)
       (wrongfulness? claim)
       (fault? claim)
       (causation? claim)
       (damage? claim))))

;; Wrongfulness
(define wrongfulness? (lambda (act)
  (or (contra-boni-mores? act)
      (infringement-of-right? act)
      (breach-of-legal-duty? act))))

;; Fault (Negligence)
(define negligence? (lambda (defendant)
  (and (duty-of-care? defendant)
       (breach-of-duty? defendant)
       (reasonable-person-standard? defendant))))

;; Causation
(define factual-causation? (lambda (act damage)
  (but-for-test? act damage)))

(define legal-causation? (lambda (act damage)
  (and (factual-causation? act damage)
       (reasonable-foreseeability? act damage))))

;; =============================================================================
;; PROPERTY LAW FRAMEWORK
;; =============================================================================

;; Property Rights
(define ownership? (lambda (person property)
  (and (has-right person 'use)
       (has-right person 'enjoy)
       (has-right person 'dispose))))

(define possession? (lambda (person property)
  (and (physical-control? person property)
       (intention-to-possess? person property))))

;; Real Rights vs Personal Rights
(define real-right? (lambda (right)
  (has-attribute right 'enforceable-against-world)))

(define personal-right? (lambda (right)
  (has-attribute right 'enforceable-against-specific-person)))

;; =============================================================================
;; FAMILY LAW FRAMEWORK
;; =============================================================================

;; Marriage
(define marriage-valid? (lambda (marriage)
  (and (capacity-to-marry? marriage)
       (consent-to-marry? marriage)
       (proper-formalities? marriage)
       (no-impediments? marriage))))

;; Divorce
(define divorce-grounds? (lambda (marriage)
  (or (irretrievable-breakdown? marriage)
      (mental-illness? marriage)
      (continuous-unconsciousness? marriage))))

;; Parental Rights and Responsibilities
(define parental-responsibilities? (lambda (parent child)
  (and (care-responsibility? parent child)
       (contact-responsibility? parent child)
       (maintenance-responsibility? parent child)
       (guardianship-responsibility? parent child))))

;; =============================================================================
;; LABOUR LAW FRAMEWORK
;; =============================================================================

;; Employment Relationship
(define employment-contract? (lambda (contract)
  (and (personal-service? contract)
       (remuneration? contract)
       (subordination? contract))))

;; Unfair Dismissal
(define unfair-dismissal? (lambda (dismissal)
  (and (dismissal-exists? dismissal)
       (no-fair-reason? dismissal)
       (no-fair-procedure? dismissal))))

;; =============================================================================
;; CONSTITUTIONAL LAW FRAMEWORK
;; =============================================================================

;; Bill of Rights
(define fundamental-right? (lambda (right)
  (has-attribute right 'constitutional-protection)))

(define right-limited? (lambda (right limitation)
  (and (law-of-general-application? limitation)
       (reasonable-and-justifiable? limitation)
       (proportionality-test? limitation))))

;; =============================================================================
;; EVIDENCE LAW FRAMEWORK
;; =============================================================================

;; Admissibility
(define evidence-admissible? (lambda (evidence)
  (and (relevance? evidence)
       (not-hearsay? evidence)
       (not-privileged? evidence)
       (not-excluded-by-statute? evidence))))

;; Burden of Proof
(define burden-of-proof? (lambda (party standard)
  (case standard
    ((beyond-reasonable-doubt) (criminal-case? party))
    ((balance-of-probabilities) (civil-case? party))
    ((preponderance-of-evidence) (civil-case? party)))))

;; =============================================================================
;; PROCEDURAL FRAMEWORK
;; =============================================================================

;; Court Jurisdiction
(define court-jurisdiction? (lambda (court case)
  (and (territorial-jurisdiction? court case)
       (subject-matter-jurisdiction? court case)
       (monetary-jurisdiction? court case))))

;; Limitation Periods
(define within-limitation-period? (lambda (claim date-of-accrual)
  (let ((limitation-period (get-limitation-period claim)))
    (< (- (current-date) date-of-accrual) limitation-period))))

;; =============================================================================
;; REMEDIES FRAMEWORK
;; =============================================================================

;; Damages
(define compensatory-damages? (lambda (damages)
  (and (actual-damage? damages)
       (causally-related? damages))))

(define punitive-damages? (lambda (damages)
  (and (malicious-conduct? damages)
       (deterrent-purpose? damages))))

;; Specific Performance
(define specific-performance-available? (lambda (contract)
  (and (contract-valid? contract)
       (damages-inadequate? contract)
       (performance-possible? contract))))

;; Injunctions
(define injunction-available? (lambda (claim)
  (and (prima-facie-right? claim)
       (well-grounded-apprehension? claim)
       (no-adequate-alternative? claim))))

;; =============================================================================
;; LEGAL REASONING FRAMEWORK
;; =============================================================================

;; Precedent System
(define binding-precedent? (lambda (case court-hierarchy)
  (and (higher-court? case court-hierarchy)
       (similar-facts? case)
       (ratio-decidendi? case))))

;; Statutory Interpretation
(define literal-rule? (lambda (statute)
  (plain-meaning? statute)))

(define golden-rule? (lambda (statute)
  (and (literal-rule? statute)
       (not-absurd-result? statute))))

(define mischief-rule? (lambda (statute)
  (and (identify-mischief? statute)
       (remedy-mischief? statute))))

;; =============================================================================
;; UTILITY FUNCTIONS AND HELPERS
;; =============================================================================

;; Date and Time Functions
(define current-date (lambda () (get-current-timestamp)))

(define within-reasonable-time? (lambda (acceptance offer)
  (let ((offer-time (get-attribute offer 'timestamp))
        (acceptance-time (get-attribute acceptance 'timestamp)))
    (< (- acceptance-time offer-time) 24))) ; 24 hours as reasonable time

;; Attribute Access Functions
(define has-attribute? (lambda (entity attribute)
  (has-attribute entity attribute)))

(define get-attribute (lambda (entity attribute)
  (entity attribute)))

;; Logical Operators for Legal Reasoning
(define and? (lambda args
  (fold-left (lambda (acc pred) (and acc pred)) #t args)))

(define or? (lambda args
  (fold-left (lambda (acc pred) (or acc pred)) #f args)))

(define not? (lambda (predicate)
  (not predicate)))

;; =============================================================================
;; DELICT LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Contra Boni Mores Test (Against Good Morals)
(define contra-boni-mores? (lambda (act)
  (or (violates-constitutional-values? act)
      (violates-public-policy? act)
      (violates-community-standards? act)
      (infringes-dignity? act)
      (infringes-privacy? act)
      (fraudulent-conduct? act))))

(define violates-constitutional-values? (lambda (act)
  (has-attribute act 'constitutional-violation)))

(define violates-public-policy? (lambda (act)
  (or (has-attribute act 'illegal-purpose)
      (has-attribute act 'immoral-purpose)
      (undermines-legal-system? act))))

(define violates-community-standards? (lambda (act)
  (and (has-attribute act 'conduct-type)
       (member (get-attribute act 'conduct-type)
               '(dishonesty deceit coercion harassment discrimination)))))

(define infringes-dignity? (lambda (act)
  (or (has-attribute act 'humiliation)
      (has-attribute act 'degrading-treatment)
      (has-attribute act 'insult))))

(define infringes-privacy? (lambda (act)
  (or (unauthorized-disclosure? act)
      (intrusion-into-private-space? act)
      (unauthorized-use-of-information? act))))

(define fraudulent-conduct? (lambda (act)
  (and (has-attribute act 'misrepresentation)
       (has-attribute act 'intent-to-deceive)
       (reliance-by-victim? act))))

;; Infringement of Right
(define infringement-of-right? (lambda (act)
  (or (infringement-of-personality-right? act)
      (infringement-of-property-right? act)
      (infringement-of-constitutional-right? act))))

(define infringement-of-personality-right? (lambda (act)
  (or (infringes-dignity? act)
      (infringes-privacy? act)
      (defamation? act)
      (assault? act)
      (false-imprisonment? act))))

(define infringement-of-property-right? (lambda (act)
  (or (unlawful-deprivation? act)
      (unlawful-interference? act)
      (unlawful-use? act))))

(define infringement-of-constitutional-right? (lambda (act)
  (has-attribute act 'constitutional-right-violated)))

;; Breach of Legal Duty
(define breach-of-legal-duty? (lambda (act)
  (or (breach-of-statutory-duty? act)
      (breach-of-common-law-duty? act)
      (breach-of-fiduciary-duty? act))))

(define breach-of-statutory-duty? (lambda (act)
  (and (has-attribute act 'applicable-statute)
       (has-attribute act 'duty-imposed-by-statute)
       (not (compliance-with-statute? act)))))

(define breach-of-common-law-duty? (lambda (act)
  (or (breach-of-duty-of-care? act)
      (breach-of-duty-not-to-cause-harm? act))))

(define breach-of-fiduciary-duty? (lambda (act)
  (and (fiduciary-relationship-exists? act)
       (or (conflict-of-interest? act)
           (unauthorized-profit? act)
           (breach-of-loyalty? act)
           (breach-of-good-faith? act)))))

;; Duty of Care (Negligence)
(define duty-of-care? (lambda (defendant)
  (and (foreseeability-of-harm? defendant)
       (proximity-between-parties? defendant)
       (reasonableness-of-imposing-duty? defendant))))

(define foreseeability-of-harm? (lambda (defendant)
  (or (has-attribute defendant 'foreseeable-risk)
      (should-have-foreseen? defendant))))

(define proximity-between-parties? (lambda (defendant)
  (or (direct-relationship? defendant)
      (sufficient-connection? defendant))))

(define reasonableness-of-imposing-duty? (lambda (defendant)
  (and (not (unlimited-liability? defendant))
       (policy-considerations-support? defendant))))

;; Breach of Duty
(define breach-of-duty? (lambda (defendant)
  (and (duty-of-care? defendant)
       (conduct-falls-below-standard? defendant))))

(define conduct-falls-below-standard? (lambda (defendant)
  (not (acted-as-reasonable-person? defendant))))

;; Reasonable Person Standard
(define reasonable-person-standard? (lambda (defendant)
  (and (objective-test? defendant)
       (considered-circumstances? defendant)
       (assessed-precautions? defendant))))

(define objective-test? (lambda (defendant)
  (not (has-attribute defendant 'subjective-standard))))

(define considered-circumstances? (lambda (defendant)
  (or (has-attribute defendant 'risk-assessment)
      (has-attribute defendant 'situation-analysis))))

(define assessed-precautions? (lambda (defendant)
  (and (identified-reasonable-precautions? defendant)
       (evaluated-cost-benefit? defendant))))

;; But-For Test (Factual Causation)
(define but-for-test? (lambda (act damage)
  (and (damage-occurred? damage)
       (would-not-have-occurred-but-for-act? act damage))))

(define damage-occurred? (lambda (damage)
  (has-attribute damage 'actual-loss)))

(define would-not-have-occurred-but-for-act? (lambda (act damage)
  (and (has-attribute damage 'cause)
       (equal? (get-attribute damage 'cause)
               (get-attribute act 'action-id)))))

;; Reasonable Foreseeability (Legal Causation)
(define reasonable-foreseeability? (lambda (act damage)
  (and (type-of-harm-foreseeable? act damage)
       (extent-of-harm-not-too-remote? act damage)
       (no-novus-actus-interveniens? act damage))))

(define type-of-harm-foreseeable? (lambda (act damage)
  (or (has-attribute act 'anticipated-harm-type)
      (general-type-of-harm? act damage))))

(define extent-of-harm-not-too-remote? (lambda (act damage)
  (not (has-attribute damage 'too-remote))))

(define no-novus-actus-interveniens? (lambda (act damage)
  (not (intervening-cause-breaks-chain? act damage))))
;; =============================================================================
;; PROPERTY LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Physical Control (Possession)
(define physical-control? (lambda (person property)
  (or (actual-physical-control? person property)
      (constructive-control? person property))))

(define actual-physical-control? (lambda (person property)
  (and (has-attribute person 'physical-custody)
       (refers-to-property? person property))))

(define constructive-control? (lambda (person property)
  (or (control-through-agent? person property)
      (control-through-lessee? person property)
      (symbolic-control? person property))))

(define control-through-agent? (lambda (person property)
  (and (has-attribute person 'agent)
       (agent-has-custody? person property))))

(define control-through-lessee? (lambda (person property)
  (and (has-attribute person 'lessee)
       (lessee-has-custody? person property))))

(define symbolic-control? (lambda (person property)
  (or (has-keys-to-property? person property)
      (has-title-documents? person property))))

;; Intention to Possess
(define intention-to-possess? (lambda (person property)
  (and (animus-possidendi? person)
       (intention-to-exclude-others? person property)
       (intention-for-own-benefit? person property))))

(define animus-possidendi? (lambda (person)
  (has-attribute person 'intention-to-possess)))

(define intention-to-exclude-others? (lambda (person property)
  (and (has-attribute person 'exclusive-control-intent)
       (not (mere-custodian? person property)))))

(define intention-for-own-benefit? (lambda (person property)
  (has-attribute person 'possession-for-self)))

;; =============================================================================
;; FAMILY LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Capacity to Marry
(define capacity-to-marry? (lambda (marriage)
  (and (parties-of-age? marriage)
       (parties-not-related? marriage)
       (parties-not-currently-married? marriage)
       (parties-of-sound-mind? marriage))))

(define parties-of-age? (lambda (marriage)
  (let ((age1 (get-attribute marriage 'party1-age))
        (age2 (get-attribute marriage 'party2-age)))
    (and (>= age1 18) (>= age2 18)))))

(define parties-not-related? (lambda (marriage)
  (not (prohibited-degree-of-relationship? marriage))))

(define prohibited-degree-of-relationship? (lambda (marriage)
  (or (direct-ascendant-descendant? marriage)
      (siblings? marriage)
      (half-siblings? marriage))))

(define parties-not-currently-married? (lambda (marriage)
  (and (not (has-attribute marriage 'party1-existing-marriage))
       (not (has-attribute marriage 'party2-existing-marriage)))))

(define parties-of-sound-mind? (lambda (marriage)
  (and (has-attribute marriage 'party1-mental-capacity)
       (has-attribute marriage 'party2-mental-capacity))))

;; Consent to Marry
(define consent-to-marry? (lambda (marriage)
  (and (free-and-voluntary-consent? marriage)
       (informed-consent? marriage)
       (not (consent-by-duress? marriage))
       (not (consent-by-fraud? marriage)))))

(define free-and-voluntary-consent? (lambda (marriage)
  (and (has-attribute marriage 'party1-consent)
       (has-attribute marriage 'party2-consent)
       (not (has-attribute marriage 'coercion)))))

(define informed-consent? (lambda (marriage)
  (and (understanding-of-marriage-nature? marriage)
       (understanding-of-legal-consequences? marriage))))

(define consent-by-duress? (lambda (marriage)
  (or (has-attribute marriage 'threats)
      (has-attribute marriage 'force)
      (has-attribute marriage 'undue-pressure))))

(define consent-by-fraud? (lambda (marriage)
  (and (has-attribute marriage 'misrepresentation)
       (material-misrepresentation? marriage))))

;; Proper Formalities
(define proper-formalities? (lambda (marriage)
  (and (valid-marriage-officer? marriage)
       (required-witnesses-present? marriage)
       (marriage-license-obtained? marriage)
       (public-ceremony-or-proper-notice? marriage))))

(define valid-marriage-officer? (lambda (marriage)
  (has-attribute marriage 'authorized-officer)))

(define required-witnesses-present? (lambda (marriage)
  (let ((witnesses (get-attribute marriage 'witnesses)))
    (>= (length witnesses) 2))))

(define marriage-license-obtained? (lambda (marriage)
  (has-attribute marriage 'marriage-license)))

(define public-ceremony-or-proper-notice? (lambda (marriage)
  (or (has-attribute marriage 'public-ceremony)
      (has-attribute marriage 'proper-notice))))

;; No Impediments
(define no-impediments? (lambda (marriage)
  (and (not (existing-marriage? marriage))
       (not (prohibited-relationship? marriage))
       (not (lack-of-capacity? marriage))
       (not (legal-restrictions? marriage)))))

(define existing-marriage? (lambda (marriage)
  (parties-not-currently-married? marriage)))

(define prohibited-relationship? (lambda (marriage)
  (prohibited-degree-of-relationship? marriage)))

(define lack-of-capacity? (lambda (marriage)
  (not (capacity-to-marry? marriage))))

(define legal-restrictions? (lambda (marriage)
  (or (has-attribute marriage 'court-order-prohibition)
      (has-attribute marriage 'statutory-prohibition))))

;; Irretrievable Breakdown of Marriage
(define irretrievable-breakdown? (lambda (marriage)
  (or (separation-period-met? marriage)
      (objective-facts-show-breakdown? marriage))))

(define separation-period-met? (lambda (marriage)
  (let ((separation-duration (get-attribute marriage 'separation-months)))
    (>= separation-duration 12)))) ; 12 months continuous separation

(define objective-facts-show-breakdown? (lambda (marriage)
  (or (adultery? marriage)
      (habitual-criminality? marriage)
      (drug-or-alcohol-dependency? marriage)
      (physical-or-mental-abuse? marriage)
      (malicious-desertion? marriage))))

;; Mental Illness Ground for Divorce
(define mental-illness? (lambda (marriage)
  (and (has-attribute marriage 'mental-illness-diagnosis)
       (incurable-or-terminal? marriage)
       (makes-continued-cohabitation-impossible? marriage))))

(define incurable-or-terminal? (lambda (marriage)
  (or (has-attribute marriage 'incurable-condition)
      (has-attribute marriage 'terminal-condition))))

(define makes-continued-cohabitation-impossible? (lambda (marriage)
  (has-attribute marriage 'cohabitation-impossible)))

;; Continuous Unconsciousness Ground for Divorce
(define continuous-unconsciousness? (lambda (marriage)
  (and (has-attribute marriage 'unconscious-state)
       (continuous-period-requirement? marriage)
       (no-reasonable-prospect-of-recovery? marriage))))

(define continuous-period-requirement? (lambda (marriage)
  (let ((unconscious-duration (get-attribute marriage 'unconscious-months)))
    (>= unconscious-duration 6)))) ; 6 months minimum

(define no-reasonable-prospect-of-recovery? (lambda (marriage)
  (has-attribute marriage 'no-recovery-prognosis)))
;; =============================================================================
;; PARENTAL RESPONSIBILITIES AND RIGHTS - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Care Responsibility
(define care-responsibility? (lambda (parent child)
  (and (duty-to-provide-food? parent child)
       (duty-to-provide-shelter? parent child)
       (duty-to-provide-clothing? parent child)
       (duty-to-provide-healthcare? parent child)
       (duty-to-provide-supervision? parent child))))

(define duty-to-provide-food? (lambda (parent child)
  (has-obligation parent 'provide-food)))

(define duty-to-provide-shelter? (lambda (parent child)
  (has-obligation parent 'provide-shelter)))

(define duty-to-provide-clothing? (lambda (parent child)
  (has-obligation parent 'provide-clothing)))

(define duty-to-provide-healthcare? (lambda (parent child)
  (has-obligation parent 'provide-healthcare)))

(define duty-to-provide-supervision? (lambda (parent child)
  (has-obligation parent 'provide-supervision)))

;; Contact Responsibility
(define contact-responsibility? (lambda (parent child)
  (and (right-to-maintain-relationship? parent child)
       (regular-communication? parent child)
       (physical-access? parent child))))

(define right-to-maintain-relationship? (lambda (parent child)
  (has-attribute parent 'contact-rights)))

(define regular-communication? (lambda (parent child)
  (or (has-attribute parent 'scheduled-contact)
      (has-attribute parent 'communication-plan))))

(define physical-access? (lambda (parent child)
  (or (has-attribute parent 'visitation-schedule)
      (has-attribute parent 'shared-custody))))

;; Maintenance Responsibility
(define maintenance-responsibility? (lambda (parent child)
  (and (financial-support-obligation? parent child)
       (based-on-means? parent)
       (based-on-needs? child))))

(define financial-support-obligation? (lambda (parent child)
  (has-obligation parent 'financial-support)))

(define based-on-means? (lambda (parent)
  (has-attribute parent 'financial-means)))

(define based-on-needs? (lambda (child)
  (has-attribute child 'financial-needs)))

;; Guardianship Responsibility
(define guardianship-responsibility? (lambda (parent child)
  (and (legal-decision-making-authority? parent child)
       (consent-to-medical-treatment? parent child)
       (consent-to-marriage? parent child)
       (administration-of-property? parent child))))

(define legal-decision-making-authority? (lambda (parent child)
  (has-attribute parent 'guardian-status)))

(define consent-to-medical-treatment? (lambda (parent child)
  (has-authority parent 'medical-decisions)))

(define consent-to-marriage? (lambda (parent child)
  (and (child-under-18? child)
       (has-authority parent 'marriage-consent))))

(define administration-of-property? (lambda (parent child)
  (has-authority parent 'property-administration)))

;; =============================================================================
;; EMPLOYMENT LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Personal Service Requirement
(define personal-service? (lambda (contract)
  (and (employee-must-perform-personally? contract)
       (cannot-delegate-to-substitute? contract)
       (personal-skill-or-judgment-required? contract))))

(define employee-must-perform-personally? (lambda (contract)
  (has-attribute contract 'personal-performance-required)))

(define cannot-delegate-to-substitute? (lambda (contract)
  (not (has-attribute contract 'substitution-allowed))))

(define personal-skill-or-judgment-required? (lambda (contract)
  (has-attribute contract 'personal-skills-required)))

;; Remuneration Requirement
(define remuneration? (lambda (contract)
  (and (payment-for-services? contract)
       (monetary-or-other-benefit? contract)
       (agreed-compensation? contract))))

(define payment-for-services? (lambda (contract)
  (has-attribute contract 'payment-terms)))

(define monetary-or-other-benefit? (lambda (contract)
  (or (has-attribute contract 'salary)
      (has-attribute contract 'wages)
      (has-attribute contract 'other-benefits))))

(define agreed-compensation? (lambda (contract)
  (has-attribute contract 'compensation-agreement)))

;; Subordination Requirement
(define subordination? (lambda (contract)
  (and (employer-control-over-work? contract)
       (employer-directs-manner-of-work? contract)
       (hierarchical-relationship? contract))))

(define employer-control-over-work? (lambda (contract)
  (has-attribute contract 'employer-control)))

(define employer-directs-manner-of-work? (lambda (contract)
  (or (has-attribute contract 'work-instructions)
      (has-attribute contract 'supervision))))

(define hierarchical-relationship? (lambda (contract)
  (has-attribute contract 'employment-hierarchy)))

;; Dismissal Exists
(define dismissal-exists? (lambda (dismissal)
  (or (employer-terminated-contract? dismissal)
      (constructive-dismissal? dismissal)
      (termination-of-fixed-term-contract? dismissal))))

(define employer-terminated-contract? (lambda (dismissal)
  (has-attribute dismissal 'employer-termination)))

(define constructive-dismissal? (lambda (dismissal)
  (and (intolerable-working-conditions? dismissal)
       (employee-had-no-choice-but-to-resign? dismissal))))

(define termination-of-fixed-term-contract? (lambda (dismissal)
  (and (has-attribute dismissal 'fixed-term-contract)
       (not (contract-renewed? dismissal)))))

;; No Fair Reason for Dismissal
(define no-fair-reason? (lambda (dismissal)
  (not (or (misconduct-reason? dismissal)
           (incapacity-reason? dismissal)
           (operational-requirements-reason? dismissal)))))

(define misconduct-reason? (lambda (dismissal)
  (and (has-attribute dismissal 'employee-misconduct)
       (serious-enough-to-warrant-dismissal? dismissal))))

(define incapacity-reason? (lambda (dismissal)
  (or (poor-work-performance? dismissal)
      (ill-health-incapacity? dismissal)
      (injury-incapacity? dismissal))))

(define operational-requirements-reason? (lambda (dismissal)
  (and (genuine-business-reason? dismissal)
       (redundancy-or-restructuring? dismissal))))

;; No Fair Procedure for Dismissal
(define no-fair-procedure? (lambda (dismissal)
  (or (no-prior-notice? dismissal)
      (no-hearing-opportunity? dismissal)
      (no-representation-allowed? dismissal)
      (no-investigation-conducted? dismissal))))

(define no-prior-notice? (lambda (dismissal)
  (not (has-attribute dismissal 'prior-notice))))

(define no-hearing-opportunity? (lambda (dismissal)
  (not (has-attribute dismissal 'disciplinary-hearing))))

(define no-representation-allowed? (lambda (dismissal)
  (not (has-attribute dismissal 'representation-allowed))))

(define no-investigation-conducted? (lambda (dismissal)
  (not (has-attribute dismissal 'investigation-conducted))))
;; =============================================================================
;; CONSTITUTIONAL LAW - LIMITATION OF RIGHTS
;; =============================================================================

;; Law of General Application
(define law-of-general-application? (lambda (limitation)
  (and (applies-to-all-persons? limitation)
       (not (arbitrary-or-discriminatory? limitation))
       (published-and-accessible? limitation))))

(define applies-to-all-persons? (lambda (limitation)
  (not (has-attribute limitation 'specific-targeting))))

(define arbitrary-or-discriminatory? (lambda (limitation)
  (or (has-attribute limitation 'arbitrary-application)
      (has-attribute limitation 'discriminatory-intent))))

(define published-and-accessible? (lambda (limitation)
  (and (has-attribute limitation 'officially-published)
       (has-attribute limitation 'publicly-accessible))))

;; Reasonable and Justifiable
(define reasonable-and-justifiable? (lambda (limitation)
  (and (legitimate-government-purpose? limitation)
       (proportionality-test? limitation)
       (less-restrictive-means-unavailable? limitation))))

(define legitimate-government-purpose? (lambda (limitation)
  (or (has-attribute limitation 'public-safety)
      (has-attribute limitation 'public-health)
      (has-attribute limitation 'public-morals)
      (has-attribute limitation 'rights-of-others)
      (has-attribute limitation 'national-security))))

;; Proportionality Test (Section 36)
(define proportionality-test? (lambda (limitation)
  (and (suitable-means? limitation)
       (necessary-means? limitation)
       (proportionate-in-narrow-sense? limitation))))

(define suitable-means? (lambda (limitation)
  (advances-legitimate-purpose? limitation)))

(define necessary-means? (lambda (limitation)
  (no-less-restrictive-alternative? limitation)))

(define proportionate-in-narrow-sense? (lambda (limitation)
  (and (benefits-outweigh-costs? limitation)
       (not (excessive-restriction? limitation)))))

(define advances-legitimate-purpose? (lambda (limitation)
  (has-attribute limitation 'purpose-advancement)))

(define no-less-restrictive-alternative? (lambda (limitation)
  (not (has-attribute limitation 'less-restrictive-means)))

(define benefits-outweigh-costs? (lambda (limitation)
  (> (get-attribute limitation 'public-benefit)
     (get-attribute limitation 'rights-restriction))))

(define excessive-restriction? (lambda (limitation)
  (has-attribute limitation 'disproportionate-impact)))

(define less-restrictive-means-unavailable? (lambda (limitation)
  (no-less-restrictive-alternative? limitation)))

;; =============================================================================
;; EVIDENCE LAW - ADMISSIBILITY
;; =============================================================================

;; Relevance of Evidence
(define relevance? (lambda (evidence)
  (and (tends-to-prove-material-fact? evidence)
       (probative-value? evidence)
       (relates-to-issue-in-dispute? evidence))))

(define tends-to-prove-material-fact? (lambda (evidence)
  (has-attribute evidence 'proves-fact)))

(define probative-value? (lambda (evidence)
  (> (get-attribute evidence 'probative-value) 0)))

(define relates-to-issue-in-dispute? (lambda (evidence)
  (has-attribute evidence 'relevant-issue)))

;; Not Hearsay
(define not-hearsay? (lambda (evidence)
  (or (not (out-of-court-statement? evidence))
      (hearsay-exception-applies? evidence))))

(define out-of-court-statement? (lambda (evidence)
  (and (has-attribute evidence 'statement)
       (not (has-attribute evidence 'in-court-testimony)))))

(define hearsay-exception-applies? (lambda (evidence)
  (or (business-records? evidence)
      (res-gestae? evidence)
      (prior-consistent-statement? evidence)
      (unavailable-witness? evidence)
      (admission-by-party-opponent? evidence))))

;; Not Privileged
(define not-privileged? (lambda (evidence)
  (not (or (attorney-client-privilege? evidence)
           (spousal-privilege? evidence)
           (state-privilege? evidence)
           (without-prejudice-privilege? evidence)))))

(define attorney-client-privilege? (lambda (evidence)
  (and (has-attribute evidence 'attorney-client-communication)
       (confidential-communication? evidence))))

(define spousal-privilege? (lambda (evidence)
  (has-attribute evidence 'spousal-communication)))

(define state-privilege? (lambda (evidence)
  (has-attribute evidence 'state-security)))

(define without-prejudice-privilege? (lambda (evidence)
  (and (has-attribute evidence 'settlement-negotiation)
       (marked-without-prejudice? evidence))))

;; Not Excluded by Statute
(define not-excluded-by-statute? (lambda (evidence)
  (not (or (illegally-obtained? evidence)
           (excluded-by-specific-statute? evidence)))))

(define illegally-obtained? (lambda (evidence)
  (and (has-attribute evidence 'obtained-illegally)
       (exclusion-warranted? evidence))))

(define excluded-by-specific-statute? (lambda (evidence)
  (has-attribute evidence 'statutory-exclusion)))

(define exclusion-warranted? (lambda (evidence)
  (or (obtained-in-violation-of-rights? evidence)
      (admission-would-be-unfair? evidence))))

;; =============================================================================
;; PROCEDURAL LAW - JURISDICTION
;; =============================================================================

;; Criminal vs Civil Case
(define criminal-case? (lambda (party)
  (has-attribute party 'criminal-charge)))

(define civil-case? (lambda (party)
  (not (criminal-case? party))))

;; Territorial Jurisdiction
(define territorial-jurisdiction? (lambda (court case)
  (or (cause-of-action-arose-in-area? court case)
      (defendant-resides-in-area? court case)
      (property-located-in-area? court case))))

(define cause-of-action-arose-in-area? (lambda (court case)
  (equal? (get-attribute court 'area)
          (get-attribute case 'cause-of-action-location))))

(define defendant-resides-in-area? (lambda (court case)
  (equal? (get-attribute court 'area)
          (get-attribute case 'defendant-residence))))

(define property-located-in-area? (lambda (court case)
  (and (has-attribute case 'property-dispute)
       (equal? (get-attribute court 'area)
               (get-attribute case 'property-location)))))

;; Subject Matter Jurisdiction
(define subject-matter-jurisdiction? (lambda (court case)
  (or (court-has-general-jurisdiction? court)
      (case-type-within-court-powers? court case))))

(define court-has-general-jurisdiction? (lambda (court)
  (has-attribute court 'general-jurisdiction)))

(define case-type-within-court-powers? (lambda (court case)
  (member (get-attribute case 'case-type)
          (get-attribute court 'permitted-case-types))))

;; Monetary Jurisdiction
(define monetary-jurisdiction? (lambda (court case)
  (let ((claim-amount (get-attribute case 'claim-amount))
        (court-limit (get-attribute court 'monetary-limit)))
    (or (not court-limit)
        (<= claim-amount court-limit)))))
;; =============================================================================
;; REMEDIES - DAMAGES AND EQUITABLE RELIEF
;; =============================================================================

;; Limitation Period
(define get-limitation-period (lambda (claim)
  (cond
    ((contract-claim? claim) 3)  ; 3 years for contractual claims
    ((delict-claim? claim) 3)    ; 3 years for delictual claims
    ((debt-claim? claim) 3)      ; 3 years for debt claims
    ((property-claim? claim) 30) ; 30 years for property claims
    ((tax-claim? claim) 5)       ; 5 years for tax claims
    (else 3))))                   ; Default 3 years

(define contract-claim? (lambda (claim)
  (has-attribute claim 'contract-based)))

(define delict-claim? (lambda (claim)
  (has-attribute claim 'delict-based)))

(define debt-claim? (lambda (claim)
  (has-attribute claim 'debt-recovery)))

(define property-claim? (lambda (claim)
  (has-attribute claim 'property-rights)))

(define tax-claim? (lambda (claim)
  (has-attribute claim 'tax-related)))

;; Actual Damages
(define actual-damage? (lambda (damages)
  (and (quantifiable-loss? damages)
       (not (speculative? damages))
       (proven-on-balance-of-probabilities? damages))))

(define quantifiable-loss? (lambda (damages)
  (has-attribute damages 'amount)))

(define speculative? (lambda (damages)
  (has-attribute damages 'speculative-nature)))

(define proven-on-balance-of-probabilities? (lambda (damages)
  (> (get-attribute damages 'probability) 0.5)))

;; Causally Related Damages
(define causally-related? (lambda (damages)
  (and (direct-consequence? damages)
       (not-too-remote? damages)
       (foreseeable-consequence? damages))))

(define direct-consequence? (lambda (damages)
  (has-attribute damages 'direct-link)))

(define not-too-remote? (lambda (damages)
  (not (has-attribute damages 'too-remote))))

(define foreseeable-consequence? (lambda (damages)
  (has-attribute damages 'reasonably-foreseeable)))

;; Punitive Damages
(define malicious-conduct? (lambda (damages)
  (or (intentional-wrongdoing? damages)
      (reckless-disregard? damages)
      (deliberate-harm? damages))))

(define intentional-wrongdoing? (lambda (damages)
  (has-attribute damages 'intent-to-harm)))

(define reckless-disregard? (lambda (damages)
  (has-attribute damages 'reckless-conduct)))

(define deliberate-harm? (lambda (damages)
  (and (has-attribute damages 'deliberate-action)
       (has-attribute damages 'knowledge-of-harm))))

(define deterrent-purpose? (lambda (damages)
  (and (public-interest-requires-deterrence? damages)
       (compensatory-damages-insufficient? damages))))

(define public-interest-requires-deterrence? (lambda (damages)
  (has-attribute damages 'public-deterrence-need)))

(define compensatory-damages-insufficient? (lambda (damages)
  (has-attribute damages 'inadequate-compensation)))

;; Specific Performance
(define damages-inadequate? (lambda (contract)
  (or (unique-subject-matter? contract)
      (difficult-to-quantify-loss? contract)
      (monetary-compensation-insufficient? contract))))

(define unique-subject-matter? (lambda (contract)
  (or (has-attribute contract 'unique-property)
      (has-attribute contract 'irreplaceable-item))))

(define difficult-to-quantify-loss? (lambda (contract)
  (has-attribute contract 'unquantifiable-loss)))

(define monetary-compensation-insufficient? (lambda (contract)
  (has-attribute contract 'inadequate-remedy)))

(define performance-possible? (lambda (contract)
  (and (not (impossible-to-perform? contract))
       (not (unlawful-to-perform? contract))
       (not (personal-service-contract? contract)))))

(define impossible-to-perform? (lambda (contract)
  (or (has-attribute contract 'physical-impossibility)
      (has-attribute contract 'practical-impossibility))))

(define unlawful-to-perform? (lambda (contract)
  (has-attribute contract 'illegal-performance)))

(define personal-service-contract? (lambda (contract)
  (has-attribute contract 'personal-services)))

;; Interdict/Injunction
(define prima-facie-right? (lambda (claim)
  (and (legal-right-exists? claim)
       (right-appears-valid? claim))))

(define legal-right-exists? (lambda (claim)
  (has-attribute claim 'legal-basis)))

(define right-appears-valid? (lambda (claim)
  (not (obviously-defective? claim))))

(define well-grounded-apprehension? (lambda (claim)
  (and (reasonable-fear-of-harm? claim)
       (harm-likely-to-occur? claim)
       (based-on-objective-facts? claim))))

(define reasonable-fear-of-harm? (lambda (claim)
  (has-attribute claim 'apprehension-of-harm)))

(define harm-likely-to-occur? (lambda (claim)
  (> (get-attribute claim 'likelihood) 0.5)))

(define based-on-objective-facts? (lambda (claim)
  (has-attribute claim 'factual-basis)))

(define no-adequate-alternative? (lambda (claim)
  (and (damages-not-sufficient-remedy? claim)
       (no-other-effective-remedy? claim))))

(define damages-not-sufficient-remedy? (lambda (claim)
  (or (irreparable-harm? claim)
      (continuing-harm? claim))))

(define no-other-effective-remedy? (lambda (claim)
  (not (has-attribute claim 'alternative-remedy)))

;; =============================================================================
;; PRECEDENT AND STARE DECISIS
;; =============================================================================

;; Higher Court Determination
(define higher-court? (lambda (case court-hierarchy)
  (let ((precedent-court (get-attribute case 'court-level))
        (current-court (get-attribute court-hierarchy 'current-level)))
    (> precedent-court current-court))))

;; Similar Facts
(define similar-facts? (lambda (case)
  (and (material-facts-similar? case)
       (legal-issues-similar? case)
       (not (distinguishable-on-facts? case)))))

(define material-facts-similar? (lambda (case)
  (has-attribute case 'factual-similarity)))

(define legal-issues-similar? (lambda (case)
  (has-attribute case 'legal-similarity)))

(define distinguishable-on-facts? (lambda (case)
  (has-attribute case 'material-difference)))

;; Ratio Decidendi
(define ratio-decidendi? (lambda (case)
  (and (essential-to-decision? case)
       (legal-principle-stated? case)
       (not (obiter-dictum? case)))))

(define essential-to-decision? (lambda (case)
  (has-attribute case 'necessary-for-judgment)))

(define legal-principle-stated? (lambda (case)
  (has-attribute case 'principle-articulated)))

(define obiter-dictum? (lambda (case)
  (has-attribute case 'incidental-remark)))

;; =============================================================================
;; STATUTORY INTERPRETATION
;; =============================================================================

;; Plain Meaning Rule
(define plain-meaning? (lambda (statute)
  (and (language-clear? statute)
       (no-ambiguity? statute)
       (contextually-sensible? statute))))

(define language-clear? (lambda (statute)
  (not (has-attribute statute 'ambiguous-language))))

(define no-ambiguity? (lambda (statute)
  (not (has-attribute statute 'multiple-meanings))))

(define contextually-sensible? (lambda (statute)
  (has-attribute statute 'coherent-in-context)))

(define not-absurd-result? (lambda (statute)
  (and (not (produces-absurdity? statute))
       (not (contrary-to-legislative-intent? statute)))))

(define produces-absurdity? (lambda (statute)
  (has-attribute statute 'absurd-consequence)))

(define contrary-to-legislative-intent? (lambda (statute)
  (has-attribute statute 'contradicts-purpose)))

;; Mischief Rule
(define identify-mischief? (lambda (statute)
  (and (historical-problem-identified? statute)
       (legislative-intent-clear? statute))))

(define historical-problem-identified? (lambda (statute)
  (has-attribute statute 'targeted-problem)))

(define legislative-intent-clear? (lambda (statute)
  (has-attribute statute 'stated-purpose)))

(define remedy-mischief? (lambda (statute)
  (and (interpretation-addresses-problem? statute)
       (advances-legislative-purpose? statute))))

(define interpretation-addresses-problem? (lambda (statute)
  (has-attribute statute 'solves-mischief)))

(define advances-legislative-purpose? (lambda (statute)
  (has-attribute statute 'purpose-advancement)))

;; =============================================================================
;; SUPPORTING HELPER FUNCTIONS
;; =============================================================================

(define has-obligation (lambda (entity obligation-type)
  (has-attribute entity obligation-type)))

(define has-authority (lambda (entity authority-type)
  (has-attribute entity authority-type)))

(define child-under-18? (lambda (child)
  (< (get-attribute child 'age) 18)))

(define refers-to-property? (lambda (person property)
  (equal? (get-attribute person 'controlled-property)
          (get-attribute property 'property-id))))

(define agent-has-custody? (lambda (person property)
  (has-attribute (get-attribute person 'agent) 'custody)))

(define lessee-has-custody? (lambda (person property)
  (has-attribute (get-attribute person 'lessee) 'custody)))

(define has-keys-to-property? (lambda (person property)
  (has-attribute person 'keys)))

(define has-title-documents? (lambda (person property)
  (has-attribute person 'title-documents)))

(define mere-custodian? (lambda (person property)
  (and (physical-control? person property)
       (not (intention-to-possess? person property)))))

(define direct-ascendant-descendant? (lambda (marriage)
  (or (has-attribute marriage 'parent-child)
      (has-attribute marriage 'grandparent-grandchild))))

(define siblings? (lambda (marriage)
  (has-attribute marriage 'full-siblings)))

(define half-siblings? (lambda (marriage)
  (has-attribute marriage 'half-siblings)))

(define understanding-of-marriage-nature? (lambda (marriage)
  (has-attribute marriage 'understanding-of-marriage)))

(define understanding-of-legal-consequences? (lambda (marriage)
  (has-attribute marriage 'understanding-of-consequences)))

(define material-misrepresentation? (lambda (marriage)
  (and (has-attribute marriage 'misrepresentation)
       (has-attribute marriage 'material-fact))))

(define adultery? (lambda (marriage)
  (has-attribute marriage 'adultery-proven)))

(define habitual-criminality? (lambda (marriage)
  (has-attribute marriage 'criminal-behavior-pattern)))

(define drug-or-alcohol-dependency? (lambda (marriage)
  (or (has-attribute marriage 'drug-dependency)
      (has-attribute marriage 'alcohol-dependency))))

(define physical-or-mental-abuse? (lambda (marriage)
  (or (has-attribute marriage 'physical-abuse)
      (has-attribute marriage 'mental-abuse))))

(define malicious-desertion? (lambda (marriage)
  (and (has-attribute marriage 'desertion)
       (has-attribute marriage 'malicious-intent))))

(define intolerable-working-conditions? (lambda (dismissal)
  (has-attribute dismissal 'intolerable-conditions)))

(define employee-had-no-choice-but-to-resign? (lambda (dismissal)
  (and (has-attribute dismissal 'employee-resignation)
       (has-attribute dismissal 'no-reasonable-alternative))))

(define contract-renewed? (lambda (dismissal)
  (has-attribute dismissal 'renewal-offered)))

(define serious-enough-to-warrant-dismissal? (lambda (dismissal)
  (or (has-attribute dismissal 'gross-misconduct)
      (has-attribute dismissal 'repeated-misconduct))))

(define poor-work-performance? (lambda (dismissal)
  (has-attribute dismissal 'performance-deficiency)))

(define ill-health-incapacity? (lambda (dismissal)
  (has-attribute dismissal 'medical-incapacity)))

(define injury-incapacity? (lambda (dismissal)
  (has-attribute dismissal 'injury-related)))

(define genuine-business-reason? (lambda (dismissal)
  (has-attribute dismissal 'legitimate-business-need)))

(define redundancy-or-restructuring? (lambda (dismissal)
  (or (has-attribute dismissal 'redundancy)
      (has-attribute dismissal 'restructuring))))

(define undermines-legal-system? (lambda (act)
  (has-attribute act 'undermines-law)))

(define unauthorized-disclosure? (lambda (act)
  (and (has-attribute act 'private-information-disclosed)
       (not (has-attribute act 'consent)))))

(define intrusion-into-private-space? (lambda (act)
  (has-attribute act 'privacy-invasion)))

(define unauthorized-use-of-information? (lambda (act)
  (and (has-attribute act 'information-use)
       (not (has-attribute act 'authorization)))))

(define reliance-by-victim? (lambda (act)
  (has-attribute act 'victim-reliance)))

(define defamation? (lambda (act)
  (and (has-attribute act 'defamatory-statement)
       (published-to-third-party? act))))

(define published-to-third-party? (lambda (act)
  (has-attribute act 'publication)))

(define assault? (lambda (act)
  (has-attribute act 'unlawful-force)))

(define false-imprisonment? (lambda (act)
  (and (has-attribute act 'unlawful-restraint)
       (has-attribute act 'deprivation-of-liberty))))

(define unlawful-deprivation? (lambda (act)
  (and (has-attribute act 'property-deprivation)
       (not (has-attribute act 'lawful-authority)))))

(define unlawful-interference? (lambda (act)
  (and (has-attribute act 'property-interference)
       (not (has-attribute act 'right-to-interfere)))))

(define unlawful-use? (lambda (act)
  (and (has-attribute act 'property-use)
       (not (has-attribute act 'permission)))))

(define compliance-with-statute? (lambda (act)
  (has-attribute act 'statutory-compliance)))

(define breach-of-duty-of-care? (lambda (act)
  (and (duty-of-care-owed? act)
       (duty-breached? act))))

(define duty-of-care-owed? (lambda (act)
  (has-attribute act 'duty-owed)))

(define duty-breached? (lambda (act)
  (has-attribute act 'breach)))

(define breach-of-duty-not-to-cause-harm? (lambda (act)
  (and (general-duty-not-to-harm? act)
       (caused-harm? act))))

(define general-duty-not-to-harm? (lambda (act)
  #t)) ; Universal duty

(define caused-harm? (lambda (act)
  (has-attribute act 'harm-caused)))

(define fiduciary-relationship-exists? (lambda (act)
  (has-attribute act 'fiduciary-duty)))

(define conflict-of-interest? (lambda (act)
  (has-attribute act 'conflict-of-interest)))

(define unauthorized-profit? (lambda (act)
  (and (has-attribute act 'profit-made)
       (not (has-attribute act 'authorized-profit)))))

(define breach-of-loyalty? (lambda (act)
  (has-attribute act 'disloyalty)))

(define breach-of-good-faith? (lambda (act)
  (has-attribute act 'bad-faith)))

(define should-have-foreseen? (lambda (defendant)
  (has-attribute defendant 'should-have-known)))

(define direct-relationship? (lambda (defendant)
  (has-attribute defendant 'direct-connection)))

(define sufficient-connection? (lambda (defendant)
  (has-attribute defendant 'nexus)))

(define unlimited-liability? (lambda (defendant)
  (has-attribute defendant 'unlimited-exposure)))

(define policy-considerations-support? (lambda (defendant)
  (has-attribute defendant 'policy-support)))

(define acted-as-reasonable-person? (lambda (defendant)
  (has-attribute defendant 'reasonable-conduct)))

(define identified-reasonable-precautions? (lambda (defendant)
  (has-attribute defendant 'precautions-identified)))

(define evaluated-cost-benefit? (lambda (defendant)
  (has-attribute defendant 'cost-benefit-analysis)))

(define general-type-of-harm? (lambda (act damage)
  (has-attribute damage 'general-harm-type)))

(define intervening-cause-breaks-chain? (lambda (act damage)
  (has-attribute damage 'novus-actus-interveniens)))

(define business-records? (lambda (evidence)
  (has-attribute evidence 'business-record)))

(define res-gestae? (lambda (evidence)
  (has-attribute evidence 'spontaneous-statement)))

(define prior-consistent-statement? (lambda (evidence)
  (has-attribute evidence 'prior-consistent)))

(define unavailable-witness? (lambda (evidence)
  (has-attribute evidence 'witness-unavailable)))

(define admission-by-party-opponent? (lambda (evidence)
  (has-attribute evidence 'party-admission)))

(define confidential-communication? (lambda (evidence)
  (has-attribute evidence 'confidential)))

(define marked-without-prejudice? (lambda (evidence)
  (has-attribute evidence 'without-prejudice-marker)))

(define obtained-in-violation-of-rights? (lambda (evidence)
  (has-attribute evidence 'rights-violation)))

(define admission-would-be-unfair? (lambda (evidence)
  (has-attribute evidence 'unfair-admission)))

(define irreparable-harm? (lambda (claim)
  (has-attribute claim 'irreparable-injury)))

(define continuing-harm? (lambda (claim)
  (has-attribute claim 'ongoing-harm)))

(define obviously-defective? (lambda (claim)
  (has-attribute claim 'clearly-defective)))

;; Get current timestamp
(define get-current-timestamp (lambda () 
  (get-attribute 'system 'current-time)))

;; =============================================================================
;; END OF SOUTH AFRICAN CIVIL LAW FRAMEWORK
;; =============================================================================

;; This framework provides the foundational structure for implementing
;; South African civil law in a rule-based system. The placeholder functions
;; can be replaced with specific implementations, machine learning models,
;; or integration with legal databases and APIs.