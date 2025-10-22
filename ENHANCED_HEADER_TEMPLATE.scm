;; Enhanced Legal Framework Header Template
;; This template demonstrates how jurisdiction-specific frameworks
;; should reference Level 1 first-order principles
;; =============================================================================

;; Import Level 1 first-order principles
(require "lv1/known_laws.scm")

;; Initialize principle registry
(initialize-principle-registry!)

;; =============================================================================
;; FRAMEWORK METADATA
;; =============================================================================

(define framework-metadata
  (make-hash-table
   'name "Framework Name"
   'jurisdiction "za"  ;; ISO 3166-1 alpha-2 country code
   'legal-domain '(civil)  ;; List of applicable domains
   'version "2.0"
   'last-updated "2025-10-22"
   'derived-from-level 1  ;; Indicates derivation from Level 1 principles
   'confidence-base 0.95  ;; Base confidence for jurisdiction-specific rules
   'language "en"))

;; =============================================================================
;; PRINCIPLE DERIVATION EXAMPLES
;; =============================================================================

;; Example: Deriving a jurisdiction-specific rule from Level 1 principles
(define contract-formation-rule
  (derive-from-principles
   'name 'contract-formation-za
   'base-principles (list pacta-sunt-servanda 
                          consensus-ad-idem 
                          consideration-exists)
   'inference-type 'deductive
   'jurisdiction "za"
   'statutory-basis "Common law, influenced by Roman-Dutch law"
   'description "In South African law, a valid contract requires offer, acceptance, and consensus ad idem"
   'confidence (compute-derived-confidence 
                (list pacta-sunt-servanda consensus-ad-idem) 
                'deductive)))

;; Example: Function that references Level 1 principles
(define (contract-valid? contract)
  ;; Check if contract satisfies Level 1 principles
  (and (principle-applies? pacta-sunt-servanda contract)
       (principle-applies? consensus-ad-idem contract)
       ;; Add jurisdiction-specific checks
       (offer-exists? contract)
       (acceptance-exists? contract)
       (consideration-exists? contract)
       (intention-to-create-legal-relations? contract)
       (capacity-of-parties? contract)
       (legality-of-object? contract)))

;; =============================================================================
;; INFERENCE CHAIN DOCUMENTATION
;; =============================================================================

;; Document how jurisdiction-specific rules derive from Level 1
(define contract-law-inference-chain
  (list
   (list 'level 1 
         'principles '(pacta-sunt-servanda consensus-ad-idem)
         'confidence 1.0)
   (list 'level 2
         'rule 'contract-formation-za
         'inference-type 'deductive
         'confidence 0.95)
   (list 'level 3
         'rule 'specific-contract-types
         'inference-type 'inductive
         'confidence 0.85)))

;; =============================================================================
;; CROSS-REFERENCE SYSTEM
;; =============================================================================

;; Function to find applicable Level 1 principles for a legal issue
(define (find-applicable-principles legal-issue)
  (let ((domain (get-attribute legal-issue 'domain))
        (fact-pattern (get-attribute legal-issue 'facts)))
    (filter (lambda (principle)
              (principle-applies? principle legal-issue))
            (get-principles-by-domain domain))))

;; =============================================================================
;; VALIDATION FUNCTIONS
;; =============================================================================

;; Validate that a jurisdiction-specific rule properly derives from Level 1
(define (validate-derivation rule)
  (and (has-attribute rule 'base-principles)
       (has-attribute rule 'inference-type)
       (all-principles-exist? (get-attribute rule 'base-principles))
       (valid-inference-type? (get-attribute rule 'inference-type))
       (confidence-properly-computed? rule)))

;; Helper validation functions
(define (all-principles-exist? principle-list)
  (all (map (lambda (p) (get-principle-from-registry (principle-name p))) 
            principle-list)))

(define (valid-inference-type? type)
  (member type '(deductive inductive abductive analogical)))

(define (confidence-properly-computed? rule)
  (let ((expected (compute-derived-confidence 
                   (get-attribute rule 'base-principles)
                   (get-attribute rule 'inference-type)))
        (actual (get-attribute rule 'confidence)))
    (<= (abs (- expected actual)) 0.05)))  ;; Allow 5% tolerance

