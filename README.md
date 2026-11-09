# FG-WVAM anonymous project page

Static page with the paper overview, method figure, main results, and demo
videos. No build step, no external JavaScript, no external fonts, no analytics.

## Files

```
index.html                 page
assets/style.css           styles
assets/tease.jpg           method/teaser figure
assets/value_compare.jpg   qualitative figure
assets/video_placeholder.svg
videos/                    six demo mp4 files (add them here)
scripts/compress_videos.sh
robots.txt                 disallow indexing
.nojekyll                  GitHub Pages: serve files as-is
```

## Replace before publishing

1. **Videos.** The three success clips are already included:
   `aerialdojo_success.mp4`, `aerialdojo_success_barrel.mp4`,
   `aerialdojo_success_market.mp4`. Optionally add the failure, candidate
   selection, and future-grounding clips listed in `videos/README.md`.
2. **Code link.** In `index.html`, replace both occurrences of
   `https://anonymous.4open.science/r/REPLACE_ME` with your anonymous code
   mirror.
3. **Paper link.** Replace the `href="#"` on the Paper button with the
   anonymous OpenReview forum link.
4. **Check the page** for any author name, affiliation, personal URL, or
   acknowledgment that could identify you.

## Local preview

```bash
cd FG-WVAM-page
python3 -m http.server 8000
# open http://localhost:8000
```

## Deploy: GitHub Pages with a neutral account

Use a **new GitHub account** with a neutral name and email. Do **not** push from
the personal `gh` login.

```bash
cd FG-WVAM-page
git init -b main
git config user.name "Anonymous"
git config user.email "noreply@example.com"
git add -A
git commit -m "Anonymous project page"
git remote add origin https://github.com/<neutral-account>/<repo>.git
HTTPS_PROXY=http://127.0.0.1:7897 git push -u origin main
```

Then in the repository: **Settings → Pages → Deploy from a branch → main / root**.
The URL will be:

```
https://<neutral-account>.github.io/<repo>/
```

Keep the account name neutral; the URL is visible in the paper/rebuttal.

## Deploy: alternatives

- **Netlify Drop**: drag the folder onto https://app.netlify.com/drop. Use a
  neutral account/email. The generated URL is random.
- **Hugging Face static Space**: create a Space of type "Static" under a neutral
  account, upload the folder, and use the Space URL.
- **OpenReview supplementary**: if you do not want a public page, zip this
  folder together with the demo videos and upload it as supplementary.

## Anonymity checklist

- [ ] No author names, affiliations, lab names, or acknowledgments.
- [ ] No personal links (homepage, Google Scholar, GitHub, social media).
- [ ] Neutral GitHub/HF/Netlify account name and email.
- [ ] Commit author/committer are neutral:
      `git log -1 --format=fuller`.
- [ ] No analytics, tracking pixels, external fonts, or third-party scripts.
- [ ] `robots.txt` and `<meta name="robots" content="noindex, nofollow">` are
      present.
- [ ] Videos/images have metadata stripped (`-map_metadata -1`).
- [ ] No lab logos, personal screens, browser tabs, or file paths in videos.
- [ ] No custom domain that identifies the group.
- [ ] Do not link the page from your personal website during review.
- [ ] Use `https://anonymous.4open.science` for the code link, not the raw
      GitHub URL.

## Video compression

See `videos/README.md` and `scripts/compress_videos.sh`. Target 720p, H.264,
no audio, ~10 MB per clip, total under ~50 MB.

## Notes

- The page is intentionally self-contained; it does not load anything from a
  CDN.
- GitHub Pages serves the page over HTTPS and has generous bandwidth for a
  review page, but keep the total video size small.
- If you later de-anonymize, replace "Anonymous Authors" and the anonymous code
  link with the camera-ready versions.