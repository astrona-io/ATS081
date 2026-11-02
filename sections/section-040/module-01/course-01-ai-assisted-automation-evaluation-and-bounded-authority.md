---
draft: true
exam_objectives:
- AI/ML in Platform Automation
---
# AI-Assisted Automation, Evaluation And Bounded Authority

AI and machine learning can support platform tasks such as classifying support requests, finding documentation or proposing configuration. These uses have different consequence and authority. A recommendation helps a person decide, while an autonomous action changes a system. The platform should define which role a feature serves before treating every fluent output as an operational result.

A useful starting point is a bounded task. For example, an assistant can suggest the relevant supported capability from maintained documentation. Success can be evaluated by whether users find the correct path and understand its limitations. A vague goal to add AI everywhere provides no clear evidence of benefit and can increase complexity without solving a recurring problem.

Generation is not validation. A model can produce plausible YAML with unsupported fields or unsafe references. The platform's schemas, policy and permission checks should apply to generated input just as they apply to human input. A generated claim should not gain broader authority because its explanation sounds confident. The actual API and controller contracts remain the source of operational meaning.

Consider an assistant proposing a development environment. It can translate a user's need into an approved service class and lifetime. The platform API then validates the request and checks tenant permissions. If the model proposes a production identity or unsupported provider option, the server should reject it. Separating recommendation from authority prevents the language interface from becoming an unrestricted administrative shortcut.

Data access also needs a boundary. Documentation, code and logs can contain confidential information or credentials. Sending all available material to an external capability can expose data unrelated to the task. Retrieval should use approved sources and access controls, and outputs should not disclose information the user is not permitted to read. Input privacy matters as much as output presentation.

Untrusted content can influence generated behavior. A retrieved document or log line may contain instructions that should remain data rather than become a command to the assistant. Tool execution should be governed by the platform's explicit policies and scoped identities. Model output is not a reason to bypass those controls or silently broaden a requested action.

Evaluation should include realistic failures. A documentation assistant can answer an unsupported question, select an obsolete API or invent a capability. A configuration generator can omit a required field. The assessment should measure useful correctness and task completion, including how the feature communicates uncertainty. A few ideal demonstrations do not establish dependable operation across the intended population.

Machine-learning predictions have similar limits. A capacity forecast depends on data quality and changing workload behavior. An anomaly detector can produce false positives or miss a new pattern. Its result can inform an investigation, but it should not automatically become proof of an incident or a reason for unrestricted remediation. Feedback from outcomes helps determine whether the model remains useful.

Adoption should match consequence. Low-impact guidance can have a different review and fallback contract from destructive infrastructure changes. Users need to understand when an output is a suggestion and when an approved action actually occurred. Status should connect actions to validated requests and observed outcomes rather than only the model's text.

The platform owns the feature as a service. It needs version awareness, monitoring, support and a way to continue useful work when the AI capability is unavailable or wrong. Students should assess a bounded capability through data, authority and outcome evidence rather than treating AI as either a universal solution or an inherently authoritative operator.

## Common pitfalls

> [!WARNING]
> Fluent generation is not validated intent or permission. Keep data access and tool authority bounded, including untrusted retrieved content. Evaluate realistic failures and provide clear uncertainty and fallback behavior for the consequence of the task.
