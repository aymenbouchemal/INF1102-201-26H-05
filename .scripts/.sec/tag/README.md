# Tag

```bash
TAG=v1.2
```

```bash
git tag ${TAG}
```

```bash
git push origin ${TAG}
```
<details>

```lua
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To github-boreal.com:CollegeBoreal/INF1084-202-25A-03.git
 * [new tag]         v1.2 -> v1.2
```

</details>
If you mean **"how to tag the `main` branch in Git"**, here’s how to do it step-by-step 👇

---

### 🧭 1. Make sure you’re on `main`

```bash
git checkout main
```

---

### 🧩 2. Pull the latest version (optional but recommended)

```bash
git pull origin main
```

---

### 🏷️ 3. Create a new tag

You can make either a **lightweight** or an **annotated** tag:

#### 🔹 Annotated tag (recommended)

```bash
git tag -a v1.0 -m "Initial release"
```

> The `-a` flag creates an annotated tag with a message.

#### 🔹 Lightweight tag

```bash
git tag v1.0
```

---

### ☁️ 4. Push the tag to GitHub

```bash
git push origin v1.0
```

If you have multiple tags to push:

```bash
git push origin --tags
```

---

### 🧾 5. Verify

```bash
git tag
```

or online on GitHub → **Repo → Tags** section.

---

Would you like me to show how to **create and use tags in a GitHub Action (CI/CD pipeline)** too?

