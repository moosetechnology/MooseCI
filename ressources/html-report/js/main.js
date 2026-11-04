// Entry point: wires the controls and renders the page. Loaded last.
(function (R) {
  'use strict';

  // Redraws what depends on the filters.
  R.render = function () {
    R.renderFacets();
    R.renderIssues();
  };

  function setupControls() {
    var search = document.getElementById('search');

    search.addEventListener('input', function () {
      R.state.search = search.value.trim().toLowerCase();
      R.renderIssues();
    });

    document.getElementById('clear-filters').addEventListener('click', function () {
      R.state.severities.clear();
      R.state.rules.clear();
      R.state.search = '';
      search.value = '';
      R.render();
    });
  }

  function showLoadError(error) {
    var container = document.getElementById('rules');
    R.clear(container);
    container.appendChild(R.el('p', 'empty', 'Could not load the report (' + error.message + ').'));
  }

  R.setupTheme();
  setupControls();

  try {
    R.state.report = R.loadReport();
  } catch (error) {
    showLoadError(error);
    return;
  }
  R.renderSummary();
  R.render();
})(window.MooseCIReport = window.MooseCIReport || {});
