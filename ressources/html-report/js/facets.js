// Left sidebar: severity and rule filters.
(function (R) {
  'use strict';

  function facetButton(content, count, pressed, onClick) {
    var button = R.el('button', 'facet-item');
    button.type = 'button';
    button.setAttribute('aria-pressed', pressed ? 'true' : 'false');
    button.disabled = count === 0;
    button.appendChild(content);
    button.appendChild(R.el('span', 'facet-count', count));
    button.addEventListener('click', onClick);
    return button;
  }

  function toggle(set, value) {
    if (set.has(value)) {
      set.delete(value);
    } else {
      set.add(value);
    }
    R.render();
  }

  function severityFacet() {
    var counts = R.countBySeverity();
    var facet = R.el('div', 'facet');
    facet.appendChild(R.el('h2', 'facet-title', 'Severity'));
    R.SEVERITIES.forEach(function (severity) {
      var label = R.severityTag(severity);
      label.textContent = '';
      label.appendChild(R.el('span', 'facet-name', severity));
      facet.appendChild(facetButton(label, counts[severity], R.state.severities.has(severity), function () {
        toggle(R.state.severities, severity);
      }));
    });
    return facet;
  }

  function ruleFacet(category, groups) {
    var facet = R.el('div', 'facet');
    facet.appendChild(R.el('h2', 'facet-title', category.title));
    groups
      .slice()
      .sort(function (a, b) {
        return R.issueCount(b) - R.issueCount(a) || a.rule.localeCompare(b.rule);
      })
      .forEach(function (group) {
        var name = R.el('span', 'facet-name', group.rule);
        name.title = group.rule;
        facet.appendChild(facetButton(name, R.issueCount(group), R.state.rules.has(group.rule), function () {
          toggle(R.state.rules, group.rule);
        }));
      });
    return facet;
  }

  R.renderFacets = function () {
    var facets = document.getElementById('facets');
    R.clear(facets);

    facets.appendChild(severityFacet());
    R.CATEGORIES.forEach(function (category) {
      var groups = R.groupsIn(category.key);
      if (groups.length > 0) {
        facets.appendChild(ruleFacet(category, groups));
      }
    });
  };
})(window.MooseCIReport = window.MooseCIReport || {});
