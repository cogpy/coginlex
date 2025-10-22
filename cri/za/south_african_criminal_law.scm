;; South African Criminal Law Framework
;; Scheme implementation for criminal law reasoning and rule-based systems
;; This file establishes the foundational structure for South African criminal legislation

;; =============================================================================
;; CORE CRIMINAL LAW CONCEPTS
;; =============================================================================

;; Criminal Liability Elements
(define criminal-liability? (lambda (act)
  (and (actus-reus? act)
       (mens-rea? act)
       (causation? act)
       (no-defence? act))))

;; Actus Reus (Guilty Act)
(define actus-reus? (lambda (act)
  (and (voluntary-conduct? act)
       (unlawful-act? act))))

;; Mens Rea (Guilty Mind)
(define mens-rea? (lambda (act)
  (or (intention? act)
      (negligence? act))))

;; Forms of Intention
(define intention? (lambda (act)
  (or (dolus-directus? act)
      (dolus-indirectus? act)
      (dolus-eventualis? act))))

(define dolus-directus? (lambda (act) #f)) ; Direct intention - to be implemented
(define dolus-indirectus? (lambda (act) #f)) ; Indirect intention - to be implemented
(define dolus-eventualis? (lambda (act) #f)) ; Dolus eventualis - to be implemented

;; Criminal Negligence
(define negligence? (lambda (act)
  (and (reasonable-person-test? act)
       (foreseeability? act)
       (preventability? act))))

;; =============================================================================
;; SPECIFIC CRIMES
;; =============================================================================

;; Crimes Against the Person
(define murder? (lambda (act)
  (and (unlawful-killing? act)
       (intention-to-kill? act))))

(define culpable-homicide? (lambda (act)
  (and (unlawful-killing? act)
       (negligence? act))))

(define assault? (lambda (act)
  (and (unlawful-application-force? act)
       (intention? act))))

(define rape? (lambda (act)
  (and (non-consensual-sexual-penetration? act)
       (intention? act))))

;; Property Crimes
(define theft? (lambda (act)
  (and (appropriation? act)
       (movable-property? act)
       (belonging-to-another? act)
       (intention-to-permanently-deprive? act))))

(define robbery? (lambda (act)
  (and (theft? act)
       (violence-or-threat? act))))

(define fraud? (lambda (act)
  (and (misrepresentation? act)
       (prejudice-to-another? act)
       (benefit-to-accused? act)
       (intention-to-deceive? act))))

(define housebreaking? (lambda (act)
  (and (breaking? act)
       (entering? act)
       (building-or-structure? act)
       (intent-to-commit-crime? act))))

;; Crimes Against the State
(define treason? (lambda (act)
  (and (violent-overthrow-attempt? act)
       (intention? act))))

(define sedition? (lambda (act)
  (and (incitement-to-violence? act)
       (against-state? act))))

;; Economic Crimes
(define bribery? (lambda (act)
  (and (offer-or-acceptance? act)
       (undue-advantage? act)
       (corrupt-purpose? act))))

(define money-laundering? (lambda (act)
  (and (proceeds-of-crime? act)
       (concealment-or-disguise? act)
       (knowledge-of-origin? act))))

;; =============================================================================
;; DEFENCES
;; =============================================================================

;; General Defences
(define no-defence? (lambda (act)
  (not (or (private-defence? act)
           (necessity? act)
           (impossibility? act)
           (consent? act)
           (insanity? act)
           (intoxication? act)
           (mistake? act)
           (duress? act)))))

;; Private Defence (Self-Defence)
(define private-defence? (lambda (act)
  (and (unlawful-attack? act)
       (defence-necessary? act)
       (proportionate-force? act)
       (no-alternative? act))))

;; Necessity
(define necessity? (lambda (act)
  (and (imminent-danger? act)
       (lesser-evil? act)
       (no-reasonable-alternative? act))))

;; Impossibility
(define impossibility? (lambda (act)
  (or (factual-impossibility? act)
      (legal-impossibility? act))))

;; Consent
(define consent? (lambda (act)
  (and (voluntary-consent? act)
       (informed-consent? act)
       (capacity-to-consent? act)
       (lawful-purpose? act))))

;; Insanity
(define insanity? (lambda (act)
  (and (mental-illness? act)
       (inability-to-appreciate-wrongfulness? act))))

;; Intoxication
(define intoxication? (lambda (act)
  (and (involuntary-intoxication? act)
       (complete-loss-control? act))))

;; Mistake
(define mistake? (lambda (act)
  (or (mistake-of-fact? act)
      (mistake-of-law? act))))

;; Duress
(define duress? (lambda (act)
  (and (threat-of-harm? act)
       (imminent-threat? act)
       (no-reasonable-alternative? act))))

;; =============================================================================
;; CRIMINAL PROCEDURE
;; =============================================================================

;; Arrest
(define lawful-arrest? (lambda (arrest)
  (and (reasonable-suspicion? arrest)
       (arrest-warrant-or-exception? arrest)
       (informed-of-rights? arrest))))

;; Search and Seizure
(define lawful-search? (lambda (search)
  (or (search-warrant? search)
      (consent-to-search? search)
      (search-incident-to-arrest? search))))

;; Bail
(define bail-granted? (lambda (application)
  (and (not-flight-risk? application)
       (not-danger-to-public? application)
       (not-interfere-with-investigation? application))))

;; Trial Rights
(define fair-trial? (lambda (trial)
  (and (presumption-of-innocence? trial)
       (right-to-legal-representation? trial)
       (right-to-remain-silent? trial)
       (right-to-confront-witnesses? trial)
       (trial-without-unreasonable-delay? trial))))

;; Burden of Proof
(define beyond-reasonable-doubt? (lambda (evidence)
  (and (prosecution-burden? evidence)
       (no-reasonable-doubt? evidence))))

;; =============================================================================
;; SENTENCING
;; =============================================================================

;; Sentencing Factors
(define appropriate-sentence? (lambda (sentence accused crime)
  (and (consider-aggravating-factors? sentence)
       (consider-mitigating-factors? sentence)
       (proportionality? sentence crime)
       (consistency? sentence))))

;; Types of Sentences
(define sentence-type? (lambda (sentence)
  (or (imprisonment? sentence)
      (fine? sentence)
      (community-service? sentence)
      (suspended-sentence? sentence)
      (correctional-supervision? sentence))))

;; =============================================================================
;; JUVENILE JUSTICE
;; =============================================================================

;; Child Justice Act
(define child-offender? (lambda (person)
  (and (under-18? person)
       (criminal-capacity? person))))

(define minimum-age-criminal-capacity? (lambda (age)
  (>= age 10)))

(define doli-incapax? (lambda (child age)
  (and (>= age 10) (< age 14)
       (not (understanding-wrongfulness? child)))))

;; =============================================================================
;; PLACEHOLDER FUNCTIONS FOR FUTURE IMPLEMENTATION
;; =============================================================================

;; =============================================================================
;; CRIMINAL LIABILITY ELEMENTS - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Forms of Intention (Mens Rea)
(define dolus-directus? (lambda (act)
  (and (conscious-decision-to-act? act)
       (aim-to-achieve-result? act)
       (deliberate-pursuit-of-outcome? act))))

(define conscious-decision-to-act? (lambda (act)
  (has-attribute act 'conscious-choice)))

(define aim-to-achieve-result? (lambda (act)
  (has-attribute act 'desired-outcome)))

(define deliberate-pursuit-of-outcome? (lambda (act)
  (has-attribute act 'purposeful-action)))

(define dolus-indirectus? (lambda (act)
  (and (primary-intention-exists? act)
       (secondary-consequence-foreseen? act)
       (accepts-secondary-consequence? act))))

(define primary-intention-exists? (lambda (act)
  (has-attribute act 'primary-intent)))

(define secondary-consequence-foreseen? (lambda (act)
  (has-attribute act 'foresaw-secondary-result)))

(define accepts-secondary-consequence? (lambda (act)
  (has-attribute act 'accepted-consequence)))

(define dolus-eventualis? (lambda (act)
  (and (foresees-possibility-of-result? act)
       (continues-regardless? act)
       (reconciles-with-result? act))))

(define foresees-possibility-of-result? (lambda (act)
  (has-attribute act 'foresaw-possibility)))

(define continues-regardless? (lambda (act)
  (has-attribute act 'proceeded-despite-risk)))

(define reconciles-with-result? (lambda (act)
  (has-attribute act 'accepted-risk)))

;; Actus Reus Elements
(define voluntary-conduct? (lambda (act)
  (and (willed-muscular-movement? act)
       (not (reflex-action? act))
       (not (under-irresistible-force? act))
       (not (unconscious-state? act)))))

(define willed-muscular-movement? (lambda (act)
  (has-attribute act 'voluntary-movement)))

(define reflex-action? (lambda (act)
  (has-attribute act 'involuntary-reflex)))

(define under-irresistible-force? (lambda (act)
  (has-attribute act 'external-force)))

(define unconscious-state? (lambda (act)
  (has-attribute act 'lack-of-consciousness)))

(define unlawful-act? (lambda (act)
  (and (not (lawful-justification? act))
       (not (consent-defence? act))
       (not (statutory-authority? act))
       (violates-legal-norm? act))))

(define lawful-justification? (lambda (act)
  (or (self-defence? act)
      (necessity? act)
      (legal-authority? act))))

(define consent-defence? (lambda (act)
  (and (has-attribute act 'victim-consent)
       (valid-consent? act))))

(define statutory-authority? (lambda (act)
  (has-attribute act 'legal-authorization)))

(define violates-legal-norm? (lambda (act)
  (or (prohibited-by-statute? act)
      (prohibited-by-common-law? act))))

(define prohibited-by-statute? (lambda (act)
  (has-attribute act 'statutory-prohibition)))

(define prohibited-by-common-law? (lambda (act)
  (has-attribute act 'common-law-prohibition)))

;; Negligence Elements
(define reasonable-person-test? (lambda (act)
  (and (objective-standard-applied? act)
       (conduct-below-standard? act)
       (would-reasonable-person-foresee? act))))

(define objective-standard-applied? (lambda (act)
  (not (has-attribute act 'subjective-test))))

(define conduct-below-standard? (lambda (act)
  (has-attribute act 'substandard-conduct)))

(define would-reasonable-person-foresee? (lambda (act)
  (has-attribute act 'reasonable-foreseeability)))

(define foreseeability? (lambda (act)
  (and (possibility-of-harm-foreseeable? act)
       (type-of-harm-foreseeable? act))))

(define possibility-of-harm-foreseeable? (lambda (act)
  (has-attribute act 'foreseeable-risk)))

(define type-of-harm-foreseeable? (lambda (act)
  (has-attribute act 'specific-harm-type)))

(define preventability? (lambda (act)
  (and (precautions-available? act)
       (reasonable-to-take-precautions? act)
       (failed-to-take-precautions? act))))

(define precautions-available? (lambda (act)
  (has-attribute act 'available-measures)))

(define reasonable-to-take-precautions? (lambda (act)
  (not (has-attribute act 'unreasonable-burden))))

(define failed-to-take-precautions? (lambda (act)
  (has-attribute act 'precautions-not-taken)))

;; Causation
(define causation? (lambda (act)
  (and (factual-causation-criminal? act)
       (legal-causation-criminal? act))))

(define factual-causation-criminal? (lambda (act)
  (but-for-act-result-not-occur? act)))

(define but-for-act-result-not-occur? (lambda (act)
  (has-attribute act 'sine-qua-non)))

(define legal-causation-criminal? (lambda (act)
  (and (direct-and-proximate? act)
       (not (novus-actus-interveniens-criminal? act)))))

(define direct-and-proximate? (lambda (act)
  (has-attribute act 'proximate-cause)))

(define novus-actus-interveniens-criminal? (lambda (act)
  (has-attribute act 'intervening-cause)))

;; =============================================================================
;; SPECIFIC CRIMES - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Murder and Homicide
(define unlawful-killing? (lambda (act)
  (and (caused-death? act)
       (death-of-living-human? act)
       (not (lawful-killing? act)))))

(define caused-death? (lambda (act)
  (has-attribute act 'death-caused)))

(define death-of-living-human? (lambda (act)
  (and (has-attribute act 'victim-human)
       (has-attribute act 'victim-alive-before))))

(define lawful-killing? (lambda (act)
  (or (capital-punishment? act)
      (lawful-war-act? act)
      (self-defence-killing? act))))

(define capital-punishment? (lambda (act)
  (has-attribute act 'death-penalty-execution)))

(define lawful-war-act? (lambda (act)
  (has-attribute act 'armed-conflict-killing)))

(define self-defence-killing? (lambda (act)
  (and (unlawful-attack? act)
       (defence-necessary? act)
       (proportionate-force? act)))

(define intention-to-kill? (lambda (act)
  (or (dolus-directus-kill? act)
      (dolus-eventualis-kill? act))))

(define dolus-directus-kill? (lambda (act)
  (and (intended-to-cause-death? act)
       (acted-to-achieve-death? act))))

(define intended-to-cause-death? (lambda (act)
  (has-attribute act 'death-intended)))

(define acted-to-achieve-death? (lambda (act)
  (has-attribute act 'actions-to-kill)))

(define dolus-eventualis-kill? (lambda (act)
  (and (foresaw-death-possibility? act)
       (proceeded-with-conduct? act)
       (reconciled-with-death? act))))

(define foresaw-death-possibility? (lambda (act)
  (has-attribute act 'death-foreseen)))

(define proceeded-with-conduct? (lambda (act)
  (has-attribute act 'continued-action)))

(define reconciled-with-death? (lambda (act)
  (has-attribute act 'accepted-death-risk)))

;; Assault
(define unlawful-application-force? (lambda (act)
  (and (physical-contact-or-threat? act)
       (without-consent? act)
       (unlawful-act? act))))

(define physical-contact-or-threat? (lambda (act)
  (or (has-attribute act 'physical-contact)
      (has-attribute act 'threat-of-violence))))

(define without-consent? (lambda (act)
  (not (has-attribute act 'valid-consent))))

;; Sexual Offenses
(define non-consensual-sexual-penetration? (lambda (act)
  (and (sexual-penetration-occurred? act)
       (no-valid-consent? act))))

(define sexual-penetration-occurred? (lambda (act)
  (has-attribute act 'sexual-penetration)))

(define no-valid-consent? (lambda (act)
  (or (no-consent-given? act)
      (consent-invalid? act)
      (complainant-incapable-consent? act))))

(define no-consent-given? (lambda (act)
  (not (has-attribute act 'consent))))

(define consent-invalid? (lambda (act)
  (or (has-attribute act 'consent-by-force)
      (has-attribute act 'consent-by-fraud)
      (has-attribute act 'consent-by-threat)))

(define complainant-incapable-consent? (lambda (act)
  (or (complainant-under-age? act)
      (complainant-unconscious? act)
      (complainant-mentally-incapacitated? act))))

(define complainant-under-age? (lambda (act)
  (< (get-attribute act 'complainant-age) 16))

(define complainant-unconscious? (lambda (act)
  (has-attribute act 'complainant-unconscious)))

(define complainant-mentally-incapacitated? (lambda (act)
  (has-attribute act 'mental-incapacity)))

;; =============================================================================
;; PROPERTY CRIMES - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Theft Elements
(define appropriation? (lambda (act)
  (and (taking-possession? act)
       (exercising-control? act)
       (treating-as-owner? act))))

(define taking-possession? (lambda (act)
  (has-attribute act 'took-possession)))

(define exercising-control? (lambda (act)
  (has-attribute act 'exercised-control)))

(define treating-as-owner? (lambda (act)
  (has-attribute act 'acted-as-owner)))

(define movable-property? (lambda (act)
  (and (property-can-be-moved? act)
       (not (immovable-property? act)))))

(define property-can-be-moved? (lambda (act)
  (has-attribute act 'movable-item)))

(define immovable-property? (lambda (act)
  (has-attribute act 'land-or-building)))

(define belonging-to-another? (lambda (act)
  (and (not (owns-property? act))
       (property-has-owner? act))))

(define owns-property? (lambda (act)
  (has-attribute act 'accused-owner)))

(define property-has-owner? (lambda (act)
  (has-attribute act 'owner-exists)))

(define intention-to-permanently-deprive? (lambda (act)
  (or (intention-to-keep-permanently? act)
      (intention-to-dispose? act)
      (treats-property-as-own? act))))

(define intention-to-keep-permanently? (lambda (act)
  (has-attribute act 'permanent-retention-intent)))

(define intention-to-dispose? (lambda (act)
  (has-attribute act 'disposal-intent)))

(define treats-property-as-own? (lambda (act)
  (has-attribute act 'ownership-assumption)))

;; Robbery
(define violence-or-threat? (lambda (act)
  (or (actual-violence-used? act)
      (threat-of-violence? act))))

(define actual-violence-used? (lambda (act)
  (has-attribute act 'violence-applied)))

(define threat-of-violence? (lambda (act)
  (has-attribute act 'violent-threat)))

;; Fraud
(define misrepresentation? (lambda (act)
  (and (false-statement? act)
       (or (statement-of-fact? act)
           (concealment-of-truth? act))
       (induced-reliance? act))))

(define false-statement? (lambda (act)
  (has-attribute act 'false-representation)))

(define statement-of-fact? (lambda (act)
  (has-attribute act 'factual-assertion)))

(define concealment-of-truth? (lambda (act)
  (has-attribute act 'suppressed-truth)))

(define induced-reliance? (lambda (act)
  (has-attribute act 'victim-relied)))

(define prejudice-to-another? (lambda (act)
  (or (actual-loss-suffered? act)
      (potential-prejudice? act))))

(define actual-loss-suffered? (lambda (act)
  (has-attribute act 'financial-loss)))

(define potential-prejudice? (lambda (act)
  (has-attribute act 'risk-of-loss)))

(define benefit-to-accused? (lambda (act)
  (or (actual-benefit-received? act)
      (potential-benefit? act))))

(define actual-benefit-received? (lambda (act)
  (has-attribute act 'benefit-gained)))

(define potential-benefit? (lambda (act)
  (has-attribute act 'benefit-possible)))

(define intention-to-deceive? (lambda (act)
  (and (knowledge-of-falsity? act)
       (intention-to-mislead? act))))

(define knowledge-of-falsity? (lambda (act)
  (has-attribute act 'knew-false)))

(define intention-to-mislead? (lambda (act)
  (has-attribute act 'intent-to-deceive)))

;; Housebreaking
(define breaking? (lambda (act)
  (or (physical-breaking? act)
      (constructive-breaking? act))))

(define physical-breaking? (lambda (act)
  (has-attribute act 'forced-entry)))

(define constructive-breaking? (lambda (act)
  (or (entry-by-fraud? act)
      (entry-by-threat? act)
      (entry-through-accomplice? act))))

(define entry-by-fraud? (lambda (act)
  (has-attribute act 'fraudulent-entry)))

(define entry-by-threat? (lambda (act)
  (has-attribute act 'threatened-entry)))

(define entry-through-accomplice? (lambda (act)
  (has-attribute act 'accomplice-entry)))

(define entering? (lambda (act)
  (or (physical-entry? act)
      (instrument-entry? act))))

(define physical-entry? (lambda (act)
  (has-attribute act 'bodily-entry)))

(define instrument-entry? (lambda (act)
  (has-attribute act 'tool-insertion)))

(define building-or-structure? (lambda (act)
  (or (has-attribute act 'building)
      (has-attribute act 'structure)
      (has-attribute act 'vehicle))))

(define intent-to-commit-crime? (lambda (act)
  (has-attribute act 'ulterior-criminal-intent)))
;; =============================================================================
;; CRIMES AGAINST THE STATE - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define violent-overthrow-attempt? (lambda (act)
  (and (use-of-violence? act)
       (intention-to-overthrow-government? act)
       (overt-acts-toward-goal? act))))

(define use-of-violence? (lambda (act)
  (or (has-attribute act 'armed-force)
      (has-attribute act 'violent-action))))

(define intention-to-overthrow-government? (lambda (act)
  (has-attribute act 'overthrow-intent)))

(define overt-acts-toward-goal? (lambda (act)
  (has-attribute act 'treasonous-conduct)))

(define incitement-to-violence? (lambda (act)
  (and (public-statement? act)
       (encourages-violence? act)
       (likely-to-cause-violence? act))))

(define public-statement? (lambda (act)
  (has-attribute act 'public-communication)))

(define encourages-violence? (lambda (act)
  (has-attribute act 'violent-incitement)))

(define likely-to-cause-violence? (lambda (act)
  (has-attribute act 'imminent-violence-risk)))

(define against-state? (lambda (act)
  (or (targets-government? act)
      (undermines-state-authority? act))))

(define targets-government? (lambda (act)
  (has-attribute act 'government-target)))

(define undermines-state-authority? (lambda (act)
  (has-attribute act 'state-authority-attack)))

;; =============================================================================
;; ECONOMIC CRIMES - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define offer-or-acceptance? (lambda (act)
  (or (bribe-offered? act)
      (bribe-accepted? act))))

(define bribe-offered? (lambda (act)
  (has-attribute act 'bribe-offer)))

(define bribe-accepted? (lambda (act)
  (has-attribute act 'bribe-acceptance)))

(define undue-advantage? (lambda (act)
  (and (advantage-provided? act)
       (not (lawful-compensation? act))
       (influences-conduct? act))))

(define advantage-provided? (lambda (act)
  (has-attribute act 'benefit-given)))

(define lawful-compensation? (lambda (act)
  (has-attribute act 'legitimate-payment)))

(define influences-conduct? (lambda (act)
  (has-attribute act 'influence-intent)))

(define corrupt-purpose? (lambda (act)
  (and (improper-purpose? act)
       (dishonest-intent? act))))

(define improper-purpose? (lambda (act)
  (has-attribute act 'improper-objective)))

(define dishonest-intent? (lambda (act)
  (has-attribute act 'corrupt-intention)))

(define proceeds-of-crime? (lambda (act)
  (and (property-from-unlawful-activity? act)
       (knows-or-suspects-criminal-origin? act))))

(define property-from-unlawful-activity? (lambda (act)
  (has-attribute act 'illicit-proceeds)))

(define knows-or-suspects-criminal-origin? (lambda (act)
  (or (has-attribute act 'knowledge-of-crime)
      (has-attribute act 'suspicion-of-crime))))

(define concealment-or-disguise? (lambda (act)
  (or (hides-true-nature? act)
      (disguises-source? act)
      (transfers-to-conceal? act))))

(define hides-true-nature? (lambda (act)
  (has-attribute act 'concealment-action)))

(define disguises-source? (lambda (act)
  (has-attribute act 'disguise-origin)))

(define transfers-to-conceal? (lambda (act)
  (has-attribute act 'laundering-transfer)))

(define knowledge-of-origin? (lambda (act)
  (or (actual-knowledge? act)
      (willful-blindness? act))))

(define actual-knowledge? (lambda (act)
  (has-attribute act 'knew-source)))

(define willful-blindness? (lambda (act)
  (and (suspected-criminal-origin? act)
       (deliberately-avoided-knowledge? act))))

(define suspected-criminal-origin? (lambda (act)
  (has-attribute act 'suspicion-present)))

(define deliberately-avoided-knowledge? (lambda (act)
  (has-attribute act 'willful-ignorance)))

;; =============================================================================
;; DEFENCES - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Private Defence / Self-Defence
(define unlawful-attack? (lambda (act)
  (and (attack-occurred? act)
       (attack-unlawful? act)
       (attack-on-person-or-property? act))))

(define attack-occurred? (lambda (act)
  (has-attribute act 'attack-present)))

(define attack-unlawful? (lambda (act)
  (not (has-attribute act 'lawful-attack))))

(define attack-on-person-or-property? (lambda (act)
  (or (has-attribute act 'attack-on-person)
      (has-attribute act 'attack-on-property))))

(define defence-necessary? (lambda (act)
  (and (attack-imminent-or-continuing? act)
       (no-other-means-available? act))))

(define attack-imminent-or-continuing? (lambda (act)
  (or (has-attribute act 'imminent-attack)
      (has-attribute act 'ongoing-attack))))

(define no-other-means-available? (lambda (act)
  (not (has-attribute act 'alternative-protection))))

(define proportionate-force? (lambda (act)
  (and (force-not-excessive? act)
       (force-necessary-to-repel? act))))

(define force-not-excessive? (lambda (act)
  (not (has-attribute act 'excessive-force))))

(define force-necessary-to-repel? (lambda (act)
  (has-attribute act 'minimal-necessary-force)))

;; Necessity
(define no-alternative? (lambda (act)
  (no-other-means-available? act)))

(define imminent-danger? (lambda (act)
  (and (danger-present? act)
       (danger-immediate? act))))

(define danger-present? (lambda (act)
  (has-attribute act 'threat-of-harm)))

(define danger-immediate? (lambda (act)
  (has-attribute act 'imminent-harm)))

(define lesser-evil? (lambda (act)
  (and (harm-prevented-greater? act)
       (harm-caused-lesser? act))))

(define harm-prevented-greater? (lambda (act)
  (> (get-attribute act 'harm-prevented-value)
     (get-attribute act 'harm-caused-value))))

(define harm-caused-lesser? (lambda (act)
  (< (get-attribute act 'harm-caused-value)
     (get-attribute act 'harm-prevented-value))))

(define no-reasonable-alternative? (lambda (act)
  (not (has-attribute act 'reasonable-alternative-action)))

;; Impossibility
(define factual-impossibility? (lambda (act)
  (and (attempted-crime? act)
       (impossible-to-complete? act)
       (due-to-facts? act))))

(define attempted-crime? (lambda (act)
  (has-attribute act 'attempt)))

(define impossible-to-complete? (lambda (act)
  (has-attribute act 'completion-impossible)))

(define due-to-facts? (lambda (act)
  (has-attribute act 'factual-circumstances)))

(define legal-impossibility? (lambda (act)
  (and (believed-conduct-criminal? act)
       (conduct-not-actually-criminal? act))))

(define believed-conduct-criminal? (lambda (act)
  (has-attribute act 'mistaken-belief-crime)))

(define conduct-not-actually-criminal? (lambda (act)
  (not (has-attribute act 'actual-crime)))

;; Consent
(define voluntary-consent? (lambda (act)
  (and (consent-given-freely? act)
       (no-coercion? act)
       (no-duress? act))))

(define consent-given-freely? (lambda (act)
  (has-attribute act 'free-consent)))

(define no-coercion? (lambda (act)
  (not (has-attribute act 'coerced-consent))))

(define no-duress? (lambda (act)
  (not (has-attribute act 'consent-under-duress))))

(define informed-consent? (lambda (act)
  (and (understands-nature-of-act? act)
       (understands-consequences? act))))

(define understands-nature-of-act? (lambda (act)
  (has-attribute act 'knows-what-consenting-to)))

(define understands-consequences? (lambda (act)
  (has-attribute act 'aware-of-consequences)))

(define capacity-to-consent? (lambda (act)
  (and (mental-capacity-present? act)
       (of-legal-age? act)
       (not-intoxicated? act))))

(define mental-capacity-present? (lambda (act)
  (has-attribute act 'mental-capacity)))

(define of-legal-age? (lambda (act)
  (>= (get-attribute act 'age) 16)))

(define not-intoxicated? (lambda (act)
  (not (has-attribute act 'intoxication))))

(define lawful-purpose? (lambda (act)
  (and (not-prohibited-by-law? act)
       (not-against-public-policy? act))))

(define not-prohibited-by-law? (lambda (act)
  (not (has-attribute act 'illegal-purpose))))

(define not-against-public-policy? (lambda (act)
  (not (has-attribute act 'public-policy-violation))))

;; Mental Illness / Insanity
(define mental-illness? (lambda (act)
  (or (has-attribute act 'mental-disorder)
      (has-attribute act 'mental-defect))))

(define inability-to-appreciate-wrongfulness? (lambda (act)
  (and (mental-illness? act)
       (cannot-distinguish-right-wrong? act))))

(define cannot-distinguish-right-wrong? (lambda (act)
  (has-attribute act 'moral-incapacity)))

;; Intoxication
(define involuntary-intoxication? (lambda (act)
  (and (intoxicated? act)
       (not-voluntary-consumption? act))))

(define intoxicated? (lambda (act)
  (has-attribute act 'intoxication-state)))

(define not-voluntary-consumption? (lambda (act)
  (or (has-attribute act 'forced-consumption)
      (has-attribute act 'unknowing-consumption))))

(define complete-loss-control? (lambda (act)
  (and (intoxicated? act)
       (inability-to-form-intent? act))))

(define inability-to-form-intent? (lambda (act)
  (has-attribute act 'cannot-form-mens-rea)))

;; Mistake
(define mistake-of-fact? (lambda (act)
  (and (factual-mistake-made? act)
       (mistake-prevents-mens-rea? act)
       (reasonable-mistake? act))))

(define factual-mistake-made? (lambda (act)
  (has-attribute act 'mistaken-belief-fact)))

(define mistake-prevents-mens-rea? (lambda (act)
  (has-attribute act 'negates-intent)))

(define reasonable-mistake? (lambda (act)
  (has-attribute act 'objectively-reasonable)))

(define mistake-of-law? (lambda (act)
  (and (legal-mistake-made? act)
       (generally-not-defence? act))))

(define legal-mistake-made? (lambda (act)
  (has-attribute act 'mistaken-belief-law)))

(define generally-not-defence? (lambda (act)
  #t)) ; Ignorance of law is generally not a defence

;; Duress
(define threat-of-harm? (lambda (act)
  (or (threat-to-self? act)
      (threat-to-loved-ones? act))))

(define threat-to-self? (lambda (act)
  (has-attribute act 'personal-threat)))

(define threat-to-loved-ones? (lambda (act)
  (has-attribute act 'threat-to-others)))

(define imminent-threat? (lambda (act)
  (and (threat-immediate? act)
       (threat-serious? act))))

(define threat-immediate? (lambda (act)
  (has-attribute act 'imminent-execution)))

(define threat-serious? (lambda (act)
  (or (has-attribute act 'death-threat)
      (has-attribute act 'serious-harm-threat)))

;; Valid Consent
(define valid-consent? (lambda (act)
  (and (voluntary-consent? act)
       (informed-consent? act)
       (capacity-to-consent? act)
       (lawful-purpose? act))))
;; =============================================================================
;; CRIMINAL PROCEDURE - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Arrest
(define reasonable-suspicion? (lambda (arrest)
  (and (objective-basis-for-suspicion? arrest)
       (facts-support-belief? arrest)
       (more-than-mere-hunch? arrest))))

(define objective-basis-for-suspicion? (lambda (arrest)
  (has-attribute arrest 'factual-basis)))

(define facts-support-belief? (lambda (arrest)
  (has-attribute arrest 'supporting-evidence)))

(define more-than-mere-hunch? (lambda (arrest)
  (not (has-attribute arrest 'speculation-only))))

(define arrest-warrant-or-exception? (lambda (arrest)
  (or (has-warrant? arrest)
      (arrest-without-warrant-justified? arrest))))

(define has-warrant? (lambda (arrest)
  (has-attribute arrest 'arrest-warrant)))

(define arrest-without-warrant-justified? (lambda (arrest)
  (or (crime-in-progress? arrest)
      (suspect-about-to-flee? arrest)
      (serious-offense? arrest))))

(define crime-in-progress? (lambda (arrest)
  (has-attribute arrest 'ongoing-crime)))

(define suspect-about-to-flee? (lambda (arrest)
  (has-attribute arrest 'flight-risk)))

(define serious-offense? (lambda (arrest)
  (has-attribute arrest 'serious-crime)))

(define informed-of-rights? (lambda (arrest)
  (and (right-to-remain-silent-explained? arrest)
       (right-to-counsel-explained? arrest)
       (reason-for-arrest-given? arrest))))

(define right-to-remain-silent-explained? (lambda (arrest)
  (has-attribute arrest 'silence-right-notice)))

(define right-to-counsel-explained? (lambda (arrest)
  (has-attribute arrest 'legal-counsel-notice)))

(define reason-for-arrest-given? (lambda (arrest)
  (has-attribute arrest 'arrest-reason-stated)))

;; Search and Seizure
(define search-warrant? (lambda (search)
  (and (has-attribute search 'search-warrant)
       (warrant-valid? search))))

(define warrant-valid? (lambda (search)
  (and (properly-issued? search)
       (describes-place-and-items? search)
       (not-stale? search))))

(define properly-issued? (lambda (search)
  (has-attribute search 'judicial-authorization)))

(define describes-place-and-items? (lambda (search)
  (and (has-attribute search 'place-described)
       (has-attribute search 'items-described))))

(define not-stale? (lambda (search)
  (not (has-attribute search 'warrant-expired))))

(define consent-to-search? (lambda (search)
  (and (consent-given? search)
       (consent-voluntary? search)
       (authority-to-consent? search))))

(define consent-given? (lambda (search)
  (has-attribute search 'consent)))

(define consent-voluntary? (lambda (search)
  (not (has-attribute search 'coerced-consent))))

(define authority-to-consent? (lambda (search)
  (has-attribute search 'consenting-party-authority)))

(define search-incident-to-arrest? (lambda (search)
  (and (lawful-arrest-occurred? search)
       (search-contemporaneous? search)
       (search-scope-limited? search))))

(define lawful-arrest-occurred? (lambda (search)
  (has-attribute search 'valid-arrest)))

(define search-contemporaneous? (lambda (search)
  (has-attribute search 'immediate-after-arrest)))

(define search-scope-limited? (lambda (search)
  (or (person-searched? search)
      (immediate-area-searched? search))))

(define person-searched? (lambda (search)
  (has-attribute search 'person-search)))

(define immediate-area-searched? (lambda (search)
  (has-attribute search 'wingspan-area)))

;; Bail
(define not-flight-risk? (lambda (application)
  (and (has-ties-to-community? application)
       (not-likely-to-abscond? application))))

(define has-ties-to-community? (lambda (application)
  (or (has-attribute application 'local-residence)
      (has-attribute application 'employment)
      (has-attribute application 'family-ties))))

(define not-likely-to-abscond? (lambda (application)
  (not (has-attribute application 'flight-risk))))

(define not-danger-to-public? (lambda (application)
  (and (not-violent-offense? application)
       (no-threat-to-witnesses? application))))

(define not-violent-offense? (lambda (application)
  (not (has-attribute application 'violent-crime))))

(define no-threat-to-witnesses? (lambda (application)
  (not (has-attribute application 'witness-intimidation-risk))))

(define not-interfere-with-investigation? (lambda (application)
  (and (no-evidence-tampering-risk? application)
       (no-witness-interference-risk? application))))

(define no-evidence-tampering-risk? (lambda (application)
  (not (has-attribute application 'evidence-tampering-risk))))

(define no-witness-interference-risk? (lambda (application)
  (not (has-attribute application 'witness-interference-risk))))

;; =============================================================================
;; TRIAL RIGHTS - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define presumption-of-innocence? (lambda (trial)
  (and (accused-presumed-innocent? trial)
       (burden-on-prosecution? trial))))

(define accused-presumed-innocent? (lambda (trial)
  #t)) ; Constitutional right

(define burden-on-prosecution? (lambda (trial)
  #t)) ; Prosecution must prove guilt

(define right-to-legal-representation? (lambda (trial)
  (and (right-to-attorney? trial)
       (state-funded-if-indigent? trial))))

(define right-to-attorney? (lambda (trial)
  #t)) ; Constitutional right

(define state-funded-if-indigent? (lambda (trial)
  (or (has-attribute trial 'legal-aid)
      (can-afford-attorney? trial))))

(define can-afford-attorney? (lambda (trial)
  (has-attribute trial 'private-counsel)))

(define right-to-remain-silent? (lambda (trial)
  (and (not-compelled-to-testify? trial)
       (silence-no-adverse-inference? trial))))

(define not-compelled-to-testify? (lambda (trial)
  #t)) ; Constitutional right

(define silence-no-adverse-inference? (lambda (trial)
  #t)) ; Cannot draw negative inference from silence

(define right-to-confront-witnesses? (lambda (trial)
  (and (right-to-cross-examine? trial)
       (witnesses-testify-in-presence? trial))))

(define right-to-cross-examine? (lambda (trial)
  #t)) ; Constitutional right

(define witnesses-testify-in-presence? (lambda (trial)
  (or (has-attribute trial 'in-person-testimony)
      (has-attribute trial 'special-measures-justified))))

(define trial-without-unreasonable-delay? (lambda (trial)
  (and (trial-commenced-promptly? trial)
       (no-unnecessary-adjournments? trial))))

(define trial-commenced-promptly? (lambda (trial)
  (not (has-attribute trial 'unreasonable-delay))))

(define no-unnecessary-adjournments? (lambda (trial)
  (not (has-attribute trial 'excessive-postponements))))

;; =============================================================================
;; BURDEN OF PROOF AND EVIDENCE
;; =============================================================================

(define prosecution-burden? (lambda (evidence)
  (has-attribute evidence 'prosecution-presents)))

(define no-reasonable-doubt? (lambda (evidence)
  (and (evidence-overwhelming? evidence)
       (excludes-reasonable-hypothesis? evidence))))

(define evidence-overwhelming? (lambda (evidence)
  (has-attribute evidence 'strong-evidence)))

(define excludes-reasonable-hypothesis? (lambda (evidence)
  (not (has-attribute evidence 'reasonable-alternative)))

;; =============================================================================
;; SENTENCING - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define consider-aggravating-factors? (lambda (sentence)
  (or (has-attribute sentence 'violence-involved)
      (has-attribute sentence 'premeditation)
      (has-attribute sentence 'victim-vulnerability)
      (has-attribute sentence 'prior-convictions)
      (has-attribute sentence 'abuse-of-trust))))

(define consider-mitigating-factors? (lambda (sentence)
  (or (has-attribute sentence 'young-age)
      (has-attribute sentence 'provocation)
      (has-attribute sentence 'remorse)
      (has-attribute sentence 'first-offender)
      (has-attribute sentence 'family-responsibilities)
      (has-attribute sentence 'rehabilitation-prospects))))

(define proportionality? (lambda (sentence crime)
  (and (severity-matches-offense? sentence crime)
       (not-excessive? sentence)
       (not-too-lenient? sentence))))

(define severity-matches-offense? (lambda (sentence crime)
  (appropriate-sentence-range? sentence crime)))

(define appropriate-sentence-range? (lambda (sentence crime)
  (let ((crime-severity (get-attribute crime 'severity))
        (sentence-severity (get-attribute sentence 'severity)))
    (and (>= sentence-severity (* 0.8 crime-severity))
         (<= sentence-severity (* 1.2 crime-severity)))))

(define not-excessive? (lambda (sentence)
  (not (has-attribute sentence 'disproportionately-harsh))))

(define not-too-lenient? (lambda (sentence)
  (not (has-attribute sentence 'inadequately-lenient))))

(define consistency? (lambda (sentence)
  (and (similar-to-precedent? sentence)
       (justified-if-different? sentence))))

(define similar-to-precedent? (lambda (sentence)
  (has-attribute sentence 'precedent-consistent)))

(define justified-if-different? (lambda (sentence)
  (or (similar-to-precedent? sentence)
      (has-attribute sentence 'departure-justified))))

;; Sentence Types
(define imprisonment? (lambda (sentence)
  (has-attribute sentence 'custodial-sentence)))

(define fine? (lambda (sentence)
  (has-attribute sentence 'monetary-penalty)))

(define community-service? (lambda (sentence)
  (has-attribute sentence 'community-work-order)))

(define suspended-sentence? (lambda (sentence)
  (and (has-attribute sentence 'imprisonment-suspended)
       (conditions-for-suspension? sentence))))

(define conditions-for-suspension? (lambda (sentence)
  (has-attribute sentence 'suspension-conditions)))

(define correctional-supervision? (lambda (sentence)
  (has-attribute sentence 'supervised-release)))

;; =============================================================================
;; CAPACITY - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define under-18? (lambda (person)
  (< (get-attribute person 'age) 18)))

(define criminal-capacity? (lambda (person)
  (and (above-minimum-age? person)
       (understands-wrongfulness-capacity? person))))

(define above-minimum-age? (lambda (person)
  (>= (get-attribute person 'age) 10)))

(define understands-wrongfulness-capacity? (lambda (person)
  (or (>= (get-attribute person 'age) 14)
      (proven-understanding? person))))

(define proven-understanding? (lambda (person)
  (has-attribute person 'demonstrated-understanding)))

(define understanding-wrongfulness? (lambda (child)
  (and (appreciates-nature-of-act? child)
       (knows-act-is-wrong? child)
       (can-act-in-accordance? child))))

(define appreciates-nature-of-act? (lambda (child)
  (has-attribute child 'understands-conduct)))

(define knows-act-is-wrong? (lambda (child)
  (has-attribute child 'moral-awareness)))

(define can-act-in-accordance? (lambda (child)
  (has-attribute child 'control-capacity')))

;; =============================================================================
;; END OF SOUTH AFRICAN CRIMINAL LAW FRAMEWORK
;; =============================================================================

;; This framework provides the foundational structure for implementing
;; South African criminal law in a rule-based system.
