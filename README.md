# website

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Build & Deploy to GitHub Pages (Automatic via GitHub Actions)

This repository is configured to automatically build and publish the Flutter web site to GitHub Pages when you push to `main`.

Repository: https://github.com/mwinter02/website

What the workflow does
- Checks out the repository
- Sets up Flutter (stable channel)
- Runs `flutter pub get`
- Builds the web output with a base href appropriate for the repo
- Publishes `build/web` to the `gh-pages` branch using `GITHUB_TOKEN`

Where the workflow lives
- `.github/workflows/deploy.yml` (already included in this repository)

How to trigger an automatic deploy
1. Commit and push your changes to `main`:

```bash
git add .
git commit -m "Update site"
git push origin main
```

2. GitHub Actions will run the workflow automatically. Open the Actions tab in your repository to monitor the run.
3. After the workflow completes it will publish the site to the `gh-pages` branch and GitHub Pages should serve the site within a few minutes.

Notes about base href and hosting URL
- This repository is a project site hosted at: `https://mwinter02.github.io/website/`
- The workflow attempts to set the correct base href automatically so the built site uses `/website/` as the base when necessary.

Pushing updates
- With the GitHub Actions workflow in place, simply pushing to `main` will rebuild and republish the site — you do not need to build locally first.

Common issues & tips
- 404 on refresh (client-side routing)
  - Single-page apps that use browser history routing will show 404s when you refresh a non-root URL. Options:
    - Use hash routing (URLs like `https://.../#/about`) — no server config needed.
    - Add a `404.html` that redirects to `index.html` (I can add one to this repo on request).

- Caching / stale files
  - GitHub Pages may cache static files. When you update assets consider versioned filenames (e.g., `main.v1.js`) or add query strings to bust caches.

- Custom domain
  - To use a custom domain, include a `CNAME` file in the published root (for example add `web/CNAME` before build or add `build/web/CNAME`). Configure DNS according to GitHub's docs.

- Large assets
  - Host large images/videos on a CDN or cloud storage and reference them by absolute URLs to keep the repository small.

Quick troubleshooting
- Open the Actions tab to inspect the deployment workflow logs for errors.
- Verify the `gh-pages` branch exists and contains `index.html` after a successful run.
- In your repository Settings → Pages, confirm GitHub Pages is set to serve from `gh-pages` (branch) and folder `/` (root).
- Clear browser cache or open in a private window if you see an old version.
- Inspect the browser console/network tab for missing assets (404s) and check that base href is correct.

---

If you'd like, I can also:
- Add a `404.html` redirect handler to improve refresh behavior for history routing.
- Add a `web/CNAME` placeholder and instructions for a custom domain.
- Walk you through watching the first GitHub Actions run and verifying the published site.
