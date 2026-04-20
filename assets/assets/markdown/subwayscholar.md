# SubwayScholar

## Brief

SubwayScholar converts a research paper PDF into a short narrated MP4 video with gameplay footage in the background —
think Subway Surfers-style content for academic papers. The project was built as an exercise in agentic AI development.

- **Project Type**: Solo
- **Skills**: `Python`, `Agentic AI`, `LLM Prompting`, `Text-to-Speech`, `Video Editing`, `Modular Architecture`

#### [Repo Link](https://github.com/mwinter02/SubwayScholar)

## Overview

The idea is simple: take a dense research paper and transform it into short-form video content — narrated summary
overlaid on Subway Surfers-style background footage. The real challenge was less about the end product and more about
*how* it was built.

SubwayScholar was developed as a deliberate experiment in agentic AI-driven development. The architecture, requirements,
and implementation prompts were all brainstormed with ChatGPT, then handed off to Codex for end-to-end implementation.
No manual coding was required during the build. The entire project took roughly 3 hours, most of which was spent
brainstorming and waiting for Codex to finish — not debugging.

Using the [ReSTIR GI](https://research.nvidia.com/publication/2021-06_restir-gi-path-resampling-real-time-path-tracing)
paper as a test case, here is an [example video output](https://drive.google.com/file/d/1EgaTgdD6D-JXlal6tSBxRBzTg8nun0Sm/view?usp=sharing).

---

## How It Works

The pipeline is split into four independent modules, each with a clear API contract:

1. **PDF Module** — Extracts text and images from the input PDF
2. **LLM Module** — Generates a narration script from the extracted content
3. **TTS Module** — Converts the script to speech using a Piper voice model
4. **Video Module** — Composites the audio, background footage, and PDF images into a final MP4

Each module is independently testable via `test.py`, which makes debugging and iteration fast without running the full
pipeline every time.

### Script Generation Modes

The LLM step supports two modes:

**Manual mode (default)** — No API key required. The app copies the prompt and parsed PDF text to the clipboard, you
paste it into any LLM of your choice, then paste the result back into the terminal.

**OpenAI API mode** — Requires an `OPENAI_API_KEY`. The script is generated automatically end-to-end with no manual
steps.

```bash
# Manual mode
python main.py assets/example.pdf

# API mode
python main.py assets/example.pdf --use-openai-api
```

---

## How It Was Built

The key insight behind this project was that agentic AI works best when given a clean, modular structure with clear
boundaries. Before a single line of code was written, the architecture was fully mapped out: module boundaries, data
formats passed between them, and the expected behavior of each component.

This upfront structure was the main reason Codex could implement the project without intervention. Each prompt given
to Codex covered exactly one focused module, which kept context windows small and well-defined. Because the interface
between modules was specified up front, there was nothing to ambiguously infer — Codex just had to implement what was
described.

Key success factors:
- **Modular architecture** — Clean separation of concerns meant each step could be built and tested in isolation
- **Clear API contracts** — Explicit data formats between modules eliminated ambiguity
- **Strong upfront structure** — The architecture was fully defined before implementation began
- **Focused context windows** — Each Codex prompt covered exactly one module

The result was a fully functional project with zero debugging or manual code intervention. This is a strong argument
for investing in design before reaching for code generation tools.

---

## Future Extensions

### Semantic image alignment per sentence

The current pipeline shows extracted PDF figures in simple sequence. A high-impact improvement would be aligning
on-screen visuals with the narration sentence being spoken at any given moment.

The concept:
1. Split the generated script into sentence-level segments with timestamps
2. Build semantic embeddings for each sentence and each available visual (PDF figures, external images, etc.)
3. Match each sentence to the most visually relevant candidate using embedding similarity
4. Render the timeline so visuals change exactly when sentence topics change

This would produce stronger narrative coherence, better educational clarity, and higher viewer retention — at the cost
of significantly higher compute, additional generation latency, and a more complex retrieval pipeline.

---

## Conclusion

SubwayScholar was less about the video output and more about proving a point: with the right structure, an agentic AI
can build a non-trivial project end-to-end without intervention. The biggest takeaway was that the quality of the
architecture defined up front directly determined how well Codex could execute. Clear module boundaries and explicit
contracts made the difference between a smooth build and a debugging nightmare.

This project reinforced how powerful agentic AI becomes when paired with strong software engineering fundamentals — and
how quickly it falls apart without them.

