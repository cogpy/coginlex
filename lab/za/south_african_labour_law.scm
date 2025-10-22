;; South African Labour Law Framework
;; Scheme implementation based on LRA, BCEA, EEA, and related legislation

;; =============================================================================
;; EMPLOYMENT RELATIONSHIP
;; =============================================================================

;; Employment Contract
(define employment-relationship? (lambda (relationship)
  (and (personal-service? relationship)
       (remuneration? relationship)
       (supervision-and-control? relationship))))

;; Employee vs Independent Contractor
(define employee? (lambda (person)
  (and (works-for-another? person)
       (subject-to-control? person)
       (economically-dependent? person))))

;; =============================================================================
;; LABOUR RELATIONS ACT (LRA)
;; =============================================================================

;; Fundamental Rights
(define labour-rights? (lambda (worker)
  (and (right-to-fair-labour-practices? worker)
       (freedom-of-association? worker)
       (right-to-organize? worker)
       (right-to-collective-bargaining? worker)
       (right-to-strike? worker))))

;; Trade Unions
(define trade-union-rights? (lambda (union)
  (and (right-to-organize? union)
       (right-to-recruit? union)
       (organizational-rights? union)
       (collective-bargaining-rights? union))))

;; Strikes and Lockouts
(define protected-strike? (lambda (strike)
  (and (relates-to-dispute-of-interest? strike)
       (conciliation-attempted? strike)
       (certificate-of-non-resolution? strike)
       (notice-given? strike)
       (procedurally-compliant? strike)
       (no-violence? strike))))

;; Unfair Dismissal
(define unfair-dismissal? (lambda (dismissal)
  (and (dismissal-occurred? dismissal)
       (or (no-fair-reason? dismissal)
           (no-fair-procedure? dismissal)))))

;; Fair Reasons for Dismissal
(define fair-reason-dismissal? (lambda (dismissal)
  (or (misconduct? dismissal)
      (incapacity? dismissal)
      (operational-requirements? dismissal))))

;; Fair Procedure
(define fair-procedure-dismissal? (lambda (dismissal)
  (and (investigation-conducted? dismissal)
       (employee-notified? dismissal)
       (opportunity-to-respond? dismissal)
       (hearing-held? dismissal)
       (right-to-representation? dismissal))))

;; Automatically Unfair Dismissal
(define automatically-unfair-dismissal? (lambda (dismissal)
  (or (discriminatory-dismissal? dismissal)
      (pregnancy-related? dismissal)
      (trade-union-participation? dismissal)
      (refusing-unsafe-work? dismissal)
      (exercising-statutory-right? dismissal))))

;; =============================================================================
;; BASIC CONDITIONS OF EMPLOYMENT ACT (BCEA)
;; =============================================================================

;; Working Time
(define working-time-compliant? (lambda (arrangement)
  (and (max-45-hours-per-week? arrangement)
       (max-9-hours-per-day? arrangement)
       (overtime-properly-compensated? arrangement)
       (rest-periods-provided? arrangement))))

;; Leave Entitlements
(define leave-entitlements? (lambda (employee)
  (and (annual-leave-21-days? employee)
       (sick-leave-entitled? employee)
       (maternity-leave-4-months? employee)
       (family-responsibility-leave? employee))))

;; Remuneration
(define remuneration-compliant? (lambda (payment)
  (and (minimum-wage-paid? payment)
       (payment-in-money? payment)
       (payment-not-unreasonably-delayed? payment))))

;; Termination of Employment
(define notice-period-compliant? (lambda (termination)
  (or (one-week-if-less-than-6-months? termination)
      (two-weeks-if-6-months-to-1-year? termination)
      (four-weeks-if-more-than-1-year? termination))))

;; =============================================================================
;; EMPLOYMENT EQUITY ACT (EEA)
;; =============================================================================

;; Prohibition of Unfair Discrimination
(define unfair-discrimination? (lambda (treatment)
  (and (differential-treatment? treatment)
       (based-on-listed-ground? treatment)
       (not-inherent-job-requirement? treatment))))

;; Listed Grounds
(define listed-ground? (lambda (ground)
  (or (race? ground)
      (gender? ground)
      (sex? ground)
      (pregnancy? ground)
      (marital-status? ground)
      (ethnic-origin? ground)
      (disability? ground)
      (age? ground)
      (religion? ground)
      (hiv-status? ground))))

;; Affirmative Action
(define affirmative-action-compliant? (lambda (employer)
  (and (designated-employer? employer)
       (employment-equity-plan? employer)
       (reasonable-accommodation? employer)
       (report-to-labour-department? employer))))

;; =============================================================================
;; BARGAINING COUNCILS
;; =============================================================================

(define bargaining-council? (lambda (council)
  (and (registered-council? council)
       (representative-parties? council)
       (collective-agreement-powers? council)
       (dispute-resolution-functions? council))))

;; =============================================================================
;; CCMA (Commission for Conciliation, Mediation and Arbitration)
;; =============================================================================

(define ccma-jurisdiction? (lambda (dispute)
  (or (unfair-dismissal-dispute? dispute)
      (unfair-labour-practice-dispute? dispute)
      (organizational-rights-dispute? dispute))))

;; Conciliation
(define conciliation-process? (lambda (dispute)
  (and (referral-to-ccma? dispute)
       (conciliation-attempted? dispute)
       (within-30-days? dispute))))

;; Arbitration
(define arbitration-available? (lambda (dispute)
  (and (conciliation-failed? dispute)
       (certificate-of-non-resolution-issued? dispute)
       (within-90-days? dispute))))

;; =============================================================================
;; RETRENCHMENT
;; =============================================================================

(define fair-retrenchment? (lambda (retrenchment)
  (and (operational-requirements? retrenchment)
       (consultation-conducted? retrenchment)
       (fair-selection-criteria? retrenchment)
       (severance-pay-offered? retrenchment)
       (alternatives-considered? retrenchment))))

;; =============================================================================
;; EMPLOYMENT RELATIONSHIP - DETAILED IMPLEMENTATIONS
;; =============================================================================

(define personal-service? (lambda (relationship)
  (and (services-rendered-personally? relationship)
       (not-delegable? relationship)
       (no-substitute-permitted? relationship)
       (individual-performs-work? relationship))))

(define services-rendered-personally? (lambda (relationship)
  (has-attribute relationship 'personal-performance)))

(define not-delegable? (lambda (relationship)
  (not (has-attribute relationship 'delegation-allowed))))

(define no-substitute-permitted? (lambda (relationship)
  (not (has-attribute relationship 'substitute-worker))))

(define individual-performs-work? (lambda (relationship)
  (has-attribute relationship 'individual-worker)))

(define remuneration? (lambda (relationship)
  (and (payment-for-services? relationship)
       (regular-payment? relationship)
       (money-or-kind? relationship)
       (consideration-for-work? relationship))))

(define payment-for-services? (lambda (relationship)
  (has-attribute relationship 'payment)))

(define regular-payment? (lambda (relationship)
  (or (has-attribute relationship 'monthly-payment)
      (has-attribute relationship 'weekly-payment)
      (has-attribute relationship 'hourly-payment))))

(define money-or-kind? (lambda (relationship)
  (or (has-attribute relationship 'cash-payment)
      (has-attribute relationship 'payment-in-kind))))

(define consideration-for-work? (lambda (relationship)
  (has-attribute relationship 'quid-pro-quo)))

(define supervision-and-control? (lambda (relationship)
  (and (employer-controls-work? relationship)
       (supervision-exists? relationship)
       (direction-on-tasks? relationship)
       (how-when-where-controlled? relationship))))

(define employer-controls-work? (lambda (relationship)
  (has-attribute relationship 'employer-control)))

(define supervision-exists? (lambda (relationship)
  (has-attribute relationship 'supervision)))

(define direction-on-tasks? (lambda (relationship)
  (has-attribute relationship 'task-direction)))

(define how-when-where-controlled? (lambda (relationship)
  (and (has-attribute relationship 'method-controlled)
       (has-attribute relationship 'time-controlled)
       (has-attribute relationship 'place-controlled))))

(define works-for-another? (lambda (person)
  (and (has-employer? person)
       (not-self-employed? person)
       (subordinate-relationship? person))))

(define has-employer? (lambda (person)
  (has-attribute person 'employer)))

(define not-self-employed? (lambda (person)
  (not (has-attribute person 'independent-business))))

(define subordinate-relationship? (lambda (person)
  (has-attribute person 'subordination)))

(define subject-to-control? (lambda (person)
  (and (follows-instructions? person)
       (employer-directs-work? person)
       (disciplinary-authority? person)
       (limited-autonomy? person))))

(define follows-instructions? (lambda (person)
  (has-attribute person 'follows-orders)))

(define employer-directs-work? (lambda (person)
  (has-attribute person 'directed-by-employer)))

(define disciplinary-authority? (lambda (person)
  (has-attribute person 'subject-to-discipline)))

(define limited-autonomy? (lambda (person)
  (not (has-attribute person 'full-autonomy))))

(define economically-dependent? (lambda (person)
  (and (relies-on-employer-income? person)
       (not-multiple-clients? person)
       (no-independent-income-source? person)
       (employer-provides-tools? person))))

(define relies-on-employer-income? (lambda (person)
  (> (get-attribute person 'employer-income-percentage) 50)))

(define not-multiple-clients? (lambda (person)
  (< (get-attribute person 'client-count) 3)))

(define no-independent-income-source? (lambda (person)
  (not (has-attribute person 'business-income))))
;; =============================================================================
;; LRA - FUNDAMENTAL LABOUR RIGHTS DETAILED IMPLEMENTATIONS
;; =============================================================================

(define right-to-fair-labour-practices? (lambda (worker)
  (and (constitutional-right? worker)
       (decent-working-conditions? worker)
       (no-exploitation? worker)
       (fair-treatment? worker))))

(define constitutional-right? (lambda (worker)
  (has-attribute worker 's23-protection)))

(define decent-working-conditions? (lambda (worker)
  (and (safe-workplace? worker)
       (reasonable-hours? worker)
       (fair-wages? worker))))

(define no-exploitation? (lambda (worker)
  (not (has-attribute worker 'exploitation))))

(define fair-treatment? (lambda (worker)
  (and (no-discrimination? worker)
       (dignity-respected? worker)
       (procedural-fairness? worker))))

(define freedom-of-association? (lambda (worker)
  (and (join-union-freely? worker)
  (form-union-freely? worker)
       (leave-union-freely? worker)
       (no-victimization-for-membership? worker))))

(define join-union-freely? (lambda (worker)
  (not (has-attribute worker 'union-joining-prevented))))

(define form-union-freely? (lambda (worker)
  (has-attribute worker 'union-formation-right)))

(define leave-union-freely? (lambda (worker)
  (not (has-attribute worker 'forced-membership))))

(define no-victimization-for-membership? (lambda (worker)
  (not (has-attribute worker 'union-victimization))))

(define right-to-organize? (lambda (worker)
  (and (form-workers-organization? worker)
       (join-workers-organization? worker)
       (participate-in-activities? worker))))

(define form-workers-organization? (lambda (worker)
  (has-attribute worker 'organize-right)))

(define join-workers-organization? (lambda (worker)
  (has-attribute worker 'membership-right)))

(define participate-in-activities? (lambda (worker)
  (has-attribute worker 'participation-right)))

(define right-to-collective-bargaining? (lambda (worker)
  (and (engage-in-bargaining? worker)
       (represented-by-union? worker)
       (binding-agreements? worker)
       (good-faith-bargaining? worker))))

(define engage-in-bargaining? (lambda (worker)
  (has-attribute worker 'bargaining-right)))

(define represented-by-union? (lambda (worker)
  (has-attribute worker 'union-representation)))

(define binding-agreements? (lambda (worker)
  (has-attribute worker 'collective-agreement)))

(define good-faith-bargaining? (lambda (worker)
  (has-attribute worker 'good-faith)))

(define right-to-strike? (lambda (worker)
  (and (withdraw-labour? worker)
       (advance-purpose? worker)
       (protected-action? worker)
       (no-dismissal-for-strike? worker))))

(define withdraw-labour? (lambda (worker)
  (has-attribute worker 'strike-action)))

(define advance-purpose? (lambda (worker)
  (has-attribute worker 'legitimate-purpose)))

(define protected-action? (lambda (worker)
  (has-attribute worker 'protected-strike)))

(define no-dismissal-for-strike? (lambda (worker)
  (not (has-attribute worker 'dismissed-for-strike))))
;; =============================================================================
;; TRADE UNION RIGHTS DETAILED IMPLEMENTATIONS
;; =============================================================================

(define organizational-rights? (lambda (union)
  (and (access-to-workplace? union)
       (stop-order-facilities? union)
       (trade-union-representatives? union)
       (leave-for-union-activities? union))))

(define access-to-workplace? (lambda (union)
  (and (sufficient-members? union)
       (employer-allows-access? union))))

(define sufficient-members? (lambda (union)
  (or (and (has-attribute union 'members)
           (>= (get-attribute union 'member-count) 
               (* 0.5 (get-attribute union 'workforce-size))))
      (registered-union? union))))

(define employer-allows-access? (lambda (union)
  (has-attribute union 'workplace-access)))

(define stop-order-facilities? (lambda (union)
  (and (deduct-union-fees? union)
       (employer-cooperation? union))))

(define deduct-union-fees? (lambda (union)
  (has-attribute union 'fee-deduction)))

(define employer-cooperation? (lambda (union)
  (has-attribute union 'employer-cooperation)))

(define trade-union-representatives? (lambda (union)
  (and (elected-representatives? union)
       (time-off-for-duties? union)
       (protected-from-victimization? union))))

(define elected-representatives? (lambda (union)
  (has-attribute union 'elected-reps)))

(define time-off-for-duties? (lambda (union)
  (has-attribute union 'time-off-granted)))

(define protected-from-victimization? (lambda (union)
  (not (has-attribute union 'victimization))))

(define leave-for-union-activities? (lambda (union)
  (has-attribute union 'leave-granted)))

(define collective-bargaining-rights? (lambda (union)
  (and (negotiate-terms? union)
       (conclude-agreements? union)
       (enforce-agreements? union)
       (sufficient-representivity? union))))

(define negotiate-terms? (lambda (union)
  (has-attribute union 'negotiation-right)))

(define conclude-agreements? (lambda (union)
  (has-attribute union 'agreement-power)))

(define enforce-agreements? (lambda (union)
  (has-attribute union 'enforcement-power)))

(define sufficient-representivity? (lambda (union)
  (>= (get-attribute union 'representivity-percentage) 50)))

(define right-to-recruit? (lambda (union)
  (and (recruit-members? union)
       (distribute-materials? union)
       (hold-meetings? union)
       (no-employer-interference? union))))

(define recruit-members? (lambda (union)
  (has-attribute union 'recruitment-right)))

(define distribute-materials? (lambda (union)
  (has-attribute union 'distribution-right)))

(define hold-meetings? (lambda (union)
  (has-attribute union 'meeting-right)))

(define no-employer-interference? (lambda (union)
  (not (has-attribute union 'employer-interference))))
;; =============================================================================
;; STRIKES AND LOCKOUTS DETAILED IMPLEMENTATIONS
;; =============================================================================

(define relates-to-dispute-of-interest? (lambda (strike)
  (and (mutual-interest-dispute? strike)
       (not-rights-dispute? strike)
       (wages-or-conditions? strike))))

(define mutual-interest-dispute? (lambda (strike)
  (has-attribute strike 'interest-dispute)))

(define not-rights-dispute? (lambda (strike)
  (not (has-attribute strike 'rights-dispute))))

(define wages-or-conditions? (lambda (strike)
  (or (has-attribute strike 'wage-dispute)
      (has-attribute strike 'conditions-dispute))))

(define conciliation-attempted? (lambda (strike)
  (and (referred-to-conciliation? strike)
       (conciliation-process-followed? strike)
       (30-day-period-elapsed? strike))))

(define referred-to-conciliation? (lambda (strike)
  (has-attribute strike 'ccma-referral)))

(define conciliation-process-followed? (lambda (strike)
  (has-attribute strike 'conciliation-completed)))

(define 30-day-period-elapsed? (lambda (strike)
  (>= (get-attribute strike 'days-since-referral) 30)))

(define certificate-of-non-resolution? (lambda (strike)
  (and (conciliation-failed? strike)
       (certificate-issued? strike)
       (valid-certificate? strike))))

(define conciliation-failed? (lambda (strike)
  (has-attribute strike 'conciliation-unsuccessful)))

(define certificate-issued? (lambda (strike)
  (has-attribute strike 'certificate)))

(define valid-certificate? (lambda (strike)
  (has-attribute strike 'valid-cert)))

(define notice-given? (lambda (strike)
  (and (48-hour-notice? strike)
       (written-notice? strike)
       (notice-to-employer? strike)
       (notice-details-complete? strike))))

(define 48-hour-notice? (lambda (strike)
  (>= (get-attribute strike 'notice-hours) 48)))

(define written-notice? (lambda (strike)
  (has-attribute strike 'written-form)))

(define notice-to-employer? (lambda (strike)
  (has-attribute strike 'employer-notified)))

(define notice-details-complete? (lambda (strike)
  (and (has-attribute strike 'strike-date)
       (has-attribute strike 'strike-duration))))

(define procedurally-compliant? (lambda (strike)
  (and (ballot-conducted? strike)
       (majority-support? strike)
       (union-authorized? strike)
       (lawful-purpose? strike))))

(define ballot-conducted? (lambda (strike)
  (has-attribute strike 'ballot-held)))

(define majority-support? (lambda (strike)
  (> (get-attribute strike 'support-percentage) 50)))

(define union-authorized? (lambda (strike)
  (has-attribute strike 'union-authorization)))

(define lawful-purpose? (lambda (strike)
  (not (has-attribute strike 'unlawful-purpose))))

(define no-violence? (lambda (strike)
  (and (peaceful-strike? strike)
       (no-intimidation? strike)
       (no-property-damage? strike)
       (no-replacement-interference? strike))))

(define peaceful-strike? (lambda (strike)
  (not (has-attribute strike 'violence)))

(define no-intimidation? (lambda (strike)
  (not (has-attribute strike 'intimidation))))

(define no-property-damage? (lambda (strike)
  (not (has-attribute strike 'damage))))

(define no-replacement-interference? (lambda (strike)
  (not (has-attribute strike 'replacement-interference))))
;; =============================================================================
;; UNFAIR DISMISSAL DETAILED IMPLEMENTATIONS
;; =============================================================================

(define dismissal-occurred? (lambda (dismissal)
  (or (employer-terminated? dismissal)
      (constructive-dismissal? dismissal)
      (non-renewal-fixed-term? dismissal))))

(define employer-terminated? (lambda (dismissal)
  (has-attribute dismissal 'termination-by-employer)))

(define constructive-dismissal? (lambda (dismissal)
  (and (intolerable-circumstances? dismissal)
       (employee-resigned? dismissal)
       (no-option-but-resign? dismissal))))

(define intolerable-circumstances? (lambda (dismissal)
  (or (has-attribute dismissal 'harassment)
      (has-attribute dismissal 'demotion)
      (has-attribute dismissal 'hostile-environment))))

(define employee-resigned? (lambda (dismissal)
  (has-attribute dismissal 'resignation)))

(define no-option-but-resign? (lambda (dismissal)
  (has-attribute dismissal 'forced-resignation)))

(define non-renewal-fixed-term? (lambda (dismissal)
  (and (fixed-term-contract? dismissal)
       (not-renewed? dismissal)
       (legitimate-expectation-renewal? dismissal))))

(define fixed-term-contract? (lambda (dismissal)
  (has-attribute dismissal 'fixed-term)))

(define not-renewed? (lambda (dismissal)
  (has-attribute dismissal 'non-renewal)))

(define legitimate-expectation-renewal? (lambda (dismissal)
  (has-attribute dismissal 'expectation-of-renewal)))

(define no-fair-reason? (lambda (dismissal)
  (not (fair-reason-dismissal? dismissal))))

(define no-fair-procedure? (lambda (dismissal)
  (not (fair-procedure-dismissal? dismissal))))

(define misconduct? (lambda (dismissal)
  (and (employee-misconduct? dismissal)
       (serious-misconduct? dismissal)
       (intentional-wrongdoing? dismissal))))

(define employee-misconduct? (lambda (dismissal)
  (or (has-attribute dismissal 'dishonesty)
      (has-attribute dismissal 'insubordination)
      (has-attribute dismissal 'poor-performance-deliberate)
      (has-attribute dismissal 'breach-of-rules))))

(define serious-misconduct? (lambda (dismissal)
  (and (material-breach? dismissal)
       (renders-relationship-intolerable? dismissal))))

(define material-breach? (lambda (dismissal)
  (has-attribute dismissal 'serious-breach)))

(define renders-relationship-intolerable? (lambda (dismissal)
  (has-attribute dismissal 'trust-destroyed)))

(define intentional-wrongdoing? (lambda (dismissal)
  (has-attribute dismissal 'intentional)))

(define incapacity? (lambda (dismissal)
  (or (poor-work-performance? dismissal)
      (ill-health-incapacity? dismissal)
      (injury-incapacity? dismissal))))

(define poor-work-performance? (lambda (dismissal)
  (and (performance-below-standard? dismissal)
       (counselling-provided? dismissal)
       (training-provided? dismissal)
       (reasonable-time-to-improve? dismissal)
       (no-improvement? dismissal))))

(define performance-below-standard? (lambda (dismissal)
  (has-attribute dismissal 'poor-performance)))

(define counselling-provided? (lambda (dismissal)
  (has-attribute dismissal 'counselling)))

(define training-provided? (lambda (dismissal)
  (has-attribute dismissal 'training-offered)))

(define reasonable-time-to-improve? (lambda (dismissal)
  (>= (get-attribute dismissal 'improvement-period-days) 30)))

(define no-improvement? (lambda (dismissal)
  (has-attribute dismissal 'performance-unchanged)))

(define ill-health-incapacity? (lambda (dismissal)
  (and (illness-prevents-work? dismissal)
       (medical-certificate? dismissal)
       (incapacity-investigation? dismissal)
       (no-alternative-work? dismissal))))

(define illness-prevents-work? (lambda (dismissal)
  (has-attribute dismissal 'ill-health)))

(define medical-certificate? (lambda (dismissal)
  (has-attribute dismissal 'medical-cert)))

(define incapacity-investigation? (lambda (dismissal)
  (has-attribute dismissal 'investigation)))

(define no-alternative-work? (lambda (dismissal)
  (not (has-attribute dismissal 'alternative-position))))

(define injury-incapacity? (lambda (dismissal)
  (and (injury-prevents-work? dismissal)
       (permanent-incapacity? dismissal)
       (accommodation-explored? dismissal))))

(define injury-prevents-work? (lambda (dismissal)
  (has-attribute dismissal 'injury)))

(define permanent-incapacity? (lambda (dismissal)
  (has-attribute dismissal 'permanent)))

(define accommodation-explored? (lambda (dismissal)
  (has-attribute dismissal 'accommodation-considered)))

(define operational-requirements? (lambda (dismissal)
  (and (genuine-operational-need? dismissal)
       (economic-reason? dismissal)
       (structural-reason? dismissal)
       (no-alternative-to-dismissal? dismissal))))

(define genuine-operational-need? (lambda (dismissal)
  (has-attribute dismissal 'operational-need)))

(define economic-reason? (lambda (dismissal)
  (or (has-attribute dismissal 'financial-difficulties)
      (has-attribute dismissal 'business-decline))))

(define structural-reason? (lambda (dismissal)
  (or (has-attribute dismissal 'restructuring)
      (has-attribute dismissal 'technology-change))))

(define no-alternative-to-dismissal? (lambda (dismissal)
  (not (has-attribute dismissal 'alternative-available))))
;; =============================================================================
;; FAIR PROCEDURE FOR DISMISSAL DETAILED IMPLEMENTATIONS
;; =============================================================================

(define investigation-conducted? (lambda (dismissal)
  (and (preliminary-investigation? dismissal)
       (facts-gathered? dismissal)
       (evidence-collected? dismissal)
       (witnesses-interviewed? dismissal))))

(define preliminary-investigation? (lambda (dismissal)
  (has-attribute dismissal 'investigation-done)))

(define facts-gathered? (lambda (dismissal)
  (has-attribute dismissal 'facts-collected)))

(define evidence-collected? (lambda (dismissal)
  (has-attribute dismissal 'evidence)))

(define witnesses-interviewed? (lambda (dismissal)
  (has-attribute dismissal 'witness-statements)))

(define employee-notified? (lambda (dismissal)
  (and (written-notice-provided? dismissal)
       (charges-specified? dismissal)
       (hearing-date-time-place? dismissal)
       (reasonable-notice-period? dismissal))))

(define written-notice-provided? (lambda (dismissal)
  (has-attribute dismissal 'written-notice)))

(define charges-specified? (lambda (dismissal)
  (has-attribute dismissal 'charges-detailed)))

(define hearing-date-time-place? (lambda (dismissal)
  (and (has-attribute dismissal 'hearing-date)
       (has-attribute dismissal 'hearing-time)
       (has-attribute dismissal 'hearing-venue))))

(define reasonable-notice-period? (lambda (dismissal)
  (>= (get-attribute dismissal 'notice-days) 2)))

(define opportunity-to-respond? (lambda (dismissal)
  (and (employee-heard? dismissal)
       (present-case? dismissal)
       (challenge-allegations? dismissal)
       (present-mitigating-factors? dismissal))))

(define employee-heard? (lambda (dismissal)
  (has-attribute dismissal 'employee-testimony)))

(define present-case? (lambda (dismissal)
  (has-attribute dismissal 'case-presented)))

(define challenge-allegations? (lambda (dismissal)
  (has-attribute dismissal 'allegations-challenged)))

(define present-mitigating-factors? (lambda (dismissal)
  (has-attribute dismissal 'mitigation-presented)))

(define hearing-held? (lambda (dismissal)
  (and (disciplinary-hearing-conducted? dismissal)
       (fair-hearing? dismissal)
       (impartial-chairperson? dismissal)
       (evidence-considered? dismissal))))

(define disciplinary-hearing-conducted? (lambda (dismissal)
  (has-attribute dismissal 'hearing-held)))

(define fair-hearing? (lambda (dismissal)
  (and (procedurally-fair-hearing? dismissal)
       (substantively-fair-hearing? dismissal))))

(define procedurally-fair-hearing? (lambda (dismissal)
  (has-attribute dismissal 'procedural-fairness)))

(define substantively-fair-hearing? (lambda (dismissal)
  (has-attribute dismissal 'substantive-fairness)))

(define impartial-chairperson? (lambda (dismissal)
  (and (has-attribute dismissal 'chairperson)
       (not (has-attribute dismissal 'biased-chairperson)))))

(define evidence-considered? (lambda (dismissal)
  (has-attribute dismissal 'evidence-reviewed)))

(define right-to-representation? (lambda (dismissal)
  (and (representative-permitted? dismissal)
       (fellow-employee-or-union-rep? dismissal)
       (time-to-prepare? dismissal))))

(define representative-permitted? (lambda (dismissal)
  (has-attribute dismissal 'representation-allowed)))

(define fellow-employee-or-union-rep? (lambda (dismissal)
  (or (has-attribute dismissal 'fellow-employee-rep)
      (has-attribute dismissal 'union-rep))))

(define time-to-prepare? (lambda (dismissal)
  (>= (get-attribute dismissal 'preparation-days) 2)))

;; =============================================================================
;; AUTOMATICALLY UNFAIR DISMISSAL DETAILED IMPLEMENTATIONS
;; =============================================================================

(define discriminatory-dismissal? (lambda (dismissal)
  (and (based-on-prohibited-ground? dismissal)
       (unfair-discrimination? dismissal)
       (not-inherent-requirement? dismissal))))

(define based-on-prohibited-ground? (lambda (dismissal)
  (or (has-attribute dismissal 'race-based)
      (has-attribute dismissal 'gender-based)
      (has-attribute dismissal 'sex-based)
      (has-attribute dismissal 'pregnancy-based)
      (has-attribute dismissal 'marital-status-based)
      (has-attribute dismissal 'family-responsibility-based)
      (has-attribute dismissal 'ethnic-origin-based)
      (has-attribute dismissal 'sexual-orientation-based)
      (has-attribute dismissal 'age-based)
      (has-attribute dismissal 'disability-based)
      (has-attribute dismissal 'religion-based)
      (has-attribute dismissal 'hiv-status-based)
      (has-attribute dismissal 'conscience-based)
      (has-attribute dismissal 'belief-based)
      (has-attribute dismissal 'political-opinion-based)
      (has-attribute dismissal 'culture-based)
      (has-attribute dismissal 'language-based)
      (has-attribute dismissal 'birth-based))))

(define unfair-discrimination? (lambda (dismissal)
  (and (differential-treatment? dismissal)
       (no-rational-basis? dismissal))))

(define differential-treatment? (lambda (dismissal)
  (has-attribute dismissal 'different-treatment)))

(define no-rational-basis? (lambda (dismissal)
  (not (has-attribute dismissal 'rational-justification))))

(define not-inherent-requirement? (lambda (dismissal)
  (not (has-attribute dismissal 'inherent-job-requirement))))

(define pregnancy-related? (lambda (dismissal)
  (or (has-attribute dismissal 'pregnancy-dismissal)
      (has-attribute dismissal 'maternity-leave-related)
      (has-attribute dismissal 'intended-pregnancy))))

(define trade-union-participation? (lambda (dismissal)
  (and (union-activity? dismissal)
       (protected-activity? dismissal)
       (dismissal-motivated-by-union? dismissal))))

(define union-activity? (lambda (dismissal)
  (has-attribute dismissal 'union-participation)))

(define protected-activity? (lambda (dismissal)
  (has-attribute dismissal 'lawful-union-activity)))

(define dismissal-motivated-by-union? (lambda (dismissal)
  (has-attribute dismissal 'union-reason)))

(define refusing-unsafe-work? (lambda (dismissal)
  (and (work-unsafe? dismissal)
       (reasonable-refusal? dismissal)
       (ohs-act-protection? dismissal))))

(define work-unsafe? (lambda (dismissal)
  (has-attribute dismissal 'unsafe-conditions)))

(define reasonable-refusal? (lambda (dismissal)
  (has-attribute dismissal 'justified-refusal)))

(define ohs-act-protection? (lambda (dismissal)
  (has-attribute dismissal 'ohs-rights)))

(define exercising-statutory-right? (lambda (dismissal)
  (and (statutory-right-exists? dismissal)
       (exercised-right? dismissal)
       (dismissal-for-exercise? dismissal))))

(define statutory-right-exists? (lambda (dismissal)
  (has-attribute dismissal 'statutory-right)))

(define exercised-right? (lambda (dismissal)
  (has-attribute dismissal 'right-exercised)))

(define dismissal-for-exercise? (lambda (dismissal)
  (has-attribute dismissal 'dismissal-reason-statutory)))
;; =============================================================================
;; BCEA - WORKING TIME DETAILED IMPLEMENTATIONS
;; =============================================================================

(define max-45-hours-per-week? (lambda (arrangement)
  (and (weekly-hours-calculated? arrangement)
       (<= (get-attribute arrangement 'weekly-hours) 45)
       (averaged-over-4-months? arrangement))))

(define weekly-hours-calculated? (lambda (arrangement)
  (has-attribute arrangement 'weekly-hours)))

(define averaged-over-4-months? (lambda (arrangement)
  (has-attribute arrangement 'averaging-permitted)))

(define max-9-hours-per-day? (lambda (arrangement)
  (and (daily-hours-tracked? arrangement)
       (<= (get-attribute arrangement 'daily-hours) 9)
       (5-day-week-10-hour-exception? arrangement))))

(define daily-hours-tracked? (lambda (arrangement)
  (has-attribute arrangement 'daily-hours)))

(define 5-day-week-10-hour-exception? (lambda (arrangement)
  (or (<= (get-attribute arrangement 'weekly-days) 5)
      (<= (get-attribute arrangement 'daily-hours) 10))))

(define overtime-properly-compensated? (lambda (arrangement)
  (and (overtime-agreed? arrangement)
       (overtime-rate-correct? arrangement)
       (max-10-hours-overtime-weekly? arrangement)
       (time-off-or-payment? arrangement))))

(define overtime-agreed? (lambda (arrangement)
  (has-attribute arrangement 'overtime-agreement)))

(define overtime-rate-correct? (lambda (arrangement)
  (>= (get-attribute arrangement 'overtime-rate) 1.5)))

(define max-10-hours-overtime-weekly? (lambda (arrangement)
  (<= (get-attribute arrangement 'overtime-hours-weekly) 10)))

(define time-off-or-payment? (lambda (arrangement)
  (or (has-attribute arrangement 'overtime-payment)
      (has-attribute arrangement 'time-off-lieu))))

(define rest-periods-provided? (lambda (arrangement)
  (and (daily-rest-period? arrangement)
       (weekly-rest-period? arrangement)
       (meal-intervals? arrangement))))

(define daily-rest-period? (lambda (arrangement)
  (>= (get-attribute arrangement 'daily-rest-hours) 12)))

(define weekly-rest-period? (lambda (arrangement)
  (>= (get-attribute arrangement 'weekly-rest-hours) 36)))

(define meal-intervals? (lambda (arrangement)
  (and (continuous-work-less-than-5-hours? arrangement)
       (or (meal-break-provided? arrangement)
           (less-than-5-hours-work? arrangement)))))

(define continuous-work-less-than-5-hours? (lambda (arrangement)
  (< (get-attribute arrangement 'continuous-hours) 5)))

(define meal-break-provided? (lambda (arrangement)
  (has-attribute arrangement 'meal-interval)))

(define less-than-5-hours-work? (lambda (arrangement)
  (< (get-attribute arrangement 'daily-hours) 5)))

;; =============================================================================
;; BCEA - LEAVE ENTITLEMENTS DETAILED IMPLEMENTATIONS
;; =============================================================================

(define annual-leave-21-days? (lambda (employee)
  (and (annual-leave-accrued? employee)
       (>= (get-attribute employee 'annual-leave-days) 21)
       (per-12-month-cycle? employee))))

(define annual-leave-accrued? (lambda (employee)
  (has-attribute employee 'leave-accrual)))

(define per-12-month-cycle? (lambda (employee)
  (has-attribute employee '12-month-cycle)))

(define sick-leave-entitled? (lambda (employee)
  (and (sick-leave-cycle? employee)
       (medical-certificate-required? employee)
       (sick-leave-days-available? employee))))

(define sick-leave-cycle? (lambda (employee)
  (has-attribute employee 'sick-leave-cycle)))

(define medical-certificate-required? (lambda (employee)
  (or (< (get-attribute employee 'sick-days-consecutive) 2)
      (has-attribute employee 'medical-certificate))))

(define sick-leave-days-available? (lambda (employee)
  (>= (get-attribute employee 'sick-leave-days-per-cycle)
      (if (>= (get-attribute employee 'months-employed) 6)
          (* (get-attribute employee 'days-worked-weekly) 6)
          (* (get-attribute employee 'days-worked-weekly)
             (/ (get-attribute employee 'months-employed) 1))))))

(define maternity-leave-4-months? (lambda (employee)
  (and (pregnant-or-recent-birth? employee)
       (4-months-consecutive? employee)
       (at-least-2-weeks-after-birth? employee))))

(define pregnant-or-recent-birth? (lambda (employee)
  (or (has-attribute employee 'pregnant)
      (has-attribute employee 'recently-gave-birth))))

(define 4-months-consecutive? (lambda (employee)
  (>= (get-attribute employee 'maternity-leave-days) 120)))

(define at-least-2-weeks-after-birth? (lambda (employee)
  (>= (get-attribute employee 'postnatal-leave-days) 14)))

(define family-responsibility-leave? (lambda (employee)
  (and (employed-4-months-plus? employee)
       (works-4-days-weekly-plus? employee)
       (3-days-per-year? employee)
       (family-event? employee))))

(define employed-4-months-plus? (lambda (employee)
  (>= (get-attribute employee 'months-employed) 4)))

(define works-4-days-weekly-plus? (lambda (employee)
  (>= (get-attribute employee 'days-worked-weekly) 4)))

(define 3-days-per-year? (lambda (employee)
  (<= (get-attribute employee 'family-leave-days-used) 3)))

(define family-event? (lambda (employee)
  (or (has-attribute employee 'child-birth)
      (has-attribute employee 'child-illness)
      (has-attribute employee 'family-death))))

;; =============================================================================
;; BCEA - REMUNERATION DETAILED IMPLEMENTATIONS
;; =============================================================================

(define minimum-wage-paid? (lambda (payment)
  (and (national-minimum-wage? payment)
       (sectoral-minimum-wage? payment)
       (>= (get-attribute payment 'wage) 
           (get-minimum-wage payment)))))

(define national-minimum-wage? (lambda (payment)
  (has-attribute payment 'nmw-compliant)))

(define sectoral-minimum-wage? (lambda (payment)
  (or (not (has-attribute payment 'sectoral-determination))
      (has-attribute payment 'sectoral-compliant))))

(define get-minimum-wage (lambda (payment)
  (if (has-attribute payment 'sectoral-wage)
      (get-attribute payment 'sectoral-wage)
      (get-attribute payment 'national-minimum-wage))))

(define payment-in-money? (lambda (payment)
  (and (cash-or-bank-transfer? payment)
       (not-wholly-in-kind? payment)
       (deductions-lawful? payment))))

(define cash-or-bank-transfer? (lambda (payment)
  (or (has-attribute payment 'cash)
      (has-attribute payment 'bank-transfer))))

(define not-wholly-in-kind? (lambda (payment)
  (not (has-attribute payment 'wholly-in-kind))))

(define deductions-lawful? (lambda (payment)
  (or (has-attribute payment 'employee-consent)
      (has-attribute payment 'statutory-deduction)
      (has-attribute payment 'court-order))))

(define payment-not-unreasonably-delayed? (lambda (payment)
  (and (pay-day-specified? payment)
       (paid-on-time? payment)
       (no-undue-delay? payment))))

(define pay-day-specified? (lambda (payment)
  (has-attribute payment 'pay-date)))

(define paid-on-time? (lambda (payment)
  (has-attribute payment 'timely-payment)))

(define no-undue-delay? (lambda (payment)
  (< (get-attribute payment 'delay-days) 7)))

;; =============================================================================
;; BCEA - TERMINATION NOTICE PERIODS DETAILED IMPLEMENTATIONS
;; =============================================================================

(define one-week-if-less-than-6-months? (lambda (termination)
  (and (< (get-attribute termination 'months-employed) 6)
       (>= (get-attribute termination 'notice-weeks) 1))))

(define two-weeks-if-6-months-to-1-year? (lambda (termination)
  (and (>= (get-attribute termination 'months-employed) 6)
       (< (get-attribute termination 'months-employed) 12)
       (>= (get-attribute termination 'notice-weeks) 2))))

(define four-weeks-if-more-than-1-year? (lambda (termination)
  (and (>= (get-attribute termination 'months-employed) 12)
       (>= (get-attribute termination 'notice-weeks) 4))))
;; =============================================================================
;; EEA - EMPLOYMENT EQUITY ACT DETAILED IMPLEMENTATIONS
;; =============================================================================

(define based-on-listed-ground? (lambda (treatment)
  (or (race? treatment)
      (gender? treatment)
      (sex? treatment)
      (pregnancy? treatment)
      (marital-status? treatment)
      (ethnic-origin? treatment)
      (disability? treatment)
      (age? treatment)
      (religion? treatment)
      (hiv-status? treatment)
      (conscience? treatment)
      (belief? treatment)
      (political-opinion? treatment)
      (culture? treatment)
      (language? treatment)
      (birth? treatment))))

(define race? (lambda (ground)
  (has-attribute ground 'race)))

(define gender? (lambda (ground)
  (has-attribute ground 'gender)))

(define sex? (lambda (ground)
  (has-attribute ground 'sex)))

(define pregnancy? (lambda (ground)
  (has-attribute ground 'pregnancy)))

(define marital-status? (lambda (ground)
  (has-attribute ground 'marital-status)))

(define ethnic-origin? (lambda (ground)
  (has-attribute ground 'ethnicity)))

(define disability? (lambda (ground)
  (has-attribute ground 'disability)))

(define age? (lambda (ground)
  (has-attribute ground 'age)))

(define religion? (lambda (ground)
  (has-attribute ground 'religion)))

(define hiv-status? (lambda (ground)
  (has-attribute ground 'hiv)))

(define conscience? (lambda (ground)
  (has-attribute ground 'conscience)))

(define belief? (lambda (ground)
  (has-attribute ground 'belief)))

(define political-opinion? (lambda (ground)
  (has-attribute ground 'political-opinion)))

(define culture? (lambda (ground)
  (has-attribute ground 'culture)))

(define language? (lambda (ground)
  (has-attribute ground 'language)))

(define birth? (lambda (ground)
  (has-attribute ground 'birth)))

(define not-inherent-job-requirement? (lambda (treatment)
  (not (inherent-requirement-of-job? treatment))))

(define inherent-requirement-of-job? (lambda (treatment)
  (and (has-attribute treatment 'inherent-requirement)
       (genuinely-required? treatment)
       (proportionate-to-job? treatment))))

(define genuinely-required? (lambda (treatment)
  (has-attribute treatment 'genuine-necessity)))

(define proportionate-to-job? (lambda (treatment)
  (has-attribute treatment 'proportionate)))

(define designated-employer? (lambda (employer)
  (or (employs-50-or-more? employer)
      (turnover-threshold-met? employer)
      (municipality? employer)
      (organ-of-state? employer))))

(define employs-50-or-more? (lambda (employer)
  (>= (get-attribute employer 'employee-count) 50)))

(define turnover-threshold-met? (lambda (employer)
  (has-attribute employer 'turnover-threshold)))

(define municipality? (lambda (employer)
  (has-attribute employer 'municipality)))

(define organ-of-state? (lambda (employer)
  (has-attribute employer 'state-organ)))

(define employment-equity-plan? (lambda (employer)
  (and (ee-plan-exists? employer)
       (consultative-process? employer)
       (barriers-identified? employer)
       (measures-to-achieve-equity? employer)
       (numerical-goals? employer)
       (timetable? employer))))

(define ee-plan-exists? (lambda (employer)
  (has-attribute employer 'ee-plan)))

(define consultative-process? (lambda (employer)
  (has-attribute employer 'consultation)))

(define barriers-identified? (lambda (employer)
  (has-attribute employer 'barriers-analysis)))

(define measures-to-achieve-equity? (lambda (employer)
  (has-attribute employer 'equity-measures)))

(define numerical-goals? (lambda (employer)
  (has-attribute employer 'numeric-targets)))

(define timetable? (lambda (employer)
  (has-attribute employer 'implementation-timeline)))

(define reasonable-accommodation? (lambda (employer)
  (and (accommodation-provided? employer)
       (disability-accommodation? employer)
       (not-unjustifiable-hardship? employer))))

(define accommodation-provided? (lambda (employer)
  (has-attribute employer 'accommodations)))

(define disability-accommodation? (lambda (employer)
  (has-attribute employer 'disability-measures)))

(define not-unjustifiable-hardship? (lambda (employer)
  (not (has-attribute employer 'unjustifiable-hardship))))

(define report-to-labour-department? (lambda (employer)
  (and (annual-report-submitted? employer)
       (report-deadline-met? employer)
       (eea-forms-complete? employer))))

(define annual-report-submitted? (lambda (employer)
  (has-attribute employer 'annual-report)))

(define report-deadline-met? (lambda (employer)
  (has-attribute employer 'timely-submission)))

(define eea-forms-complete? (lambda (employer)
  (has-attribute employer 'eea-forms)))

;; =============================================================================
;; BARGAINING COUNCILS DETAILED IMPLEMENTATIONS
;; =============================================================================

(define registered-council? (lambda (council)
  (and (registered-with-registrar? council)
       (certificate-of-registration? council)
       (constitution-compliant? council))))

(define registered-with-registrar? (lambda (council)
  (has-attribute council 'registration)))

(define certificate-of-registration? (lambda (council)
  (has-attribute council 'certificate)))

(define constitution-compliant? (lambda (council)
  (has-attribute council 'valid-constitution)))

(define representative-parties? (lambda (council)
  (and (employer-organization-representative? council)
       (trade-union-representative? council)
       (sufficient-representivity? council))))

(define employer-organization-representative? (lambda (council)
  (has-attribute council 'employer-org)))

(define trade-union-representative? (lambda (council)
  (has-attribute council 'trade-union)))

(define collective-agreement-powers? (lambda (council)
  (and (conclude-collective-agreements? council)
       (extend-agreements? council)
       (enforce-agreements? council))))

(define conclude-collective-agreements? (lambda (council)
  (has-attribute council 'agreement-power)))

(define extend-agreements? (lambda (council)
  (has-attribute council 'extension-power)))

(define enforce-agreements? (lambda (council)
  (has-attribute council 'enforcement-power)))

(define dispute-resolution-functions? (lambda (council)
  (and (conciliation-function? council)
       (arbitration-function? council)
       (independent-body? council))))

(define conciliation-function? (lambda (council)
  (has-attribute council 'conciliation)))

(define arbitration-function? (lambda (council)
  (has-attribute council 'arbitration)))

(define independent-body? (lambda (council)
  (has-attribute council 'independence)))

;; =============================================================================
;; CCMA DETAILED IMPLEMENTATIONS
;; =============================================================================

(define unfair-dismissal-dispute? (lambda (dispute)
  (and (dismissal-dispute? dispute)
       (alleged-unfairness? dispute)
       (section-185-dispute? dispute))))

(define dismissal-dispute? (lambda (dispute)
  (has-attribute dispute 'dismissal)))

(define alleged-unfairness? (lambda (dispute)
  (has-attribute dispute 'unfairness-claim)))

(define section-185-dispute? (lambda (dispute)
  (has-attribute dispute 's185-dispute)))

(define unfair-labour-practice-dispute? (lambda (dispute)
  (and (labour-practice-dispute? dispute)
       (section-186-grounds? dispute))))

(define labour-practice-dispute? (lambda (dispute)
  (has-attribute dispute 'labour-practice)))

(define section-186-grounds? (lambda (dispute)
  (or (has-attribute dispute 'unfair-promotion)
      (has-attribute dispute 'unfair-demotion)
      (has-attribute dispute 'unfair-suspension)
      (has-attribute dispute 'unfair-training)
      (has-attribute dispute 'unfair-benefits))))

(define organizational-rights-dispute? (lambda (dispute)
  (and (rights-dispute? dispute)
       (relates-to-organizational-rights? dispute))))

(define rights-dispute? (lambda (dispute)
  (has-attribute dispute 'rights-dispute)))

(define relates-to-organizational-rights? (lambda (dispute)
  (or (has-attribute dispute 'access-dispute)
      (has-attribute dispute 'stop-order-dispute)
      (has-attribute dispute 'disclosure-dispute))))

(define referral-to-ccma? (lambda (dispute)
  (and (referral-form-submitted? dispute)
       (within-jurisdiction? dispute)
       (proper-referral? dispute))))

(define referral-form-submitted? (lambda (dispute)
  (has-attribute dispute 'referral-form)))

(define within-jurisdiction? (lambda (dispute)
  (has-attribute dispute 'ccma-jurisdiction)))

(define proper-referral? (lambda (dispute)
  (has-attribute dispute 'valid-referral)))

(define within-30-days? (lambda (dispute)
  (and (referral-date-known? dispute)
       (<= (get-attribute dispute 'days-since-event) 30))))

(define referral-date-known? (lambda (dispute)
  (has-attribute dispute 'referral-date)))

(define certificate-of-non-resolution-issued? (lambda (dispute)
  (and (certificate-exists? dispute)
       (issued-by-ccma? dispute)
       (conciliation-complete? dispute))))

(define certificate-exists? (lambda (dispute)
  (has-attribute dispute 'certificate)))

(define issued-by-ccma? (lambda (dispute)
  (has-attribute dispute 'ccma-certificate)))

(define conciliation-complete? (lambda (dispute)
  (has-attribute dispute 'conciliation-finished)))

(define within-90-days? (lambda (dispute)
  (and (certificate-date-known? dispute)
       (<= (get-attribute dispute 'days-since-certificate) 90))))

(define certificate-date-known? (lambda (dispute)
  (has-attribute dispute 'certificate-date)))

;; =============================================================================
;; RETRENCHMENT DETAILED IMPLEMENTATIONS
;; =============================================================================

(define consultation-conducted? (lambda (retrenchment)
  (and (consultation-initiated? retrenchment)
       (reasons-disclosed? retrenchment)
       (alternatives-discussed? retrenchment)
       (selection-criteria-discussed? retrenchment)
       (severance-pay-discussed? retrenchment)
       (meaningful-consultation? retrenchment))))

(define consultation-initiated? (lambda (retrenchment)
  (has-attribute retrenchment 'consultation-started)))

(define reasons-disclosed? (lambda (retrenchment)
  (has-attribute retrenchment 'reasons-given)))

(define alternatives-discussed? (lambda (retrenchment)
  (has-attribute retrenchment 'alternatives-consultation)))

(define selection-criteria-discussed? (lambda (retrenchment)
  (has-attribute retrenchment 'criteria-discussed)))

(define severance-pay-discussed? (lambda (retrenchment)
  (has-attribute retrenchment 'severance-discussion)))

(define meaningful-consultation? (lambda (retrenchment)
  (and (genuine-consultation? retrenchment)
       (sufficient-time? retrenchment)
       (good-faith? retrenchment))))

(define genuine-consultation? (lambda (retrenchment)
  (has-attribute retrenchment 'genuine)))

(define sufficient-time? (lambda (retrenchment)
  (>= (get-attribute retrenchment 'consultation-days) 14)))

(define good-faith? (lambda (retrenchment)
  (has-attribute retrenchment 'good-faith)))

(define fair-selection-criteria? (lambda (retrenchment)
  (and (objective-criteria? retrenchment)
       (non-discriminatory? retrenchment)
       (applied-consistently? retrenchment)
       (lifo-or-agreed-criteria? retrenchment))))

(define objective-criteria? (lambda (retrenchment)
  (has-attribute retrenchment 'objective-selection)))

(define non-discriminatory? (lambda (retrenchment)
  (not (has-attribute retrenchment 'discriminatory-selection))))

(define applied-consistently? (lambda (retrenchment)
  (has-attribute retrenchment 'consistent-application)))

(define lifo-or-agreed-criteria? (lambda (retrenchment)
  (or (has-attribute retrenchment 'last-in-first-out)
      (has-attribute retrenchment 'agreed-criteria))))

(define severance-pay-offered? (lambda (retrenchment)
  (and (severance-calculated? retrenchment)
       (minimum-one-week-per-year? retrenchment)
       (payment-on-termination? retrenchment))))

(define severance-calculated? (lambda (retrenchment)
  (has-attribute retrenchment 'severance-calculation)))

(define minimum-one-week-per-year? (lambda (retrenchment)
  (>= (get-attribute retrenchment 'severance-weeks)
      (get-attribute retrenchment 'years-service))))

(define payment-on-termination? (lambda (retrenchment)
  (has-attribute retrenchment 'severance-paid)))

(define alternatives-considered? (lambda (retrenchment)
  (and (explored-alternatives? retrenchment)
       (alternative-options-listed? retrenchment)
       (genuinely-explored? retrenchment))))

(define explored-alternatives? (lambda (retrenchment)
  (has-attribute retrenchment 'alternatives-explored)))

(define alternative-options-listed? (lambda (retrenchment)
  (or (has-attribute retrenchment 'voluntary-severance)
      (has-attribute retrenchment 'reduced-hours)
      (has-attribute retrenchment 'redeployment)
      (has-attribute retrenchment 'early-retirement))))

(define genuinely-explored? (lambda (retrenchment)
  (has-attribute retrenchment 'genuine-exploration)))

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

(define employer-provides-tools? (lambda (person)
  (has-attribute person 'tools-provided)))

(define safe-workplace? (lambda (worker)
  (has-attribute worker 'safe-conditions)))

(define reasonable-hours? (lambda (worker)
  (<= (get-attribute worker 'working-hours) 45)))

(define fair-wages? (lambda (worker)
  (>= (get-attribute worker 'wage) (get-attribute worker 'minimum-wage))))

(define no-discrimination? (lambda (worker)
  (not (has-attribute worker 'discrimination))))

(define dignity-respected? (lambda (worker)
  (has-attribute worker 'dignity)))

(define procedural-fairness? (lambda (worker)
  (has-attribute worker 'fair-procedure)))

(define registered-union? (lambda (union)
  (has-attribute union 'registration)))

;; =============================================================================
;; END OF SOUTH AFRICAN LABOUR LAW FRAMEWORK
;; =============================================================================
