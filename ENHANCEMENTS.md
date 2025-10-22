# ChainLex Framework Enhancements

**Version:** 2.1  
**Date:** October 23, 2025  
**Status:** Enhanced with Module Structure and Cross-References

## Overview

This document describes the enhancements made to the ChainLex legal framework to improve its structure, usability, and integration capabilities.

## Key Enhancements

### 1. Module System Support

All Scheme files now include commented module definitions compatible with Guile Scheme's module system. This allows for:

- **Namespace isolation:** Each legal domain has its own namespace
- **Explicit imports:** Clear dependencies between modules
- **Selective exports:** Only public functions are exported
- **Better organization:** Hierarchical module structure

**Example:**
```scheme
(define-module (civ za south-african-civil-law)
  #:use-module (lv1 known-laws)
  #:use-module (srfi srfi-1)
  #:export (contract-valid? delict-established? ...))
```

### 2. Framework Metadata

Each jurisdiction-specific framework now includes structured metadata:

```scheme
(define framework-metadata
  (list
   (cons 'name "South African Civil Law")
   (cons 'jurisdiction "ZA")
   (cons 'legal-domain '(civil contract delict property))
   (cons 'version "2.1")
   (cons 'last-updated "2025-10-23")
   (cons 'derived-from-level 1)
   (cons 'confidence-base 0.95)
   (cons 'language "en")))
```

This metadata enables:
- Automated framework discovery
- Version tracking
- Jurisdiction identification
- Confidence level management

### 3. Cross-References to Level 1 Principles

All jurisdiction-specific rules now include explicit cross-references to the Level 1 first-order principles from which they are derived.

**Example:**
```scheme
(define (contract-valid? contract)
  "Determine if a contract is valid under South African law
   Cross-reference: pacta-sunt-servanda, consensus-ad-idem (Level 1)"
  ...)
```

**Benefits:**
- Traceability of legal reasoning
- Clear inference chains
- Support for explanation generation
- Validation of derived rules

### 4. Enhanced Documentation

All functions now include:
- Docstrings explaining their purpose
- Parameter descriptions
- Return value specifications
- Cross-references to related principles
- Usage examples where applicable

### 5. Improved Helper Functions

Standardized helper functions across all frameworks:

```scheme
(define (has-attribute entity attr)
  "Check if an entity has a specific attribute"
  (cond
    ((hash-table? entity) (hash-has-key? entity attr))
    ((list? entity) (assoc attr entity))
    (else #f)))

(define (get-attribute entity attr)
  "Get an attribute value from an entity"
  ...)
```

These functions work with both hash tables and association lists, providing flexibility in data representation.

## Framework Structure

### Level 1: First-Order Principles (`lv1/known_laws.scm`)

The foundational layer containing 60+ universally recognized legal maxims:

- **Contract Principles:** pacta-sunt-servanda, consensus-ad-idem, consideration-exists
- **Property Principles:** nemo-plus-iuris, nemo-dat-quod-non-habet, res-nullius
- **Procedural Justice:** audi-alteram-partem, nemo-iudex-in-causa-sua
- **Criminal Law:** nullum-crimen-sine-lege, actus-non-facit-reum-nisi-mens-sit-rea
- **Constitutional:** supremacy-of-constitution, rule-of-law, ubuntu
- **And 50+ more fundamental principles**

**Enhancements:**
- Principle constructor with metadata support
- Registry system for principle lookup
- Inference chain building
- Confidence computation for derived principles

### Level 2+: Jurisdiction-Specific Frameworks

Each framework derives from Level 1 principles through logical inference:

| Framework | File | Lines | Key Principles |
|:----------|:-----|------:|:---------------|
| Administrative Law | `adm/za/south_african_administrative_law.scm` | 911 | audi-alteram-partem, procedural-fairness, rationality |
| Civil Law | `civ/za/south_african_civil_law.scm` | 1,489 | pacta-sunt-servanda, damnum-injuria-datum, culpa |
| Construction Law | `cst/za/south_african_construction_law.scm` | 1,587 | pacta-sunt-servanda, bona-fides |
| Criminal Law | `cri/za/south_african_criminal_law.scm` | 1,335 | nullum-crimen-sine-lege, actus-non-facit-reum |
| Environmental Law | `env/za/south_african_environmental_law.scm` | 1,409 | proportionality, subsidiarity |
| International Law | `int/za/south_african_international_law.scm` | 1,577 | jus-cogens, pacta-sunt-servanda |
| Labour Law | `lab/za/south_african_labour_law.scm` | 1,553 | audi-alteram-partem, ubuntu |

## Usage Examples

### 1. Using the Module System (Guile Scheme)

```scheme
;; Load the Level 1 principles
(use-modules (lv1 known-laws))

;; Load a jurisdiction-specific framework
(use-modules (civ za south-african-civil-law))

;; Check if a contract is valid
(define my-contract 
  (list (cons 'offer #t)
        (cons 'acceptance #t)
        (cons 'consideration #t)
        (cons 'intention-to-be-bound #t)
        (cons 'party-a-capacity #t)
        (cons 'party-b-capacity #t)))

(contract-valid? my-contract)  ;; Returns #t
```

### 2. Querying Level 1 Principles

```scheme
;; Initialize the principle registry
(initialize-principle-registry!)

;; Get all contract law principles
(get-principles-by-domain 'contract)

;; Get a specific principle
(get-principle-from-registry 'pacta-sunt-servanda)

;; Find related principles
(find-related-principles pacta-sunt-servanda)
```

### 3. Building Inference Chains

```scheme
;; Build an inference chain between two principles
(build-inference-chain pacta-sunt-servanda 
                      exceptio-non-adimpleti-contractus)

;; Compute confidence for a derived rule
(compute-derived-confidence 
  (list pacta-sunt-servanda consensus-ad-idem)
  'deductive)  ;; Returns 0.95 (high confidence for deductive inference)
```

## Integration with HypergraphQL

The enhanced frameworks are designed for seamless integration with the HypergraphQL engine:

1. **Automatic Loading:** The engine can automatically discover and load all frameworks
2. **Graph Traversal:** Principles and rules form nodes in a hypergraph
3. **Pattern Matching:** Query legal concepts and their relationships
4. **Inference Chains:** Trace reasoning from Level 1 principles to specific rules

**Example HypergraphQL Integration:**
```python
from hypergraphql import LegalHypergraph

# Create hypergraph and load frameworks
graph = LegalHypergraph()
graph.load_legal_frameworks("/path/to/chainlex")

# Query for contract-related principles
results = graph.query(domain='contract', confidence_min=0.9)

# Find inference path
path = graph.find_path('pacta-sunt-servanda', 'contract-valid')
```

## Best Practices for Extension

### Adding a New Jurisdiction

1. Create directory structure: `{domain}/{country-code}/`
2. Copy `ENHANCED_HEADER_TEMPLATE.scm` as starting point
3. Define framework metadata with appropriate jurisdiction code
4. Implement jurisdiction-specific rules
5. Add cross-references to Level 1 principles
6. Document derivations and inference types

### Adding a New Legal Domain

1. Identify relevant Level 1 principles
2. Create domain directory: `{domain-code}/`
3. Define core concepts and rules
4. Specify confidence levels for derived rules
5. Add to `DOMAIN_PRINCIPLES` mapping
6. Update documentation

### Implementing Placeholder Functions

Many functions are currently placeholders. To implement them:

1. Identify the function's purpose from its docstring
2. Determine which Level 1 principles apply
3. Implement the logic using those principles
4. Add appropriate confidence calculations
5. Include cross-references in comments
6. Write test cases

**Example:**
```scheme
;; Before (placeholder)
(define (offer-revoked? offer)
  (has-attribute offer 'revocation-notice))

;; After (implemented)
(define (offer-revoked? offer)
  "Check if an offer has been revoked
   An offer is revoked if:
   - Revocation notice was communicated before acceptance
   - Counter-offer was made (destroys original offer)
   - Lapse of time specified in offer
   Cross-reference: consensus-ad-idem (Level 1)"
  (or (and (has-attribute offer 'revocation-notice)
           (revocation-communicated-before-acceptance? offer))
      (has-attribute offer 'counter-offer)
      (offer-lapsed? offer)))
```

## Testing

### Unit Tests

Each framework should have corresponding unit tests:

```scheme
;; test-civil-law.scm
(use-modules (civ za south-african-civil-law))
(use-modules (srfi srfi-64))  ;; Testing framework

(test-begin "contract-law")

(test-assert "valid contract"
  (contract-valid? 
    (list (cons 'offer #t)
          (cons 'acceptance #t)
          (cons 'consideration #t)
          (cons 'intention-to-be-bound #t)
          (cons 'party-a-capacity #t)
          (cons 'party-b-capacity #t))))

(test-assert "invalid contract without offer"
  (not (contract-valid? 
         (list (cons 'acceptance #t)
               (cons 'consideration #t)))))

(test-end "contract-law")
```

### Integration Tests

Test the interaction between frameworks and Level 1 principles:

```python
# test_legal_frameworks.py
def test_principle_application():
    """Test that Level 1 principles apply correctly to jurisdiction rules"""
    principle = get_principle_from_registry('pacta-sunt-servanda')
    context = {'legal-domain': 'contract', 'fact-pattern': {...}}
    assert principle_applies?(principle, context)
```

## Future Enhancements

### Short-term
- [ ] Complete implementation of placeholder functions
- [ ] Add more comprehensive test coverage
- [ ] Create visualization tools for inference chains
- [ ] Add natural language query interface

### Medium-term
- [ ] Integrate with machine learning models
- [ ] Add case law citation support
- [ ] Implement statutory interpretation algorithms
- [ ] Create web-based query interface

### Long-term
- [ ] Expand to other jurisdictions (UK, US, EU)
- [ ] Add multilingual support
- [ ] Implement automated legal reasoning engine
- [ ] Create legal education platform

## Contributing

When contributing to the ChainLex framework:

1. Follow the established module structure
2. Include framework metadata in new files
3. Add cross-references to Level 1 principles
4. Write comprehensive docstrings
5. Include test cases
6. Update this documentation

## License

See LICENSE file in the repository root.

## References

- [ChainLex Repository](https://github.com/cogpy/chainlex)
- [Guile Scheme Manual](https://www.gnu.org/software/guile/manual/)
- [SRFI Standards](https://srfi.schemers.org/)
- [HypergraphQL Documentation](../models/ggmlex/hypergraphql/)

