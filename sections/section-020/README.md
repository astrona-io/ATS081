---
draft: true
exam_objectives:
  - API-Driven Service Catalogs
---
# Section 020: API-Driven Service Catalogs

This section teaches you to keep a service catalog behind an API. You model entities, owners and relationships, store them as `CatalogEntity` objects with validation rules, and find stale, ownerless and dangling entries with `jq`.

**Exam objective covered:** API-Driven Service Catalogs

---

## What You Will Master

- Distinguish a catalog entity from its deployment and name the kinds of entity.
- Map a descriptor file to owners, lifecycle and relationships.
- Define a catalog kind in Kubernetes with a schema and validation rules.
- Find dangling references, placeholder owners and stale review dates with `jq`.
- Link catalog entries to running workloads with labels and report on catalog health.

---

## The Learning Path

### 1. The Catalog Model, The Catalog As An API And Keeping It Useful
*   **Module Reader:** **[Module 1: The Catalog Model, The Catalog As An API And Keeping It Useful](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-020/module-01/playground` - kind cluster. The namespace `catalog` holds an incomplete Starfleet catalog.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-01/playground
    ```
*   **Lab:** Complete The Starfleet Catalog - `sections/section-020/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/module-01/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Catalog Health Capstone - `sections/section-020/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-020/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Make the catalog of the `starfleet` fleet healthy before the quarterly review: refresh a stale review date, replace a placeholder owner, register a missing dependency and a new component, label the Deployments and record a `catalog-report` that matches the catalog.

### Knowledge Check
*   **Quiz:** 11 questions in `sections/section-020/quiz.yaml`. The pass score is 70 percent.
