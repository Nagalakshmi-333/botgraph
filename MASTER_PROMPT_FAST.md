# MASTER PROMPT (FAST BUILD) - BotGraph

> **How to use this file:** open this folder (`8.ProjectCode`) as its own workspace, start a new Claude Code session and say:
> *"Read MASTER_PROMPT_FAST.md completely and follow it exactly."*
>
> **Before you start (do this first - it saves the most time):**
> - **Kaggle account + API token** for the dataset download script - https://www.kaggle.com/settings (Create New Token).
> - In the session, switch to **accept-edits** mode, and when it first asks to run `pip`, `npm`, `python` or `git`, choose **"Yes, and don't ask again"**. Waiting for approvals is the biggest hidden time cost.

---

## 0. Your role and the goal

You are the lead engineer for **BotGraph** - finds fake accounts and coordinated botnets from the shape of the social graph, not just from single profiles.

**Goal: a fully working, end-to-end product in the shortest time.** Every feature in section 4.4 must really work with real data and the real model or API - nothing faked. Build only what is in this file. When two approaches both work, **always take the simpler one.**

---

## 1. Rules

1. **One stop only.** Do the Start step (section 8), show a short plan, and wait for **"proceed"**. After that, build straight through without stopping. Don't ask more questions unless you are truly blocked; pick sensible defaults and list them at the end.
2. **Real product identity.** Never write anything suggesting coursework or an institution - in code, comments, UI text, docs, sample data, file names or commit messages: no "B.Tech", "final year", "major/mini project", "semester", "college/university project", "student batch", "project guide", "supervisor", "viva", "project review", "project submission", "HOD" or academic department names, and no names of people or institutions. Ordinary product words (a hospital department, a moderator review) are fine.
3. **Works end-to-end, nothing faked.** No placeholders, dummy buttons or hard-coded results. Every output comes from the real pipeline. Seed or sample data is allowed only where it is clearly labelled as such.
4. **Speed rules.**
   - Build only the features in section 4.4. No extra features, no animation libraries, no refactoring for elegance.
   - Install only what section 6 lists. Do **not** add LangChain, LlamaIndex or anything not named there.
   - Timebox: if something still fails after 3 attempts, take a simpler approach that works and say so at the end.
   - Testing = one smoke-test script that drives the real API, plus a frontend production build (`npm run build`). No large unit-test suites.
   - Run the backend and frontend in the background while you work; never block on them.
5. **Secrets** live only in `.env`, never hard-coded. In this repository `.env` **is committed** (it is private, and the owner wants the project to run out of the box).
6. **Leave `2.ABSTRACT.docx` and `MASTER_PROMPT.md` in this folder untouched**, and don't reference them in the product.
7. **Fixed ports** (other products run on this machine at the same time): backend **8309**, frontend **5309** (`strictPort: true`). Any extra local service uses a port in **13090-13099**. Put them in `.env` / `.env.example`; never use the defaults 8000 / 5173.
8. **Everything is committed** (code, sample data, model and evaluation output, docs) except `venv/`, `node_modules/`, `dist/`, and a full dataset when only a sample is committed.

---

## 2. The problem

- Fake profiles are created faster than manual moderation can remove them.
- Per-account classifiers miss coordinated networks whose individual profiles appear legitimate.
- Bot behaviour evolves quickly, so static rules and signatures become obsolete.
- Class imbalance and label noise degrade conventional supervised models.

**What is needed:** a graph-based detector that classifies accounts from their relational context and exposes coordinated botnet clusters at scale.

---

## 3. Who uses it

- Platform trust and safety teams
- Moderators working through reported accounts
- Researchers studying coordinated behaviour

---

## 4. System evolution (read, then build 4.4)

### 4.1 Reference system
**PruferNET: An Augmented Graph Neural Network for Influential Node Detection in Social Networks** - IEEE Access, 2026 - https://ieeexplore.ieee.org/document/11533388

- The surveyed work applies GNNs to influence and node classification in social graphs. The gap is applying the same relational learning specifically to fake-profile and botnet detection at platform scale.
- The base paper establishes the core technique for this problem domain. This project reuses that technique and extends it to the specific scope described in the abstract.

### 4.2 Advanced system (the specification - every point must be met)

- The rapid growth of Indian social platforms has triggered a surge in sophisticated fake profiles and automated botnets that threaten national security, user privacy, and digital trust.
- Traditional rule-based filters and classical machine learning models struggle to catch these threats because modern bot behaviors evolve too quickly.
- To solve this, a novel Graph Neural Network (GNN) framework maps entire social ecosystems into relational data graphs, treating user accounts as nodes and interactions—like likes, comments, and follows—as connecting edges.
- By deploying advanced GCN, GAT, and GraphSAGE architectures, the system extracts deep structural embeddings and fuses them with behavioral data, including linguistic cues and temporal patterns.
- This approach significantly outperforms conventional classifiers, delivering higher precision and F1-scores on highly imbalanced fraud datasets to expose hidden, coordinated bot communities.
- Ultimately, this scalable and adaptive architecture is purpose-built to uncover relational anomalies, offering a robust security solution for massive, localized Indian platforms such as ShareChat and Moj.

Objectives the product must meet:

1. Construct a graph representation of the social platform with accounts as nodes and interactions as edges.
2. Engineer node features covering profile metadata, posting behaviour and interaction frequency.
3. Implement and compare GCN, GAT and GraphSAGE architectures for account classification.
4. Detect coordinated botnet clusters from the learned graph embeddings.
5. Evaluate detection accuracy, precision and recall against labelled fake-account datasets.
6. Assess scalability as the number of nodes and edges grows.

### 4.3 Latest approaches
- Graph neural networks (GCN, GAT, GraphSAGE) classify accounts using their neighbourhood, not only their own features.
- Community detection over learned embeddings surfaces coordinated clusters whose individual members look ordinary.
- Message-passing layers can be written directly in PyTorch, avoiding fragile geometric-library builds on Windows.
- Scalability is reported as nodes and edges grow, not just accuracy on a fixed split.

### 4.4 What you will build - BotGraph
Build these and only these.

- **F1 Graph builder** - accounts become nodes and interactions become edges, assembled from the committed datasets into one graph with a documented schema.
- **F2 Node features** - profile metadata (age, followers/following ratio, bio and picture presence), posting behaviour and interaction frequency.
- **F3 Three architectures compared** - GCN, GAT and GraphSAGE trained on the same split, with a feature-only baseline (no graph) to prove the graph is earning its place.
- **F4 Account scoring** - every account gets a fake-probability with its top contributing features and a view of its neighbourhood.
- **F5 Botnet clusters** - community detection over the learned embeddings groups coordinated accounts; each cluster shows size, shared behaviour and an interactive graph view.
- **F6 Moderator queue** - confirm or dismiss a flagged account or cluster; decisions are logged and feed the next training run.
- **F7 Evaluation** - accuracy, precision, recall and F1 per architecture, plus a scalability chart of training and inference time as the graph grows.

### 4.5 Data

- **Twitter Bot Detection Dataset** (Kaggle) - https://www.kaggle.com/datasets/goyaladi/twitter-bot-detection-dataset - 7.1 MB, CC0 -> commit; account features and bot/human labels.
- **Instagram fake, spammer and genuine accounts** (Kaggle) - https://www.kaggle.com/datasets/free4ever1/instagram-fake-spammer-genuine-accounts - under 1 MB, CC BY 3.0 -> commit; a second labelled source.
- **Social circles: Facebook** (Kaggle mirror of SNAP) - https://www.kaggle.com/datasets/dhruvb2028/social-circles-facebook - 0.7 MB -> commit; supplies a **real** social graph topology.
- A committed, seeded script injects coordinated bot clusters into that topology so cluster detection can be measured against ground truth. Document clearly in the docs which edges are real and which are injected.

**Dataset rules:** commit the dataset when it is about 200 MB or less with no single file over 100 MB; otherwise commit a representative sample under `data/sample/` plus `scripts/download_data.py` (Kaggle via `kagglehub`). Anything you generate must come from a committed, seeded script. Record each source, its licence and what is committed in `docs/02_HOW_IT_WORKS.md`.

---

## 5. Screens

1. Landing
2. Login (analyst, moderator)
3. Overview dashboard
4. Accounts (ranked, with neighbourhood view)
5. Cluster explorer (graph)
6. Moderator queue
7. Model comparison and scalability

Keep the UI clean and responsive with Tailwind, and give every action a loading and an error state. No landing-page animation libraries.

---

## 6. Tech stack (fast version - ask before adding anything)

- **Frontend:** React + Vite (**JavaScript**, not TypeScript), Tailwind CSS, react-router-dom, axios, lucide-react icons. Vite proxies `/api` to the backend port.
- **Backend:** Python 3.11+, FastAPI + Uvicorn, SQLAlchemy 2 + SQLite (created on first run), PyJWT + bcrypt for login, python-dotenv. Keep the schema small.
- **Specific to BotGraph:** PyTorch (CPU wheel) with the GCN, GAT and GraphSAGE layers written directly against sparse tensors - deliberately **no torch-geometric**, whose Windows wheels are a common build failure; NetworkX plus python-louvain for communities; react-force-graph for the graph view.
- **Training:** The model(s) train **locally on CPU in M1** with a small, fast config (few epochs / a data subset). Save the model plus a `metrics.json` under `experiments/`.

---

## 7. Folder structure

```
8.ProjectCode/
  backend/app/        main.py, db.py, auth.py, routes/, services/
  frontend/src/       pages/, components/, api.js
  ml/                 training and evaluation scripts
  scripts/            smoke_test.py, download_data.py (if needed), generators
  data/               raw or sample data, app.db (git-ignored)
  models/  experiments/   trained model(s) and metrics
  docs/               01_OVERVIEW.md, 02_HOW_IT_WORKS.md, 03_HOW_TO_RUN.md
  setup.bat  run.bat  .env.example  .gitignore  README.md
```

---

## 8. Workflow

**Start (then the only stop)**
1. Check Python, Node.js LTS and Git. Check `.env` has every key section 6 needs, and that any dataset or file you need is present. If something is missing, give the user 2-3 exact steps to fix it.
2. Write `docs/PLAN.md` (30 lines or fewer: architecture, endpoints, tables, screens, the data you will use).
3. Show a 10-line summary and wait for **"proceed"**.

**M1 - Backend and core logic.** Project skeleton, `setup.bat` (venv + pip + `npm install`), backend with login and database, then the data and model pipeline and every feature endpoint from section 4.4. Train the model(s) here with a small, fast config and save the metrics. `scripts/smoke_test.py` drives the running API through the main flow end-to-end and must pass. Commit and push.

**M2 - Frontend.** The screens in section 5, wired to the API. `run.bat` starts backend and frontend and opens the browser. Commit and push.

**M3 - Finish.** `ml/eval.py` (or `scripts/eval.py`) produces the evaluation numbers the objectives ask for and writes them to `experiments/eval/metrics.json`. Write the 3 docs and a README (features, quick start, demo login, evaluation results, documentation index). Copy `docs/03_HOW_TO_RUN.md` to `../18.FinalCodeExecutionSteps/HOW_TO_RUN.md`. Final check: the smoke test passes and `npm run build` succeeds. Commit and push, then give the user a short summary: how to run it, the demo login, and the defaults you chose.

---

## 9. Git rules (other sessions may be committing in sibling folders at the same time)

- From this folder: `git add -A .` then `git commit -m "<3-5 plain words>" -- .` - never a bare `git commit`. No message body, no co-author or AI-attribution lines. Never change git config.
- Push with `git push`. If it is rejected because the remote moved, run `git pull --rebase --autostash` only when `git status` shows nothing outside this folder; otherwise wait a minute and retry.
- On `index.lock` or "another git process": wait 10 seconds and retry. Never delete the lock file.
- Never run `git stash`, `reset`, `checkout`, `restore`, `clean`, `rebase` or `push --force`.
- In M3, name the copied file explicitly: `git add -A . ../18.FinalCodeExecutionSteps/HOW_TO_RUN.md` and `git commit -m "<message>" -- . ../18.FinalCodeExecutionSteps/HOW_TO_RUN.md`.
- `.gitignore`: `venv/`, `node_modules/`, `__pycache__/`, `dist/`, `data/app.db`, and `data/raw/` when only a sample is committed.
- A single file over 100 MB needs Git LFS: ask the user first.

---

## 10. Done when

**Demo (from a fresh `run.bat`):**
1. Build the graph -> node and edge counts with the feature summary.
2. Train all three architectures -> comparison table showing each beating the no-graph baseline.
3. Open the top-scored account -> its probability, top features and neighbourhood.
4. Open the cluster explorer -> an injected botnet is recovered as one community; dismiss one member and see it logged.

**Checklist:** every feature in 4.4 works through the UI - the smoke test passes - `npm run build` succeeds - the evaluation numbers are in the README - the 3 docs and the HOW_TO_RUN copy are done - no academic wording, no hard-coded secrets - everything committed.

---

## Deferred for speed (not in this build)
- TwiBot-22-scale graphs, linguistic and temporal transformer features, and live platform API ingestion.
These are left out deliberately to keep the build fast. Do not add them unless the user asks.
