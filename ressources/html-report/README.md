# HTML report template

The page shown by the HTML report. Open `index.html` directly in a browser to preview it: no server needed.

- `index.html`: page skeleton. The report data goes into the empty `<script id="report" type="application/json">` slot. When the slot is empty, as it is here, the page uses `sample-report.js`.
- `report.css`: styles, light and dark themes.
- `js/`: plain scripts (no modules) that share the `window.MooseCIReport` object. `index.html` loads them in order and `main.js` runs last.
  - `data.js`: constants, filter state, loading and queries on the report
  - `dom.js`: DOM helpers
  - `summary.js`: header and measures
  - `facets.js`: severity and rule filters
  - `issues.js`: issue list, grouped by category and rule
  - `theme.js`: light and dark toggle
  - `main.js`: entry point
- `sample-report.js`: sample data for development only. It is not part of the generated report.

To add a component, create a file in `js/` and add its `<script src>` to `index.html` before `main.js`.
