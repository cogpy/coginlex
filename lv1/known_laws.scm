;; Known Laws - Inference Level 1 (First-Order Principles)
;; Fundamental legal maxims and principles from which the scheme frameworks are derived
;; These are the foundational legal principles that underpin all legal reasoning
;; Enhanced with structured metadata, inference rules, and cross-references
;; Version: 2.0
;; Last Updated: 2025-10-22

;; =============================================================================
;; METADATA STRUCTURE
;; =============================================================================
;; Each principle now includes:
;; - name: identifier
;; - description: human-readable explanation
;; - domain: legal domain(s) where applicable
;; - confidence: 1.0 (explicitly stated, universally recognized)
;; - provenance: historical/jurisdictional origin
;; - related-principles: cross-references
;; - inference-type: how this principle can be used in reasoning

;; =============================================================================
;; GENERAL LEGAL PRINCIPLES
;; =============================================================================

;; Contract and Agreement Principles
(define pacta-sunt-servanda
  (make-principle
   'name 'pacta-sunt-servanda
   'description "Agreements must be kept - the foundational principle of contract law"
   'domain '(contract civil international)
   'confidence 1.0
   'provenance "Roman law, universally recognized"
   'related-principles '(consensus-ad-idem bona-fides)
   'inference-type 'deductive
   'application-context "Binding force of contracts between parties"))

(define consensus-ad-idem
  (make-principle
   'name 'consensus-ad-idem
   'description "Meeting of the minds - parties must have mutual agreement"
   'domain '(contract civil)
   'confidence 1.0
   'provenance "Roman law, common law"
   'related-principles '(pacta-sunt-servanda bona-fides)
   'inference-type 'deductive
   'application-context "Formation of valid contracts"))

(define exceptio-non-adimpleti-contractus
  (make-principle
   'name 'exceptio-non-adimpleti-contractus
   'description "Exception of non-performance - a party need not perform if the other has not"
   'domain '(contract civil)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(pacta-sunt-servanda reciprocity)
   'inference-type 'deductive
   'application-context "Bilateral contracts with reciprocal obligations"))

(define consideration-exists
  (make-principle
   'name 'consideration-exists
   'description "Valid contracts require consideration or quid pro quo"
   'domain '(contract civil)
   'confidence 1.0
   'provenance "Common law"
   'related-principles '(pacta-sunt-servanda consensus-ad-idem)
   'inference-type 'deductive
   'application-context "Contract formation in common law jurisdictions"))

;; Property and Ownership Principles
(define nemo-plus-iuris
  (make-principle
   'name 'nemo-plus-iuris
   'description "No one can transfer more rights than they have"
   'domain '(property civil)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(nemo-dat-quod-non-habet ownership-rights)
   'inference-type 'deductive
   'application-context "Transfer of property rights"))

(define nemo-dat-quod-non-habet
  (make-principle
   'name 'nemo-dat-quod-non-habet
   'description "No one gives what they do not have"
   'domain '(property civil)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(nemo-plus-iuris ownership-rights)
   'inference-type 'deductive
   'application-context "Validity of property transfers"))

(define res-nullius
  (make-principle
   'name 'res-nullius
   'description "A thing belonging to no one - can be acquired by occupation"
   'domain '(property civil)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(ownership-rights occupation)
   'inference-type 'deductive
   'application-context "Original acquisition of property"))

;; Procedural Justice Principles
(define audi-alteram-partem
  (make-principle
   'name 'audi-alteram-partem
   'description "Hear the other side - fundamental principle of natural justice"
   'domain '(procedure administrative constitutional)
   'confidence 1.0
   'provenance "Roman law, natural justice"
   'related-principles '(procedural-fairness nemo-iudex-in-causa-sua)
   'inference-type 'deductive
   'application-context "Fair hearing rights in all proceedings"))

(define nemo-iudex-in-causa-sua
  (make-principle
   'name 'nemo-iudex-in-causa-sua
   'description "No one should be a judge in their own cause"
   'domain '(procedure administrative constitutional)
   'confidence 1.0
   'provenance "Natural justice"
   'related-principles '(audi-alteram-partem procedural-fairness impartiality)
   'inference-type 'deductive
   'application-context "Judicial and administrative impartiality"))

(define ei-qui-affirmat-non-ei-qui-negat-incumbit-probatio
  (make-principle
   'name 'ei-qui-affirmat-non-ei-qui-negat-incumbit-probatio
   'description "The burden of proof lies on the one who affirms, not on the one who denies"
   'domain '(procedure evidence civil criminal)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(onus-probandi in-dubio-pro-reo)
   'inference-type 'deductive
   'application-context "Allocation of burden of proof"))

;; Interpretation Principles
(define lex-specialis-derogat-legi-generali
  (make-principle
   'name 'lex-specialis-derogat-legi-generali
   'description "Specific law overrides general law"
   'domain '(interpretation statutory)
   'confidence 1.0
   'provenance "Roman law, statutory interpretation"
   'related-principles '(lex-posterior-derogat-legi-priori purposive-approach)
   'inference-type 'deductive
   'application-context "Resolving conflicts between laws"))

(define lex-posterior-derogat-legi-priori
  (make-principle
   'name 'lex-posterior-derogat-legi-priori
   'description "Later law overrides earlier law"
   'domain '(interpretation statutory)
   'confidence 1.0
   'provenance "Roman law, statutory interpretation"
   'related-principles '(lex-specialis-derogat-legi-generali)
   'inference-type 'deductive
   'application-context "Temporal conflicts between laws"))

(define expressio-unius-est-exclusio-alterius
  (make-principle
   'name 'expressio-unius-est-exclusio-alterius
   'description "Express mention of one thing excludes others"
   'domain '(interpretation statutory)
   'confidence 1.0
   'provenance "Statutory interpretation canon"
   'related-principles '(literal-rule purposive-approach)
   'inference-type 'deductive
   'application-context "Interpreting statutory lists and enumerations"))

;; =============================================================================
;; CRIMINAL LAW PRINCIPLES
;; =============================================================================

(define nullum-crimen-sine-lege
  (make-principle
   'name 'nullum-crimen-sine-lege
   'description "No crime without law - acts cannot be criminal unless prohibited by law"
   'domain '(criminal constitutional)
   'confidence 1.0
   'provenance "Enlightenment legal philosophy, international human rights"
   'related-principles '(nulla-poena-sine-lege rule-of-law legality)
   'inference-type 'deductive
   'application-context "Principle of legality in criminal law"))

(define nulla-poena-sine-lege
  (make-principle
   'name 'nulla-poena-sine-lege
   'description "No punishment without law - punishment must be prescribed by law"
   'domain '(criminal constitutional)
   'confidence 1.0
   'provenance "Enlightenment legal philosophy, international human rights"
   'related-principles '(nullum-crimen-sine-lege rule-of-law)
   'inference-type 'deductive
   'application-context "Sentencing and punishment legitimacy"))

(define in-dubio-pro-reo
  (make-principle
   'name 'in-dubio-pro-reo
   'description "When in doubt, for the accused - presumption of innocence"
   'domain '(criminal procedure)
   'confidence 1.0
   'provenance "Roman law, international human rights"
   'related-principles '(onus-probandi presumption-of-innocence)
   'inference-type 'deductive
   'application-context "Criminal trials and burden of proof"))

(define actus-non-facit-reum-nisi-mens-sit-rea
  (make-principle
   'name 'actus-non-facit-reum-nisi-mens-sit-rea
   'description "An act does not make one guilty unless the mind is guilty - requires both actus reus and mens rea"
   'domain '(criminal)
   'confidence 1.0
   'provenance "Common law"
   'related-principles '(culpa criminal-liability)
   'inference-type 'deductive
   'application-context "Elements of criminal liability"))

;; =============================================================================
;; DELICT/TORT PRINCIPLES
;; =============================================================================

(define damnum-injuria-datum
  (make-principle
   'name 'damnum-injuria-datum
   'description "Loss wrongfully caused - basis of delictual liability"
   'domain '(delict tort civil)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(culpa causation wrongfulness)
   'inference-type 'deductive
   'application-context "Foundation of tort/delict law"))

(define volenti-non-fit-injuria
  (make-principle
   'name 'volenti-non-fit-injuria
   'description "No injury is done to one who consents"
   'domain '(delict tort civil criminal)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(consent assumption-of-risk)
   'inference-type 'deductive
   'application-context "Defense to liability based on consent"))

(define culpa
  (make-principle
   'name 'culpa
   'description "Fault or negligence - required element for liability"
   'domain '(delict tort civil criminal)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(damnum-injuria-datum reasonable-person-test)
   'inference-type 'deductive
   'application-context "Fault element in liability"))

(define res-ipsa-loquitur
  (make-principle
   'name 'res-ipsa-loquitur
   'description "The thing speaks for itself - doctrine of negligence"
   'domain '(delict tort evidence)
   'confidence 1.0
   'provenance "Common law"
   'related-principles '(culpa onus-probandi)
   'inference-type 'abductive
   'application-context "Inferring negligence from circumstances"))

;; =============================================================================
;; CONSTITUTIONAL PRINCIPLES
;; =============================================================================

(define supremacy-of-constitution
  (make-principle
   'name 'supremacy-of-constitution
   'description "The constitution is supreme and all law must conform to it"
   'domain '(constitutional)
   'confidence 1.0
   'provenance "Modern constitutionalism"
   'related-principles '(rule-of-law judicial-review)
   'inference-type 'deductive
   'application-context "Constitutional validity of laws"))

(define rule-of-law
  (make-principle
   'name 'rule-of-law
   'description "Everyone is subject to the law and equal before it"
   'domain '(constitutional administrative)
   'confidence 1.0
   'provenance "Common law, constitutional principle"
   'related-principles '(supremacy-of-constitution equality legality)
   'inference-type 'deductive
   'application-context "Legal equality and accountability"))

(define separation-of-powers
  (make-principle
   'name 'separation-of-powers
   'description "Division of government into legislative, executive, and judicial branches"
   'domain '(constitutional)
   'confidence 1.0
   'provenance "Montesquieu, modern constitutionalism"
   'related-principles '(checks-and-balances judicial-independence)
   'inference-type 'deductive
   'application-context "Constitutional structure and limits"))

(define ubuntu
  (make-principle
   'name 'ubuntu
   'description "Humanity towards others - African philosophy of interconnectedness"
   'domain '(constitutional customary)
   'confidence 1.0
   'provenance "African customary law, South African Constitution"
   'related-principles '(human-dignity community solidarity)
   'inference-type 'inductive
   'application-context "Interpretation of rights and remedies"))

;; =============================================================================
;; ADMINISTRATIVE LAW PRINCIPLES
;; =============================================================================

(define legality
  (make-principle
   'name 'legality
   'description "Administrative action must be authorized by law"
   'domain '(administrative)
   'confidence 1.0
   'provenance "Rule of law principle"
   'related-principles '(rule-of-law ultra-vires)
   'inference-type 'deductive
   'application-context "Validity of administrative action"))

(define rationality
  (make-principle
   'name 'rationality
   'description "Administrative decisions must be rational and reasonable"
   'domain '(administrative)
   'confidence 1.0
   'provenance "Administrative law, judicial review"
   'related-principles '(reasonableness proportionality)
   'inference-type 'deductive
   'application-context "Substantive review of administrative action"))

(define procedural-fairness
  (make-principle
   'name 'procedural-fairness
   'description "Fair procedures must be followed in administrative action"
   'domain '(administrative)
   'confidence 1.0
   'provenance "Natural justice, administrative law"
   'related-principles '(audi-alteram-partem nemo-iudex-in-causa-sua)
   'inference-type 'deductive
   'application-context "Procedural requirements for administrative action"))

(define legitimate-expectation
  (make-principle
   'name 'legitimate-expectation
   'description "Reasonable expectations created by authorities should be protected"
   'domain '(administrative)
   'confidence 1.0
   'provenance "Administrative law, judicial review"
   'related-principles '(procedural-fairness bona-fides)
   'inference-type 'inductive
   'application-context "Protection of reliance interests"))

;; =============================================================================
;; EQUITY PRINCIPLES
;; =============================================================================

(define equity-will-not-suffer-a-wrong-without-remedy
  (make-principle
   'name 'equity-will-not-suffer-a-wrong-without-remedy
   'description "Equity provides remedies where common law fails"
   'domain '(equity civil)
   'confidence 1.0
   'provenance "Equity jurisprudence"
   'related-principles '(ubi-ius-ibi-remedium)
   'inference-type 'deductive
   'application-context "Availability of equitable remedies"))

(define he-who-seeks-equity-must-do-equity
  (make-principle
   'name 'he-who-seeks-equity-must-do-equity
   'description "One seeking equitable relief must act fairly"
   'domain '(equity civil)
   'confidence 1.0
   'provenance "Equity maxim"
   'related-principles '(clean-hands bona-fides)
   'inference-type 'deductive
   'application-context "Conditions for equitable relief"))

(define equality-is-equity
  (make-principle
   'name 'equality-is-equity
   'description "Equity treats all parties equally"
   'domain '(equity civil)
   'confidence 1.0
   'provenance "Equity maxim"
   'related-principles '(equality fairness)
   'inference-type 'deductive
   'application-context "Equal treatment in equity"))

(define equity-follows-the-law
  (make-principle
   'name 'equity-follows-the-law
   'description "Equitable principles supplement but do not contradict law"
   'domain '(equity civil)
   'confidence 1.0
   'provenance "Equity maxim"
   'related-principles '(rule-of-law)
   'inference-type 'deductive
   'application-context "Relationship between equity and law"))

;; =============================================================================
;; EVIDENCE PRINCIPLES
;; =============================================================================

(define onus-probandi
  (make-principle
   'name 'onus-probandi
   'description "Burden of proof - party asserting must prove"
   'domain '(evidence procedure)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(ei-qui-affirmat-non-ei-qui-negat-incumbit-probatio)
   'inference-type 'deductive
   'application-context "Allocation of burden of proof"))

(define best-evidence-rule
  (make-principle
   'name 'best-evidence-rule
   'description "Original evidence is preferred over secondary evidence"
   'domain '(evidence)
   'confidence 1.0
   'provenance "Common law evidence"
   'related-principles '(reliability authenticity)
   'inference-type 'deductive
   'application-context "Admissibility of documentary evidence"))

(define relevance
  (make-principle
   'name 'relevance
   'description "Evidence must be relevant to the matter at issue"
   'domain '(evidence)
   'confidence 1.0
   'provenance "Evidence law"
   'related-principles '(materiality probative-value)
   'inference-type 'deductive
   'application-context "Admissibility of evidence"))

(define hearsay-rule
  (make-principle
   'name 'hearsay-rule
   'description "Hearsay evidence is generally inadmissible"
   'domain '(evidence)
   'confidence 1.0
   'provenance "Common law evidence"
   'related-principles '(reliability confrontation)
   'inference-type 'deductive
   'application-context "Admissibility of out-of-court statements"))

;; =============================================================================
;; STATUTORY INTERPRETATION PRINCIPLES
;; =============================================================================

(define literal-rule
  (make-principle
   'name 'literal-rule
   'description "Words in statutes should be given their ordinary meaning"
   'domain '(interpretation statutory)
   'confidence 1.0
   'provenance "Statutory interpretation canon"
   'related-principles '(plain-meaning textualism)
   'inference-type 'deductive
   'application-context "Primary approach to statutory interpretation"))

(define golden-rule
  (make-principle
   'name 'golden-rule
   'description "Literal interpretation unless it leads to absurdity"
   'domain '(interpretation statutory)
   'confidence 1.0
   'provenance "Statutory interpretation canon"
   'related-principles '(literal-rule purposive-approach)
   'inference-type 'deductive
   'application-context "Modified literal interpretation"))

(define mischief-rule
  (make-principle
   'name 'mischief-rule
   'description "Interpret to suppress the mischief and advance the remedy"
   'domain '(interpretation statutory)
   'confidence 1.0
   'provenance "Heydon's Case (1584)"
   'related-principles '(purposive-approach legislative-intent)
   'inference-type 'abductive
   'application-context "Purposive statutory interpretation"))

(define purposive-approach
  (make-principle
   'name 'purposive-approach
   'description "Interpret statutes according to their purpose and spirit"
   'domain '(interpretation statutory constitutional)
   'confidence 1.0
   'provenance "Modern statutory interpretation"
   'related-principles '(mischief-rule legislative-intent)
   'inference-type 'abductive
   'application-context "Contemporary interpretation methodology"))

;; =============================================================================
;; TIME AND LIMITATION PRINCIPLES
;; =============================================================================

(define tempus-regit-actum
  (make-principle
   'name 'tempus-regit-actum
   'description "Time governs the act - law in force at the time governs"
   'domain '(temporal procedure)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(non-retroactivity vested-rights)
   'inference-type 'deductive
   'application-context "Temporal application of laws"))

(define prescription
  (make-principle
   'name 'prescription
   'description "Rights can be lost through passage of time and inaction"
   'domain '(temporal civil)
   'confidence 1.0
   'provenance "Roman law, statutory limitation"
   'related-principles '(laches limitation-periods)
   'inference-type 'deductive
   'application-context "Time-based extinction of rights"))

(define laches
  (make-principle
   'name 'laches
   'description "Unreasonable delay can bar equitable relief"
   'domain '(temporal equity)
   'confidence 1.0
   'provenance "Equity doctrine"
   'related-principles '(prescription diligence)
   'inference-type 'inductive
   'application-context "Delay as bar to equitable remedies"))

;; =============================================================================
;; REMEDIES PRINCIPLES
;; =============================================================================

(define restitutio-in-integrum
  (make-principle
   'name 'restitutio-in-integrum
   'description "Restoration to the original position"
   'domain '(remedies civil delict)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(damages compensation)
   'inference-type 'deductive
   'application-context "Measure of damages"))

(define specific-performance
  (make-principle
   'name 'specific-performance
   'description "Actual performance of contractual obligation may be ordered"
   'domain '(remedies contract equity)
   'confidence 1.0
   'provenance "Equity remedy"
   'related-principles '(pacta-sunt-servanda inadequacy-of-damages)
   'inference-type 'deductive
   'application-context "Equitable remedy for breach of contract"))

(define injunction
  (make-principle
   'name 'injunction
   'description "Court order to do or refrain from doing something"
   'domain '(remedies equity)
   'confidence 1.0
   'provenance "Equity remedy"
   'related-principles '(irreparable-harm balance-of-convenience)
   'inference-type 'deductive
   'application-context "Preventive equitable remedy"))

(define ubi-ius-ibi-remedium
  (make-principle
   'name 'ubi-ius-ibi-remedium
   'description "Where there is a right, there is a remedy"
   'domain '(remedies civil)
   'confidence 1.0
   'provenance "Legal maxim"
   'related-principles '(equity-will-not-suffer-a-wrong-without-remedy)
   'inference-type 'deductive
   'application-context "Availability of legal remedies"))

;; =============================================================================
;; LEGAL CAPACITY PRINCIPLES
;; =============================================================================

(define doli-incapax
  (make-principle
   'name 'doli-incapax
   'description "Incapable of crime - children under certain age presumed incapable"
   'domain '(criminal capacity)
   'confidence 1.0
   'provenance "Common law"
   'related-principles '(mens-rea criminal-liability)
   'inference-type 'deductive
   'application-context "Criminal capacity of minors"))

(define compos-mentis
  (make-principle
   'name 'compos-mentis
   'description "Of sound mind - legal capacity requires mental competence"
   'domain '(capacity civil criminal)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(legal-capacity contractual-capacity)
   'inference-type 'deductive
   'application-context "Mental capacity for legal acts"))

;; =============================================================================
;; GOOD FAITH AND MORALITY PRINCIPLES
;; =============================================================================

(define bona-fides
  (make-principle
   'name 'bona-fides
   'description "Good faith - acting honestly and fairly"
   'domain '(contract civil equity)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(uberrima-fides fair-dealing)
   'inference-type 'deductive
   'application-context "Standard of conduct in legal relations"))

(define contra-bonos-mores
  (make-principle
   'name 'contra-bonos-mores
   'description "Against good morals - unlawful conduct violating community values"
   'domain '(delict civil)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(public-policy wrongfulness)
   'inference-type 'inductive
   'application-context "Test for wrongfulness"))

(define ex-turpi-causa-non-oritur-actio
  (make-principle
   'name 'ex-turpi-causa-non-oritur-actio
   'description "From a dishonourable cause, no action arises"
   'domain '(contract civil)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(illegality public-policy)
   'inference-type 'deductive
   'application-context "Defense based on illegality"))

(define uberrima-fides
  (make-principle
   'name 'uberrima-fides
   'description "Utmost good faith - highest standard of honesty"
   'domain '(contract insurance)
   'confidence 1.0
   'provenance "Insurance law"
   'related-principles '(bona-fides disclosure)
   'inference-type 'deductive
   'application-context "Duty of disclosure in insurance contracts"))

;; =============================================================================
;; RELATIONSHIP AND AGENCY PRINCIPLES
;; =============================================================================

(define qui-facit-per-alium-facit-per-se
  (make-principle
   'name 'qui-facit-per-alium-facit-per-se
   'description "He who acts through another acts himself - vicarious liability"
   'domain '(agency delict employment)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(respondeat-superior vicarious-liability)
   'inference-type 'deductive
   'application-context "Attribution of acts through agents"))

(define respondeat-superior
  (make-principle
   'name 'respondeat-superior
   'description "Let the master answer - employer liability for employee acts"
   'domain '(employment delict)
   'confidence 1.0
   'provenance "Common law"
   'related-principles '(qui-facit-per-alium-facit-per-se vicarious-liability)
   'inference-type 'deductive
   'application-context "Vicarious liability of employers"))

;; =============================================================================
;; CAUSATION PRINCIPLES
;; =============================================================================

(define causa-sine-qua-non
  (make-principle
   'name 'causa-sine-qua-non
   'description "Cause without which not - but-for test of causation"
   'domain '(delict criminal causation)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(factual-causation legal-causation)
   'inference-type 'deductive
   'application-context "Factual causation test"))

(define novus-actus-interveniens
  (make-principle
   'name 'novus-actus-interveniens
   'description "New intervening act - breaks chain of causation"
   'domain '(delict criminal causation)
   'confidence 1.0
   'provenance "Roman law"
   'related-principles '(causa-sine-qua-non legal-causation)
   'inference-type 'abductive
   'application-context "Breaking chain of causation"))

;; =============================================================================
;; ADDITIONAL INTERNATIONAL AND COMPARATIVE PRINCIPLES
;; =============================================================================

(define proportionality
  (make-principle
   'name 'proportionality
   'description "Measures must be proportionate to their objectives"
   'domain '(constitutional administrative human-rights)
   'confidence 1.0
   'provenance "European law, constitutional law"
   'related-principles '(rationality reasonableness)
   'inference-type 'deductive
   'application-context "Limitation of rights and administrative action"))

(define subsidiarity
  (make-principle
   'name 'subsidiarity
   'description "Decisions should be made at the most local level possible"
   'domain '(constitutional administrative international)
   'confidence 1.0
   'provenance "European Union law, federalism"
   'related-principles '(federalism decentralization)
   'inference-type 'deductive
   'application-context "Allocation of powers in multi-level governance"))

(define non-refoulement
  (make-principle
   'name 'non-refoulement
   'description "Prohibition on returning refugees to danger"
   'domain '(international refugee human-rights)
   'confidence 1.0
   'provenance "1951 Refugee Convention"
   'related-principles '(human-dignity protection-of-life)
   'inference-type 'deductive
   'application-context "Refugee and asylum law"))

(define jus-cogens
  (make-principle
   'name 'jus-cogens
   'description "Peremptory norms of international law from which no derogation is permitted"
   'domain '(international)
   'confidence 1.0
   'provenance "Vienna Convention on the Law of Treaties"
   'related-principles '(supremacy hierarchy-of-norms)
   'inference-type 'deductive
   'application-context "Hierarchy of international legal norms"))

(define pacta-tertiis-nec-nocent-nec-prosunt
  (make-principle
   'name 'pacta-tertiis-nec-nocent-nec-prosunt
   'description "Treaties neither harm nor benefit third parties"
   'domain '(international treaty)
   'confidence 1.0
   'provenance "International law"
   'related-principles '(privity-of-contract)
   'inference-type 'deductive
   'application-context "Effect of treaties on third states"))

;; =============================================================================
;; PRINCIPLE CONSTRUCTOR AND ACCESSOR FUNCTIONS
;; =============================================================================

;; Constructor for principle structure
(define (make-principle . args)
  (let ((principle (make-hash-table)))
    (let loop ((args args))
      (if (null? args)
          principle
          (begin
            (hash-set! principle (car args) (cadr args))
            (loop (cddr args)))))))

;; Accessor functions
(define (principle-name p) (hash-ref p 'name))
(define (principle-description p) (hash-ref p 'description))
(define (principle-domain p) (hash-ref p 'domain))
(define (principle-confidence p) (hash-ref p 'confidence))
(define (principle-provenance p) (hash-ref p 'provenance))
(define (principle-related p) (hash-ref p 'related-principles))
(define (principle-inference-type p) (hash-ref p 'inference-type))
(define (principle-context p) (hash-ref p 'application-context))

;; =============================================================================
;; LEGAL REASONING FUNCTIONS
;; =============================================================================

;; Function to check if a principle applies to a given context
(define (principle-applies? principle context)
  (and (has-attribute context 'legal-domain)
       (has-attribute context 'fact-pattern)
       (domain-matches? (principle-domain principle) (get-attribute context 'legal-domain))
       (principle-matches-context? principle context)))

;; Function to derive inference from known law
(define (derive-from-known-law law fact-pattern inference-type)
  (list 'inference
        (list 'source (principle-name law))
        (list 'facts fact-pattern)
        (list 'level 1)  ;; Level 1 = first-order principle
        (list 'confidence (principle-confidence law))
        (list 'inference-type inference-type)
        (list 'timestamp (current-timestamp))))

;; Function to combine multiple known laws
(define (combine-known-laws . laws)
  (map (lambda (law) 
         (list 'known-law 
               (principle-name law)
               (principle-confidence law))) 
       laws))

;; Function to find related principles
(define (find-related-principles principle)
  (principle-related principle))

;; Function to build inference chain
(define (build-inference-chain start-principle end-principle)
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
                          (let ((result (dfs (get-principle next) target)))
                            (if result
                                result
                                (begin
                                  (set! path (cdr path))
                                  (loop (cdr related)))))))))))))
    (dfs start-principle (principle-name end-principle))))

;; Function to validate inference
(define (validate-inference inference)
  (and (has-attribute inference 'source)
       (has-attribute inference 'facts)
       (has-attribute inference 'confidence)
       (>= (get-attribute inference 'confidence) 0.0)
       (<= (get-attribute inference 'confidence) 1.0)))

;; Function to compute confidence for derived principle
(define (compute-derived-confidence base-principles inference-type)
  (let ((base-confidence (apply min (map principle-confidence base-principles))))
    (case inference-type
      ((deductive) (* base-confidence 0.95))  ;; Deductive reasoning preserves most confidence
      ((inductive) (* base-confidence 0.80))  ;; Inductive reasoning reduces confidence
      ((abductive) (* base-confidence 0.70))  ;; Abductive reasoning reduces confidence more
      ((analogical) (* base-confidence 0.65)) ;; Analogical reasoning most uncertain
      (else (* base-confidence 0.50)))))

;; =============================================================================
;; HELPER FUNCTIONS (Enhanced implementations)
;; =============================================================================

(define (has-attribute entity attr)
  (and (hash-table? entity)
       (hash-has-key? entity attr)))

(define (get-attribute entity attr)
  (if (hash-table? entity)
      (hash-ref entity attr #f)
      #f))

(define (domain-matches? principle-domains context-domain)
  (member context-domain principle-domains))

(define (principle-matches-context? principle context)
  ;; Placeholder for sophisticated context matching
  ;; Could involve pattern matching, semantic similarity, etc.
  #t)

(define (current-timestamp)
  (date->string (current-date) "~Y-~m-~d ~H:~M:~S"))

(define (get-principle name)
  ;; Placeholder - would look up principle by name from registry
  ;; For now, returns a dummy principle
  (make-principle 'name name 'confidence 1.0))

;; =============================================================================
;; PRINCIPLE REGISTRY
;; =============================================================================

;; Global registry of all principles
(define *principle-registry* (make-hash-table))

;; Function to register a principle
(define (register-principle! principle)
  (hash-set! *principle-registry* 
             (principle-name principle) 
             principle))

;; Function to get principle from registry
(define (get-principle-from-registry name)
  (hash-ref *principle-registry* name #f))

;; Function to get all principles in a domain
(define (get-principles-by-domain domain)
  (hash-fold (lambda (name principle acc)
               (if (member domain (principle-domain principle))
                   (cons principle acc)
                   acc))
             '()
             *principle-registry*))

;; =============================================================================
;; INITIALIZATION
;; =============================================================================

;; Register all defined principles
;; (This would be called after all principles are defined)
(define (initialize-principle-registry!)
  (for-each register-principle!
            (list pacta-sunt-servanda
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
                  pacta-tertiis-nec-nocent-nec-prosunt)))

;; =============================================================================
;; EXPORT
;; =============================================================================

;; Export all principles and functions for use in other modules
(provide pacta-sunt-servanda
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
         pacta-tertiis-nec-nocent-nec-prosunt
         make-principle
         principle-name
         principle-description
         principle-domain
         principle-confidence
         principle-provenance
         principle-related
         principle-inference-type
         principle-context
         principle-applies?
         derive-from-known-law
         combine-known-laws
         find-related-principles
         build-inference-chain
         validate-inference
         compute-derived-confidence
         initialize-principle-registry!
         get-principle-from-registry
         get-principles-by-domain)

