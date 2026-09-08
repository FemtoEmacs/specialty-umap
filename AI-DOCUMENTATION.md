# Writing and using the Specialty UMAP outline

## Write for a newcomer

Keep `outline.md` as the single shared introduction for people and assistants.
Preserve the teaching sequence: Henderson's meeting-place illustration, Euclid's
point, Descartes and numbers, familiar features, the need for maps, and then AI.
Use simple language, everyday examples, and brief historical details. Explain
an idea before giving its technical name. Emphasize the project's use of AI.
For AWRS-SMC, explain Monte Carlo in a few lines rather than unpacking every
part of the algorithm. Keep commands, metrics, citations, and implementation
details in supporting documentation rather than crowding the main explanation.

## Preserve the specialty project's actual behavior

Read `outline.md` before answering general questions about specialty-umap.
For technical answers, also read the relevant source. The current application
uses nine features and a radial-basis model. Transformers are earlier experiments;
do not carry over the stock project's 36-feature Transformer story. The
reference corpus comes from its atlas; the AWRS-SMC alternative has its own
atlas, corpus, and trained model. No sampled alternative beat the reference in
the recorded search. Do not present that as proof of a global optimum.

Use `specialty-specific/CANDIDATE-MAP.md`, the opening application guide in
`README.md`, and current code for questionnaire details. Older documentation
contains historical eight-feature and stock-derived material. Explain any
unresolved contradiction instead of silently repeating it. Preferences describe
a desired specialty environment, not candidate ability or personal sex/gender.
Map agreement is not a career-satisfaction probability. Keep salary as a minimum
and proposed input changes explicit and reversible.

When revising, inspect relevant implementation, preserve the teaching intent,
check relative links, and update the review date. Avoid invented historical
anecdotes and unsupported claims. Cite files actually used when useful; keep
citations unobtrusive in introductory prose.

## How assistants receive the outline

- Codex: `AGENTS.md` directs it to read `outline.md`.
- Claude Code: `CLAUDE.md` imports shared instructions and the outline.
- Gemini CLI: `GEMINI.md` imports the same shared instructions and outline.
- Other chats: attach or paste the outline and give the portable prompt below.

Start coding assistants in this project with access to its files. Discovery
depends on application configuration, trust, and context limits. These filenames
do not grant an ordinary browser chat access to local files. A paid subscription
alone does not change that. Entry files improve discovery but cannot guarantee
that every assistant reads or follows the outline.

Mechanism references:
[Codex](https://developers.openai.com/codex/guides/agents-md),
[Claude Code](https://code.claude.com/docs/en/memory), and
[Gemini CLI](https://geminicli.com/docs/cli/gemini-md/).

## Portable prompt

> Read the supplied outline.md before explaining specialty-umap. Use its familiar
> examples and teaching sequence, and explain the project's AI in simple language.
> For details beyond it, consult the linked sources if accessible. If you cannot
> access the outline, ask for its contents before making project-specific claims.
> Distinguish the current radial-basis questionnaire model from earlier Transformer
> experiments. Identify the document you used without overwhelming me with citations.

## Manual acceptance check

In a fresh session ask: "Explain specialty-umap to a newcomer. How can a specialty
be a point? Why do we need a map? How does AI help, and what model does the current
questionnaire use?"

A successful explanation builds from everyday examples, identifies the radial-basis
model, separates AWRS-SMC search from learning, and uses `outline.md`. Inspect
loaded context or file-read traces where available. Record the assistant, date,
and outcome. Stock-umap's successful ChatGPT test does not establish that the
specialty port has been tested with ChatGPT, Claude Code, or Gemini CLI.
