// Report data: constants, filter state, loading and queries on the report.
(function (R) {
  'use strict';

  R.SEVERITIES = ['Error', 'Warning', 'Information', 'Hint'];
  R.CATEGORIES = [
    { key: 'architecture', title: 'Architecture constraints' },
    { key: 'quality', title: 'Quality rules' }
  ];

  R.state = {
    report: null,
    severities: new Set(),
    rules: new Set(),
    search: ''
  };

  // The report is written into the #report slot; during development the slot is empty
  // and sample-report.js provides the data instead.
  R.loadReport = function () {
    var slot = document.getElementById('report');
    var inline = slot ? slot.textContent.trim() : '';
    if (inline) {
      return JSON.parse(inline);
    }
    if (R.sampleReport) {
      return R.sampleReport;
    }
    throw new Error('no report data in the page');
  };

  R.groups = function () {
    return (R.state.report && R.state.report.violations) || [];
  };

  R.issueCount = function (group) {
    return (group.entities || []).length;
  };

  R.categoryOf = function (group) {
    return group.category === 'architecture' ? 'architecture' : 'quality';
  };

  R.groupsIn = function (category) {
    return R.groups().filter(function (group) {
      return R.categoryOf(group) === category;
    });
  };

  R.totalIssues = function (groups) {
    return groups.reduce(function (sum, group) {
      return sum + R.issueCount(group);
    }, 0);
  };

  R.countBySeverity = function () {
    var counts = {};
    R.SEVERITIES.forEach(function (severity) {
      counts[severity] = 0;
    });
    R.groups().forEach(function (group) {
      counts[group.severity] = (counts[group.severity] || 0) + R.issueCount(group);
    });
    return counts;
  };

  R.location = function (entity) {
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
  };

  // Filters

  R.matchesSearch = function (entity) {
    if (!R.state.search) {
      return true;
    }
    var haystack = ((entity.entity || '') + ' ' + (entity.file || '')).toLowerCase();
    return haystack.indexOf(R.state.search) >= 0;
  };

  R.groupIsSelected = function (group) {
    var state = R.state;
    return (state.severities.size === 0 || state.severities.has(group.severity)) &&
      (state.rules.size === 0 || state.rules.has(group.rule));
  };

  R.hasFilters = function () {
    var state = R.state;
    return state.severities.size > 0 || state.rules.size > 0 || state.search !== '';
  };
})(window.MooseCIReport = window.MooseCIReport || {});
