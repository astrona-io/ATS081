# IDPs and Developer Experience (ATS081)

Certified Cloud Native Platform Engineering Associate (CNPA): IDPs and Developer Experience, worth 8% of the official curriculum. This course belongs to ATP016.

Concept lessons explain each official objective through mechanisms, responsible components, examples and limits. Every module has a playground (a clean kind cluster to explore), a graded lab and a summary. Every section ends with a capstone lab and a knowledge check. A final knowledge check closes the course.

## Course Outline

| Section | Objective | Modules | Features used in the labs |
| --- | --- | --- | --- |
| 010 | Simplified Access to Platform Capabilities | 2 + capstone | CustomResourceDefinition, ResourceQuota, LimitRange, ValidatingAdmissionPolicy, RBAC |
| 020 | API-Driven Service Catalogs | 2 + capstone | CustomResourceDefinition, CEL validation, labels, kubectl and jq queries |
| 030 | Developer Portals for Platform Adoption | 2 + capstone | ConfigMap-driven portal, templates, catalog data |
| 040 | AI/ML in Platform Automation | 2 + capstone | RBAC, ValidatingAdmissionPolicy, audit records |

See [the curriculum map](CURRICULUM.md) for module outcomes. The manifest `astrona.yaml` registers readings, labs and quizzes in teaching order. See also [primary sources](SOURCES.md) and [contribution instructions](CONTRIBUTING.md).

## Authoring Status

Readings are drafts for review. The playgrounds and labs are built untested: only static checks were run (`astrona validate -c`, `bash -n`, YAML parsing). Every lab README says UNTESTED. Technical sections and the ATP016 registration remain draft until the maintainer approves publication.

The folders `assessments/` and `schemas/` hold the earlier question banks. They are not registered in `astrona.yaml`; the quizzes are `sections/section-0X0/quiz.yaml` and `sections/final-domain-quiz.yaml`.

## Run A Lab

```sh
astrona run -c sections/section-010/module-01/labs/lab-01
astrona submit -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-081-lab-010-01
```

Playgrounds are started the same way with `astrona run -c <playground dir>`.
