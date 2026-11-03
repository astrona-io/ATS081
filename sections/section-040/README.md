---
draft: true
exam_objectives:
  - AI/ML in Platform Automation
---
# Section 040: AI/ML in Platform Automation

This section teaches you to place an AI assistant in platform automation without giving it authority it should not have. You limit an assistant identity to reading and proposing with RBAC and an admission policy, route proposals through a reviewer and evaluate the proposals with an acceptance rate.

**Exam objective covered:** AI/ML in Platform Automation

---

## What You Will Master

- Decide which platform tasks suit an assistant and which need tested automation.
- Explain why an assistant must be bounded by its identity and not by its instructions.
- Replace a broad role binding with a read-only Role and a propose-only Role.
- Force the status `proposed` on assistant proposals with a ValidatingAdmissionPolicy that reads `request.userInfo`.
- Compute an acceptance rate from reviewed proposals and decide the assistant mode.

---

## The Learning Path

### 1. AI-Assisted Automation, Bounded Authority And Evaluation
*   **Module Reader:** **[Module 1: AI-Assisted Automation, Bounded Authority And Evaluation](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-040/module-01/playground` - kind cluster. The namespace `assistant` holds the ServiceAccount `ops-assistant` with no permissions.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-01/playground
    ```
*   **Lab:** Bound The Ops Assistant - `sections/section-040/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. Platform Capabilities For Machine Learning Workloads
*   **Module Reader:** **[Module 2: Platform Capabilities For Machine Learning Workloads](./module-02/course.md)**
*   **Hands-on Playground:** `sections/section-040/module-02/playground` - kind cluster with the namespace `ml-team` with a suspended training Job.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-02/playground
    ```
*   **Lab:** Limit GPUs And Clean Up Training Jobs Lab - `sections/section-040/module-02/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/module-02/labs/lab-01
    astrona submit -c .
    ```
*   **Module quiz:** 10 questions in `sections/section-040/module-02/quiz.yaml`.

### Section Capstone Challenge
*   **Comprehensive Challenge:** Assistant Evaluation Capstone - `sections/section-040/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-040/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Bound an over-privileged assistant, give the user `platform-reviewer` the right to update proposals, and record an `assistant-evaluation` whose counts, acceptance rate and mode match the twelve seeded proposals. The grader checks live cluster state and uses impersonation.

### Knowledge Check
*   **Quiz:** 11 questions in `sections/section-040/quiz.yaml`. The pass score is 70 percent.
