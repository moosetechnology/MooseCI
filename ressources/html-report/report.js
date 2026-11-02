(function () {
  'use strict';

  var SEVERITIES = ['Error', 'Warning', 'Information', 'Hint'];
  var CATEGORIES = [
    { key: 'architecture', title: 'Architecture constraints' },
    { key: 'quality', title: 'Quality rules' }
  ];
  var THEME_KEY = 'mooseci-report-theme';

  var state = {
    report: null,
    severities: new Set(),
    rules: new Set(),
    search: ''
  };

  // Loading

  function loadReport() {
    var slot = document.getElementById('report');
    var inline = slot ? slot.textContent.trim() : '';
    if (inline) {
      return Promise.resolve(JSON.parse(inline));
    }
    // Development: no report written into the page, use the sample.
    return fetch('sample-report.json', { cache: 'no-store' }).then(function (response) {
      if (!response.ok) {
        throw new Error('HTTP ' + response.status);
      }
      return response.json();
    });
  }

  // Helpers

  function el(tag, className, text) {
    var node = document.createElement(tag);
    if (className) {
      node.className = className;
    }
    if (text !== undefined && text !== null) {
      node.textContent = String(text);
    }
    return node;
  }

  function clear(node) {
    while (node.firstChild) {
      node.removeChild(node.firstChild);
    }
  }

  function plural(count, word) {
    return count + ' ' + word + (count === 1 ? '' : 's');
  }

  function humanize(key) {
    var text = String(key).replace(/[_-]+/g, ' ');
    return text.charAt(0).toUpperCase() + text.slice(1);
  }

  function severityTag(severity) {
    var known = SEVERITIES.indexOf(severity) >= 0 ? severity : 'Hint';
    return el('span', 'severity severity-' + known.toLowerCase(), severity);
  }

  function groups() {
    return (state.report && state.report.violations) || [];
  }

  function issueCount(group) {
    return (group.entities || []).length;
  }

  function categoryOf(group) {
    return group.category === 'architecture' ? 'architecture' : 'quality';
  }

  function groupsIn(category) {
    return groups().filter(function (group) {
      return categoryOf(group) === category;
    });
  }

  function totalIssues(list) {
    return list.reduce(function (sum, group) {
      return sum + issueCount(group);
    }, 0);
  }

  function countBySeverity() {
    var counts = {};
    SEVERITIES.forEach(function (severity) {
      counts[severity] = 0;
    });
    groups().forEach(function (group) {
      counts[group.severity] = (counts[group.severity] || 0) + issueCount(group);
    });
    return counts;
  }

  function location(entity) {
    if (!entity.file) {
      return 'no source location';
    }
    if (entity.startLine == null) {
      return entity.file;
    }
    if (entity.endLine == null || entity.endLine === entity.startLine) {
      return entity.file + ':' + entity.startLine;
    }
    return entity.file + ':' + entity.startLine + '–' + entity.endLine;
  }

  function matchesSearch(entity) {
    if (!state.search) {
      return true;
    }
    var haystack = ((entity.entity || '') + ' ' + (entity.file || '')).toLowerCase();
    return haystack.indexOf(state.search) >= 0;
  }

  function groupIsSelected(group) {
    return (state.severities.size === 0 || state.severities.has(group.severity)) &&
      (state.rules.size === 0 || state.rules.has(group.rule));
  }

  function hasFilters() {
    return state.severities.size > 0 || state.rules.size > 0 || state.search !== '';
  }

  // Header and summary

  function renderMeta() {
    var report = state.report;
    var parts = [];
    if (report.project) {
      parts.push(report.project);
    }
    if (report.generatedAt) {
      parts.push(new Date(report.generatedAt).toLocaleString());
    }
    document.getElementById('meta').textContent = parts.length ? parts.join(' · ') : 'Analysis report';
  }

  function renderGate() {
    var gate = document.getElementById('gate');
    var errors = countBySeverity().Error;
    var failed = errors > 0;
    clear(gate);
    gate.appendChild(el('div', 'gate-label', 'Quality gate'));
    gate.appendChild(el('div', 'gate-status ' + (failed ? 'failed' : 'passed'), failed ? 'Failed' : 'Passed'));
    gate.appendChild(el('div', 'gate-reason', failed ? plural(errors, 'error-level issue') : 'No error-level issues'));
  }

  function measure(label, value) {
    var cell = el('div', 'measure');
    cell.appendChild(el('dt', null, label));
    cell.appendChild(el('dd', null, value));
    return cell;
  }

  function renderMeasures() {
    var measures = document.getElementById('measures');
    var metrics = state.report.metrics || {};
    var counts = countBySeverity();
    var total = SEVERITIES.reduce(function (sum, severity) {
      return sum + counts[severity];
    }, 0);
    clear(measures);

    var issues = measure('Issues', total);
    var breakdown = el('div', 'measure-breakdown');
    SEVERITIES.forEach(function (severity) {
      var tag = severityTag(severity);
      tag.textContent = String(counts[severity]);
      tag.title = severity;
      breakdown.appendChild(tag);
    });
    issues.appendChild(breakdown);
    measures.appendChild(issues);

    CATEGORIES.forEach(function (category) {
      measures.appendChild(measure(category.title, totalIssues(groupsIn(category.key))));
    });

    Object.keys(metrics).forEach(function (key) {
      measures.appendChild(measure(humanize(key), metrics[key]));
    });
  }

  // Facets

  function facetButton(content, count, pressed, onClick) {
    var button = el('button', 'facet-item');
    button.type = 'button';
    button.setAttribute('aria-pressed', pressed ? 'true' : 'false');
    button.disabled = count === 0;
    button.appendChild(content);
    button.appendChild(el('span', 'facet-count', count));
    button.addEventListener('click', onClick);
    return button;
  }

  function toggle(set, value) {
    if (set.has(value)) {
      set.delete(value);
    } else {
      set.add(value);
    }
    render();
  }

  function renderFacets() {
    var facets = document.getElementById('facets');
    var counts = countBySeverity();
    clear(facets);

    var severityFacet = el('div', 'facet');
    severityFacet.appendChild(el('h2', 'facet-title', 'Severity'));
    SEVERITIES.forEach(function (severity) {
      var label = severityTag(severity);
      label.textContent = '';
      label.appendChild(el('span', 'facet-name', severity));
      severityFacet.appendChild(facetButton(label, counts[severity], state.severities.has(severity), function () {
        toggle(state.severities, severity);
      }));
    });
    facets.appendChild(severityFacet);

    CATEGORIES.forEach(function (category) {
      var categoryGroups = groupsIn(category.key);
      if (categoryGroups.length === 0) {
        return;
      }
      var ruleFacet = el('div', 'facet');
      ruleFacet.appendChild(el('h2', 'facet-title', category.title));
      categoryGroups
        .slice()
        .sort(function (a, b) {
          return issueCount(b) - issueCount(a) || a.rule.localeCompare(b.rule);
        })
        .forEach(function (group) {
          var name = el('span', 'facet-name', group.rule);
          name.title = group.rule;
          ruleFacet.appendChild(facetButton(name, issueCount(group), state.rules.has(group.rule), function () {
            toggle(state.rules, group.rule);
          }));
        });
      facets.appendChild(ruleFacet);
    });
  }

  // Issue list

  function renderRule(group, entities) {
    var details = el('details', 'rule');
    details.open = true;

    var summary = el('summary');
    summary.appendChild(severityTag(group.severity));
    summary.appendChild(el('span', 'rule-name', group.rule));
    summary.appendChild(el('span', 'rule-count', plural(entities.length, 'issue')));
    details.appendChild(summary);

    var table = el('table', 'entities');
    var body = el('tbody');
    entities.forEach(function (entity) {
      var row = el('tr');
      row.appendChild(el('td', 'entity', entity.entity));
      row.appendChild(el('td', 'location', location(entity)));
      body.appendChild(row);
    });
    table.appendChild(body);
    details.appendChild(table);
    return details;
  }

  function renderRules() {
    var container = document.getElementById('rules');
    var shown = 0;
    clear(container);

    CATEGORIES.forEach(function (category) {
      var section = el('section', 'category');
      var heading = el('h2', 'category-title', category.title);
      var count = el('span', 'category-count');
      var shownInCategory = 0;
      heading.appendChild(count);
      section.appendChild(heading);

      groupsIn(category.key).forEach(function (group) {
        if (!groupIsSelected(group)) {
          return;
        }
        var entities = (group.entities || []).filter(matchesSearch);
        if (entities.length === 0) {
          return;
        }
        shownInCategory += entities.length;
        section.appendChild(renderRule(group, entities));
      });

      if (shownInCategory > 0) {
        count.textContent = plural(shownInCategory, 'issue');
        container.appendChild(section);
        shown += shownInCategory;
      }
    });

    document.getElementById('shown-count').textContent = plural(shown, 'issue');
    document.getElementById('empty').hidden = shown > 0;
    document.getElementById('clear-filters').hidden = !hasFilters();
  }

  function render() {
    renderFacets();
    renderRules();
  }

  // Theme

  function storedTheme() {
    try {
      return localStorage.getItem(THEME_KEY);
    } catch (e) {
      return null;
    }
  }

  function currentTheme() {
    var explicit = document.documentElement.getAttribute('data-theme');
    if (explicit) {
      return explicit;
    }
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  function updateThemeButton() {
    var button = document.getElementById('theme-toggle');
    var next = currentTheme() === 'dark' ? 'light' : 'dark';
    button.textContent = next === 'dark' ? 'Dark' : 'Light';
    button.setAttribute('aria-label', 'Switch to ' + next + ' mode');
  }

  function setupTheme() {
    var saved = storedTheme();
    if (saved === 'light' || saved === 'dark') {
      document.documentElement.setAttribute('data-theme', saved);
    }
    updateThemeButton();

    document.getElementById('theme-toggle').addEventListener('click', function () {
      var next = currentTheme() === 'dark' ? 'light' : 'dark';
      document.documentElement.setAttribute('data-theme', next);
      try {
        localStorage.setItem(THEME_KEY, next);
      } catch (e) {
        // Storage can be unavailable (private window, file://); the toggle still works for this visit.
      }
      updateThemeButton();
    });

    if (window.matchMedia) {
      window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', updateThemeButton);
    }
  }

  // Controls

  function setupControls() {
    document.getElementById('search').addEventListener('input', function (event) {
      state.search = event.target.value.trim().toLowerCase();
      renderRules();
    });

    document.getElementById('clear-filters').addEventListener('click', function () {
      state.severities.clear();
      state.rules.clear();
      state.search = '';
      document.getElementById('search').value = '';
      render();
    });
  }

  function showLoadError(error) {
    var container = document.getElementById('rules');
    clear(container);
    var message = el('p', 'empty', 'Could not load the report (' + error.message + '). ' +
      'When previewing the template, serve this folder over HTTP instead of opening the file directly.');
    container.appendChild(message);
  }

  setupTheme();
  setupControls();

  loadReport()
    .then(function (report) {
      state.report = report;
      renderMeta();
      renderGate();
      renderMeasures();
      render();
    })
    .catch(showLoadError);
})();
