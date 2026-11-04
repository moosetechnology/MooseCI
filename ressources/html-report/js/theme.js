// Light / dark mode: follows the system, with a manual toggle remembered per browser.
(function (R) {
  'use strict';

  var THEME_KEY = 'mooseci-report-theme';

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

  R.setupTheme = function () {
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
  };
})(window.MooseCIReport = window.MooseCIReport || {});
