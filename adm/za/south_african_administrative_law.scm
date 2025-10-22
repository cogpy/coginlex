;; South African Administrative Law Framework
;; Scheme implementation based on PAJA (Promotion of Administrative Justice Act)

;; =============================================================================
;; CORE ADMINISTRATIVE LAW PRINCIPLES
;; =============================================================================

;; Administrative Action (PAJA Section 1)
(define administrative-action? (lambda (action)
  (and (decision-or-failure-to-act? action)
       (public-nature? action)
       (adversely-affects-rights? action)
       (direct-external-legal-effect? action)
       (not-excluded-action? action))))

;; =============================================================================
;; PROCEDURAL FAIRNESS (SECTION 3)
;; =============================================================================

(define procedurally-fair-action? (lambda (action)
  (and (adequate-notice? action)
       (reasonable-opportunity-to-respond? action)
       (clear-statement-of-action? action)
       (reasons-for-action? action)
       (proper-consideration-of-submissions? action))))

;; Audi Alteram Partem (Hear the Other Side)
(define audi-alteram-partem? (lambda (action)
  (and (notice-given? action)
       (opportunity-to-be-heard? action)
       (opportunity-to-present-case? action))))

;; =============================================================================
;; LAWFULNESS (SECTION 6)
;; =============================================================================

(define lawful-administrative-action? (lambda (action)
  (and (empowered-by-law? action)
       (authorized-by-law? action)
       (within-scope-of-power? action)
       (proper-purpose? action))))

;; Grounds for Review
(define reviewable-administrative-action? (lambda (action)
  (or (not-authorized-by-empowering-provision? action)
      (mandatory-procedure-not-followed? action)
      (influenced-by-error-of-law? action)
      (taken-for-unauthorized-purpose? action)
      (irrelevant-considerations? action)
      (relevant-considerations-not-considered? action)
      (exercised-in-bad-faith? action)
      (arbitrary-or-capricious? action)
      (procedurally-unfair? action)
      (materially-influenced-by-error? action)
      (ultra-vires? action))))

;; =============================================================================
;; REASONABLENESS
;; =============================================================================

(define reasonable-administrative-action? (lambda (action)
  (and (rational-connection? action)
       (proportionate? action)
       (justifiable-in-circumstances? action))))

;; Rationality Test
(define rational-action? (lambda (action)
  (and (reasons-provided? action)
       (logical-connection-to-facts? action)
       (within-range-of-reasonable-outcomes? action))))

;; =============================================================================
;; ADMINISTRATIVE APPEALS (SECTION 7)
;; =============================================================================

(define internal-appeal-available? (lambda (action)
  (and (appeal-procedure-exists? action)
       (within-appeal-period? action)
       (exhausted-internal-remedies? action))))

;; =============================================================================
;; JUDICIAL REVIEW (SECTION 8)
;; =============================================================================

(define judicial-review-available? (lambda (action)
  (and (administrative-action? action)
       (exhausted-internal-remedies? action)
       (within-time-limits? action)
       (locus-standi? action))))

;; Remedies
(define review-remedy? (lambda (action)
  (or (set-aside-decision? action)
      (correct-defect? action)
      (remit-to-administrator? action)
      (substitute-own-decision? action)
      (award-damages? action))))

;; =============================================================================
;; LEGITIMATE EXPECTATION
;; =============================================================================

(define legitimate-expectation? (lambda (expectation)
  (and (clear-representation? expectation)
       (reasonable-reliance? expectation)
       (not-contrary-to-law? expectation))))

;; =============================================================================
;; BIAS AND CONFLICT OF INTEREST
;; =============================================================================

(define nemo-judex-in-causa-sua? (lambda (administrator)
  (or (direct-interest? administrator)
      (reasonable-apprehension-of-bias? administrator))))

;; =============================================================================
;; RULE-MAKING (DELEGATED LEGISLATION)
;; =============================================================================

(define valid-regulation? (lambda (regulation)
  (and (authorized-by-enabling-act? regulation)
       (within-scope-of-delegation? regulation)
       (procedurally-correct? regulation)
       (published-in-gazette? regulation)
       (substantively-reasonable? regulation))))

;; =============================================================================
;; ADMINISTRATIVE ACTION - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define decision-or-failure-to-act? (lambda (action)
  (or (decision-made? action)
      (failure-to-decide? action)
      (conduct-affecting-rights? action))))

(define decision-made? (lambda (action)
  (has-attribute action 'decision)))

(define failure-to-decide? (lambda (action)
  (and (has-attribute action 'duty-to-decide)
       (not (has-attribute action 'decision-made)))))

(define conduct-affecting-rights? (lambda (action)
  (has-attribute action 'conduct-with-effect)))

(define public-nature? (lambda (action)
  (and (exercise-of-public-power? action)
       (or (state-organ-action? action)
           (public-function-performer? action)
           (statutory-power-exercise? action)))))

(define exercise-of-public-power? (lambda (action)
  (has-attribute action 'public-power)))

(define state-organ-action? (lambda (action)
  (has-attribute action 'state-organ)))

(define public-function-performer? (lambda (action)
  (has-attribute action 'public-function)))

(define statutory-power-exercise? (lambda (action)
  (has-attribute action 'statutory-power)))

(define adversely-affects-rights? (lambda (action)
  (and (affects-rights? action)
       (adverse-impact? action)
       (not-beneficial-only? action))))

(define affects-rights? (lambda (action)
  (has-attribute action 'affects-rights)))

(define adverse-impact? (lambda (action)
  (or (has-attribute action 'negative-impact)
      (has-attribute action 'detrimental-effect))))

(define not-beneficial-only? (lambda (action)
  (not (has-attribute action 'purely-beneficial))))

(define direct-external-legal-effect? (lambda (action)
  (and (external-effect? action)
       (legal-consequences? action)
       (not-internal-administrative? action))))

(define external-effect? (lambda (action)
  (has-attribute action 'external-impact)))

(define legal-consequences? (lambda (action)
  (or (has-attribute action 'creates-rights)
      (has-attribute action 'imposes-obligations)
      (has-attribute action 'affects-legal-position))))

(define not-internal-administrative? (lambda (action)
  (not (has-attribute action 'purely-internal))))

(define not-excluded-action? (lambda (action)
  (not (excluded-administrative-action? action))))

(define excluded-administrative-action? (lambda (action)
  (or (has-attribute action 'executive-policy-formulation)
      (has-attribute action 'legislative-function)
      (has-attribute action 'judicial-function)
      (has-attribute action 'cabinet-decision)
      (has-attribute action 'judicial-officer-action))))

;; =============================================================================
;; PROCEDURAL FAIRNESS - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define adequate-notice? (lambda (action)
  (and (notice-provided? action)
       (reasonable-time? action)
       (sufficient-information? action)
       (comprehensible-notice? action))))

(define notice-provided? (lambda (action)
  (has-attribute action 'notice)))

(define reasonable-time? (lambda (action)
  (>= (get-attribute action 'notice-days) 7)))

(define sufficient-information? (lambda (action)
  (and (has-attribute action 'nature-of-action)
       (has-attribute action 'reasons-for-action)
       (has-attribute action 'factual-basis))))

(define comprehensible-notice? (lambda (action)
  (and (has-attribute action 'clear-language)
       (has-attribute action 'language-understood))))

(define reasonable-opportunity-to-respond? (lambda (action)
  (and (opportunity-provided? action)
       (adequate-time-to-respond? action)
       (means-to-respond? action)
       (no-undue-impediments? action))))

(define opportunity-provided? (lambda (action)
  (has-attribute action 'response-opportunity)))

(define adequate-time-to-respond? (lambda (action)
  (>= (get-attribute action 'response-period-days) 14)))

(define means-to-respond? (lambda (action)
  (or (has-attribute action 'written-submissions)
      (has-attribute action 'oral-hearing))))

(define no-undue-impediments? (lambda (action)
  (not (has-attribute action 'obstacles-to-response))))

(define clear-statement-of-action? (lambda (action)
  (and (proposed-action-clear? action)
       (specific-details? action)
       (unambiguous-terms? action))))

(define proposed-action-clear? (lambda (action)
  (has-attribute action 'clear-proposal)))

(define specific-details? (lambda (action)
  (has-attribute action 'specific-action)))

(define unambiguous-terms? (lambda (action)
  (not (has-attribute action 'ambiguous))))

(define reasons-for-action? (lambda (action)
  (and (reasons-given? action)
       (adequate-reasons? action)
       (intelligible-reasons? action))))

(define reasons-given? (lambda (action)
  (has-attribute action 'reasons)))

(define adequate-reasons? (lambda (action)
  (and (factual-basis-stated? action)
       (legal-basis-stated? action)
       (reasoning-explained? action))))

(define factual-basis-stated? (lambda (action)
  (has-attribute action 'facts-stated)))

(define legal-basis-stated? (lambda (action)
  (has-attribute action 'legal-authority)))

(define reasoning-explained? (lambda (action)
  (has-attribute action 'reasoning-process)))

(define intelligible-reasons? (lambda (action)
  (and (has-attribute action 'comprehensible)
       (not (has-attribute action 'contradictory)))))

(define proper-consideration-of-submissions? (lambda (action)
  (and (submissions-considered? action)
       (material-submissions-addressed? action)
       (fair-consideration? action))))

(define submissions-considered? (lambda (action)
  (has-attribute action 'submissions-reviewed)))

(define material-submissions-addressed? (lambda (action)
  (has-attribute action 'key-points-addressed)))

(define fair-consideration? (lambda (action)
  (and (has-attribute action 'open-mind)
       (not (has-attribute action 'predetermined)))))

;; =============================================================================
;; AUDI ALTERAM PARTEM - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define notice-given? (lambda (action)
  (and (has-attribute action 'notice-provided)
       (has-attribute action 'timely-notice))))

(define opportunity-to-be-heard? (lambda (action)
  (or (written-hearing? action)
      (oral-hearing? action)
      (appropriate-hearing-method? action))))

(define written-hearing? (lambda (action)
  (has-attribute action 'written-submissions-allowed)))

(define oral-hearing? (lambda (action)
  (has-attribute action 'oral-hearing-held)))

(define appropriate-hearing-method? (lambda (action)
  (has-attribute action 'suitable-hearing-form)))

(define opportunity-to-present-case? (lambda (action)
  (and (evidence-presentation-allowed? action)
       (arguments-presentation-allowed? action)
       (cross-examination-if-needed? action))))

(define evidence-presentation-allowed? (lambda (action)
  (has-attribute action 'evidence-permitted)))

(define arguments-presentation-allowed? (lambda (action)
  (has-attribute action 'arguments-permitted)))

(define cross-examination-if-needed? (lambda (action)
  (or (not (has-attribute action 'disputed-facts))
      (has-attribute action 'cross-examination-allowed))))
;; =============================================================================
;; LAWFULNESS - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define empowered-by-law? (lambda (action)
  (and (statutory-authorization? action)
       (constitutional-authorization? action)
       (common-law-authorization? action))))

(define statutory-authorization? (lambda (action)
  (or (has-attribute action 'statute-power)
      (not (requires-statute? action)))))

(define constitutional-authorization? (lambda (action)
  (has-attribute action 'constitutional-power)))

(define common-law-authorization? (lambda (action)
  (or (has-attribute action 'common-law-power)
      (not (requires-common-law? action)))))

(define requires-statute? (lambda (action)
  (has-attribute action 'statute-required)))

(define requires-common-law? (lambda (action)
  (has-attribute action 'common-law-required)))

(define authorized-by-law? (lambda (action)
  (and (empowering-provision-exists? action)
       (valid-authorization? action)
       (not-repealed? action))))

(define empowering-provision-exists? (lambda (action)
  (has-attribute action 'empowering-provision)))

(define valid-authorization? (lambda (action)
  (has-attribute action 'valid-authority)))

(define not-repealed? (lambda (action)
  (not (has-attribute action 'repealed-provision))))

(define within-scope-of-power? (lambda (action)
  (and (intra-vires? action)
       (not-ultra-vires? action)
       (power-properly-construed? action))))

(define intra-vires? (lambda (action)
  (has-attribute action 'within-powers)))

(define not-ultra-vires? (lambda (action)
  (not (ultra-vires? action))))

(define power-properly-construed? (lambda (action)
  (has-attribute action 'correct-interpretation)))

(define proper-purpose? (lambda (action)
  (and (purpose-authorized? action)
       (not-improper-purpose? action)
       (not-ulterior-motive? action))))

(define purpose-authorized? (lambda (action)
  (has-attribute action 'authorized-purpose)))

(define not-improper-purpose? (lambda (action)
  (not (has-attribute action 'improper-purpose))))

(define not-ulterior-motive? (lambda (action)
  (not (has-attribute action 'ulterior-motive))))

;; =============================================================================
;; GROUNDS FOR REVIEW - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define not-authorized-by-empowering-provision? (lambda (action)
  (or (no-empowering-provision? action)
      (provision-not-authorize? action)
      (exceeded-scope? action))))

(define no-empowering-provision? (lambda (action)
  (not (has-attribute action 'empowering-provision))))

(define provision-not-authorize? (lambda (action)
  (has-attribute action 'unauthorized-by-provision)))

(define exceeded-scope? (lambda (action)
  (has-attribute action 'scope-exceeded)))

(define mandatory-procedure-not-followed? (lambda (action)
  (and (mandatory-procedure-exists? action)
       (procedure-not-complied? action)
       (material-non-compliance? action))))

(define mandatory-procedure-exists? (lambda (action)
  (has-attribute action 'mandatory-procedure)))

(define procedure-not-complied? (lambda (action)
  (has-attribute action 'non-compliance)))

(define material-non-compliance? (lambda (action)
  (has-attribute action 'material-breach)))

(define influenced-by-error-of-law? (lambda (action)
  (and (error-of-law-exists? action)
       (material-influence? action)
       (not-immaterial-error? action))))

(define error-of-law-exists? (lambda (action)
  (or (has-attribute action 'wrong-legal-test)
      (has-attribute action 'misinterpretation)
      (has-attribute action 'incorrect-principle))))

(define material-influence? (lambda (action)
  (has-attribute action 'influenced-outcome)))

(define not-immaterial-error? (lambda (action)
  (not (has-attribute action 'immaterial-error))))

(define taken-for-unauthorized-purpose? (lambda (action)
  (and (purpose-identified? action)
       (purpose-not-authorized? action))))

(define purpose-identified? (lambda (action)
  (has-attribute action 'identifiable-purpose)))

(define purpose-not-authorized? (lambda (action)
  (has-attribute action 'unauthorized-purpose)))

(define irrelevant-considerations? (lambda (action)
  (and (irrelevant-factors-considered? action)
       (material-weight-given? action))))

(define irrelevant-factors-considered? (lambda (action)
  (has-attribute action 'irrelevant-considerations)))

(define material-weight-given? (lambda (action)
  (has-attribute action 'material-weight)))

(define relevant-considerations-not-considered? (lambda (action)
  (and (mandatory-consideration-exists? action)
       (not-considered? action)
       (would-affect-decision? action))))

(define mandatory-consideration-exists? (lambda (action)
  (has-attribute action 'mandatory-consideration)))

(define not-considered? (lambda (action)
  (has-attribute action 'not-considered)))

(define would-affect-decision? (lambda (action)
  (has-attribute action 'material-omission)))

(define exercised-in-bad-faith? (lambda (action)
  (or (dishonesty? action)
      (ulterior-purpose? action)
      (malice? action)
      (spite? action))))

(define dishonesty? (lambda (action)
  (has-attribute action 'dishonest)))

(define ulterior-purpose? (lambda (action)
  (has-attribute action 'ulterior-purpose)))

(define malice? (lambda (action)
  (has-attribute action 'malicious)))

(define spite? (lambda (action)
  (has-attribute action 'spiteful)))

(define arbitrary-or-capricious? (lambda (action)
  (and (no-rational-basis? action)
       (or (whimsical? action)
           (irrational? action)
           (without-reason? action)))))

(define no-rational-basis? (lambda (action)
  (not (has-attribute action 'rational-basis)))

(define whimsical? (lambda (action)
  (has-attribute action 'whimsical)))

(define irrational? (lambda (action)
  (has-attribute action 'irrational)))

(define without-reason? (lambda (action)
  (has-attribute action 'unreasoned)))

(define procedurally-unfair? (lambda (action)
  (not (procedurally-fair-action? action))))

(define materially-influenced-by-error? (lambda (action)
  (and (error-exists? action)
       (material-to-outcome? action))))

(define error-exists? (lambda (action)
  (or (has-attribute action 'error-of-fact)
      (has-attribute action 'error-of-law))))

(define material-to-outcome? (lambda (action)
  (has-attribute action 'material-error)))

(define ultra-vires? (lambda (action)
  (or (beyond-powers? action)
      (excess-of-jurisdiction? action)
      (unconstitutional-action? action))))

(define beyond-powers? (lambda (action)
  (has-attribute action 'exceeds-powers)))

(define excess-of-jurisdiction? (lambda (action)
  (has-attribute action 'no-jurisdiction)))

(define unconstitutional-action? (lambda (action)
  (has-attribute action 'unconstitutional)))
;; =============================================================================
;; REASONABLENESS - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define rational-connection? (lambda (action)
  (and (means-related-to-end? action)
       (logical-link? action)
       (not-irrational? action))))

(define means-related-to-end? (lambda (action)
  (has-attribute action 'means-end-link)))

(define logical-link? (lambda (action)
  (has-attribute action 'logical-connection)))

(define not-irrational? (lambda (action)
  (not (has-attribute action 'irrational))))

(define proportionate? (lambda (action)
  (and (suitable? action)
       (necessary? action)
       (proportionate-stricto-sensu? action))))

(define suitable? (lambda (action)
  (has-attribute action 'suitable-means)))

(define necessary? (lambda (action)
  (and (has-attribute action 'necessary)
       (not (has-attribute action 'less-restrictive-alternative))))

(define proportionate-stricto-sensu? (lambda (action)
  (and (benefits-outweigh-burdens? action)
       (not-excessive? action))))

(define benefits-outweigh-burdens? (lambda (action)
  (> (get-attribute action 'benefits-score)
     (get-attribute action 'burdens-score))))

(define not-excessive? (lambda (action)
  (not (has-attribute action 'excessive)))

(define justifiable-in-circumstances? (lambda (action)
  (and (context-considered? action)
       (all-factors-weighed? action)
       (reasonable-outcome? action))))

(define context-considered? (lambda (action)
  (has-attribute action 'context-analysis)))

(define all-factors-weighed? (lambda (action)
  (has-attribute action 'balanced-assessment)))

(define reasonable-outcome? (lambda (action)
  (has-attribute action 'reasonable-result)))

(define reasons-provided? (lambda (action)
  (and (has-attribute action 'written-reasons)
       (has-attribute action 'substantive-reasons))))

(define logical-connection-to-facts? (lambda (action)
  (and (facts-to-decision-link? action)
       (evidence-supports-decision? action))))

(define facts-to-decision-link? (lambda (action)
  (has-attribute action 'facts-decision-link)))

(define evidence-supports-decision? (lambda (action)
  (has-attribute action 'evidential-basis)))

(define within-range-of-reasonable-outcomes? (lambda (action)
  (and (not-manifestly-unreasonable? action)
       (defensible-decision? action))))

(define not-manifestly-unreasonable? (lambda (action)
  (not (has-attribute action 'manifestly-unreasonable))))

(define defensible-decision? (lambda (action)
  (has-attribute action 'defensible)))

;; =============================================================================
;; APPEALS AND REVIEW - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define appeal-procedure-exists? (lambda (action)
  (and (internal-appeal-mechanism? action)
       (appeal-route-available? action))))

(define internal-appeal-mechanism? (lambda (action)
  (has-attribute action 'appeal-procedure)))

(define appeal-route-available? (lambda (action)
  (has-attribute action 'appeal-avenue)))

(define within-appeal-period? (lambda (action)
  (and (appeal-deadline-known? action)
       (<= (get-attribute action 'days-since-decision)
           (get-attribute action 'appeal-period-days)))))

(define appeal-deadline-known? (lambda (action)
  (has-attribute action 'appeal-deadline)))

(define exhausted-internal-remedies? (lambda (action)
  (or (no-internal-remedy? action)
      (internal-remedies-pursued? action)
      (futile-to-exhaust? action))))

(define no-internal-remedy? (lambda (action)
  (not (has-attribute action 'internal-remedy))))

(define internal-remedies-pursued? (lambda (action)
  (has-attribute action 'remedies-exhausted)))

(define futile-to-exhaust? (lambda (action)
  (has-attribute action 'futility-exception)))

(define within-time-limits? (lambda (action)
  (and (time-limit-known? action)
       (or (within-180-days? action)
           (extension-granted? action)))))

(define time-limit-known? (lambda (action)
  (has-attribute action 'time-limit)))

(define within-180-days? (lambda (action)
  (<= (get-attribute action 'days-since-action) 180)))

(define extension-granted? (lambda (action)
  (has-attribute action 'condonation)))

(define locus-standi? (lambda (action)
  (or (person-with-sufficient-interest? action)
      (acting-in-public-interest? action)
      (acting-on-behalf-of-group? action))))

(define person-with-sufficient-interest? (lambda (action)
  (has-attribute action 'sufficient-interest)))

(define acting-in-public-interest? (lambda (action)
  (has-attribute action 'public-interest)))

(define acting-on-behalf-of-group? (lambda (action)
  (has-attribute action 'class-action)))

(define set-aside-decision? (lambda (action)
  (has-attribute action 'set-aside-remedy)))

(define correct-defect? (lambda (action)
  (has-attribute action 'correct-remedy)))

(define remit-to-administrator? (lambda (action)
  (has-attribute action 'remittal-remedy)))

(define substitute-own-decision? (lambda (action)
  (and (has-attribute action 'substitution-remedy)
       (no-further-factual-findings? action))))

(define no-further-factual-findings? (lambda (action)
  (not (has-attribute action 'factual-inquiry-needed))))

(define award-damages? (lambda (action)
  (and (has-attribute action 'damages-appropriate)
       (loss-suffered? action)
       (causal-link-to-action? action))))

(define loss-suffered? (lambda (action)
  (has-attribute action 'damages-suffered)))

(define causal-link-to-action? (lambda (action)
  (has-attribute action 'causation)))

;; =============================================================================
;; LEGITIMATE EXPECTATION - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define clear-representation? (lambda (expectation)
  (and (representation-made? expectation)
       (unambiguous-representation? expectation)
       (by-authorized-person? expectation))))

(define representation-made? (lambda (expectation)
  (or (has-attribute expectation 'express-representation)
      (has-attribute expectation 'implied-representation)
      (has-attribute expectation 'past-practice))))

(define unambiguous-representation? (lambda (expectation)
  (has-attribute expectation 'clear-promise)))

(define by-authorized-person? (lambda (expectation)
  (has-attribute expectation 'authorized-official)))

(define reasonable-reliance? (lambda (expectation)
  (and (reliance-occurred? expectation)
       (reliance-reasonable? expectation)
       (detrimental-reliance? expectation))))

(define reliance-occurred? (lambda (expectation)
  (has-attribute expectation 'relied-upon)))

(define reliance-reasonable? (lambda (expectation)
  (and (has-attribute expectation 'reasonable-belief)
       (not (has-attribute expectation 'knew-or-should-have-known-false)))))

(define detrimental-reliance? (lambda (expectation)
  (or (has-attribute expectation 'detriment)
      (substantive-expectation? expectation))))

(define substantive-expectation? (lambda (expectation)
  (has-attribute expectation 'substantive)))

(define not-contrary-to-law? (lambda (expectation)
  (and (not-unlawful? expectation)
       (not-contrary-to-statute? expectation)
       (not-contrary-to-policy? expectation))))

(define not-unlawful? (lambda (expectation)
  (not (has-attribute expectation 'unlawful-promise))))

(define not-contrary-to-statute? (lambda (expectation)
  (not (has-attribute expectation 'statutory-conflict))))

(define not-contrary-to-policy? (lambda (expectation)
  (not (has-attribute expectation 'policy-conflict))))

;; =============================================================================
;; BIAS AND CONFLICT - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define direct-interest? (lambda (administrator)
  (or (financial-interest? administrator)
      (personal-interest? administrator)
      (relationship-interest? administrator))))

(define financial-interest? (lambda (administrator)
  (has-attribute administrator 'pecuniary-interest)))

(define personal-interest? (lambda (administrator)
  (has-attribute administrator 'direct-personal-interest)))

(define relationship-interest? (lambda (administrator)
  (has-attribute administrator 'family-friend-interest)))

(define reasonable-apprehension-of-bias? (lambda (administrator)
  (and (reasonable-person-test? administrator)
       (would-apprehend-bias? administrator)
       (not-actual-bias-required? administrator))))

(define reasonable-person-test? (lambda (administrator)
  (has-attribute administrator 'objective-test)))

(define would-apprehend-bias? (lambda (administrator)
  (or (has-attribute administrator 'bias-indicators)
      (has-attribute administrator 'prejudgment)
      (has-attribute administrator 'predetermined-mind))))

(define not-actual-bias-required? (lambda (administrator)
  (not (has-attribute administrator 'actual-bias-needed))))

;; =============================================================================
;; DELEGATED LEGISLATION - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define authorized-by-enabling-act? (lambda (regulation)
  (and (enabling-act-exists? regulation)
       (power-to-make-regulations? regulation)
       (specific-authorization? regulation))))

(define enabling-act-exists? (lambda (regulation)
  (has-attribute regulation 'enabling-act)))

(define power-to-make-regulations? (lambda (regulation)
  (has-attribute regulation 'regulation-power)))

(define specific-authorization? (lambda (regulation)
  (has-attribute regulation 'specific-power)))

(define within-scope-of-delegation? (lambda (regulation)
  (and (subject-matter-authorized? regulation)
       (not-sub-delegation? regulation)
       (consistent-with-act? regulation))))

(define subject-matter-authorized? (lambda (regulation)
  (has-attribute regulation 'authorized-subject)))

(define not-sub-delegation? (lambda (regulation)
  (or (not (has-attribute regulation 'sub-delegated))
      (has-attribute regulation 'sub-delegation-permitted))))

(define consistent-with-act? (lambda (regulation)
  (not (has-attribute regulation 'contradicts-act))))

(define procedurally-correct? (lambda (regulation)
  (and (consultation-conducted? regulation)
       (notice-published? regulation)
       (comments-considered? regulation))))

(define consultation-conducted? (lambda (regulation)
  (or (has-attribute regulation 'consultation-done)
      (not (has-attribute regulation 'consultation-required)))))

(define notice-published? (lambda (regulation)
  (has-attribute regulation 'notice-publication)))

(define comments-considered? (lambda (regulation)
  (or (has-attribute regulation 'comments-reviewed)
      (not (has-attribute regulation 'comments-received)))))

(define published-in-gazette? (lambda (regulation)
  (and (gazette-publication? regulation)
       (proper-gazette? regulation)
       (date-of-commencement? regulation))))

(define gazette-publication? (lambda (regulation)
  (has-attribute regulation 'gazette-published)))

(define proper-gazette? (lambda (regulation)
  (has-attribute regulation 'government-gazette)))

(define date-of-commencement? (lambda (regulation)
  (has-attribute regulation 'commencement-date)))

(define substantively-reasonable? (lambda (regulation)
  (and (rational-regulation? regulation)
       (proportionate-regulation? regulation)
       (not-arbitrary-regulation? regulation))))

(define rational-regulation? (lambda (regulation)
  (has-attribute regulation 'rational)))

(define proportionate-regulation? (lambda (regulation)
  (has-attribute regulation 'proportionate)))

(define not-arbitrary-regulation? (lambda (regulation)
  (not (has-attribute regulation 'arbitrary))))

;; =============================================================================
;; HELPER FUNCTIONS
;; =============================================================================

(define has-attribute (lambda (entity attribute)
  (and (not (null? entity))
       (if (pair? entity)
           (or (eq? (car entity) attribute)
               (has-attribute (cdr entity) attribute))
           (eq? entity attribute)))))

(define get-attribute (lambda (entity attribute)
  (cond
    ((null? entity) 0)
    ((pair? entity)
     (if (eq? (car entity) attribute)
         (if (pair? (cdr entity))
             (car (cdr entity))
             (cdr entity))
         (get-attribute (cdr entity) attribute)))
    (else 0))))

;; =============================================================================
;; END OF SOUTH AFRICAN ADMINISTRATIVE LAW FRAMEWORK
;; =============================================================================
