// Main list: one section per category, one collapsible block per rule.
(function (R) {
  'use strict';

  function renderRule(group, entities) {
    var details = R.el('details', 'rule');
    details.open = true;

    var summary = R.el('summary');
    summary.appendChild(R.severityTag(group.severity));
    summary.appendChild(R.el('span', 'rule-name', group.rule));
    summary.appendChild(R.el('span', 'rule-count', R.plural(entities.length, 'issue')));
    details.appendChild(summary);

    var table = R.el('table', 'entities');
    var body = R.el('tbody');
    entities.forEach(function (entity) {
      var row = R.el('tr');
      row.appendChild(R.el('td', 'entity', entity.entity));
      row.appendChild(R.el('td', 'location', R.location(entity)));
      body.appendChild(row);
    });
    table.appendChild(body);
    details.appendChild(table);
    return details;
  }

  // Answers the section and how many issues it shows; an empty section is not displayed.
  function renderCategory(category) {
    var section = R.el('section', 'category');
    var heading = R.el('h2', 'category-title', category.title);
    var count = R.el('span', 'category-count');
    var shown = 0;
    heading.appendChild(count);
    section.appendChild(heading);

    R.groupsIn(category.key).forEach(function (group) {
      if (!R.groupIsSelected(group)) {
        return;
      }
      var entities = (group.entities || []).filter(R.matchesSearch);
      if (entities.length === 0) {
        return;
      }
      shown += entities.length;
      section.appendChild(renderRule(group, entities));
    });

    count.textContent = R.plural(shown, 'issue');
    return { section: section, shown: shown };
  }

  R.renderIssues = function () {
    var container = document.getElementById('rules');
    var shown = 0;
    R.clear(container);

    R.CATEGORIES.forEach(function (category) {
      var result = renderCategory(category);
      if (result.shown > 0) {
        container.appendChild(result.section);
        shown += result.shown;
      }
    });

    document.getElementById('shown-count').textContent = R.plural(shown, 'issue');
    document.getElementById('empty').hidden = shown > 0;
    document.getElementById('clear-filters').hidden = !R.hasFilters();
  };
})(window.MooseCIReport = window.MooseCIReport || {});
