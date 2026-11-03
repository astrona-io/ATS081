---
draft: true
exam_objectives:
  - Developer Portals for Platform Adoption
---
# Section 030: Developer Portals for Platform Adoption

This section teaches you to separate a developer portal from the platform behind it. You run a small portal on Kubernetes, build a golden-path template, and measure adoption and the freshness of the data the portal shows.

**Exam objective covered:** Developer Portals for Platform Adoption

---

## What You Will Master

- Explain what a portal shows and what it must not own.
- Refresh the service list that a portal serves from a ConfigMap and confirm that the running pods see the change.
- Write a golden-path template with placeholders, render it and apply the result.
- State what a golden path promises: owner label, catalog link, readiness probe and memory limit.
- Compute adoption coverage and detect stale portal data.

---

## The Learning Path

### 1. Developer Portals, Golden Paths And Supported Adoption
*   **Module Reader:** **[Module 1: Developer Portals, Golden Paths And Supported Adoption](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-030/module-01/playground` - kind cluster. The namespace `portal` runs a portal that serves a service list, with a template that has gaps.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-01/playground
    ```
*   **Lab:** Refresh The Portal Service List - `sections/section-030/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. Software Templates In Depth
*   **Module Reader:** **[Module 2: Software Templates In Depth](./module-02/course.md)**
*   **Hands-on Playground:** `sections/section-030/module-02/playground` - kind cluster with the a template stored as text in a ConfigMap.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-02/playground
    ```
*   **Lab:** Complete The Starfleet Service Template Lab - `sections/section-030/module-02/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-02/labs/lab-01
    astrona submit -c .
    ```
*   **Module quiz:** 10 questions in `sections/section-030/module-02/quiz.yaml`.

### Section Capstone Challenge
*   **Comprehensive Challenge:** Golden Path And Portal Capstone - `sections/section-030/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Fix the golden-path template, render it for the service `beacon`, update the portal list with real owners and a current date, and record an `adoption-report` with the totals and the coverage. The grader checks live cluster state.

### Knowledge Check
*   **Quiz:** 11 questions in `sections/section-030/quiz.yaml`. The pass score is 70 percent.
