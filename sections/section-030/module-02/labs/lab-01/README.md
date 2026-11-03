---
estimated_duration: 25m
---

# Lab: Complete The Starfleet Service Template Lab

Graded lab. **Status: UNTESTED.** It was built and checked statically only. The task is in `question.md`; the walkthrough is in `solution.md`.

Complete a Scaffolder template that is stored as text in a ConfigMap: required parameters, a name pattern, publish and register steps and an output link.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS081.git -c sections/section-030/module-02/labs/lab-01
astrona destroy ats-081-lab-030-02-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-required.sh` | The parameters name and owner are in a required list |
| `validate-pattern.sh` | The parameter name has a pattern |
| `validate-publish.sh` | The template has a step with the action publish:github |
| `validate-register.sh` | The catalog:register step comes after the publish:github step |
| `validate-output-link.sh` | The output has a link with an entityRef |
