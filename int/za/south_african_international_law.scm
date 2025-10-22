;; South African International Law Framework
;; Scheme implementation for international law principles and South African context

;; =============================================================================
;; SOURCES OF INTERNATIONAL LAW
;; =============================================================================

(define international-law-source? (lambda (source)
  (or (international-treaty? source)
      (customary-international-law? source)
      (general-principles-of-law? source)
      (judicial-decisions? source)
      (teachings-of-publicists? source))))

;; =============================================================================
;; TREATIES AND CONVENTIONS
;; =============================================================================

;; Treaty Formation
(define treaty-valid? (lambda (treaty)
  (and (negotiation? treaty)
       (signature? treaty)
       (ratification? treaty)
       (entry-into-force? treaty))))

;; Treaty Application in South Africa (Section 231)
(define treaty-binding-in-sa? (lambda (treaty)
  (or (and (international-agreement? treaty)
           (approved-by-parliament? treaty)
           (incorporated-into-law? treaty))
      (self-executing-treaty? treaty))))

;; Vienna Convention Rules
(define treaty-interpretation? (lambda (treaty)
  (and (good-faith? treaty)
       (ordinary-meaning? treaty)
       (context-considered? treaty)
       (object-and-purpose? treaty))))

;; =============================================================================
;; CUSTOMARY INTERNATIONAL LAW
;; =============================================================================

(define customary-international-law? (lambda (custom)
  (and (state-practice? custom)
       (opinio-juris? custom)
       (consistent-practice? custom)
       (general-acceptance? custom))))

;; Application in South Africa (Section 232)
(define customary-law-binding-in-sa? (lambda (custom)
  (and (customary-international-law? custom)
       (not-inconsistent-with-constitution? custom)
       (not-inconsistent-with-act-of-parliament? custom))))

;; =============================================================================
;; SOVEREIGNTY AND JURISDICTION
;; =============================================================================

;; State Sovereignty
(define sovereign-equality? (lambda (state)
  (and (territorial-integrity? state)
       (political-independence? state)
       (non-interference? state))))

;; Jurisdiction
(define jurisdiction-type? (lambda (jurisdiction)
  (or (territorial-jurisdiction? jurisdiction)
      (nationality-jurisdiction? jurisdiction)
      (protective-jurisdiction? jurisdiction)
      (universal-jurisdiction? jurisdiction))))

;; Universal Jurisdiction
(define universal-jurisdiction-applicable? (lambda (crime)
  (or (genocide? crime)
      (crimes-against-humanity? crime)
      (war-crimes? crime)
      (piracy? crime)
      (torture? crime))))

;; =============================================================================
;; DIPLOMATIC AND CONSULAR LAW
;; =============================================================================

;; Diplomatic Immunity (Vienna Convention on Diplomatic Relations)
(define diplomatic-immunity? (lambda (person)
  (and (diplomatic-agent? person)
       (accredited-to-receiving-state? person)
       (immunity-from-jurisdiction? person))))

;; Consular Immunity
(define consular-immunity? (lambda (person)
  (and (consular-officer? person)
       (performing-consular-functions? person)
       (limited-immunity? person))))

;; =============================================================================
;; INTERNATIONAL HUMANITARIAN LAW
;; =============================================================================

;; Geneva Conventions
(define geneva-conventions-applicable? (lambda (conflict)
  (or (international-armed-conflict? conflict)
      (non-international-armed-conflict? conflict))))

;; Protected Persons
(define protected-person-status? (lambda (person conflict)
  (or (civilian? person)
      (prisoner-of-war? person)
      (wounded-and-sick? person)
      (medical-personnel? person))))

;; War Crimes
(define war-crime? (lambda (act)
  (or (grave-breach-geneva? act)
      (attacking-civilians? act)
      (using-prohibited-weapons? act)
      (perfidy? act))))

;; =============================================================================
;; INTERNATIONAL HUMAN RIGHTS LAW
;; =============================================================================

;; Universal Declaration of Human Rights
(define universal-human-right? (lambda (right)
  (or (right-to-life? right)
      (freedom-from-torture? right)
      (freedom-from-slavery? right)
      (right-to-fair-trial? right)
      (freedom-of-expression? right))))

;; Regional Systems
(define african-charter-rights? (lambda (right)
  (and (individual-rights? right)
       (peoples-rights? right)
       (duties-included? right))))

;; =============================================================================
;; INTERNATIONAL CRIMINAL LAW
;; =============================================================================

;; Rome Statute (ICC)
(define icc-jurisdiction? (lambda (crime)
  (and (or (genocide? crime)
           (crimes-against-humanity? crime)
           (war-crimes? crime)
           (crime-of-aggression? crime))
       (complementarity-test? crime)
       (sufficient-gravity? crime))))

;; South Africa and ICC
(define icc-implementation-sa? (lambda (crime)
  (and (icc-act-applicable? crime)
       (cooperation-with-icc? crime)
       (surrender-of-persons? crime))))

;; =============================================================================
;; INTERNATIONAL TRADE LAW
;; =============================================================================

;; WTO Principles
(define wto-compliant? (lambda (measure)
  (and (most-favoured-nation? measure)
       (national-treatment? measure)
       (no-quantitative-restrictions? measure)
       (transparency? measure))))

;; SADC and Regional Integration
(define sadc-obligations? (lambda (measure)
  (and (free-trade-area? measure)
       (regional-cooperation? measure)
       (dispute-settlement-available? measure))))

;; =============================================================================
;; INTERNATIONAL ENVIRONMENTAL LAW
;; =============================================================================

(define international-environmental-obligation? (lambda (obligation)
  (and (prevent-transboundary-harm? obligation)
       (sustainable-development? obligation)
       (precautionary-principle? obligation)
       (common-but-differentiated-responsibility? obligation))))

;; =============================================================================
;; STATE RESPONSIBILITY
;; =============================================================================

(define state-responsibility? (lambda (act)
  (and (attributable-to-state? act)
       (breach-of-international-obligation? act)
       (wrongful-act? act))))

;; Countermeasures
(define lawful-countermeasure? (lambda (measure)
  (and (response-to-wrongful-act? measure)
       (proportionate? measure)
       (aimed-at-inducing-compliance? measure)
       (not-affecting-fundamental-rights? measure))))

;; =============================================================================
;; PEACEFUL SETTLEMENT OF DISPUTES
;; =============================================================================

(define dispute-settlement-method? (lambda (method)
  (or (negotiation? method)
      (mediation? method)
      (conciliation? method)
      (arbitration? method)
      (judicial-settlement? method))))

;; ICJ Jurisdiction
(define icj-jurisdiction? (lambda (dispute)
  (and (between-states? dispute)
       (consent-of-parties? dispute)
       (contentious-or-advisory? dispute))))

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
;; SOURCES OF INTERNATIONAL LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Treaties
(define international-treaty? (lambda (source)
  (and (has-attribute source 'treaty)
       (written-agreement? source)
       (between-states? source)
       (governed-by-international-law? source))))

(define written-agreement? (lambda (source)
  (has-attribute source 'written-form)))

(define governed-by-international-law? (lambda (source)
  (has-attribute source 'international-law-governed)))

;; General Principles
(define general-principles-of-law? (lambda (source)
  (and (has-attribute source 'general-principle)
       (recognized-by-civilized-nations? source)
       (applicable-to-international-relations? source))))

(define recognized-by-civilized-nations? (lambda (source)
  (has-attribute source 'wide-recognition)))

(define applicable-to-international-relations? (lambda (source)
  (has-attribute source 'international-applicability)))

;; Judicial Decisions
(define judicial-decisions? (lambda (source)
  (and (has-attribute source 'judicial-decision)
       (international-court-decision? source))))

(define international-court-decision? (lambda (source)
  (or (has-attribute source 'icj-decision)
      (has-attribute source 'icc-decision)
      (has-attribute source 'regional-court-decision))))

;; Teachings of Publicists
(define teachings-of-publicists? (lambda (source)
  (and (has-attribute source 'scholarly-work)
       (highly-qualified-publicist? source)
       (subsidiary-means? source))))

(define highly-qualified-publicist? (lambda (source)
  (has-attribute source 'qualified-author)))

(define subsidiary-means? (lambda (source)
  (has-attribute source 'subsidiary-source)))

;; =============================================================================
;; TREATIES - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Treaty Formation Stages
(define negotiation? (lambda (treaty)
  (and (has-attribute treaty 'negotiation-phase)
       (state-representatives-present? treaty)
       (terms-discussed? treaty))))

(define state-representatives-present? (lambda (treaty)
  (has-attribute treaty 'plenipotentiaries)))

(define terms-discussed? (lambda (treaty)
  (has-attribute treaty 'negotiation-record)))

(define signature? (lambda (treaty)
  (and (has-attribute treaty 'signature-date)
       (authorized-signatory? treaty)
       (text-authenticated? treaty))))

(define authorized-signatory? (lambda (treaty)
  (has-attribute treaty 'full-powers)))

(define text-authenticated? (lambda (treaty)
  (has-attribute treaty 'authenticated-text)))

(define ratification? (lambda (treaty)
  (and (has-attribute treaty 'ratification-instrument)
       (domestic-approval-obtained? treaty)
       (instrument-deposited? treaty))))

(define domestic-approval-obtained? (lambda (treaty)
  (or (has-attribute treaty 'parliamentary-approval)
      (has-attribute treaty 'executive-authority))))

(define instrument-deposited? (lambda (treaty)
  (has-attribute treaty 'deposited-with-depository)))

(define entry-into-force? (lambda (treaty)
  (and (has-attribute treaty 'entry-into-force-date)
       (conditions-met? treaty))))

(define conditions-met? (lambda (treaty)
  (or (minimum-ratifications-received? treaty)
      (specific-date-reached? treaty))))

(define minimum-ratifications-received? (lambda (treaty)
  (and (has-attribute treaty 'ratifications)
       (has-attribute treaty 'minimum-required)
       (let ((ratifications (get-attribute treaty 'ratifications))
             (minimum (get-attribute treaty 'minimum-required)))
         (>= ratifications minimum)))))

(define specific-date-reached? (lambda (treaty)
  (has-attribute treaty 'fixed-entry-date)))

;; Section 231 - Treaty Incorporation
(define international-agreement? (lambda (treaty)
  (and (has-attribute treaty 'international-agreement)
       (binding-on-south-africa? treaty))))

(define binding-on-south-africa? (lambda (treaty)
  (or (has-attribute treaty 'sa-party)
      (has-attribute treaty 'sa-signatory))))

(define approved-by-parliament? (lambda (treaty)
  (and (has-attribute treaty 'parliamentary-resolution)
       (section-231-2-process? treaty))))

(define section-231-2-process? (lambda (treaty)
  (or (national-assembly-approval? treaty)
      (both-houses-approval? treaty))))

(define national-assembly-approval? (lambda (treaty)
  (has-attribute treaty 'na-resolution)))

(define both-houses-approval? (lambda (treaty)
  (and (has-attribute treaty 'na-resolution)
       (has-attribute treaty 'ncop-resolution)
       (section-231-3-matters? treaty))))

(define section-231-3-matters? (lambda (treaty)
  (or (has-attribute treaty 'provincial-competence)
      (has-attribute treaty 'provincial-interests))))

(define incorporated-into-law? (lambda (treaty)
  (or (has-attribute treaty 'act-of-parliament)
      (has-attribute treaty 'regulations-enacted))))

;; Self-Executing Treaties
(define self-executing-treaty? (lambda (treaty)
  (and (has-attribute treaty 'directly-applicable)
       (no-implementing-legislation-required? treaty)
       (creates-individual-rights? treaty))))

(define no-implementing-legislation-required? (lambda (treaty)
  (not (has-attribute treaty 'requires-legislation))))

(define creates-individual-rights? (lambda (treaty)
  (has-attribute treaty 'individual-rights-created)))

;; Vienna Convention Interpretation
(define good-faith? (lambda (treaty)
  (and (has-attribute treaty 'interpretation-method)
       (honest-interpretation? treaty))))

(define honest-interpretation? (lambda (treaty)
  (not (has-attribute treaty 'bad-faith-interpretation))))

(define ordinary-meaning? (lambda (treaty)
  (and (has-attribute treaty 'text)
       (plain-language-interpretation? treaty)
       (no-special-meaning-unless-intended? treaty))))

(define plain-language-interpretation? (lambda (treaty)
  (has-attribute treaty 'ordinary-sense)))

(define no-special-meaning-unless-intended? (lambda (treaty)
  (or (not (has-attribute treaty 'special-meaning))
      (parties-intended-special-meaning? treaty))))

(define parties-intended-special-meaning? (lambda (treaty)
  (has-attribute treaty 'special-meaning-intended)))

(define context-considered? (lambda (treaty)
  (and (preamble-considered? treaty)
       (annexes-considered? treaty)
       (related-agreements-considered? treaty))))

(define preamble-considered? (lambda (treaty)
  (or (not (has-attribute treaty 'preamble))
      (has-attribute treaty 'preamble-reviewed))))

(define annexes-considered? (lambda (treaty)
  (or (not (has-attribute treaty 'annexes))
      (has-attribute treaty 'annexes-reviewed))))

(define related-agreements-considered? (lambda (treaty)
  (or (not (has-attribute treaty 'related-agreements))
      (has-attribute treaty 'related-agreements-reviewed))))

(define object-and-purpose? (lambda (treaty)
  (and (treaty-purpose-identified? treaty)
       (interpretation-furthers-purpose? treaty))))

(define treaty-purpose-identified? (lambda (treaty)
  (has-attribute treaty 'treaty-object)))

(define interpretation-furthers-purpose? (lambda (treaty)
  (has-attribute treaty 'purposive-interpretation)))

;; =============================================================================
;; CUSTOMARY INTERNATIONAL LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; State Practice
(define state-practice? (lambda (custom)
  (and (has-attribute custom 'state-actions)
       (practice-consistent? custom)
       (practice-general? custom)
       (duration-sufficient? custom))))

(define practice-consistent? (lambda (custom)
  (and (has-attribute custom 'consistent-conduct)
       (no-significant-contradictions? custom))))

(define no-significant-contradictions? (lambda (custom)
  (not (has-attribute custom 'inconsistent-practice))))

(define practice-general? (lambda (custom)
  (and (has-attribute custom 'widespread-practice)
       (multiple-states-engaged? custom))))

(define multiple-states-engaged? (lambda (custom)
  (and (has-attribute custom 'participating-states)
       (let ((states (get-attribute custom 'participating-states)))
         (> states 10)))) ; significant number of states

(define duration-sufficient? (lambda (custom)
  (or (long-established-practice? custom)
      (instant-custom-accepted? custom))))

(define long-established-practice? (lambda (custom)
  (and (has-attribute custom 'duration-years)
       (let ((years (get-attribute custom 'duration-years)))
         (> years 10)))) ; substantial period

(define instant-custom-accepted? (lambda (custom)
  (and (has-attribute custom 'rapid-formation)
       (overwhelming-acceptance? custom))))

(define overwhelming-acceptance? (lambda (custom)
  (has-attribute custom 'universal-acceptance)))

;; Opinio Juris
(define opinio-juris? (lambda (custom)
  (and (has-attribute custom 'legal-obligation-belief)
       (practice-as-law? custom)
       (not-mere-courtesy? custom))))

(define practice-as-law? (lambda (custom)
  (or (official-statements-indicate-obligation? custom)
      (legal-claims-assert-obligation? custom))))

(define official-statements-indicate-obligation? (lambda (custom)
  (has-attribute custom 'official-position)))

(define legal-claims-assert-obligation? (lambda (custom)
  (has-attribute custom 'legal-claim)))

(define not-mere-courtesy? (lambda (custom)
  (not (has-attribute custom 'comity-only))))

;; Consistency and Generality
(define consistent-practice? (lambda (custom)
  (and (uniform-conduct? custom)
       (no-major-deviations? custom))))

(define uniform-conduct? (lambda (custom)
  (has-attribute custom 'uniformity)))

(define no-major-deviations? (lambda (custom)
  (not (has-attribute custom 'significant-deviations))))

(define general-acceptance? (lambda (custom)
  (and (widespread-adherence? custom)
       (representative-states-practice? custom))))

(define widespread-adherence? (lambda (custom)
  (has-attribute custom 'broad-acceptance)))

(define representative-states-practice? (lambda (custom)
  (and (has-attribute custom 'geographic-distribution)
       (has-attribute custom 'legal-systems-represented))))

;; Section 232 - Customary Law in SA
(define not-inconsistent-with-constitution? (lambda (custom)
  (and (constitutional-compliance-checked? custom)
       (no-constitutional-conflict? custom))))

(define constitutional-compliance-checked? (lambda (custom)
  (has-attribute custom 'constitution-review)))

(define no-constitutional-conflict? (lambda (custom)
  (not (or (has-attribute custom 'bill-of-rights-violation)
           (has-attribute custom 'constitutional-principle-conflict)))))

(define not-inconsistent-with-act-of-parliament? (lambda (custom)
  (and (legislation-reviewed? custom)
       (no-statutory-conflict? custom))))

(define legislation-reviewed? (lambda (custom)
  (has-attribute custom 'legislation-check)))

(define no-statutory-conflict? (lambda (custom)
  (not (has-attribute custom 'statute-conflict))))

;; =============================================================================
;; SOVEREIGNTY AND JURISDICTION - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; State Sovereignty Elements
(define territorial-integrity? (lambda (state)
  (and (defined-territory? state)
       (no-unauthorized-interference? state))))

(define defined-territory? (lambda (state)
  (has-attribute state 'territorial-boundaries)))

(define no-unauthorized-interference? (lambda (state)
  (not (has-attribute state 'territorial-violation))))

(define political-independence? (lambda (state)
  (and (autonomous-decision-making? state)
       (no-external-control? state))))

(define autonomous-decision-making? (lambda (state)
  (has-attribute state 'sovereign-authority)))

(define no-external-control? (lambda (state)
  (not (has-attribute state 'external-domination))))

(define non-interference? (lambda (state)
  (and (respect-for-domestic-jurisdiction? state)
       (no-intervention-in-internal-affairs? state))))

(define respect-for-domestic-jurisdiction? (lambda (state)
  (has-attribute state 'domestic-competence)))

(define no-intervention-in-internal-affairs? (lambda (state)
  (not (has-attribute state 'internal-interference))))

;; Jurisdiction Types
(define territorial-jurisdiction? (lambda (jurisdiction)
  (and (has-attribute jurisdiction 'territory-based)
       (crime-committed-in-territory? jurisdiction))))

(define crime-committed-in-territory? (lambda (jurisdiction)
  (or (has-attribute jurisdiction 'offense-location-sa)
      (has-attribute jurisdiction 'territorial-waters)
      (has-attribute jurisdiction 'sa-flagged-vessel))))

(define nationality-jurisdiction? (lambda (jurisdiction)
  (and (has-attribute jurisdiction 'nationality-based)
       (accused-is-national? jurisdiction))))

(define accused-is-national? (lambda (jurisdiction)
  (or (has-attribute jurisdiction 'sa-citizen)
      (has-attribute jurisdiction 'sa-resident))))

(define protective-jurisdiction? (lambda (jurisdiction)
  (and (has-attribute jurisdiction 'state-interest-threatened)
       (vital-state-interest? jurisdiction))))

(define vital-state-interest? (lambda (jurisdiction)
  (or (has-attribute jurisdiction 'national-security-threat)
      (has-attribute jurisdiction 'currency-counterfeiting)
      (has-attribute jurisdiction 'immigration-fraud))))

(define universal-jurisdiction? (lambda (jurisdiction)
  (and (has-attribute jurisdiction 'universal-concern-crime)
       (crime-affects-international-community? jurisdiction))))

(define crime-affects-international-community? (lambda (jurisdiction)
  (has-attribute jurisdiction 'hostis-humani-generis)))

;; Universal Jurisdiction Crimes
(define genocide? (lambda (crime)
  (and (has-attribute crime 'genocide-acts)
       (intent-to-destroy-group? crime)
       (protected-group-targeted? crime))))

(define intent-to-destroy-group? (lambda (crime)
  (has-attribute crime 'specific-intent-dolus-specialis)))

(define protected-group-targeted? (lambda (crime)
  (and (has-attribute crime 'target-group)
       (member (get-attribute crime 'target-group)
               '(national ethnic racial religious)))))

(define crimes-against-humanity? (lambda (crime)
  (and (has-attribute crime 'widespread-or-systematic-attack)
       (directed-against-civilian-population? crime)
       (enumerated-act? crime))))

(define directed-against-civilian-population? (lambda (crime)
  (has-attribute crime 'civilian-victims)))

(define enumerated-act? (lambda (crime)
  (and (has-attribute crime 'act-type)
       (member (get-attribute crime 'act-type)
               '(murder extermination enslavement deportation torture rape persecution)))))

(define war-crimes? (lambda (crime)
  (and (has-attribute crime 'armed-conflict-context)
       (nexus-to-armed-conflict? crime)
       (grave-breach-or-serious-violation? crime))))

(define nexus-to-armed-conflict? (lambda (crime)
  (has-attribute crime 'conflict-related)))

(define grave-breach-or-serious-violation? (lambda (crime)
  (or (has-attribute crime 'grave-breach-gc)
      (has-attribute crime 'serious-violation-laws-of-war))))

(define piracy? (lambda (crime)
  (and (has-attribute crime 'high-seas-location)
       (illegal-act-of-violence? crime)
       (private-ends? crime))))

(define illegal-act-of-violence? (lambda (crime)
  (or (has-attribute crime 'violence)
      (has-attribute crime 'detention)
      (has-attribute crime 'depredation))))

(define private-ends? (lambda (crime)
  (not (has-attribute crime 'political-motive))))

(define torture? (lambda (crime)
  (and (has-attribute crime 'severe-pain-or-suffering)
       (intentionally-inflicted? crime)
       (specific-purpose? crime)
       (official-capacity? crime))))

(define intentionally-inflicted? (lambda (crime)
  (has-attribute crime 'intentional)))

(define specific-purpose? (lambda (crime)
  (and (has-attribute crime 'purpose)
       (member (get-attribute crime 'purpose)
               '(obtaining-information punishment intimidation coercion discrimination)))))

(define official-capacity? (lambda (crime)
  (or (has-attribute crime 'public-official)
      (has-attribute crime 'official-acquiescence))))

;; =============================================================================
;; DIPLOMATIC LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Diplomatic Agents
(define diplomatic-agent? (lambda (person)
  (and (has-attribute person 'diplomatic-rank)
       (member (get-attribute person 'diplomatic-rank)
               '(ambassador minister counsellor secretary attache)))))

(define accredited-to-receiving-state? (lambda (person)
  (and (has-attribute person 'credentials)
       (credentials-presented? person)
       (agrément-granted? person))))

(define credentials-presented? (lambda (person)
  (has-attribute person 'credentials-presented)))

(define agrément-granted? (lambda (person)
  (has-attribute person 'agrément)))

(define immunity-from-jurisdiction? (lambda (person)
  (and (criminal-immunity? person)
       (civil-immunity? person)
       (administrative-immunity? person))))

(define criminal-immunity? (lambda (person)
  (and (has-attribute person 'criminal-jurisdiction-immune)
       (absolute-immunity? person))))

(define absolute-immunity? (lambda (person)
  (not (waiver-granted? person))))

(define waiver-granted? (lambda (person)
  (has-attribute person 'immunity-waiver)))

(define civil-immunity? (lambda (person)
  (or (has-attribute person 'civil-jurisdiction-immune)
      (not (private-commercial-act? person)))))

(define private-commercial-act? (lambda (person)
  (has-attribute person 'private-commercial-activity)))

(define administrative-immunity? (lambda (person)
  (has-attribute person 'administrative-jurisdiction-immune)))

;; Consular Officers
(define consular-officer? (lambda (person)
  (and (has-attribute person 'consular-rank)
       (member (get-attribute person 'consular-rank)
               '(consul-general consul vice-consul consular-agent)))))

(define performing-consular-functions? (lambda (person)
  (and (has-attribute person 'consular-functions)
       (within-consular-district? person))))

(define within-consular-district? (lambda (person)
  (has-attribute person 'consular-district)))

(define limited-immunity? (lambda (person)
  (and (functional-immunity-only? person)
       (no-immunity-for-private-acts? person))))

(define functional-immunity-only? (lambda (person)
  (has-attribute person 'acts-in-official-capacity)))

(define no-immunity-for-private-acts? (lambda (person)
  (or (not (private-act? person))
      (no-immunity-granted? person))))

(define private-act? (lambda (person)
  (has-attribute person 'private-capacity-act)))

(define no-immunity-granted? (lambda (person)
  (not (has-attribute person 'immunity-for-private-acts))))

;; =============================================================================
;; INTERNATIONAL HUMANITARIAN LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Armed Conflict Classification
(define international-armed-conflict? (lambda (conflict)
  (and (has-attribute conflict 'armed-conflict)
       (between-states-conflict? conflict))))

(define between-states-conflict? (lambda (conflict)
  (and (has-attribute conflict 'state-parties)
       (let ((parties (get-attribute conflict 'state-parties)))
         (>= parties 2)))))

(define non-international-armed-conflict? (lambda (conflict)
  (and (has-attribute conflict 'armed-conflict)
       (not (between-states-conflict? conflict))
       (organized-armed-groups? conflict)
       (intensity-threshold-met? conflict))))

(define organized-armed-groups? (lambda (conflict)
  (has-attribute conflict 'organized-groups)))

(define intensity-threshold-met? (lambda (conflict)
  (and (has-attribute conflict 'intensity-level)
       (protracted-armed-violence? conflict))))

(define protracted-armed-violence? (lambda (conflict)
  (has-attribute conflict 'protracted-violence)))

;; Protected Persons
(define civilian? (lambda (person)
  (and (not (combatant? person))
       (not (direct-participation-in-hostilities? person)))))

(define combatant? (lambda (person)
  (or (has-attribute person 'armed-forces-member)
      (has-attribute person 'organized-armed-group-member))))

(define direct-participation-in-hostilities? (lambda (person)
  (has-attribute person 'direct-participation)))

(define prisoner-of-war? (lambda (person)
  (and (combatant? person)
       (fallen-into-enemy-hands? person)
       (entitled-to-pow-status? person))))

(define fallen-into-enemy-hands? (lambda (person)
  (has-attribute person 'captured)))

(define entitled-to-pow-status? (lambda (person)
  (and (has-attribute person 'lawful-combatant)
       (meets-pow-criteria? person))))

(define meets-pow-criteria? (lambda (person)
  (or (has-attribute person 'regular-forces)
      (organized-resistance-movement? person))))

(define organized-resistance-movement? (lambda (person)
  (and (has-attribute person 'organized-group)
       (distinctive-sign? person)
       (arms-openly? person)
       (respects-laws-of-war? person))))

(define distinctive-sign? (lambda (person)
  (has-attribute person 'distinctive-emblem)))

(define arms-openly? (lambda (person)
  (has-attribute person 'open-arms)))

(define respects-laws-of-war? (lambda (person)
  (has-attribute person 'ihl-compliance)))

(define wounded-and-sick? (lambda (person)
  (and (has-attribute person 'wounded-or-sick)
       (requires-medical-care? person))))

(define requires-medical-care? (lambda (person)
  (has-attribute person 'medical-assistance-needed)))

(define medical-personnel? (lambda (person)
  (and (has-attribute person 'medical-role)
       (exclusively-medical-duties? person))))

(define exclusively-medical-duties? (lambda (person)
  (has-attribute person 'medical-duties-only)))

;; War Crimes Specification
(define grave-breach-geneva? (lambda (act)
  (and (protected-person-victim? act)
       (grave-breach-act-committed? act))))

(define protected-person-victim? (lambda (act)
  (has-attribute act 'protected-person-victim)))

(define grave-breach-act-committed? (lambda (act)
  (and (has-attribute act 'act-type)
       (member (get-attribute act 'act-type)
               '(willful-killing torture inhuman-treatment biological-experiments 
                 extensive-destruction unlawful-deportation unlawful-confinement 
                 hostage-taking))))

(define attacking-civilians? (lambda (act)
  (and (intentional-attack? act)
       (civilian-object-targeted? act)
       (no-military-objective? act))))

(define intentional-attack? (lambda (act)
  (has-attribute act 'deliberate-attack)))

(define civilian-object-targeted? (lambda (act)
  (or (has-attribute act 'civilian-population-target)
      (has-attribute act 'civilian-object-target))))

(define no-military-objective? (lambda (act)
  (not (has-attribute act 'military-objective))))

(define using-prohibited-weapons? (lambda (act)
  (and (has-attribute act 'weapon-type)
       (weapon-prohibited? act))))

(define weapon-prohibited? (lambda (act)
  (and (has-attribute act 'weapon-type)
       (member (get-attribute act 'weapon-type)
               '(chemical biological poison-gas expanding-bullets blinding-lasers))))

(define perfidy? (lambda (act)
  (and (feigning-protected-status? act)
       (intent-to-kill-injure-capture? act))))

(define feigning-protected-status? (lambda (act)
  (or (has-attribute act 'fake-surrender)
      (has-attribute act 'fake-civilian-status)
      (has-attribute act 'misuse-protected-emblem))))

(define intent-to-kill-injure-capture? (lambda (act)
  (has-attribute act 'hostile-intent)))

;; =============================================================================
;; INTERNATIONAL HUMAN RIGHTS LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Universal Human Rights
(define right-to-life? (lambda (right)
  (and (has-attribute right 'life-right)
       (inherent-right? right)
       (arbitrary-deprivation-prohibited? right))))

(define inherent-right? (lambda (right)
  (has-attribute right 'inherent)))

(define arbitrary-deprivation-prohibited? (lambda (right)
  (has-attribute right 'non-arbitrary)))

(define freedom-from-torture? (lambda (right)
  (and (has-attribute right 'torture-prohibition)
       (absolute-right? right)
       (no-derogation? right))))

(define absolute-right? (lambda (right)
  (has-attribute right 'non-derogable)))

(define no-derogation? (lambda (right)
  (not (has-attribute right 'derogation-permitted))))

(define freedom-from-slavery? (lambda (right)
  (and (has-attribute right 'slavery-prohibition)
       (includes-servitude? right)
       (includes-forced-labor? right))))

(define includes-servitude? (lambda (right)
  (has-attribute right 'servitude-prohibited)))

(define includes-forced-labor? (lambda (right)
  (has-attribute right 'forced-labor-prohibited)))

(define right-to-fair-trial? (lambda (right)
  (and (has-attribute right 'fair-trial-guarantee)
       (independent-impartial-tribunal? right)
       (public-hearing? right)
       (presumption-of-innocence? right))))

(define independent-impartial-tribunal? (lambda (right)
  (and (has-attribute right 'independent-tribunal)
       (has-attribute right 'impartial-tribunal))))

(define public-hearing? (lambda (right)
  (or (has-attribute right 'public-hearing)
      (closed-hearing-justified? right))))

(define closed-hearing-justified? (lambda (right)
  (has-attribute right 'justified-closed-hearing)))

(define presumption-of-innocence? (lambda (right)
  (has-attribute right 'innocent-until-proven-guilty)))

(define freedom-of-expression? (lambda (right)
  (and (has-attribute right 'expression-freedom)
       (subject-to-limitations? right))))

(define subject-to-limitations? (lambda (right)
  (and (has-attribute right 'limitations-permitted)
       (limitations-lawful-and-necessary? right))))

(define limitations-lawful-and-necessary? (lambda (right)
  (and (prescribed-by-law? right)
       (legitimate-aim? right)
       (proportionate-limitation? right))))

(define prescribed-by-law? (lambda (right)
  (has-attribute right 'legal-basis)))

(define legitimate-aim? (lambda (right)
  (and (has-attribute right 'limitation-purpose)
       (member (get-attribute right 'limitation-purpose)
               '(public-order public-health public-morals rights-of-others national-security)))))

(define proportionate-limitation? (lambda (right)
  (and (necessary-in-democratic-society? right)
       (least-restrictive-means? right))))

(define necessary-in-democratic-society? (lambda (right)
  (has-attribute right 'democratic-necessity)))

(define least-restrictive-means? (lambda (right)
  (has-attribute right 'minimal-restriction)))

;; African Charter Specifics
(define individual-rights? (lambda (right)
  (and (has-attribute right 'individual-right)
       (civil-political-or-economic-social-cultural? right))))

(define civil-political-or-economic-social-cultural? (lambda (right)
  (or (has-attribute right 'civil-political)
      (has-attribute right 'economic-social-cultural))))

(define peoples-rights? (lambda (right)
  (and (has-attribute right 'collective-right)
       (group-entitlement? right))))

(define group-entitlement? (lambda (right)
  (or (has-attribute right 'self-determination)
      (has-attribute right 'natural-resources)
      (has-attribute right 'development)
      (has-attribute right 'peace-and-security))))

(define duties-included? (lambda (right)
  (and (has-attribute right 'individual-duties)
       (duties-to-family-society-state? right))))

(define duties-to-family-society-state? (lambda (right)
  (or (has-attribute right 'family-duties)
      (has-attribute right 'society-duties)
      (has-attribute right 'state-duties))))

;; =============================================================================
;; INTERNATIONAL CRIMINAL LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Crime of Aggression
(define crime-of-aggression? (lambda (crime)
  (and (has-attribute crime 'act-of-aggression)
       (leadership-crime? crime)
       (manifest-violation-un-charter? crime))))

(define leadership-crime? (lambda (crime)
  (and (has-attribute crime 'accused-position)
       (position-of-control? crime))))

(define position-of-control? (lambda (crime)
  (or (has-attribute crime 'political-leader)
      (has-attribute crime 'military-commander)))

(define manifest-violation-un-charter? (lambda (crime)
  (and (has-attribute crime 'charter-violation)
       (clear-and-serious-violation? crime))))

(define clear-and-serious-violation? (lambda (crime)
  (has-attribute crime 'manifest-breach)))

;; ICC Complementarity
(define complementarity-test? (lambda (crime)
  (and (national-jurisdiction-primary? crime)
       (icc-jurisdiction-exceptional? crime))))

(define national-jurisdiction-primary? (lambda (crime)
  (or (unwilling-to-investigate? crime)
      (unable-to-investigate? crime)
      (no-genuine-proceedings? crime))))

(define unwilling-to-investigate? (lambda (crime)
  (or (proceedings-shield-from-responsibility? crime)
      (unjustified-delay? crime)
      (not-conducted-independently? crime))))

(define proceedings-shield-from-responsibility? (lambda (crime)
  (has-attribute crime 'sham-proceedings)))

(define unjustified-delay? (lambda (crime)
  (and (has-attribute crime 'delay)
       (inconsistent-with-justice? crime))))

(define inconsistent-with-justice? (lambda (crime)
  (has-attribute crime 'unreasonable-delay)))

(define not-conducted-independently? (lambda (crime)
  (has-attribute crime 'lack-independence)))

(define unable-to-investigate? (lambda (crime)
  (or (total-collapse-national-system? crime)
      (substantial-collapse? crime))))

(define total-collapse-national-system? (lambda (crime)
  (has-attribute crime 'collapsed-judiciary)))

(define substantial-collapse? (lambda (crime)
  (has-attribute crime 'unavailable-judiciary)))

(define no-genuine-proceedings? (lambda (crime)
  (or (not (has-attribute crime 'national-proceedings))
      (unwilling-to-investigate? crime)
      (unable-to-investigate? crime))))

(define icc-jurisdiction-exceptional? (lambda (crime)
  (has-attribute crime 'complementarity-met)))

;; Gravity Threshold
(define sufficient-gravity? (lambda (crime)
  (and (has-attribute crime 'gravity-assessment)
       (gravity-threshold-met? crime))))

(define gravity-threshold-met? (lambda (crime)
  (or (large-scale-crime? crime)
      (systematic-crime? crime)
      (serious-impact? crime))))

(define large-scale-crime? (lambda (crime)
  (and (has-attribute crime 'number-of-victims)
       (let ((victims (get-attribute crime 'number-of-victims)))
         (> victims 100)))) ; significant number

(define systematic-crime? (lambda (crime)
  (has-attribute crime 'systematic-pattern)))

(define serious-impact? (lambda (crime)
  (has-attribute crime 'serious-harm)))

;; South Africa ICC Implementation
(define icc-act-applicable? (lambda (crime)
  (and (has-attribute crime 'icc-act-2002)
       (domestic-legislation-incorporates? crime))))

(define domestic-legislation-incorporates? (lambda (crime)
  (has-attribute crime 'domestic-law-criminalizes)))

(define cooperation-with-icc? (lambda (crime)
  (and (arrest-warrant-executed? crime)
       (evidence-provided? crime)
       (general-cooperation-obligations? crime))))

(define arrest-warrant-executed? (lambda (crime)
  (or (not (has-attribute crime 'arrest-warrant))
      (has-attribute crime 'warrant-executed))))

(define evidence-provided? (lambda (crime)
  (or (not (has-attribute crime 'evidence-request))
      (has-attribute crime 'evidence-transmitted))))

(define general-cooperation-obligations? (lambda (crime)
  (has-attribute crime 'cooperation-compliance)))

(define surrender-of-persons? (lambda (crime)
  (and (surrender-request-received? crime)
       (no-immunity-obstacle? crime)
       (person-surrendered? crime))))

(define surrender-request-received? (lambda (crime)
  (has-attribute crime 'surrender-request)))

(define no-immunity-obstacle? (lambda (crime)
  (or (not (has-attribute crime 'immunity-claim))
      (immunity-waived-or-inapplicable? crime))))

(define immunity-waived-or-inapplicable? (lambda (crime)
  (has-attribute crime 'no-immunity-bar)))

(define person-surrendered? (lambda (crime)
  (has-attribute crime 'surrender-completed)))

;; =============================================================================
;; INTERNATIONAL TRADE LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; WTO Principles
(define most-favoured-nation? (lambda (measure)
  (and (has-attribute measure 'mfn-treatment)
       (no-discrimination-between-members? measure)
       (best-treatment-to-all? measure))))

(define no-discrimination-between-members? (lambda (measure)
  (not (has-attribute measure 'country-discrimination))))

(define best-treatment-to-all? (lambda (measure)
  (has-attribute measure 'equal-best-treatment)))

(define national-treatment? (lambda (measure)
  (and (has-attribute measure 'national-treatment)
       (no-discrimination-domestic-foreign? measure)
       (like-products-treated-equally? measure))))

(define no-discrimination-domestic-foreign? (lambda (measure)
  (not (has-attribute measure 'origin-discrimination))))

(define like-products-treated-equally? (lambda (measure)
  (has-attribute measure 'like-product-equality)))

(define no-quantitative-restrictions? (lambda (measure)
  (and (no-import-quotas? measure)
       (no-export-restrictions? measure)
       (exceptions-justified? measure))))

(define no-import-quotas? (lambda (measure)
  (not (has-attribute measure 'import-quota))))

(define no-export-restrictions? (lambda (measure)
  (not (has-attribute measure 'export-restriction))))

(define exceptions-justified? (lambda (measure)
  (or (not (has-attribute measure 'quantitative-measure))
      (gatt-exception-applies? measure))))

(define gatt-exception-applies? (lambda (measure)
  (and (has-attribute measure 'gatt-article-xx)
       (legitimate-policy-objective? measure)))

(define legitimate-policy-objective? (lambda (measure)
  (or (has-attribute measure 'public-morals)
      (has-attribute measure 'human-health)
      (has-attribute measure 'environmental-protection))))

(define transparency? (lambda (measure)
  (and (published-and-notified? measure)
       (enquiry-point-accessible? measure))))

(define published-and-notified? (lambda (measure)
  (and (has-attribute measure 'published)
       (has-attribute measure 'wto-notified))))

(define enquiry-point-accessible? (lambda (measure)
  (has-attribute measure 'enquiry-point)))

;; SADC
(define free-trade-area? (lambda (measure)
  (and (tariff-elimination-scheduled? measure)
       (rules-of-origin-complied? measure))))

(define tariff-elimination-scheduled? (lambda (measure)
  (has-attribute measure 'tariff-phase-down)))

(define rules-of-origin-complied? (lambda (measure)
  (has-attribute measure 'origin-compliance)))

(define regional-cooperation? (lambda (measure)
  (and (supports-regional-integration? measure)
       (facilitates-trade? measure))))

(define supports-regional-integration? (lambda (measure)
  (has-attribute measure 'integration-objective)))

(define facilitates-trade? (lambda (measure)
  (has-attribute measure 'trade-facilitation)))

(define dispute-settlement-available? (lambda (measure)
  (and (has-attribute measure 'dispute-mechanism)
       (tribunal-accessible? measure))))

(define tribunal-accessible? (lambda (measure)
  (has-attribute measure 'tribunal-access)))

;; =============================================================================
;; INTERNATIONAL ENVIRONMENTAL LAW - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define prevent-transboundary-harm? (lambda (obligation)
  (and (due-diligence-exercised? obligation)
       (harm-prevention-measures? obligation)
       (notification-of-risk? obligation))))

(define due-diligence-exercised? (lambda (obligation)
  (has-attribute obligation 'due-diligence)))

(define harm-prevention-measures? (lambda (obligation)
  (has-attribute obligation 'prevention-measures)))

(define notification-of-risk? (lambda (obligation)
  (or (not (transboundary-risk? obligation))
      (has-attribute obligation 'risk-notification))))

(define transboundary-risk? (lambda (obligation)
  (has-attribute obligation 'cross-border-impact)))

(define sustainable-development? (lambda (obligation)
  (and (integration-of-environment-development? obligation)
       (intergenerational-equity? obligation))))

(define integration-of-environment-development? (lambda (obligation)
  (has-attribute obligation 'integrated-approach)))

(define intergenerational-equity? (lambda (obligation)
  (has-attribute obligation 'future-generations)))

(define precautionary-principle? (lambda (obligation)
  (and (scientific-uncertainty? obligation)
       (preventive-action-taken? obligation))))

(define scientific-uncertainty? (lambda (obligation)
  (has-attribute obligation 'uncertain-harm)))

(define preventive-action-taken? (lambda (obligation)
  (has-attribute obligation 'precautionary-measures)))

(define common-but-differentiated-responsibility? (lambda (obligation)
  (and (common-responsibility-recognized? obligation)
       (differentiated-based-on-capacity? obligation))))

(define common-responsibility-recognized? (lambda (obligation)
  (has-attribute obligation 'common-concern)))

(define differentiated-based-on-capacity? (lambda (obligation)
  (and (has-attribute obligation 'capabilities-considered)
       (developed-developing-distinction? obligation))))

(define developed-developing-distinction? (lambda (obligation)
  (has-attribute obligation 'differentiation)))

;; =============================================================================
;; STATE RESPONSIBILITY - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define attributable-to-state? (lambda (act)
  (or (state-organ-conduct? act)
      (exercising-governmental-authority? act)
      (directed-or-controlled-by-state? act)
      (acknowledged-and-adopted? act))))

(define state-organ-conduct? (lambda (act)
  (has-attribute act 'state-organ)))

(define exercising-governmental-authority? (lambda (act)
  (and (has-attribute act 'governmental-authority)
       (empowered-by-law? act))))

(define empowered-by-law? (lambda (act)
  (has-attribute act 'legal-empowerment)))

(define directed-or-controlled-by-state? (lambda (act)
  (and (has-attribute act 'state-direction)
       (effective-control? act))))

(define effective-control? (lambda (act)
  (has-attribute act 'control-over-conduct)))

(define acknowledged-and-adopted? (lambda (act)
  (and (has-attribute act 'state-acknowledgment)
       (has-attribute act 'state-adoption))))

(define breach-of-international-obligation? (lambda (act)
  (and (international-obligation-exists? act)
       (conduct-inconsistent-with-obligation? act)
       (obligation-in-force? act))))

(define international-obligation-exists? (lambda (act)
  (or (has-attribute act 'treaty-obligation)
      (has-attribute act 'customary-obligation))))

(define conduct-inconsistent-with-obligation? (lambda (act)
  (has-attribute act 'obligation-breach)))

(define obligation-in-force? (lambda (act)
  (and (has-attribute act 'temporal-applicability)
       (not (has-attribute act 'obligation-terminated)))))

(define wrongful-act? (lambda (act)
  (and (attributable-to-state? act)
       (breach-of-international-obligation? act)
       (no-circumstance-precluding-wrongfulness? act))))

(define no-circumstance-precluding-wrongfulness? (lambda (act)
  (not (or (consent-given? act)
           (self-defence-justified? act)
           (countermeasure-lawful? act)
           (force-majeure? act)
           (distress? act)
           (necessity? act)))))

(define consent-given? (lambda (act)
  (and (has-attribute act 'consent)
       (valid-consent? act))))

(define valid-consent? (lambda (act)
  (and (free-consent? act)
       (not-violating-jus-cogens? act))))

(define free-consent? (lambda (act)
  (not (has-attribute act 'coerced-consent))))

(define not-violating-jus-cogens? (lambda (act)
  (not (has-attribute act 'jus-cogens-violation))))

(define self-defence-justified? (lambda (act)
  (and (has-attribute act 'self-defence)
       (armed-attack-occurred? act)
       (necessary-and-proportionate? act))))

(define armed-attack-occurred? (lambda (act)
  (has-attribute act 'armed-attack)))

(define necessary-and-proportionate? (lambda (act)
  (and (has-attribute act 'necessity)
       (has-attribute act 'proportionality))))

(define countermeasure-lawful? (lambda (act)
  (lawful-countermeasure? act)))

(define force-majeure? (lambda (act)
  (and (irresistible-force? act)
       (unforeseen-event? act)
       (beyond-state-control? act))))

(define irresistible-force? (lambda (act)
  (has-attribute act 'irresistible)))

(define unforeseen-event? (lambda (act)
  (has-attribute act 'unforeseeable)))

(define beyond-state-control? (lambda (act)
  (has-attribute act 'no-control)))

(define distress? (lambda (act)
  (and (no-other-means-to-save-lives? act)
       (limited-to-saving-lives? act))))

(define no-other-means-to-save-lives? (lambda (act)
  (has-attribute act 'no-alternative)))

(define limited-to-saving-lives? (lambda (act)
  (has-attribute act 'life-saving-only)))

(define necessity? (lambda (act)
  (and (grave-and-imminent-peril? act)
       (essential-interest? act)
       (only-way-to-safeguard? act)
       (not-seriously-impairing-other-state? act))))

(define grave-and-imminent-peril? (lambda (act)
  (and (has-attribute act 'grave-peril)
       (has-attribute act 'imminent-peril))))

(define essential-interest? (lambda (act)
  (has-attribute act 'essential-interest)))

(define only-way-to-safeguard? (lambda (act)
  (has-attribute act 'only-means)))

(define not-seriously-impairing-other-state? (lambda (act)
  (not (has-attribute act 'serious-impairment-other))))

;; Countermeasures
(define response-to-wrongful-act? (lambda (measure)
  (and (prior-wrongful-act? measure)
       (measure-responsive? measure))))

(define prior-wrongful-act? (lambda (measure)
  (has-attribute measure 'prior-breach)))

(define measure-responsive? (lambda (measure)
  (has-attribute measure 'responsive-nature)))

(define proportionate? (lambda (measure)
  (and (has-attribute measure 'proportionality-assessment)
       (not-excessive? measure))))

(define not-excessive? (lambda (measure)
  (not (has-attribute measure 'disproportionate))))

(define aimed-at-inducing-compliance? (lambda (measure)
  (and (has-attribute measure 'compliance-purpose)
       (not-punitive? measure))))

(define not-punitive? (lambda (measure)
  (not (has-attribute measure 'punishment-intent))))

(define not-affecting-fundamental-rights? (lambda (measure)
  (and (no-violation-basic-human-rights? measure)
       (no-violation-humanitarian-obligations? measure)
       (no-violation-jus-cogens? measure))))

(define no-violation-basic-human-rights? (lambda (measure)
  (not (has-attribute measure 'human-rights-violation))))

(define no-violation-humanitarian-obligations? (lambda (measure)
  (not (has-attribute measure 'ihl-violation))))

(define no-violation-jus-cogens? (lambda (measure)
  (not (has-attribute measure 'peremptory-norm-breach))))

;; =============================================================================
;; PEACEFUL DISPUTE SETTLEMENT - DETAILED IMPLEMENTATIONS
;; =============================================================================

;; Negotiation
(define negotiation? (lambda (method)
  (and (has-attribute method 'direct-negotiation)
       (parties-communicate-directly? method)
       (seek-mutually-acceptable-solution? method))))

(define parties-communicate-directly? (lambda (method)
  (has-attribute method 'bilateral-talks)))

(define seek-mutually-acceptable-solution? (lambda (method)
  (has-attribute method 'consensual-resolution)))

;; Mediation
(define mediation? (lambda (method)
  (and (has-attribute method 'third-party-mediator)
       (mediator-facilitates? method)
       (non-binding-suggestions? method))))

(define mediator-facilitates? (lambda (method)
  (has-attribute method 'facilitation)))

(define non-binding-suggestions? (lambda (method)
  (not (binding-decision? method))))

(define binding-decision? (lambda (method)
  (has-attribute method 'binding-outcome)))

;; Conciliation
(define conciliation? (lambda (method)
  (and (has-attribute method 'conciliation-commission)
       (commission-investigates? method)
       (commission-proposes-terms? method))))

(define commission-investigates? (lambda (method)
  (has-attribute method 'fact-finding)))

(define commission-proposes-terms? (lambda (method)
  (has-attribute method 'settlement-proposal)))

;; Arbitration
(define arbitration? (lambda (method)
  (and (has-attribute method 'arbitral-tribunal)
       (parties-consent-to-arbitration? method)
       (binding-arbitral-award? method))))

(define parties-consent-to-arbitration? (lambda (method)
  (has-attribute method 'arbitration-agreement)))

(define binding-arbitral-award? (lambda (method)
  (has-attribute method 'binding-award)))

;; Judicial Settlement
(define judicial-settlement? (lambda (method)
  (and (has-attribute method 'international-court)
       (binding-judgment? method)
       (third-party-adjudication? method))))

(define binding-judgment? (lambda (method)
  (has-attribute method 'binding-judgment)))

(define third-party-adjudication? (lambda (method)
  (has-attribute method 'judicial-determination)))

;; ICJ Jurisdiction
(define between-states? (lambda (dispute)
  (and (has-attribute dispute 'parties)
       (only-states-as-parties? dispute))))

(define only-states-as-parties? (lambda (dispute)
  (has-attribute dispute 'state-parties-only)))

(define consent-of-parties? (lambda (dispute)
  (or (treaty-jurisdiction? dispute)
      (special-agreement? dispute)
      (unilateral-application-accepted? dispute))))

(define treaty-jurisdiction? (lambda (dispute)
  (has-attribute dispute 'compromissory-clause)))

(define special-agreement? (lambda (dispute)
  (has-attribute dispute 'compromis)))

(define unilateral-application-accepted? (lambda (dispute)
  (and (has-attribute dispute 'unilateral-application)
       (has-attribute dispute 'acceptance-of-jurisdiction))))

(define contentious-or-advisory? (lambda (dispute)
  (or (contentious-jurisdiction? dispute)
      (advisory-opinion-requested? dispute))))

(define contentious-jurisdiction? (lambda (dispute)
  (and (has-attribute dispute 'legal-dispute)
       (binding-decision-sought? dispute))))

(define binding-decision-sought? (lambda (dispute)
  (has-attribute dispute 'binding-resolution)))

(define advisory-opinion-requested? (lambda (dispute)
  (and (has-attribute dispute 'advisory-opinion)
       (authorized-un-organ-request? dispute))))

(define authorized-un-organ-request? (lambda (dispute)
  (or (has-attribute dispute 'ga-request)
      (has-attribute dispute 'sc-request)
      (has-attribute dispute 'authorized-body-request))))

;; =============================================================================
;; END OF SOUTH AFRICAN INTERNATIONAL LAW FRAMEWORK
;; =============================================================================
