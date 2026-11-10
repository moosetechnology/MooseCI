// Top of the page: header meta and measures.
(function (R) {
  'use strict';

  function renderMeta(report) {
    var parts = [];
    if (report.project) {
      parts.push(report.project);
    }
    if (report.generatedAt) {
      parts.push(new Date(report.generatedAt).toLocaleString());
    }
    document.getElementById('meta').textContent = parts.length ? parts.join(' · ') : 'Analysis report';
  }

  function measure(label, value) {
    var cell = R.el('div', 'measure');
    cell.appendChild(R.el('dt', null, label));
    cell.appendChild(R.el('dd', null, value));
    return cell;
  }

  function issuesMeasure() {
    var counts = R.countBySeverity();
    var total = R.SEVERITIES.reduce(function (sum, severity) {
      return sum + counts[severity];
    }, 0);

    var cell = measure('Issues', total);
    var breakdown = R.el('div', 'measure-breakdown');
    R.SEVERITIES.forEach(function (severity) {
      var tag = R.severityTag(severity);
      tag.textContent = String(counts[severity]);
      tag.title = severity;
      breakdown.appendChild(tag);
    });
    cell.appendChild(breakdown);
    return cell;
  }

  function renderMeasures(report) {
    var measures = document.getElementById('measures');
    var metrics = report.metrics || {};
    R.clear(measures);

    Object.keys(metrics).forEach(function (key) {
      measures.appendChild(measure(R.humanize(key), metrics[key]));
    });
    measures.appendChild(issuesMeasure());
    R.CATEGORIES.forEach(function (category) {
      measures.appendChild(measure(category.title, R.totalIssues(R.groupsIn(category.key))));
    });
  }

  R.renderSummary = function () {
    var report = R.state.report;
    renderMeta(report);
    renderMeasures(report);
  };
})(window.MooseCIReport = window.MooseCIReport || {});
