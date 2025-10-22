;; South African Civil Law - Enhanced Version
;; Scheme implementation for legal reasoning and rule-based systems
;; This file establishes the foundational structure for South African civil legislation
;; Version: 2.1
;; Last Updated: 2025-10-23

;; =============================================================================
;; MODULE DEFINITION AND IMPORTS
;; =============================================================================

;; For Guile Scheme module system (uncomment when using with Guile):
;;
;; (define-module (civ za south-african-civil-law)
;;   #:use-module (lv1 known-laws)
;;   #:use-module (srfi srfi-1)
;;   #:use-module (ice-9 hash-table)
;;   #:export (...))

;; Import Level 1 first-order principles (when using module system)
;; (use-modules (lv1 known-laws))

;; =============================================================================
;; FRAMEWORK METADATA
;; =============================================================================

(define framework-metadata
  (list
   (cons 'name "South African Civil Law")
   (cons 'jurisdiction "ZA")
   (cons 'legal-domain '(civil contract delict property family))
   (cons 'version "2.1")
   (cons 'last-updated "2025-10-23")
   (cons 'derived-from-level 1)
   (cons 'confidence-base 0.95)
   (cons 'language "en")))

;; =============================================================================
;; HELPER FUNCTIONS
;; =============================================================================

(define (has-attribute entity attr)
  "Check if an entity has a specific attribute"
  (cond
    ((hash-table? entity) (hash-has-key? entity attr))
    ((list? entity) (assoc attr entity))
    (else #f)))

(define (get-attribute entity attr)
  "Get an attribute value from an entity"
  (cond
    ((hash-table? entity) (hash-ref entity attr #f))
    ((list? entity) (let ((pair (assoc attr entity)))
                      (if pair (cdr pair) #f)))
    (else #f)))

(define (has-right person right-type)
  "Check if a person has a specific right"
  (has-attribute person right-type))

;; =============================================================================
;; CORE LEGAL CONCEPTS AND DEFINITIONS
;; =============================================================================

;; Legal Personhood and Capacity
;; Derived from: compos-mentis, legal-capacity principles (Level 1)

(define (legal-person? entity)
  "Determine if an entity is a legal person (natural or juristic)"
  (or (natural-person? entity) 
      (juristic-person? entity)))

(define (natural-person? entity)
  "Determine if an entity is a natural person"
  (and (has-attribute entity 'birth-date)
       (has-attribute entity 'identity-number)))

(define (juristic-person? entity)
  "Determine if an entity is a juristic person (company, trust, etc.)"
  (and (has-attribute entity 'registration-number)
       (has-attribute entity 'legal-status)))

(define (legal-capacity person age)
  "Determine the legal capacity of a person based on age
   Returns: 'minor, 'major-with-restrictions, 'full-capacity, or 'unknown"
  (cond
    ((< age 7) 'doli-incapax)           ;; Below age of criminal capacity
    ((< age 18) 'minor)                  ;; Minor - limited capacity
    ((and (>= age 18) (< age 21)) 'major-with-restrictions)  ;; Young adult
    ((>= age 21) 'full-capacity)         ;; Full legal capacity
    (else 'unknown)))

;; =============================================================================
;; CONTRACT LAW FRAMEWORK
;; =============================================================================
;; Derived from Level 1 principles:
;; - pacta-sunt-servanda (agreements must be kept)
;; - consensus-ad-idem (meeting of minds)
;; - consideration-exists (quid pro quo)
;; - bona-fides (good faith)

(define (contract-valid? contract)
  "Determine if a contract is valid under South African law
   Requires: offer, acceptance, consideration, intention, capacity, legality
   Cross-reference: pacta-sunt-servanda, consensus-ad-idem (Level 1)"
  (and (offer-exists? contract)
       (acceptance-exists? contract)
       (consideration-exists? contract)
       (intention-to-create-legal-relations? contract)
       (capacity-of-parties? contract)
       (legality-of-object? contract)))

;; Offer and Acceptance
(define (offer-exists? contract)
  "Check if a valid offer exists in the contract"
  (has-attribute contract 'offer))

(define (acceptance-exists? contract)
  "Check if a valid acceptance exists in the contract
   Cross-reference: consensus-ad-idem (Level 1)"
  (has-attribute contract 'acceptance))

(define (consideration-exists? contract)
  "Check if consideration exists in the contract
   Cross-reference: consideration-exists (Level 1)"
  (has-attribute contract 'consideration))

(define (intention-to-create-legal-relations? contract)
  "Check if parties intended to create legal relations"
  (has-attribute contract 'intention-to-be-bound))

(define (capacity-of-parties? contract)
  "Check if all parties have legal capacity to contract
   Cross-reference: compos-mentis, legal-capacity (Level 1)"
  (and (has-attribute contract 'party-a-capacity)
       (has-attribute contract 'party-b-capacity)))

(define (legality-of-object? contract)
  "Check if the contract object is legal
   Cross-reference: ex-turpi-causa-non-oritur-actio (Level 1)"
  (not (has-attribute contract 'illegal-purpose)))

;; Contract Formation Rules
(define (offer-revoked? offer)
  "Check if an offer has been revoked"
  (or (has-attribute offer 'revocation-notice)
      (has-attribute offer 'counter-offer)))

(define (acceptance-effective? acceptance offer)
  "Check if acceptance is effective (mirror image rule, timing)"
  (and (within-reasonable-time? acceptance offer)
       (mirror-image-rule? acceptance offer)))

(define (within-reasonable-time? acceptance offer)
  "Check if acceptance occurred within reasonable time"
  (has-attribute acceptance 'timely))

(define (mirror-image-rule? acceptance offer)
  "Check if acceptance matches offer exactly (mirror image rule)"
  (has-attribute acceptance 'matches-offer))

;; =============================================================================
;; DELICT LAW (TORT LAW) FRAMEWORK
;; =============================================================================
;; Derived from Level 1 principles:
;; - damnum-injuria-datum (loss wrongfully caused)
;; - culpa (fault/negligence)
;; - causa-sine-qua-non (but-for causation)
;; - volenti-non-fit-injuria (consent defense)

(define (delict-established? claim)
  "Determine if delictual liability is established
   Requires: act/omission, wrongfulness, fault, causation, damage
   Cross-reference: damnum-injuria-datum, culpa (Level 1)"
  (and (act-or-omission? claim)
       (wrongfulness? claim)
       (fault? claim)
       (causation? claim)
       (damage? claim)))

(define (act-or-omission? claim)
  "Check if there was an act or omission"
  (has-attribute claim 'conduct))

(define (wrongfulness? act)
  "Determine if conduct is wrongful
   Cross-reference: contra-bonos-mores (Level 1)"
  (or (contra-boni-mores? act)
      (infringement-of-right? act)
      (breach-of-legal-duty? act)))

(define (contra-boni-mores? act)
  "Check if act is contra bonos mores (against good morals)
   Cross-reference: contra-bonos-mores (Level 1)"
  (has-attribute act 'violates-community-norms))

(define (infringement-of-right? act)
  "Check if act infringes on a legal right"
  (has-attribute act 'infringes-right))

(define (breach-of-legal-duty? act)
  "Check if act breaches a legal duty"
  (has-attribute act 'breaches-duty))

(define (fault? claim)
  "Determine if fault (intention or negligence) exists
   Cross-reference: culpa (Level 1)"
  (or (intention? claim)
      (negligence? claim)))

(define (intention? claim)
  "Check if defendant acted with intention (dolus)"
  (has-attribute claim 'dolus))

(define (negligence? defendant)
  "Determine if defendant was negligent
   Cross-reference: culpa, reasonable-person-test (Level 1)"
  (and (duty-of-care? defendant)
       (breach-of-duty? defendant)
       (reasonable-person-standard? defendant)))

(define (duty-of-care? defendant)
  "Check if defendant owed a duty of care"
  (has-attribute defendant 'duty-of-care))

(define (breach-of-duty? defendant)
  "Check if defendant breached the duty of care"
  (has-attribute defendant 'breach))

(define (reasonable-person-standard? defendant)
  "Apply the reasonable person test
   Cross-reference: reasonable-person-test (Level 1)"
  (has-attribute defendant 'failed-reasonable-person-test))

(define (causation? claim)
  "Determine if causation exists (factual and legal)
   Cross-reference: causa-sine-qua-non (Level 1)"
  (and (factual-causation? claim)
       (legal-causation? claim)))

(define (factual-causation? claim)
  "Apply the but-for test for factual causation
   Cross-reference: causa-sine-qua-non (Level 1)"
  (has-attribute claim 'but-for-test-satisfied))

(define (legal-causation? claim)
  "Determine legal causation (reasonable foreseeability)"
  (and (factual-causation? claim)
       (reasonable-foreseeability? claim)))

(define (reasonable-foreseeability? claim)
  "Check if harm was reasonably foreseeable"
  (has-attribute claim 'reasonably-foreseeable))

(define (damage? claim)
  "Check if damage/harm occurred"
  (has-attribute claim 'damage))

;; =============================================================================
;; PROPERTY LAW FRAMEWORK
;; =============================================================================
;; Derived from Level 1 principles:
;; - nemo-plus-iuris (no one can transfer more rights than they have)
;; - nemo-dat-quod-non-habet (no one gives what they don't have)
;; - res-nullius (things belonging to no one)

(define (ownership? person property)
  "Determine if person has ownership of property
   Ownership includes: use, enjoy, dispose (usus, fructus, abusus)
   Cross-reference: nemo-plus-iuris (Level 1)"
  (and (has-right person 'use)
       (has-right person 'enjoy)
       (has-right person 'dispose)))

(define (possession? person property)
  "Determine if person has possession of property
   Requires: physical control + intention to possess (corpus + animus)"
  (and (physical-control? person property)
       (intention-to-possess? person property)))

(define (physical-control? person property)
  "Check if person has physical control (corpus possessionis)"
  (has-attribute person 'physical-control))

(define (intention-to-possess? person property)
  "Check if person has intention to possess (animus possidendi)"
  (has-attribute person 'animus-possidendi))

;; Real Rights vs Personal Rights
(define (real-right? right)
  "Determine if a right is a real right (enforceable against the world)"
  (has-attribute right 'enforceable-against-world))

(define (personal-right? right)
  "Determine if a right is a personal right (enforceable against specific person)"
  (has-attribute right 'enforceable-against-specific-person))

;; =============================================================================
;; FAMILY LAW FRAMEWORK
;; =============================================================================

(define (marriage-valid? marriage)
  "Determine if a marriage is valid under South African law
   Requires: capacity, consent, formalities, no impediments"
  (and (capacity-to-marry? marriage)
       (consent-to-marry? marriage)
       (proper-formalities? marriage)
       (no-impediments? marriage)))

(define (capacity-to-marry? marriage)
  "Check if parties have capacity to marry (age, mental capacity)"
  (has-attribute marriage 'capacity))

(define (consent-to-marry? marriage)
  "Check if parties consented to marry
   Cross-reference: consensus-ad-idem (Level 1)"
  (has-attribute marriage 'consent))

(define (proper-formalities? marriage)
  "Check if proper formalities were observed"
  (has-attribute marriage 'formalities-complied))

(define (no-impediments? marriage)
  "Check if there are no impediments to marriage"
  (not (has-attribute marriage 'impediment)))

(define (divorce-grounds? marriage)
  "Determine if grounds for divorce exist"
  (or (irretrievable-breakdown? marriage)
      (mental-illness? marriage)
      (continuous-unconsciousness? marriage)))

(define (irretrievable-breakdown? marriage)
  "Check if marriage has irretrievably broken down"
  (has-attribute marriage 'irretrievable-breakdown))

(define (mental-illness? marriage)
  "Check if mental illness ground applies"
  (has-attribute marriage 'mental-illness))

(define (continuous-unconsciousness? marriage)
  "Check if continuous unconsciousness ground applies"
  (has-attribute marriage 'continuous-unconsciousness))

(define (parental-responsibilities parent child)
  "Determine parental responsibilities and rights
   Includes: care, contact, maintenance, guardianship"
  (list
   (cons 'care (care-responsibility? parent child))
   (cons 'contact (contact-responsibility? parent child))
   (cons 'maintenance (maintenance-responsibility? parent child))
   (cons 'guardianship (guardianship-responsibility? parent child))))

(define (care-responsibility? parent child)
  "Check care responsibility"
  (has-attribute parent 'care-duty))

(define (contact-responsibility? parent child)
  "Check contact responsibility"
  (has-attribute parent 'contact-right))

(define (maintenance-responsibility? parent child)
  "Check maintenance responsibility"
  (has-attribute parent 'maintenance-duty))

(define (guardianship-responsibility? parent child)
  "Check guardianship responsibility"
  (has-attribute parent 'guardianship))

;; =============================================================================
;; CROSS-REFERENCE TO LEVEL 1 PRINCIPLES
;; =============================================================================

;; This framework derives from the following Level 1 principles:
;; - pacta-sunt-servanda (contract law foundation)
;; - consensus-ad-idem (contract formation)
;; - consideration-exists (contract validity)
;; - bona-fides (good faith in contracts)
;; - damnum-injuria-datum (delict foundation)
;; - culpa (fault element)
;; - causa-sine-qua-non (causation)
;; - volenti-non-fit-injuria (consent defense)
;; - contra-bonos-mores (wrongfulness test)
;; - nemo-plus-iuris (property transfer limits)
;; - nemo-dat-quod-non-habet (property transfer validity)
;; - compos-mentis (legal capacity)
;; - ex-turpi-causa-non-oritur-actio (illegality defense)

;; =============================================================================
;; EXPORT (for module system)
;; =============================================================================

;; When using Guile module system, export all public functions:
;; (export legal-person? natural-person? juristic-person? legal-capacity
;;         contract-valid? offer-exists? acceptance-exists? ...
;;         delict-established? wrongfulness? fault? causation? ...
;;         ownership? possession? real-right? personal-right? ...
;;         marriage-valid? divorce-grounds? parental-responsibilities ...)

