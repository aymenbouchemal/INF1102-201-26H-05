# Protection

The **GitHub branch protection configured via a JSON payload** for the API. Here’s a ready-to-use JSON example to **prevent deletion of `main`** and enforce protections:

```json
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": null,
  "restrictions": null,
  "allow_deletions": false
}
```

---

### **How to apply it via `gh api`**

using a JSON file:

```bash
gh api \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  /repos/collegeboreal/INF1084-202-25A-03/branches/main/protection \
  -f @protection.json
```

Where `protection.json` contains the JSON payload above. ✅

This **fully disables deletion of the main branch** remotely.

