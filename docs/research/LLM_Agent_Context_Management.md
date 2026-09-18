# **The Architecture and Economics of LLM Agent Context Management: A Comprehensive Lifecycle Analysis**

## **The Context Lifecycle Problem in Long-Horizon Automation**

Large Language Models (LLMs) deployed as autonomous coding agents operate under a fundamental paradox: while modern transformer architectures support nominal context windows exceeding 200,000 tokens, fully utilizing these windows systematically degrades reasoning quality, inflates inference latency, and accelerates computational costs. The context window is not an infinite workspace; it is a strictly constrained "attention budget" that dictates the economic and cognitive viability of the agent1. As an agent progresses through a long-horizon software engineering workflow—iterating over terminal commands, navigating repositories, and debugging code—its interaction history accumulates linearly. This uncontrolled accumulation induces a complex trade-off between retaining past environmental feedback and staying within an effective processing envelope3.

This accumulation triggers severe cognitive degradation within the model. The most prominent failure mode is the "lost in the middle" phenomenon, where transformer-based architectures fail to robustly access relevant information buried in the center of long input sequences. LLMs exhibit a distinctive U-shaped performance curve heavily skewed toward primacy and recency biases; performance is highest when relevant information occurs at the beginning or end of the input, but significantly degrades when the model must synthesize data from the middle of extensive histories5. As context balloons, the model’s ability to capture accurate pairwise token relationships deteriorates, increasing unreliability and leading the model to make premature assumptions or hallucinate solutions1.

Furthermore, simply feeding a model its own extensive interaction history introduces a psychological failure mode termed "contextual drag." When an agent attempts to debug an error by reflecting on its previous failed attempts, the presence of the erroneous reasoning in the context structurally biases the subsequent generation. The model's attention mechanism anchors to the flawed logic, causing new reasoning trajectories to inherit structurally similar error patterns. This effectively neutralizes self-correction mechanisms and frequently causes the agent to collapse into spirals of self-deterioration10.

Addressing these intersecting challenges requires a complete departure from monolithic prompt engineering toward rigorous "context lifecycle management." The problem must be decomposed into a sequential pipeline determining what information enters the model initially, what remains cached during iterative loops, what must be dynamically compressed out of the working window, what is persisted externally for later retrieval, and when the active context must be completely rebuilt to clear cognitive pollution3.

## **Ingestion and Selection: Curating the Initial Context State**

The initial phase of context management governs the precise injection of task states, environmental constraints, and repository data. Rather than loading entire knowledge corpora into the prompt, state-of-the-art agent architectures employ selective, programmatic ingestion strategies to maximize information density while minimizing token consumption.

### **Structural Codebase Indexing Over Semantic Search**

Traditional Retrieval-Augmented Generation (RAG) relies on semantic vector embeddings, which match natural language queries to text chunks. However, semantic search performs poorly on source code because it ignores the strict syntactic hierarchies, structural dependencies, and execution relationships inherent in software engineering16. To optimize what enters the model, systems like Aider replace standard semantic search with structural Abstract Syntax Tree (AST) parsing16.

By processing the entire repository using tools like Tree-sitter, the agent infrastructure extracts function definitions, class signatures, and variable declarations directly from the syntax tree. Instead of sending raw code chunks, the system constructs a dependency graph mapping how files reference each other's symbols16. A graph ranking algorithm—specifically PageRank, analogous to early web search routing—is then applied to this dependency network to identify the most heavily referenced, globally important symbols16. The resulting "Repo Map" compresses the structural reality of the codebase into a dense, token-efficient summary that gives the LLM ambient awareness of API surfaces and project architecture without requiring the full text of any single file. This map dynamically adjusts its size, typically optimizing to fit within a strict default budget of 1,024 tokens16.

&nbsp;

| Indexing Methodology | Mechanism | Context Footprint | Efficacy for Coding Agents |
| :---- | :---- | :---- | :---- |
| **Vector Embeddings (Standard RAG)** | Semantic similarity matching | High (retrieves raw text blocks) | Low (ignores syntactic hierarchies)19. |
| **Grep / Keyword Search** | Exact string matching | Variable (often retrieves irrelevant logs) | Low (lacks architectural awareness)19. |
| **Tree-sitter Repo Mapping** | AST parsing \+ PageRank dependency graphing | Minimal (configurable, default 1K tokens) | High (provides global architectural context)16. |

### **Dynamic Tool Masking vs. Context Modification**

In multi-step execution environments, an agent may theoretically require access to dozens of distinct tools ranging from file editors to web browsers. A naive context management approach dynamically modifies the system prompt to add or remove tool schemas based on the current task phase. However, dynamic modification alters the prompt prefix, instantly invalidating the Key-Value (KV) cache and forcing the model to recompute the entire attention matrix, drastically increasing inference costs2.

To control the action space without breaking the cache, production systems like Manus employ context-aware state machines coupled with inference-time logit masking. The system prompt stably declares all possible tools for the entire session. When the agent transitions to a state where certain tools are prohibited—such as preventing code editing during a read-only exploration phase—the orchestration layer masks the logit probabilities of the tokens corresponding to those tool triggers during the autoregressive decoding phase2. By designing tool names with consistent prefixes, the orchestrator can efficiently enforce tool group constraints through logit masking25. This ensures that the model cannot physically output an unauthorized tool invocation, maintaining perfect prompt prefix stability while strictly controlling the action space without relying on prompt mutation25.

### **Agentic Context Engineering (ACE)**

The instructions and operational guidelines that enter the model are further optimized through Agentic Context Engineering (ACE). ACE shifts the paradigm from static system prompts to dynamic, itemized "playbooks." Continually rewriting a single, monolithic prompt based on execution feedback often leads to "brevity bias" and "context collapse," where critical domain insights, nuanced failure patterns, and edge-case handling instructions are gradually erased by the model's recursive summarization28.

ACE mitigates context collapse by maintaining the context as a structured list of discrete knowledge units. The architecture utilizes a modular pipeline comprising a Generator, a Reflector, and a Curator. As the agent executes tasks, the Reflector analyzes the trajectory alongside execution feedback, diagnosing errors and identifying successful strategies. Crucially, rather than prompting the LLM to rewrite the entire prompt, the Curator synthesizes these insights into precise "delta entries"—isolated insertions, modifications, or deletions of specific bullet points28. This programmatic, incremental mutation of the context ensures that highly specific failure patterns and domain strategies accumulate losslessly over the agent's lifecycle, improving performance on complex reasoning benchmarks by up to 10.6% while reducing adaptation latency30.

## **Retention and Serving-Time Optimization: The Economics of the KV-Cache**

Once information successfully enters the context, the economics of LLM inference dictate what should remain active in memory. In agentic workflows, the ratio of input tokens to output tokens frequently exceeds 10:1, and can stretch beyond 50:1. Because the sequence length grows with every turn of a conversation, recalculating the attention matrix for a 100,000-token prompt at every step becomes computationally prohibitive34. Consequently, the decision of what remains in the working context is heavily constrained by the underlying mechanics of KV-cache reuse at the serving layer.

### **The Structural Imperative of Prefix Caching**

Two dominant architectural paradigms dictate how context remains efficiently accessible in GPU memory without forcing repeated recomputation: PagedAttention and RadixAttention.

vLLM relies on PagedAttention and Automatic Prefix Caching (APC). In this architecture, the KV cache is divided into fixed-size logical blocks (typically 16 tokens). These blocks are hashed based on their token content and mapped to physical memory via a block table. If a subsequent request contains a sequence of tokens whose block hashes match existing blocks in the cache, the engine reuses those activations. This eliminates internal memory fragmentation and allows for efficient, block-level sharing across requests34.

Conversely, SGLang utilizes RadixAttention, which operates as a tree structure rather than a block table. The runtime maintains a global radix tree (a compressed trie) over the entire KV pool, where each edge represents a sequence of tokens. Every unique prompt prefix is stored as a path in the tree. When a new agent turn is processed, SGLang walks the tree to find the longest exact matching prefix, instantly reusing the computed cache for that branch and only generating new KV tensors for the divergent suffix35.

&nbsp;

| Feature | vLLM (PagedAttention \+ APC) | SGLang (RadixAttention) |
| :---- | :---- | :---- |
| **Granularity** | Block-level (typically 16 tokens)34. | Token-level exact branching (radix tree)34. |
| **Memory Management** | Virtual OS-style block tables, high stability35. | Tree-based indexing, optimized for heavy context reuse36. |
| **Optimal Workload** | High-throughput general inference, diverse hardware36. | Complex multi-turn agents, RAG, shared system prompts36. |
| **Agent Efficacy** | Moderate prefix savings36. | 30-50% prefix caching savings on agent workflows36. |

### **Context Ordering for Maximum Hit Rates**

Because cache matching—in both PagedAttention and RadixAttention—relies on strict sequential prefix alignment, even a single altered byte invalidates the entire cache from that token onward. A dynamic timestamp placed at the beginning of a system prompt, or a tool list that changes its definition order, will result in near-zero cache hit rates24.

To ensure critical context remains in the cache, the prompt architecture must be rigidly stratified from most static to most volatile. The system prompt, behavioral constraints, and tool definitions must be placed at the absolute beginning of the sequence and remain completely static across all calls2. The append-only interaction history (the event log) follows, acting as a stable prefix for the next turn. Any highly volatile state variables—such as current time, dynamic status lines, or intermediate thought processes that fluctuate rapidly—must be relegated to standard user messages at the absolute end of the prompt24. Frameworks like TokenPilot enforce this strictly by replacing volatile runtime variables with stable placeholders in the prompt prefix, securing a byte-identical prefix across long-horizon sessions42.

### **Agent-Aware Cache Eviction via CacheScout**

Standard inference engines evict cached tokens using reactive, recency-based policies like Least Recently Used (LRU). This is highly inefficient for multi-agent workflows, as it frequently purges reusable agent contexts before the agent's next invocation, forcing repeated recomputation39.

Advanced runtime layers like CacheScout bridge the gap by integrating agent-awareness directly into the KV-cache management. CacheScout models agent execution as an online first-order Markov chain. By tracking execution transitions without requiring offline training, it learns the probability that a specific agent or sub-task will be invoked next. CacheScout utilizes this transition matrix to guide survival-based cache eviction—protecting the KV blocks of agents that are statistically likely to be needed soon—and triggers proactive, between-step prefetching. Across real-world multi-agent workloads, this predictive retention improves KV-cache hit rates by 10 to 18 percentage points, reduces mean time-to-first-token (TTFT) by up to 45%, and elevates peak throughput by up to 57%39.

## **Compression and Eviction: Bounded Representations of Interaction History**

Despite optimization and caching, the total context window is finite. The accumulation of terminal observations, iterative code blocks, execution traces, and environmental feedback inevitably approaches the budget limits. At this threshold, context must be compressed. The evolution of context compression in software engineering agents has shifted dramatically away from arbitrary token pruning toward highly structured, action-preserving elision that respects the syntactic boundaries of code.

### **The Fallacy of Token-Level Pruning**

Early approaches to context compression, such as LLMLingua and SelectiveContext, relied on small auxiliary language models to calculate the perplexity of individual tokens. These systems dropped tokens that appeared statistically predictable to fit the remaining context into a defined budget14. While highly effective for compressing redundant natural language prose, token-level pruning is catastrophic for coding agents. It destroys the strict syntactic integrity of source code, breaks Abstract Syntax Trees (ASTs), drops critical semantic symbols necessary for downstream execution, and obscures the precise logic required for debugging23.

### **Action-Preserving and Goal-Driven Compression**

To preserve the logic required for complex software engineering, modern systems utilize observation-level compression guided by strict behavioral constraints, moving away from language perplexity toward execution fidelity.

**CoACT (Action-Preserving Observation Compression):** This framework is built on the rigorous constraint of Next-Action Preservation (NAP). The underlying principle dictates that a compressed observation is only valid if it induces the agent to produce the exact same next action as the raw observation would have49. During training, CoACT generates multiple compressed candidates for an environment observation. It then applies an action-preservation reward based on NAP to filter out any candidate that shifts the agent's immediate next action. By explicitly modeling how compression affects downstream behavior, CoACT filters out distracting environment logs while maintaining task-solving effectiveness. On SWE-bench Verified, it reduces average total token consumption by up to 33% without degrading the pass@1 success rate, validating NAP as a superior metric to token perplexity49.

**SWE-Pruner:** Recognizing that developers do not read code linearly but rather skim based on objectives, SWE-Pruner executes task-aware adaptive pruning at the line level. Driven by the agent's explicit, immediate goal (e.g., "focus on error handling"), a lightweight 0.6B parameter neural skimmer evaluates observations23. By discarding irrelevant code lines while maintaining intact line structures for the remaining code, SWE-Pruner preserves structural integrity. It achieves 23–54% token reduction on agent tasks like SWE-Bench Verified. Crucially, the removal of distracting tokens improves agent decision quality, reducing redundant exploratory agent rounds by up to 26% and accelerating task resolution23.

**TACO (Terminal Agent Compression):** For terminal-centric agents operating in Bash environments, raw command-line feedback—such as build traces or test outputs—is highly verbose and redundant. TACO acts as a self-evolving compression framework that automatically discovers and refines structural compression rules directly from agent interaction trajectories52. It learns workflow-adaptive rules that filter out low-value terminal outputs while preserving the precise error messages required for future actions. These autonomously evolved rules are stored in a Global Rule Pool and transferred across different terminal tasks. On TerminalBench, integrating TACO yields 1%–4% absolute accuracy gains by focusing the agent's attention on task-relevant evidence, doing so entirely without manual heuristic design or task-specific compressor training52.

&nbsp;

| Compression Framework | Core Mechanism | Metric/Target | Primary Domain Advantage |
| :---- | :---- | :---- | :---- |
| **LLMLingua** | Small LM Perplexity Scoring | Token Predictability | Natural language summarization14. |
| **CoACT** | Next-Action Preservation (NAP) | Action Consistency | Software engineering trajectories49. |
| **SWE-Pruner** | Goal-conditioned Neural Skimming | Line-level Relevance | AST and syntax preservation23. |
| **TACO** | Self-Evolving Structural Rules | Terminal Evidence | Bash/CLI observation filtering52. |

### **Budget-Aware Context Management (BACM)**

Determining *when* to compress is equally as critical as determining *how* to compress. Heuristic-based triggers (e.g., "compress when context hits 80% capacity") are rigid and fail to adapt to the complexity of the current reasoning phase. Budget-Aware Context Management (BACM) formulates context compression as a sequential decision problem constrained by an explicit token limit3.

Through curriculum-based reinforcement learning (BACM-RL), the agent is trained to monitor a continuous budget signal. Before appending new observations, the agent evaluates its remaining context headroom3. This empowers the agent to autonomously decide when to aggregate history, how aggressively to compress, and what specific reasoning traces must be preserved to satisfy the long-horizon objective3. BACM-RL incorporates overflow-sensitive regularization, penalizing budget violations during training, which results in highly robust context management under strictly tightening constraints3.

Empirical studies evaluating the architecture of coding harnesses reveal that the staging of compression mechanisms heavily influences both cost and accuracy. Staging rule-based elision prior to LLM-based summarization provides the strongest efficiency among context-management strategies4. Summarization requires heavy LLM inference and is prone to brevity bias, whereas structured elision safely removes bulk data efficiently. Interestingly, empirical harness studies show that implementing complex retrieval mechanisms to allow agents to recover elided content yields almost no accuracy gains, as models rarely utilize the recovery machinery effectively4.

## **Externalization and Persistence: Constructing Out-of-Context Memory**

Because aggressive compression inherently destroys some degree of information, data that is evicted from the active context window but may be required later must be persisted in external memory architectures. Treating the context window as the sole source of truth leads to context rot; instead, the context window must function strictly as the agent's working memory, interfacing with persistent external storage systems.

### **Executable Substrates and Programmatic Context**

Frameworks like Scroll decouple the interaction history from the LLM's prompt entirely by treating the session as an executable "Session Environment." Instead of serializing the entire history into text tokens, Scroll maintains an append-only Event Log and a sandboxed, persistent Python kernel58. Tool outputs, retrieved data, intermediate execution states, and large JSON responses are bound directly to Python variables residing in the external kernel58.

Context management thus transforms into a programmatic task: the LLM writes code to search, filter, join, and materialize data from the Event Log. Only the specific projections explicitly printed by the agent's code cross the boundary to enter the working context window58. As the context approaches its budget, stale observations are evicted from the prompt, but an "eviction index" leaves compact programmatic pointers (landmarks) tied to the exact addresses in the Event Log. This ensures that while the working view remains lean, the full historical ground truth remains losslessly recoverable via deterministic execution58.

### **Version-Controlled Agent Memory**

Drawing inspiration directly from collaborative software engineering, the Git-Context-Controller (GCC) elevates agent memory from a flat, transient token stream into a hierarchical, version-controlled file system61. Under GCC, context is externalized into a structured directory (e.g., .GCC/) containing a global roadmap and branch-specific execution traces, mirroring the architecture of Git62.

Agents manipulate this external state using explicit commands that manage reasoning trajectories:

&nbsp;

| GCC Command | Functionality in Agent Context | Purpose |
| :---- | :---- | :---- |
| COMMIT | Checkpoints meaningful progress, synthesizing raw actions into a high-level milestone summary62. | Prevents context loss by creating durable, summarized save states62. |
| BRANCH | Isolates speculative reasoning, API explorations, or alternative debugging paths into a separate workspace62. | Protects the main reasoning trajectory from pollution by failed experiments64. |
| MERGE | Synthesizes divergent reasoning paths and outcomes back into the primary trajectory62. | Consolidates successful exploration into actionable main-line context64. |
| CONTEXT | Retrieves historical information at varying resolutions (project, commit, or log level)62. | Allows the agent to scroll through past logs without loading them simultaneously62. |

By formalizing memory persistence through version control semantics, GCC enables agents to recover context across sessions, coordinate multi-trajectory problem-solving, and resume complex logic seamlessly. Empirically, integrating GCC provides massive capability unlocks, boosting models like Claude-4-Sonnet to state-of-the-art performance on SWE-bench Verified (exceeding 80% task resolution), representing a 13.6% absolute improvement simply through superior context persistence61.

### **Tiered Event-Sourced Architectures**

Systems like Letta (built upon the foundations of MemGPT) operationalize this persistence through tiered memory architectures modeled on operating system design. The "Working Memory" maps directly to the LLM's active context window, serving as the immediate processing zone. A "Recall Memory" serves as a durable, append-only event log of all past interactions and system states. An "Archival Memory" functions as a semantically searchable vector database for long-term knowledge storage68.

Similarly, the OpenHands SDK delegates all conversation history to a separate, file-backed EventLog. This ensures the "Context State Object" (CSO) acts as the single, immutable source of truth, rather than relying on the LLM's inherently fragile and dynamically shifting context window72. The orchestration layer can then surgically select elements from these durable external stores to rebuild the active context exactly as needed.

## **Reset and Sub-Agent Delegation: Breaking Contextual Drag**

The final, and perhaps most critical, lever in context lifecycle management is the decision to entirely rebuild or reset the working context. This requirement is necessitated not by token limits, but by the psychological and mathematical constraints of the attention mechanism.

### **The Phenomenon of Contextual Drag**

When an autonomous agent attempts a complex software patch, executes tests, and fails, the standard ReAct orchestration loop appends the failure, the flawed code, and the error log to the context, prompting the agent to try again. However, structural analyses utilizing Tree Edit Distance (TED) on model outputs demonstrate that LLMs suffer heavily from "Contextual Drag"10.

The presence of the failed reasoning in the context exerts a powerful gravitational pull on the transformer's attention mechanism. As the model attempts to generate a corrected solution, its subsequent reasoning paths structurally mimic the erroneous draft. The model copies the logical structure of the error, even if the model successfully verifies and explicitly outputs that the previous draft was wrong10. Because external feedback (e.g., test suite failures) and self-verification are insufficient to break this deep structural anchoring bias, agents with severely polluted contexts often enter spirals of self-deterioration, where iterative refinement actually decreases overall performance10.

While test-time "context denoising"—prompting the model to filter or revise the drafts before proceeding—can partially mitigate this effect, it is computationally expensive and imperfect10. The only guaranteed methodology to eliminate contextual drag and restore optimal reasoning capability is a clean-slate context reset.

### **Sub-Agent Architectures for Context Isolation**

To execute context resets safely without losing overarching task progress or breaking the main prompt caching strategy, modern production environments utilize sub-agent architectures. In tools like Claude Code, rather than forcing a single agent to handle exploration, planning, and precise coding within one continuously growing and heavily polluted window, the main orchestrator delegates distinct tasks to specialized sub-agents77.

Sub-agents are defined programmatically via Markdown files containing YAML frontmatter. This frontmatter explicitly defines the sub-agent's restricted tool access, its preferred routing model, and its permissions, while the body serves as a highly specific, clean system prompt77.

When the orchestrator invokes a sub-agent, it spawns in a completely isolated, clean context window77. This isolation achieves three critical objectives:

> 1. **Isolation of Noise:** A sub-agent (such as Claude Code's built-in Explore agent) can execute dozens of terminal commands, grep through deep repository structures, and read extensive files. The resulting dense, noisy token accumulation is entirely contained within the sub-agent's isolated window, keeping the parent's working memory lean78.  
> 2. **Contextual Drag Prevention:** If the sub-agent goes down a flawed reasoning path, or generates severely hallucinated code during exploration, the structural errors do not pollute the parent agent's context. The parent remains objective and unanchored78.  
> 3. **Cache Preservation:** Because the sub-agent runs as a distinct session, it does not mutate the parent’s prompt prefix. In systems utilizing prefix caching (which often enforce strict Time-To-Live expiration, such as a 5-minute TTL for API usage), this protects the parent's highly discounted KV-cache, preserving inference speed and cost efficiency24.

Once the sub-agent completes its objective, the isolated process terminates, and only a highly synthesized summary of the final result is returned to the orchestrator78. This architectural delegation acts as a targeted, functional context reset, enabling the system to achieve long-horizon task completion without succumbing to token exhaustion or cognitive drag.

## **Synthesis and Strategic Outlook**

Achieving high-reliability automation in software engineering requires abandoning the notion of the context window as a passive ledger. Instead, it must be treated as a highly regulated, economically constrained working memory. The optimal architecture for a coding agent requires rigorous enforcement of boundaries across the entire context lifecycle.

What enters the model must be dense and structural; Tree-sitter Repo Maps and Agentic Context Engineering (ACE) playbooks provide global awareness without text bloat, while logit masking safely constrains tool usage without mutating prompts. What remains must be structurally optimized to exploit KV-cache prefix mechanics, requiring rigid sequence ordering and predictive, Markov-based prefetching via systems like CacheScout. When the budget tightens, arbitrary token pruning must be rejected in favor of action-preserving elision (CoACT, SWE-Pruner, TACO) that protects syntax and execution fidelity. What is evicted must be persisted in robust, version-controlled external environments like Git-Context-Controller or executable event logs. Finally, to combat the psychological anchor of contextual drag, the system must aggressively delegate noisy execution to isolated sub-agents, protecting the primary orchestrator's context from irreversible cognitive pollution. By unifying these five lifecycle stages, agent harnesses bridge the horizon gap, translating raw model capabilities into persistent, reliable software engineering execution.

#### **Works cited**

> 1. Effective context engineering for AI agents \- Anthropic, [https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)  
> 2. Context Engineering — harn.app Knowledge Base, [https://harn.app/kb/context](https://harn.app/kb/context)  
> 3. Budget-Aware Context Management for Long-Horizon Search Agents, [https://arxiv.org/html/2604.01664v1](https://arxiv.org/html/2604.01664v1)  
> 4. An Empirical Study of Harness Design for Coding Agents \- arXiv, [https://arxiv.org/html/2609.20804v1](https://arxiv.org/html/2609.20804v1)  
> 5. Lost in the Middle: How Language Models Use Long Contexts, [https://www.researchgate.net/publication/378284067\_Lost\_in\_the\_Middle\_How\_Language\_Models\_Use\_Long\_Contexts](https://www.researchgate.net/publication/378284067_Lost_in_the_Middle_How_Language_Models_Use_Long_Contexts)  
> 6. Lost in the Middle: How Language Models Use Long Contexts \- arXiv, [https://arxiv.org/abs/2307.03172](https://arxiv.org/abs/2307.03172)  
> 7. Lost in the Middle: How Language Models Use Long Contexts, [https://cs.stanford.edu/\~nfliu/papers/lost-in-the-middle.arxiv2023.pdf](https://cs.stanford.edu/~nfliu/papers/lost-in-the-middle.arxiv2023.pdf)  
> 8. Found in the Middle: How Language Models Use Long Contexts, [https://arxiv.org/html/2403.04797v1](https://arxiv.org/html/2403.04797v1)  
> 9. LLMs Get Lost In Multi-Turn Conversation \- arXiv, [https://arxiv.org/pdf/2505.06120](https://arxiv.org/pdf/2505.06120)  
> 10. Contextual Drag: How Errors in the Context Affect LLM Reasoning, [https://arxiv.org/html/2602.04288v1](https://arxiv.org/html/2602.04288v1)  
> 11. Contextual Drag: How Errors in the Context Affect LLM Reasoning, [https://www.alphaxiv.org/abs/2602.04288](https://www.alphaxiv.org/abs/2602.04288)  
> 12. Contextual Drag: How Errors in the Context Affect LLM Reasoning, [https://arxiv.org/pdf/2602.04288](https://arxiv.org/pdf/2602.04288)  
> 13. Contextual Drag: How Errors in the Context Affect LLM Reasoning, [https://github.com/princeton-pli/contextual-drag](https://github.com/princeton-pli/contextual-drag)  
> 14. Context Compression for Long-Horizon AI Agents: Lifecycle, [https://www.preprints.org/manuscript/202607.0924](https://www.preprints.org/manuscript/202607.0924)  
> 15. Context Compression for LLM Agents: A Survey of Methods, Failure, [https://www.preprints.org/manuscript/202605.2065](https://www.preprints.org/manuscript/202605.2065)  
> 16. Aider \- Learn AI \- Miraheze, [https://ai.miraheze.org/wiki/Aider](https://ai.miraheze.org/wiki/Aider)  
> 17. Securely indexing large codebases \- Cursor, [https://cursor.com/blog/secure-codebase-indexing](https://cursor.com/blog/secure-codebase-indexing)  
> 18. Repository map \- Aider, [https://aider.chat/docs/repomap.html](https://aider.chat/docs/repomap.html)  
> 19. How I use LLMs | Karan Sharma, [https://mrkaran.dev/posts/using-llm/](https://mrkaran.dev/posts/using-llm/)  
> 20. Building a better repository map with tree sitter \- Aider, [https://aider.chat/2023/10/22/repomap.html](https://aider.chat/2023/10/22/repomap.html)  
> 21. Aider Review: Terminal AI Coding Agent (2026) \- Codegen, [https://codegen.com/ai-tools/aider/](https://codegen.com/ai-tools/aider/)  
> 22. AI Coding Agent Architecture: Agent Loop Deep Dive, [https://fp8.co/articles/AI-Coding-Agent-Architecture-Deep-Dive](https://fp8.co/articles/AI-Coding-Agent-Architecture-Deep-Dive)  
> 23. SWE-Pruner: Self-Adaptive Context Pruning for Coding Agents \- arXiv, [https://arxiv.org/html/2601.16746v1](https://arxiv.org/html/2601.16746v1)  
> 24. How Prompt Caching Actually Works in Claude Code, [https://www.claudecodecamp.com/p/how-prompt-caching-actually-works-in-claude-code](https://www.claudecodecamp.com/p/how-prompt-caching-actually-works-in-claude-code)  
> 25. Context Engineering Strategies for Production AI Agents \- ZenML, [https://www.zenml.io/llmops-database/context-engineering-strategies-for-production-ai-agents](https://www.zenml.io/llmops-database/context-engineering-strategies-for-production-ai-agents)  
> 26. Context Engineering for AI Agents: Lessons from Building Manus, [https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)  
> 27. Context Engineering for AI Agents: Key Lessons from Manus, [https://www.marktechpost.com/2025/07/22/context-engineering-for-ai-agents-key-lessons-from-manus/](https://www.marktechpost.com/2025/07/22/context-engineering-for-ai-agents-key-lessons-from-manus/)  
> 28. Agentic Context Engineering: Evolving Contexts for Self-Improving, [https://www.alphaxiv.org/abs/2510.04618](https://www.alphaxiv.org/abs/2510.04618)  
> 29. Agentic Context Engineering: Evolving Contexts for Self-Improving, [https://huggingface.co/papers/2510.04618](https://huggingface.co/papers/2510.04618)  
> 30. Evolving Contexts for Self-Improving Language Models \- arXiv, [https://arxiv.org/abs/2510.04618](https://arxiv.org/abs/2510.04618)  
> 31. Evolving Contexts for Self-Improving Language Models \- arXiv, [https://arxiv.org/html/2510.04618v3](https://arxiv.org/html/2510.04618v3)  
> 32. Agentic Context Engineering: Evolving Contexts for Self-Improving, [https://openreview.net/forum?id=eC4ygDs02R](https://openreview.net/forum?id=eC4ygDs02R)  
> 33. Evolving Contexts for Self-Improving Language Models | Request PDF, [https://www.researchgate.net/publication/396250582\_Agentic\_Context\_Engineering\_Evolving\_Contexts\_for\_Self-Improving\_Language\_Models](https://www.researchgate.net/publication/396250582_Agentic_Context_Engineering_Evolving_Contexts_for_Self-Improving_Language_Models)  
> 34. Context Engineering for Production AI Agents: KV Cache, Prefix, [https://www.spheron.network/blog/context-engineering-production-ai-agents-kv-cache-long-context/](https://www.spheron.network/blog/context-engineering-production-ai-agents-kv-cache-long-context/)  
> 35. KV Cache Management: PagedAttention & RadixAttention, [https://www.analyticsvidhya.com/blog/2026/08/pagedattention-radixattention-llm-kv-cache/](https://www.analyticsvidhya.com/blog/2026/08/pagedattention-radixattention-llm-kv-cache/)  
> 36. vLLM vs SGLang: Enterprise LLM Inference Comparison, [https://dev.to/ljhao/vllm-vs-sglang-enterprise-llm-inference-comparison-3dg3](https://dev.to/ljhao/vllm-vs-sglang-enterprise-llm-inference-comparison-3dg3)  
> 37. SGLang — Fast LLM Serving with RadixAttention \- Yobitel, [https://yobitel.com/knowledge-base/sglang](https://yobitel.com/knowledge-base/sglang)  
> 38. radix-attention.md \- AI-research-SKILLs \- GitHub, [https://github.com/firecrawl/ai-research-skills/blob/main/12-inference-serving/sglang/references/radix-attention.md](https://github.com/firecrawl/ai-research-skills/blob/main/12-inference-serving/sglang/references/radix-attention.md)  
> 39. Learning Agent Execution for KV-Cache Management in ... \- arXiv, [https://arxiv.org/html/2608.14624v1](https://arxiv.org/html/2608.14624v1)  
> 40. SGLang vs. vLLM: The New Throughput King? \- GoPenAI, [https://blog.gopenai.com/sglang-vs-vllm-the-new-throughput-king-7daec596f7fa](https://blog.gopenai.com/sglang-vs-vllm-the-new-throughput-king-7daec596f7fa)  
> 41. Semantic Caching for AI Agents: Monitoring LLM Performance, [https://www.logicmonitor.com/blog/semantic-caching-what-we-measured-why-it-matters](https://www.logicmonitor.com/blog/semantic-caching-what-we-measured-why-it-matters)  
> 42. TokenPilot: Cache-Efficient Context Management for LLM Agents, [https://arxiv.org/html/2606.17016v1](https://arxiv.org/html/2606.17016v1)  
> 43. A Policy-Driven Runtime Layer for Agentic LLM Serving \- arXiv, [https://arxiv.org/html/2605.27744v2](https://arxiv.org/html/2605.27744v2)  
> 44. \[PDF\] PentaRAG: Large-Scale Intelligent Knowledge Retrieval for, [https://www.semanticscholar.org/paper/PentaRAG%3A-Large-Scale-Intelligent-Knowledge-for-LLM-Syarubany-Yoo/6c855d6d2074e4e5dde91cda70c5dbbb08303435](https://www.semanticscholar.org/paper/PentaRAG%3A-Large-Scale-Intelligent-Knowledge-for-LLM-Syarubany-Yoo/6c855d6d2074e4e5dde91cda70c5dbbb08303435)  
> 45. The Fundamentals of Context Management and Compaction in LLMs, [https://kargarisaac.medium.com/the-fundamentals-of-context-management-and-compaction-in-llms-171ea31741a2](https://kargarisaac.medium.com/the-fundamentals-of-context-management-and-compaction-in-llms-171ea31741a2)  
> 46. Prompt Compression in Large Language Models (LLMs) \- Medium, [https://medium.com/@sahin.samia/prompt-compression-in-large-language-models-llms-making-every-token-count-078a2d1c7e03](https://medium.com/@sahin.samia/prompt-compression-in-large-language-models-llms-making-every-token-count-078a2d1c7e03)  
> 47. SWE-Pruner: Self-Adaptive Context Pruning for Coding Agents \- arXiv, [https://arxiv.org/html/2601.16746v3](https://arxiv.org/html/2601.16746v3)  
> 48. SWE-Pruner: Self-Adaptive Context Pruning for Coding Agents \- arXiv, [https://arxiv.org/pdf/2601.16746](https://arxiv.org/pdf/2601.16746)  
> 49. Action-Preserving Observation Compression for Coding Agents \- arXiv, [https://arxiv.org/abs/2607.02911](https://arxiv.org/abs/2607.02911)  
> 50. Action-Preserving Observation Compression for Coding Agents \- arXiv, [https://arxiv.org/html/2607.02911v1](https://arxiv.org/html/2607.02911v1)  
> 51. SWE-Pruner: Self-Adaptive Context Pruning for Coding Agents, [https://www.emergentmind.com/papers/2601.16746](https://www.emergentmind.com/papers/2601.16746)  
> 52. A Self-Evolving Framework for Efficient Terminal Agents via ... \- arXiv, [https://arxiv.org/html/2604.19572v3](https://arxiv.org/html/2604.19572v3)  
> 53. A Self-Evolving Framework for Efficient Terminal Agents via ... \- arXiv, [https://arxiv.org/html/2604.19572v2](https://arxiv.org/html/2604.19572v2)  
> 54. A Self-Evolving Framework for Efficient Terminal Agents via ... \- arXiv, [https://arxiv.org/pdf/2604.19572](https://arxiv.org/pdf/2604.19572)  
> 55. Budget-Aware Context Management for Long-Horizon Search Agents, [https://huggingface.co/papers/2604.01664](https://huggingface.co/papers/2604.01664)  
> 56. ContextBudget: Budget-Aware Context Management for ... \- GitHub, [https://github.com/yw-0311/ContextBudget](https://github.com/yw-0311/ContextBudget)  
> 57. Paper page \- An Empirical Study of Harness Design for Coding Agents, [https://huggingface.co/papers/2609.20804](https://huggingface.co/papers/2609.20804)  
> 58. Programmatic Context Management for Long-Horizon Agents \- arXiv, [https://arxiv.org/abs/2608.21690](https://arxiv.org/abs/2608.21690)  
> 59. Programmatic Context Management for Long-Horizon Agents \- arXiv, [https://arxiv.org/html/2608.21690v1](https://arxiv.org/html/2608.21690v1)  
> 60. Programmatic Context Management for Long-Horizon Agents \- arXiv, [https://arxiv.org/pdf/2608.21690](https://arxiv.org/pdf/2608.21690)  
> 61. Manage the Context of LLM-based Agents like Git \- arXiv, [https://arxiv.org/pdf/2508.00031](https://arxiv.org/pdf/2508.00031)  
> 62. Manage the Context of LLM-based Agents like Git \- arXiv, [https://arxiv.org/html/2508.00031v1](https://arxiv.org/html/2508.00031v1)  
> 63. Git Context Controller: Manage the Context of Agents by Agentic Git, [https://arxiv.org/html/2508.00031v2](https://arxiv.org/html/2508.00031v2)  
> 64. Git-Context-Controller Framework \- Emergent Mind, [https://www.emergentmind.com/topics/git-context-controller](https://www.emergentmind.com/topics/git-context-controller)  
> 65. \[Resource\]: Git Context Controller (GCC) · Issue \#855 \- GitHub, [https://github.com/hesreallyhim/awesome-claude-code/issues/855](https://github.com/hesreallyhim/awesome-claude-code/issues/855)  
> 66. Git Context Controller: Manage the Context of Agents by Agentic Git, [https://arxiv.org/html/2508.00031v3](https://arxiv.org/html/2508.00031v3)  
> 67. Manage the Context of LLM-based Agents like Git, [https://www.alphaxiv.org/abs/2508.00031](https://www.alphaxiv.org/abs/2508.00031)  
> 68. Letta Agent | Personalized Agent That Remembers and Learns, [https://www.letta.com/agent/](https://www.letta.com/agent/)  
> 69. Best AI Agent Memory Frameworks in 2026: Compared and Ranked, [https://atlan.com/know/best-ai-agent-memory-frameworks-2026/](https://atlan.com/know/best-ai-agent-memory-frameworks-2026/)  
> 70. Archival memory \- Letta Docs, [https://docs.letta.com/v1-sdk/memory/archival-memory](https://docs.letta.com/v1-sdk/memory/archival-memory)  
> 71. letta\_memgpt\_patterns.ipynb \- Agent\_Memory\_Techniques \- GitHub, [https://github.com/NirDiamant/Agent\_Memory\_Techniques/blob/main/all\_techniques/26\_letta\_memgpt\_patterns/letta\_memgpt\_patterns.ipynb](https://github.com/NirDiamant/Agent_Memory_Techniques/blob/main/all_techniques/26_letta_memgpt_patterns/letta_memgpt_patterns.ipynb)  
> 72. senpai/SPEC.md at main \- GitHub, [https://github.com/wandb/senpai/blob/main/SPEC.md](https://github.com/wandb/senpai/blob/main/SPEC.md)  
> 73. Efficient On-Device Agents via Adaptive Context Management \- arXiv, [https://arxiv.org/html/2511.03728v1](https://arxiv.org/html/2511.03728v1)  
> 74. (PDF) Harness Engineering: Anatomy, Architecture, and Evolution of, [https://www.researchgate.net/publication/413883486\_Harness\_Engineering\_Anatomy\_Architecture\_and\_Evolution\_of\_Coding\_Agents\_--\_A\_Source-Code\_Study\_of\_Eleven\_Systems](https://www.researchgate.net/publication/413883486_Harness_Engineering_Anatomy_Architecture_and_Evolution_of_Coding_Agents_--_A_Source-Code_Study_of_Eleven_Systems)  
> 75. Contextual Drag: How Errors in the Context Affect LLM Reasoning, [https://arxiv.org/abs/2602.04288](https://arxiv.org/abs/2602.04288)  
> 76. Contextual Drag: How Errors in the Context Affect LLM Reasoning, [https://www.alphaxiv.org/audio/2602.04288v1](https://www.alphaxiv.org/audio/2602.04288v1)  
> 77. Claude Code Subagents: A 2026 Practical Guide \- Tembo.io, [https://www.tembo.io/blog/claude-code-subagents](https://www.tembo.io/blog/claude-code-subagents)  
> 78. How to Use Sub-Agents in Claude Code to Manage Context and, [https://www.mindstudio.ai/blog/sub-agents-claude-code-context-management](https://www.mindstudio.ai/blog/sub-agents-claude-code-context-management)  
> 79. Create custom subagents \- Claude Code Docs, [https://code.claude.com/docs/en/sub-agents](https://code.claude.com/docs/en/sub-agents)  
> 80. claude-howto/04-subagents/README.md at main \- GitHub, [https://github.com/luongnv89/claude-howto/blob/main/04-subagents/README.md](https://github.com/luongnv89/claude-howto/blob/main/04-subagents/README.md)  
> 81. How prompt caching works in Claude Code (and how to stop, [https://www.reddit.com/r/ClaudeAI/comments/1uih6w7/how\_prompt\_caching\_works\_in\_claude\_code\_and\_how/](https://www.reddit.com/r/ClaudeAI/comments/1uih6w7/how_prompt_caching_works_in_claude_code_and_how/)  
> 82. Claude Code Subagents \- GeeksforGeeks, [https://www.geeksforgeeks.org/artificial-intelligence/claude-code-subagents/](https://www.geeksforgeeks.org/artificial-intelligence/claude-code-subagents/)