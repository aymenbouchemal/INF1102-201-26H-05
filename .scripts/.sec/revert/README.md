# :chess_pawn: Revert

Let’s go over the main strategies 👇

---

## 🧩 Option 1 — Create a *new commit* that reverts everything since `v1.1`

Instead of rewriting history, you can **make a new commit** that undoes all changes after `v1.1`.

```bash
git checkout main
git revert --no-commit v1.1..HEAD
git commit -m "Revert main branch back to v1.1 state"
git push origin main
```

✅ **Pros:**

* Safe for teams (no history rewriting).
* Remote stays consistent.

⚠️ **Cons:**

* The history keeps the bad commits, but they’re “cancelled out” by the revert commit.

---

## 🧩 Option 2 — Create a new branch from the tag

You can just make a clean branch from the tag:

```bash
git checkout -b main-fixed v1.1
git push origin main-fixed
```

✅ **Pros:**

* 100% safe.
* Leaves the old `main` untouched.

Then you can later rename it on the remote (or swap branches):

```bash
git push origin main:main-old
git push origin main-fixed:main
```

---

## 🧩 Option 3 — Use a *force push*, but keep a backup (your original method, safer variant)

If you really want `main` to *be exactly* like `v1.1`, but you want safety:

```bash
# Backup the current state
git branch backup-main main
git push origin backup-main

# Reset local main
git reset --hard v1.1

# Force push safely
git push origin main --force
```

✅ **Pros:**

* You can always recover using the backup branch.
  ⚠️ **Cons:**
* Still rewrites history — use only if you’re sure.

---

## 🧩 Option 4 — Use GitHub’s “Revert” or “Restore branch” button

If this is on GitHub, you can:

* Go to the **tag page**, click “Browse files”, and create a PR from that snapshot back to `main`.
* Or use the **“Revert”** button in the GitHub UI for a safer restore.

---

## 🧠 Summary

| Method                                      | Safe for Teams | Description                           |
| ------------------------------------------- | -------------- | ------------------------------------- |
| `git reset --hard v1.1 && git push --force` | ❌ No           | Resets history (fast but destructive) |
| `git revert v1.1..HEAD`                     | ✅ Yes          | Creates a commit that cancels changes |
| `git checkout -b main-fixed v1.1`           | ✅ Yes          | Makes a clean branch from the tag     |
| Backup + force push                         | ⚠️ Mostly      | Safer variant of reset                |

