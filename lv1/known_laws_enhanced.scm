;; Known Laws - Inference Level 1 (First-Order Principles)
;; Enhanced Version with Proper Scheme Module Structure
;; Fundamental legal maxims and principles from which the scheme frameworks are derived
;; Version: 2.1
;; Last Updated: 2025-10-23

(define-module (lv1 known-laws)
  #:use-module (srfi srfi-1)   ;; List library
  #:use-module (srfi srfi-9)   ;; Records
  #:use-module (srfi srfi-19)  ;; Time/Date
  #:use-module (ice-9 hash-table)
  #:export (;; Principle constructors and accessors
            make-principle
            principle-name
            principle-description
            principle-domain
            principle-confidence
            principle-provenance
            principle-related
            principle-inference-type
            principle-context
            
            ;; Reasoning functions
            principle-applies?
            derive-from-known-law
            combine-known-laws
            find-related-principles
            build-inference-chain
            validate-inference
            compute-derived-confidence
            
            ;; Registry functions
            initialize-principle-registry!
            register-principle!
            get-principle-from-registry
            get-principles-by-domain
            get-all-principles
            
            ;; All principle definitions
            pacta-sunt-servanda
            consensus-ad-idem
            exceptio-non-adimpleti-contractus
            consideration-exists
            nemo-plus-iuris
            nemo-dat-quod-non-habet
            res-nullius
            audi-alteram-partem
            nemo-iudex-in-causa-sua
            ei-qui-affirmat-non-ei-qui-negat-incumbit-probatio
            lex-specialis-derogat-legi-generali
            lex-posterior-derogat-legi-priori
            expressio-unius-est-exclusio-alterius
            nullum-crimen-sine-lege
            nulla-poena-sine-lege
            in-dubio-pro-reo
            actus-non-facit-reum-nisi-mens-sit-rea
            damnum-injuria-datum
            volenti-non-fit-injuria
            culpa
            res-ipsa-loquitur
            supremacy-of-constitution
            rule-of-law
            separation-of-powers
            ubuntu
            legality
            rationality
            procedural-fairness
            legitimate-expectation
            equity-will-not-suffer-a-wrong-without-remedy
            he-who-seeks-equity-must-do-equity
            equality-is-equity
            equity-follows-the-law
            onus-probandi
            best-evidence-rule
            relevance
            hearsay-rule
            literal-rule
            golden-rule
            mischief-rule
            purposive-approach
            tempus-regit-actum
            prescription
            laches
            restitutio-in-integrum
            specific-performance
            injunction
            ubi-ius-ibi-remedium
            doli-incapax
            compos-mentis
            bona-fides
            contra-bonos-mores
            ex-turpi-causa-non-oritur-actio
            uberrima-fides
            qui-facit-per-alium-facit-per-se
            respondeat-superior
            causa-sine-qua-non
            novus-actus-interveniens
            proportionality
            subsidiarity
            non-refoulement
            jus-cogens
            pacta-tertiis-nec-nocent-nec-prosunt))

;; =============================================================================
;; PRINCIPLE CONSTRUCTOR AND ACCESSOR FUNCTIONS
;; =============================================================================

;; Constructor for principle structure using hash tables
(define (make-principle . args)
  "Create a new legal principle with metadata.
   Usage: (make-principle 'name 'principle-name 'description \"...\" ...)"
  (let ((principle (make-hash-table)))
    (let loop ((args args))
      (if (null? args)
          principle
          (begin
            (hash-set! principle (car args) (cadr args))
            (loop (cddr args)))))))

;; Accessor functions for principle attributes
(define (principle-name p) 
  "Get the name of a principle"
  (hash-ref p 'name))

(define (principle-description p) 
  "Get the description of a principle"
  (hash-ref p 'description))

(define (principle-domain p) 
  "Get the legal domains where this principle applies"
  (hash-ref p 'domain))

(define (principle-confidence p) 
  "Get the confidence level (0.0-1.0) of this principle"
  (hash-ref p 'confidence))

(define (principle-provenance p) 
  "Get the historical/jurisdictional origin of this principle"
  (hash-ref p 'provenance))

(define (principle-related p) 
  "Get list of related principles"
  (hash-ref p 'related-principles))

(define (principle-inference-type p) 
  "Get the inference type for this principle"
  (hash-ref p 'inference-type))

(define (principle-context p) 
  "Get the application context for this principle"
  (hash-ref p 'application-context))

;; =============================================================================
;; PRINCIPLE REGISTRY
;; =============================================================================

;; Global registry of all principles
(define *principle-registry* (make-hash-table))

;; Function to register a principle
(define (register-principle! principle)
  "Register a principle in the global registry"
  (hash-set! *principle-registry* 
             (principle-name principle) 
             principle))

;; Function to get principle from registry
(define (get-principle-from-registry name)
  "Retrieve a principle by name from the registry"
  (hash-ref *principle-registry* name #f))

;; Function to get all principles in a domain
(define (get-principles-by-domain domain)
  "Get all principles applicable to a specific legal domain"
  (hash-fold (lambda (name principle acc)
               (if (member domain (principle-domain principle))
                   (cons principle acc)
                   acc))
             '()
             *principle-registry*))

;; Function to get all registered principles
(define (get-all-principles)
  "Get all principles from the registry"
  (hash-fold (lambda (name principle acc)
               (cons principle acc))
             '()
             *principle-registry*))

;; =============================================================================
;; HELPER FUNCTIONS
;; =============================================================================

(define (has-attribute entity attr)
  "Check if an entity has a specific attribute"
  (and (hash-table? entity)
       (hash-has-key? entity attr)))

(define (get-attribute entity attr)
  "Get an attribute value from an entity"
  (if (hash-table? entity)
      (hash-ref entity attr #f)
      #f))

(define (domain-matches? principle-domains context-domain)
  "Check if a context domain matches any of the principle's domains"
  (member context-domain principle-domains))

(define (principle-matches-context? principle context)
  "Check if a principle matches a given context (placeholder for sophisticated matching)"
  #t)

(define (current-timestamp)
  "Get current timestamp as string"
  (date->string (current-date) "~Y-~m-~d ~H:~M:~S"))

;; =============================================================================
;; LEGAL REASONING FUNCTIONS
;; =============================================================================

;; Function to check if a principle applies to a given context
(define (principle-applies? principle context)
  "Determine if a legal principle applies to a given context"
  (and (has-attribute context 'legal-domain)
       (has-attribute context 'fact-pattern)
       (domain-matches? (principle-domain principle) 
                       (get-attribute context 'legal-domain))
       (principle-matches-context? principle context)))

;; Function to derive inference from known law
(define (derive-from-known-law law fact-pattern inference-type)
  "Create an inference from a known law applied to facts"
  (list 'inference
        (list 'source (principle-name law))
        (list 'facts fact-pattern)
        (list 'level 1)  ;; Level 1 = first-order principle
        (list 'confidence (principle-confidence law))
        (list 'inference-type inference-type)
        (list 'timestamp (current-timestamp))))

;; Function to combine multiple known laws
(define (combine-known-laws . laws)
  "Combine multiple known laws into a composite structure"
  (map (lambda (law) 
         (list 'known-law 
               (principle-name law)
               (principle-confidence law))) 
       laws))

;; Function to find related principles
(define (find-related-principles principle)
  "Find all principles related to a given principle"
  (principle-related principle))

;; Function to build inference chain between two principles
(define (build-inference-chain start-principle end-principle)
  "Build an inference chain from start principle to end principle using DFS"
  (let ((visited (make-hash-table))
        (path '()))
    (define (dfs current target)
      (if (eq? (principle-name current) target)
          (reverse (cons current path))
          (begin
            (hash-set! visited (principle-name current) #t)
            (let loop ((related (principle-related current)))
              (if (null? related)
                  #f
                  (let ((next (car related)))
                    (if (hash-ref visited next #f)
                        (loop (cdr related))
                        (begin
                          (set! path (cons current path))
                          (let ((next-principle (get-principle-from-registry next)))
                            (if next-principle
                                (let ((result (dfs next-principle target)))
                                  (if result
                                      result
                                      (begin
                                        (set! path (cdr path))
                                        (loop (cdr related)))))
                                (loop (cdr related))))))))))))
    (dfs start-principle (principle-name end-principle))))

;; Function to validate inference
(define (validate-inference inference)
  "Validate that an inference has all required attributes"
  (and (has-attribute inference 'source)
       (has-attribute inference 'facts)
       (has-attribute inference 'confidence)
       (>= (get-attribute inference 'confidence) 0.0)
       (<= (get-attribute inference 'confidence) 1.0)))

;; Function to compute confidence for derived principle
(define (compute-derived-confidence base-principles inference-type)
  "Compute confidence level for a principle derived from base principles"
  (let ((base-confidence (apply min (map principle-confidence base-principles))))
    (case inference-type
      ((deductive) (* base-confidence 0.95))  ;; Deductive reasoning preserves most confidence
      ((inductive) (* base-confidence 0.80))  ;; Inductive reasoning reduces confidence
      ((abductive) (* base-confidence 0.70))  ;; Abductive reasoning reduces confidence more
      ((analogical) (* base-confidence 0.65)) ;; Analogical reasoning most uncertain
      (else (* base-confidence 0.50)))))

;; =============================================================================
;; NOTE: All principle definitions follow in the original known_laws.scm
;; This enhanced version provides the module structure and improved functions
;; The actual principle definitions remain the same
;; =============================================================================

