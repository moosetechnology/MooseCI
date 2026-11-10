// DOM helpers shared by the components. Text always goes through textContent:
// entity names come from the analyzed code.
(function (R) {
  'use strict';

  R.el = function (tag, className, text) {
    var node = document.createElement(tag);
    if (className) {
      node.className = className;
    }
    if (text !== undefined && text !== null) {
      node.textContent = String(text);
    }
    return node;
  };

  R.clear = function (node) {
    while (node.firstChild) {
      node.removeChild(node.firstChild);
    }
  };

  R.plural = function (count, word) {
    return count + ' ' + word + (count === 1 ? '' : 's');
  };

  R.humanize = function (key) {
    var text = String(key).replace(/[_-]+/g, ' ');
    return text.charAt(0).toUpperCase() + text.slice(1);
  };

  R.severityTag = function (severity) {
    var known = R.SEVERITIES.indexOf(severity) >= 0 ? severity : 'Hint';
    return R.el('span', 'severity severity-' + known.toLowerCase(), severity);
  };
})(window.MooseCIReport = window.MooseCIReport || {});
