# HTML report template

The page shown by the HTML report: `index.html`, `report.css` and `report.js`. The report data goes into the empty `<script id="report" type="application/json">` slot. When the slot is empty, as it is here, the page loads `sample-report.json` instead.

To preview it, serve this folder over HTTP (browsers block `fetch` on `file://`):

```bash
python3 -m http.server -d ressources/html-report
```

Then open http://localhost:8000.
